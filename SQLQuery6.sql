--Tablo Oluþturma
-- Kullanýcýlar Tablosu
CREATE TABLE Kullanicilar (
    KullaniciID INT IDENTITY(1,1) PRIMARY KEY,
    AdSoyad NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    Sifre NVARCHAR(100) NOT NULL,
    Telefon NVARCHAR(15) NULL,
    KayitTarihi DATE DEFAULT GETDATE(),
    UyeTipi NVARCHAR(20) DEFAULT 'standart' CHECK (UyeTipi IN ('standart','ogrenci','vip')),
    Rol NVARCHAR(20) DEFAULT 'uye' CHECK (Rol IN ('uye','gorevli','admin'))
);
-- Kullanýcý Ödemeleri Tablosu
CREATE TABLE KullaniciOdemeleri (
    OdemeID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    Tarih DATE DEFAULT GETDATE(),
    Ucret DECIMAL(10,2) NOT NULL,
    Aciklama NVARCHAR(200) NULL
);
-- Katlar
CREATE TABLE Katlar (
    KatID INT PRIMARY KEY,
    Ad NVARCHAR(50) NOT NULL
);
-- Odalar
CREATE TABLE Odalar (
    OdaID INT IDENTITY(1,1) PRIMARY KEY,
    KatID INT FOREIGN KEY REFERENCES Katlar(KatID),
    OdaTipi NVARCHAR(50),  -- VIP 2 kiþilik, VIP 3-4 kiþilik
    Kapasite INT,
    Musait BIT DEFAULT 1
);
-- Örnek kayýtlar
INSERT INTO Katlar (KatID, Ad) VALUES 
(1, 'Alt Kat - Sesli'), 
(2, 'Üst Kat - Sessiz');

-- Kitaplar
--kütüphanedeki kaynaklarýn temel bilgileri
CREATE TABLE Kitaplar (
    KitapID INT IDENTITY(1,1) PRIMARY KEY,
    Baslik NVARCHAR(200) NOT NULL,
    Yazar NVARCHAR(100),
    YayinYili INT,
    Durum NVARCHAR(20) DEFAULT 'Mevcut' CHECK (Durum IN ('Mevcut','OduncAlindi'))
);
--ISBN sütunu eklendi
ALTER TABLE dbo.Kitaplar
ADD ISBN NVARCHAR(20) NULL;

--Kitap Stok Sayýsý Ekleme
ALTER TABLE Kitaplar
ADD StokSayisi INT DEFAULT 0;


-- Ödünç kayýtlarý
--kim hangi kitabý aldý, iade durumu
CREATE TABLE OduncAlmalar (
    OduncID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    KitapID INT FOREIGN KEY REFERENCES Kitaplar(KitapID),
    OduncTarihi DATE DEFAULT GETDATE(),
    IadeTarihi DATE NULL
);

-- Kafe ürünleri
CREATE TABLE KafeUrunleri (
    UrunID INT IDENTITY(1,1) PRIMARY KEY,
    Ad NVARCHAR(100) NOT NULL,
    Tip NVARCHAR(50),  -- Kahve, Sandviç, Tatlý
    Fiyat DECIMAL(10,2) NOT NULL
);

-- Menüler
CREATE TABLE Menuler (
    MenuID INT IDENTITY(1,1) PRIMARY KEY,
    Ad NVARCHAR(100),
    Fiyat DECIMAL(10,2)
);

-- Menü içindeki ürünler
CREATE TABLE MenuDetaylari (
    DetayID INT IDENTITY(1,1) PRIMARY KEY,
    MenuID INT FOREIGN KEY REFERENCES Menuler(MenuID),
    UrunID INT FOREIGN KEY REFERENCES KafeUrunleri(UrunID)
);

-- Sipariþler
CREATE TABLE Siparisler (
    SiparisID INT IDENTITY(1,1) PRIMARY KEY,
    KullaniciID INT FOREIGN KEY REFERENCES Kullanicilar(KullaniciID),
    Tarih DATE DEFAULT GETDATE(),
    Toplam DECIMAL(10,2)
);

-- Sipariþ detaylarý
CREATE TABLE SiparisDetaylari (
    DetayID INT IDENTITY(1,1) PRIMARY KEY,
    SiparisID INT FOREIGN KEY REFERENCES Siparisler(SiparisID),
    UrunID INT FOREIGN KEY REFERENCES KafeUrunleri(UrunID),
    Adet INT,
    Fiyat DECIMAL(10,2)
);

--Kampanya Sorgusu
SELECT K.KullaniciID, K.AdSoyad, COUNT(*) AS KahveSayisi
FROM SiparisDetaylari SD
JOIN KafeUrunleri KU ON SD.UrunID = KU.UrunID
JOIN Siparisler S ON S.SiparisID = SD.SiparisID
JOIN Kullanicilar K ON K.KullaniciID = S.KullaniciID
WHERE KU.Tip = 'Kahve'
GROUP BY K.KullaniciID, K.AdSoyad
HAVING COUNT(*) >= 10;
