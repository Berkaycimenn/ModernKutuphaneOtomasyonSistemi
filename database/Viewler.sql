--View
--Bugün Kim Giriþ Yaptý
CREATE VIEW vw_BugunGirisYapanlar
AS
SELECT K.KullaniciID, K.AdSoyad, KO.Tarih, KO.Ucret
FROM KullaniciOdemeleri KO
JOIN Kullanicilar K ON KO.KullaniciID = K.KullaniciID
WHERE CAST(KO.Tarih AS DATE) = CAST(GETDATE() AS DATE);

--Kullanýmý
SELECT * FROM vw_BugunGirisYapanlar;

--En Çok Kahve Alan Kullanýcý
CREATE VIEW vw_EnCokKahveAlanKullanicilar
AS
SELECT TOP 10 
    K.KullaniciID,
    K.AdSoyad,
    COUNT(*) AS KahveSayisi
FROM SiparisDetaylari SD
JOIN Siparisler S ON SD.SiparisID = S.SiparisID
JOIN Kullanicilar K ON S.KullaniciID = K.KullaniciID
JOIN KafeUrunleri KU ON SD.UrunID = KU.UrunID
WHERE KU.Tip = 'Kahve'
GROUP BY K.KullaniciID, K.AdSoyad
ORDER BY KahveSayisi DESC;

--Kullanýmý
SELECT * FROM vw_EnCokKahveAlanKullanicilar;

--Þuan Kimde Hangi Kitap Var
CREATE VIEW vw_OduncKitaplar
AS
SELECT 
    K.AdSoyad, 
    KT.Baslik AS KitapAdi, 
    O.OduncTarihi, 
    O.IadeTarihi
FROM OduncAlmalar O
JOIN Kullanicilar K ON O.KullaniciID = K.KullaniciID
JOIN Kitaplar KT ON O.KitapID = KT.KitapID
WHERE O.IadeTarihi IS NULL;

--Kullanýmý
SELECT * FROM vw_OduncKitaplar;

--Kafe Satýþ Raporu
CREATE VIEW vw_KafeSatisRaporu
AS
SELECT 
    K.AdSoyad,
    SUM(SD.Adet * SD.Fiyat) AS ToplamHarcama,
    COUNT(S.SiparisID) AS SiparisSayisi
FROM SiparisDetaylari SD
JOIN Siparisler S ON SD.SiparisID = S.SiparisID
JOIN Kullanicilar K ON S.KullaniciID = K.KullaniciID
GROUP BY K.AdSoyad;

--Kullanýmý
SELECT * FROM vw_KafeSatisRaporu;

--Aktif Rezervasyonlar
CREATE VIEW vw_AktifRezervasyonlar AS
SELECT 
    r.RezervasyonID,
    k.AdSoyad AS KullaniciAdi,
    o.OdaAdi,
    r.BaslangicTarihi,
    r.BitisTarihi,
    r.Durum
FROM OdaRezervasyonlari r
JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
JOIN Odalar o ON r.OdaID = o.OdaID
WHERE r.Durum = 'Aktif';

--Bugünkü Rezervasyonlar
CREATE VIEW vw_BugunkuRezervasyonlar AS
SELECT 
    r.RezervasyonID,
    o.OdaAdi,
    k.AdSoyad,
    r.BaslangicTarihi,
    r.BitisTarihi
FROM OdaRezervasyonlari r
JOIN Odalar o ON r.OdaID = o.OdaID
JOIN Kullanicilar k ON r.KullaniciID = k.KullaniciID
WHERE CONVERT(DATE, r.BaslangicTarihi) = CONVERT(DATE, GETDATE());

--Aktif Rezervasyonlar View

CREATE OR ALTER VIEW vw_AktifRezervasyonlar
AS
SELECT 
    r.RezervasyonID,
    r.OdaID,
    o.OdaAdi,
    o.Kapasite,
    r.BaslangicTarihi,
    r.BitisTarihi,
    r.Aciklama
FROM OdaRezervasyonlari r
INNER JOIN Odalar o
    ON r.OdaID = o.OdaID
WHERE r.BitisTarihi >= GETDATE();  -- sadece bitmemiþ rezervasyonlar

--Rapor Önerisi
CREATE VIEW vw_EnCokRezerveEdilenOdalar AS
SELECT TOP 5 
    o.OdaAdi,
    COUNT(r.RezervasyonID) AS RezervasyonSayisi
FROM OdaRezervasyonlari r
JOIN Odalar o ON r.OdaID = o.OdaID
GROUP BY o.OdaAdi
ORDER BY RezervasyonSayisi DESC;


CREATE OR ALTER VIEW vw_AktifRezervasyonlar
AS
SELECT 
    r.RezervasyonID,
    o.OdaID,
    o.OdaAdi,
    k.KullaniciID,
    k.AdSoyad AS KullaniciAdi,
    r.BaslangicTarihi,
    r.BitisTarihi,
    r.Durum,
    r.Aciklama
FROM dbo.OdaRezervasyonlari r
INNER JOIN dbo.Odalar o ON r.OdaID = o.OdaID
INNER JOIN dbo.Kullanicilar k ON r.KullaniciID = k.KullaniciID
WHERE r.BitisTarihi >= GETDATE();  -- Sadece aktif veya gelecekteki rezervasyonlar


-- Günlük Kafe Satýþlarý View
CREATE OR ALTER VIEW vw_KafeGunlukSatis
AS
SELECT 
    CONVERT(DATE, SatisTarihi) AS SatisTarihi,
    UrunID,
    SUM(Miktar) AS ToplamAdet,
    SUM(Toplam) AS ToplamGelir
FROM KafeSatislar
GROUP BY CONVERT(DATE, SatisTarihi), UrunID;


-- Aylýk Kafe Satýþlarý View
CREATE OR ALTER VIEW vw_KafeAylikSatis
AS
SELECT 
    YEAR(SatisTarihi) AS Yil,
    MONTH(SatisTarihi) AS Ay,
    UrunID,
    SUM(Miktar) AS ToplamAdet,
    SUM(Toplam) AS ToplamGelir
FROM KafeSatislar
GROUP BY YEAR(SatisTarihi), MONTH(SatisTarihi), UrunID;


