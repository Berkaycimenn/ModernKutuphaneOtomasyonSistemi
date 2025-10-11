--Trigger

CREATE TRIGGER trg_KahveKampanya
ON SiparisDetaylari
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SiparisID INT, @KullaniciID INT;

    -- Yeni eklenen sipariþ ID'sini al
    SELECT TOP 1 @SiparisID = S.SiparisID, 
                 @KullaniciID = S.KullaniciID
    FROM inserted I
    JOIN Siparisler S ON I.SiparisID = S.SiparisID;

    -- Kullanýcýnýn toplam aldýðý kahve sayýsýný hesapla
    DECLARE @ToplamKahve INT;
    SELECT @ToplamKahve = COUNT(*)
    FROM SiparisDetaylari SD
    JOIN Siparisler S ON SD.SiparisID = S.SiparisID
    JOIN KafeUrunleri KU ON SD.UrunID = KU.UrunID
    WHERE S.KullaniciID = @KullaniciID
      AND KU.Tip = 'Kahve';

    -- Eðer 10'un katý ise bedava kahve + tatlý ekle
    IF (@ToplamKahve % 10 = 0)
    BEGIN
        DECLARE @KahveID INT, @TatliID INT;

        -- Kahve ürün ID'sini al
        SELECT TOP 1 @KahveID = UrunID FROM KafeUrunleri WHERE Tip = 'Kahve';
        -- Tatlý ürün ID'sini al
        SELECT TOP 1 @TatliID = UrunID FROM KafeUrunleri WHERE Tip = 'Tatlý';

        -- Bedava kahve ekle
        INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, Fiyat)
        VALUES (@SiparisID, @KahveID, 1, 0);

        -- Bedava tatlý ekle
        INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, Fiyat)
        VALUES (@SiparisID, @TatliID, 1, 0);

        PRINT 'Kampanya: 10 kahve sonrasý bedava kahve + tatlý eklendi!';
    END
END;

--Kontrol
-- Kahve ekle
INSERT INTO KafeUrunleri (Ad, Tip, Fiyat) 
VALUES ('Espresso', 'Kahve', 20);

-- Tatlý ekle
INSERT INTO KafeUrunleri (Ad, Tip, Fiyat) 
VALUES ('Cheesecake', 'Tatlý', 35);

--Kullanýcýya Yeni Sipariþ
INSERT INTO Siparisler (KullaniciID, Tarih) 
VALUES (1, GETDATE()); -- KullaniciID = 1 olduðunu varsayýyoruz

--Kontrol
SELECT * FROM Siparisler;

-- Kahve ekleme (SiparisID = 1 için)
INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, Fiyat)
SELECT 1, UrunID, 1, 20
FROM KafeUrunleri
WHERE Tip = 'Kahve';

--Kontrol
SELECT * FROM SiparisDetaylari WHERE SiparisID = 1;

--Ödünç Alma Trigger
CREATE OR ALTER TRIGGER trg_KitapOduncAl
ON OduncAlmalar
AFTER INSERT
AS
BEGIN
    UPDATE k
    SET k.StokSayisi = k.StokSayisi - 1
    FROM Kitaplar k
    INNER JOIN inserted i ON k.KitapID = i.KitapID;
END;

--Ýade Etme Trigger
CREATE OR ALTER TRIGGER trg_KitapIade
ON OduncAlmalar
AFTER UPDATE
AS
BEGIN
    -- Sadece IadeTarihi NULL’dan dolu hale geldiyse stok artýr
    UPDATE k
    SET k.StokSayisi = k.StokSayisi + 1
    FROM Kitaplar k
    INNER JOIN inserted i ON k.KitapID = i.KitapID
    INNER JOIN deleted d ON i.OduncID = d.OduncID
    WHERE d.IadeTarihi IS NULL AND i.IadeTarihi IS NOT NULL;
END;

--Kontrol
CREATE OR ALTER TRIGGER trg_KitapOduncAl
ON OduncAlmalar
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Kitaplar k
        INNER JOIN inserted i ON k.KitapID = i.KitapID
        WHERE k.StokSayisi <= 0
    )
    BEGIN
        RAISERROR('Bu kitap stokta yok! Ödünç verilemez.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    UPDATE k
    SET k.StokSayisi = k.StokSayisi - 1
    FROM Kitaplar k
    INNER JOIN inserted i ON k.KitapID = i.KitapID;
END;