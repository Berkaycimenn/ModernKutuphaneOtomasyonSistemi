--Loglar
--iþlemlerin kayýt altýna alýnmasý
CREATE TABLE Loglar (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT NULL,
    IslemTipi NVARCHAR(50) NOT NULL,  -- Örn: 'Giris', 'Kitap Odunc', 'Siparis'
    Aciklama NVARCHAR(255) NULL,      -- Detaylý bilgi
    Tarih DATETIME DEFAULT GETDATE(), -- Ne zaman yapýldý
    FOREIGN KEY (KullaniciID) REFERENCES Kullanicilar(KullaniciID)
);
--Örnek1
INSERT INTO Loglar (KullaniciID, IslemTipi, Aciklama)
VALUES (1, 'Giris', 'Kullanýcý sisteme giriþ yaptý.');
--Örnek2
INSERT INTO Loglar (KullaniciID, IslemTipi, Aciklama)
VALUES (1, 'Kitap Odunc', 'KitapID = 5 ödünç alýndý.');

--Triger Ýle Otomatik Loglama
CREATE TRIGGER trg_SiparisLog
ON Siparisler
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Loglar (KullaniciID, IslemTipi, Aciklama)
    SELECT KullaniciID, 'Siparis', 'Yeni sipariþ oluþturuldu. SiparisID=' + CAST(SiparisID AS NVARCHAR)
    FROM inserted;
END;

--Kitap Ödünç Alma Loglama
CREATE TRIGGER trg_KitapOduncLog
ON OduncAlmalar
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Loglar (KullaniciID, IslemTipi, Aciklama)
    SELECT 
        KullaniciID,
        'Kitap Odunc',
        'Kullanýcý ID=' + CAST(KullaniciID AS NVARCHAR) +
        ' Kitap ID=' + CAST(KitapID AS NVARCHAR) + 
        ' ödünç aldý.'
    FROM inserted;
END;

--Kontrol
INSERT INTO OduncAlmalar (KullaniciID, KitapID, OduncTarihi)
VALUES (1, 2, GETDATE());  -- KullaniciID=1, KitapID=2

SELECT * FROM Loglar;

--Kullanýcý Giriþi Loglama
--Stored Procedure:
CREATE PROCEDURE sp_KullaniciGirisLog
    @KullaniciID INT
AS
BEGIN
    INSERT INTO Loglar (KullaniciID, IslemTipi, Aciklama)
    VALUES (@KullaniciID, 'Giris', 'Kullanýcý sisteme giriþ yaptý.');
END;

--Kullaným (web tarafýndan)
EXEC sp_KullaniciGirisLog @KullaniciID = 1;
