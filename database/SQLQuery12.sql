--Yeni Kullanýcý Ekleme
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

--Kullanýmý
EXEC sp_YeniKullaniciEkle 
    @AdSoyad = 'Zeynep Kýlýç', 
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
        -- Ödünç kaydý ekle
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
        PRINT 'Kitap zaten ödünç alýnmýþ veya mevcut deðil!';
    END
END;

--Kullanýmý
EXEC sp_KitapOduncAl @KullaniciID = 1, @KitapID = 2;

--Þipariþ Oluþturma
CREATE PROCEDURE sp_SiparisOlustur
    @KullaniciID INT,
    @Urunler NVARCHAR(MAX) -- format: "UrunID:Adet;UrunID:Adet"
AS
BEGIN
    DECLARE @SiparisID INT;
    DECLARE @Toplam DECIMAL(10,2) = 0;

    -- Önce sipariþi ekle
    INSERT INTO Siparisler (KullaniciID, Tarih, Toplam)
    VALUES (@KullaniciID, GETDATE(), 0);

    SET @SiparisID = SCOPE_IDENTITY();

    -- Ürünleri parçala ve sipariþ detayýna ekle
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

    -- Toplamý güncelle
    UPDATE Siparisler
    SET Toplam = @Toplam
    WHERE SiparisID = @SiparisID;

    PRINT 'Sipariþ baþarýyla oluþturuldu.';
END;

--Kullanýmý
EXEC sp_SiparisOlustur @KullaniciID = 1, @Urunler = '1:2;3:1';  
-- Ali 2 kahve + 1 cheesecake aldý
--Sipariþ Tablosu Ekle
INSERT INTO Siparisler (KullaniciID, Tarih)
VALUES (1, GETDATE());
SELECT * FROM Siparisler;

