--Saklı Prosedürler
--Yeni Kullanıcı Ekleme
CREATE PROCEDURE sp_YeniKullaniciEkle
    @AdSoyad NVARCHAR(100),
    @Email NVARCHAR(100),
    @Sifre NVARCHAR(100),
    @Telefon NVARCHAR(15) = NULL,
    @UyeTipi NVARCHAR(20) = 'standart',
    @Rol NVARCHAR(20) = 'uye'
AS
BEGIN
    INSERT INTO Kullanicilar (AdSoyad, Email, Sifre, Telefon, UyeTipi, Rol)
    VALUES (@AdSoyad, @Email, @Sifre, @Telefon, @UyeTipi, @Rol);

    SELECT SCOPE_IDENTITY() AS YeniKullaniciID;
END;

--Kullanımı
EXEC sp_YeniKullaniciEkle 
    @AdSoyad = 'Zeynep Kılıç', 
    @Email = 'zeynep@example.com',
    @Sifre = '44444',
    @Telefon = '05007778899',
    @UyeTipi = 'ogrenci',
    @Rol = 'uye';
	--Kontrol
	SELECT * FROM Kullanicilar;

	--Kitap Ödünç Alma
	CREATE PROCEDURE sp_KitapOduncAl
    @KullaniciID INT,
    @KitapID INT
AS
BEGIN
    -- Kitap mevcut mu kontrol et
    IF EXISTS (SELECT 1 FROM Kitaplar WHERE KitapID = @KitapID AND Durum = 'Mevcut')
    BEGIN
        -- Ödünç kaydı ekle
        INSERT INTO OduncAlmalar (KullaniciID, KitapID, OduncTarihi)
        VALUES (@KullaniciID, @KitapID, GETDATE());

        -- Kitap durumunu güncelle
        UPDATE Kitaplar
        SET Durum = 'OduncAlindi'
        WHERE KitapID = @KitapID;

        PRINT 'Kitap ödünç verildi.';
    END
    ELSE
    BEGIN
        PRINT 'Kitap zaten ödünç alınmış veya mevcut değil!';
    END
END;

--Kullanımı
EXEC sp_KitapOduncAl @KullaniciID = 1, @KitapID = 2;

--Şipariş Oluşturma
CREATE PROCEDURE sp_SiparisOlustur
    @KullaniciID INT,
    @Urunler NVARCHAR(MAX) -- format: "UrunID:Adet;UrunID:Adet"
AS
BEGIN
    DECLARE @SiparisID INT;
    DECLARE @Toplam DECIMAL(10,2) = 0;

    -- Önce siparişi ekle
    INSERT INTO Siparisler (KullaniciID, Tarih, Toplam)
    VALUES (@KullaniciID, GETDATE(), 0);

    SET @SiparisID = SCOPE_IDENTITY();

    -- Ürünleri parçala ve sipariş detayına ekle
    DECLARE @xml XML;
    SET @xml = '<root><r>' + REPLACE(REPLACE(@Urunler, ';', '</r><r>'), ':', '</r><r>') + '</r></root>';

    ;WITH cte AS (
        SELECT
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn,
            n.value('.', 'INT') AS val
        FROM @xml.nodes('//r') AS x(n)
    )
    SELECT * INTO #tmp FROM cte;

    DECLARE @i INT = 1, @count INT, @UrunID INT, @Adet INT, @Fiyat DECIMAL(10,2);
    SELECT @count = MAX(rn) FROM #tmp;

    WHILE @i <= @count
    BEGIN
        SELECT @UrunID = val FROM #tmp WHERE rn = @i;
        SELECT @Adet = val FROM #tmp WHERE rn = @i+1;

        SELECT @Fiyat = Fiyat FROM KafeUrunleri WHERE UrunID = @UrunID;

        INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, Fiyat)
        VALUES (@SiparisID, @UrunID, @Adet, @Fiyat);

        SET @Toplam = @Toplam + (@Fiyat * @Adet);

        SET @i = @i + 2;
    END

    DROP TABLE #tmp;

    -- Toplamı güncelle
    UPDATE Siparisler
    SET Toplam = @Toplam
    WHERE SiparisID = @SiparisID;

    PRINT 'Sipariş başarıyla oluşturuldu.';
END;

--Kullanımı
EXEC sp_SiparisOlustur @KullaniciID = 1, @Urunler = '1:2;3:1';  
-- Ali 2 kahve + 1 cheesecake aldı
--Sipariş Tablosu Ekle
INSERT INTO Siparisler (KullaniciID, Tarih)
VALUES (1, GETDATE());
SELECT * FROM Siparisler;

--Rezervasyon Ekleme Stored Procedure
CREATE PROCEDURE sp_OdaRezervasyonEkle
    @OdaID INT,
    @KullaniciID INT,
    @BaslangicTarihi DATETIME,
    @BitisTarihi DATETIME,
    @Aciklama NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1 FROM OdaRezervasyonlari
        WHERE OdaID = @OdaID
        AND Durum = 'Aktif'
        AND (
            (@BaslangicTarihi BETWEEN BaslangicTarihi AND BitisTarihi)
            OR (@BitisTarihi BETWEEN BaslangicTarihi AND BitisTarihi)
            OR (BaslangicTarihi BETWEEN @BaslangicTarihi AND @BitisTarihi)
        )
    )
    BEGIN
        RAISERROR('Bu tarih aralığında oda zaten rezerve edilmiş.', 16, 1);
        RETURN;
    END

    INSERT INTO OdaRezervasyonlari (OdaID, KullaniciID, BaslangicTarihi, BitisTarihi, Aciklama)
    VALUES (@OdaID, @KullaniciID, @BaslangicTarihi, @BitisTarihi, @Aciklama);
END;

--Rezervasyon Durum Güncelleme
CREATE PROCEDURE sp_RezervasyonDurumGuncelle
    @RezervasyonID INT,
    @YeniDurum NVARCHAR(20)
AS
BEGIN
    UPDATE OdaRezervasyonlari
    SET Durum = @YeniDurum
    WHERE RezervasyonID = @RezervasyonID;
END;

CREATE OR ALTER PROCEDURE sp_OdaRezervasyonEkle
    @OdaID INT,
    @KullaniciID INT,
    @BaslangicTarihi DATETIME,
    @BitisTarihi DATETIME,
    @Aciklama NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Oda var mı kontrolü
    IF NOT EXISTS (SELECT 1 FROM Odalar WHERE OdaID = @OdaID)
    BEGIN
        PRINT 'HATA: Seçilen OdaID mevcut değil!';
        RETURN;
    END

	--Rezervasyon Güncelleme Prosedürü

CREATE OR ALTER PROCEDURE sp_OdaRezervasyonGuncelle
    @RezervasyonID INT,
    @BaslangicTarihi DATETIME,
    @BitisTarihi DATETIME,
    @Aciklama NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- Rezervasyon var mı kontrolü
    IF NOT EXISTS (SELECT 1 FROM OdaRezervasyonlari WHERE RezervasyonID = @RezervasyonID)
    BEGIN
        PRINT 'HATA: Rezervasyon bulunamadı!';
        RETURN;
    END

    DECLARE @OdaID INT;
    SELECT @OdaID = OdaID FROM OdaRezervasyonlari WHERE RezervasyonID = @RezervasyonID;

	--Rezervasyon İptal Prosedürü


CREATE OR ALTER PROCEDURE sp_OdaRezervasyonIptal
    @RezervasyonID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Rezervasyon var mı kontrolü
    IF NOT EXISTS (SELECT 1 FROM OdaRezervasyonlari WHERE RezervasyonID = @RezervasyonID)
    BEGIN
        PRINT 'HATA: Rezervasyon bulunamadı!';
        RETURN;
    END

    DELETE FROM OdaRezervasyonlari
    WHERE RezervasyonID = @RezervasyonID;

    PRINT 'Rezervasyon başarıyla iptal edildi!';
END

--Stored Procedure: sp_OdaRezervasyonEkle

CREATE OR ALTER PROCEDURE sp_OdaRezervasyonEkle
    @OdaID INT,
    @KullaniciID INT,
    @BaslangicTarihi DATE,
    @BitisTarihi DATE,
    @Aciklama NVARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1️⃣ Tarih çakışması kontrolü
    IF EXISTS (
        SELECT 1
        FROM OdaRezervasyonlari
        WHERE OdaID = @OdaID
          AND NOT (BitisTarihi < @BaslangicTarihi OR BaslangicTarihi > @BitisTarihi)
    )
    BEGIN
        RAISERROR('Seçilen oda bu tarihler arasında zaten rezerve edilmiş.', 16, 1);
        RETURN;
    END

	--Giriş Kaydetme Stored Procedure

CREATE OR ALTER PROCEDURE sp_KullaniciGirisKaydet
    @KullaniciID INT,
    @Basarili BIT,
    @IPAdres NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- 1. KullaniciGirisleri tablosuna ekle
    INSERT INTO dbo.KullaniciGirisleri (KullaniciID, Basarili, IPAdres, Tarih)
    VALUES (@KullaniciID, @Basarili, @IPAdres, GETDATE());

    -- 2. Kullanicilar tablosunu güncelle (Son login bilgisi)
    UPDATE K
    SET K.SonLoginTarih = GETDATE(),
        K.SonLoginBasarili = @Basarili
    FROM Kullanicilar K
    WHERE K.KullaniciID = @KullaniciID;
END;

--Oda Rezervasyon ve Tarih Yönetimi

CREATE OR ALTER PROCEDURE sp_OdaRezervasyonEkle
    @OdaID INT,
    @KullaniciID INT,
    @BaslangicTarihi DATETIME,
    @BitisTarihi DATETIME,
    @Durum NVARCHAR(20) = NULL,
    @Aciklama NVARCHAR(255) = NULL
AS
BEGIN
    -- Aynı tarihlerde rezervasyon var mı kontrol
    IF EXISTS (
        SELECT 1 FROM OdaRezervasyonlari
        WHERE OdaID = @OdaID
        AND (
            (@BaslangicTarihi BETWEEN BaslangicTarihi AND BitisTarihi) OR
            (@BitisTarihi BETWEEN BaslangicTarihi AND BitisTarihi) OR
            (BaslangicTarihi BETWEEN @BaslangicTarihi AND @BitisTarihi)
        )
    )
    BEGIN
        RAISERROR('Seçilen oda bu tarihler arasında zaten rezerve edilmiş.', 16, 1);
        RETURN;
    END

    -- Rezervasyonu ekle
    INSERT INTO OdaRezervasyonlari
        (OdaID, KullaniciID, BaslangicTarihi, BitisTarihi, Durum, Aciklama, OlusturmaTarihi)
    VALUES
        (@OdaID, @KullaniciID, @BaslangicTarihi, @BitisTarihi, @Durum, @Aciklama, GETDATE());
END;

CREATE OR ALTER PROCEDURE sp_OdaRezervasyonGuncelle
    @RezervasyonID INT,
    @BaslangicTarihi DATETIME,
    @BitisTarihi DATETIME,
    @Durum NVARCHAR(20) = NULL,
    @Aciklama NVARCHAR(255) = NULL
AS
BEGIN
    -- Çakışma kontrolü
    IF EXISTS (
        SELECT 1
        FROM dbo.OdaRezervasyonlari
        WHERE OdaID = (SELECT OdaID FROM dbo.OdaRezervasyonlari WHERE RezervasyonID = @RezervasyonID)
          AND RezervasyonID <> @RezervasyonID
          AND ((@BaslangicTarihi BETWEEN BaslangicTarihi AND BitisTarihi)
               OR (@BitisTarihi BETWEEN BaslangicTarihi AND BitisTarihi))
    )
    BEGIN
        RAISERROR('Seçilen oda bu tarihler arasında zaten rezerve edilmiş.', 16, 1);
        RETURN;
    END


CREATE OR ALTER PROCEDURE sp_OdaRezervasyonIptal
    @RezervasyonID INT
AS
BEGIN
    UPDATE dbo.OdaRezervasyonlari
    SET Durum = 'İptal'
    WHERE RezervasyonID = @RezervasyonID;
END;


CREATE PROCEDURE sp_VIPOdaKullanim
AS
BEGIN
    SELECT 
        o.OdaAdi,
        COUNT(r.RezervasyonID) AS KullanimSayisi,
        SUM(DATEDIFF(HOUR, r.BaslangicTarihi, r.BitisTarihi)) AS ToplamSaat
    FROM OdaRezervasyonlari r
    INNER JOIN Odalar o ON r.OdaID = o.OdaID
    WHERE o.OdaTipi = 'VIP'
    GROUP BY o.OdaAdi
    ORDER BY ToplamSaat DESC;
END;
GO


CREATE PROCEDURE sp_AylikKafeSatis
    @Ay INT,
    @Yil INT
AS
BEGIN
    SELECT 
        u.UrunAdi,
        SUM(ks.Miktar) AS ToplamAdet,
        SUM(ks.Toplam) AS ToplamGelir
    FROM KafeSatislar ks
    INNER JOIN Urunler u ON ks.UrunID = u.UrunID
    WHERE MONTH(ks.SatisTarihi) = @Ay AND YEAR(ks.SatisTarihi) = @Yil
    GROUP BY u.UrunAdi
    ORDER BY ToplamGelir DESC;
END;
GO


CREATE PROCEDURE sp_GunlukKafeSatis
    @Tarih DATE
AS
BEGIN
    SELECT 
        u.UrunAdi,
        SUM(ks.Miktar) AS ToplamAdet,
        SUM(ks.Toplam) AS ToplamGelir
    FROM KafeSatislar ks
    INNER JOIN Urunler u ON ks.UrunID = u.UrunID
    WHERE CAST(ks.SatisTarihi AS DATE) = @Tarih
    GROUP BY u.UrunAdi
    ORDER BY ToplamGelir DESC;
END;
GO


--Kafe Satış
CREATE OR ALTER PROCEDURE sp_UrunBazliKafeSatis
    @UrunID INT
AS
BEGIN
    SELECT 
        CAST(SatisTarihi AS DATE) AS SatisGunu,
        SUM(Miktar) AS ToplamAdet,
        SUM(Toplam) AS ToplamTutar
    FROM KafeSatislar
    WHERE UrunID = @UrunID
    GROUP BY CAST(SatisTarihi AS DATE)
    ORDER BY SatisGunu;
END;
