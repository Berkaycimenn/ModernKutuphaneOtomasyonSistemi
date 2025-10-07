--Örnek Veri Ekleme
--Kullanýcýlar
INSERT INTO Kullanicilar (AdSoyad, Email, Sifre, Telefon, UyeTipi, Rol)
VALUES
('Ali Yýlmaz', 'ali@example.com', '12345', '05001112233', 'standart', 'uye'),
('Ayþe Demir', 'ayse@example.com', '54321', '05002223344', 'ogrenci', 'uye'),
('Mehmet Kaya', 'mehmet@example.com', '11111', '05003334455', 'vip', 'gorevli');
--Kullanýcý Ödemeleri
INSERT INTO KullaniciOdemeleri (KullaniciID, Ucret, Aciklama)
VALUES
(1, 50.00, 'Günlük giriþ ücreti'),
(2, 30.00, 'Öðrenci indirimi'),
(3, 100.00, 'VIP üyelik');
--Kitaplar
INSERT INTO Kitaplar (Baslik, Yazar, YayinYili, Durum)
VALUES
('Suç ve Ceza', 'Fyodor Dostoyevski', 1866, 'Mevcut'),
('Kürk Mantolu Madonna', 'Sabahattin Ali', 1943, 'Mevcut');
--Ödünç Alma
INSERT INTO OduncAlmalar (KullaniciID, KitapID, OduncTarihi)
VALUES
(1, 1, GETDATE()),   -- Ali Suç ve Ceza aldý
(2, 2, GETDATE());   -- Ayþe Kürk Mantolu Madonna aldý
--Kafe Ürünleri
INSERT INTO KafeUrunleri (Ad, Tip, Fiyat)
VALUES
('Türk Kahvesi', 'Kahve', 15.00),
('Sandviç', 'Sandviç', 25.00),
('Cheesecake', 'Tatlý', 30.00);
--Menü
INSERT INTO Menuler (Ad, Fiyat)
VALUES
('Kahve + Sandviç Menü', 35.00);

-- Menü içindeki ürünler
INSERT INTO MenuDetaylari (MenuID, UrunID)
VALUES
(1, 1),  -- Türk Kahvesi
(1, 2);  -- Sandviç
--Sipariþler
INSERT INTO Siparisler (KullaniciID, Toplam)
VALUES
(1, 40.00),  -- Ali sipariþ verdi
(2, 30.00);  -- Ayþe sipariþ verdi

-- Sipariþ detaylarý
INSERT INTO SiparisDetaylari (SiparisID, UrunID, Adet, Fiyat)
VALUES
(1, 1, 2, 15.00),   -- Ali 2 kahve aldý
(1, 3, 1, 30.00),   -- Ali cheesecake aldý
(2, 2, 1, 25.00);   -- Ayþe sandviç aldý