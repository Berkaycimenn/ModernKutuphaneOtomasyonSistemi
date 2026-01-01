<?php
session_start();

if (!isset($_SESSION['kullanici_id'])) {
    header("Location: giris.html");
    exit;
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Hesap Ayarları | Kütüphane Luna</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body>

<header class="navbar">
    <div class="logo"><span style="color:white;font-weight:bold;">LUNA</span></div>
    <nav class="nav-links">
        <a href="anasayfa.php" class="nav-item">ANASAYFA</a>
        <a href="profil.php" class="nav-item">HESABIM</a>
        <a href="cikis.php" class="nav-item">ÇIKIŞ</a>
    </nav>
</header>

<main style="padding-top:120px; min-height:80vh; background:#f5f5f5;">
    <div style="max-width:600px; margin:0 auto; background:white; padding:40px; border-radius:10px; box-shadow:0 10px 30px rgba(0,0,0,0.1);">

        <h2 style="margin-bottom:30px; color:#2e4d3a;">⚙️ Hesap Ayarları</h2>

        <?php if (isset($_SESSION['hata'])): ?>
            <div style="color:#721c24; background:#f8d7da; padding:12px; border-radius:6px; margin-bottom:20px; border:1px solid #f5c6cb;">
                <?= $_SESSION['hata']; unset($_SESSION['hata']); ?>
            </div>
        <?php endif; ?>

        <?php if (isset($_SESSION['basari'])): ?>
            <div style="color:#155724; background:#d4edda; padding:12px; border-radius:6px; margin-bottom:20px; border:1px solid #c3e6cb;">
                <?= $_SESSION['basari']; unset($_SESSION['basari']); ?>
            </div>
        <?php endif; ?>

        <form action="/kutuphane_backend/api/kullanici_guncelle.php" method="POST" style="display:flex; flex-direction:column; gap:20px;">
            <div>
                <label for="adsoyad" style="font-weight:bold; display:block; margin-bottom:8px;">Ad Soyad:</label>
                <input type="text" id="adsoyad" name="adsoyad" 
                       value="<?= htmlspecialchars($_SESSION['adsoyad'] ?? '') ?>" 
                       style="width:100%; padding:10px; border-radius:6px; border:1px solid #ccc;" required>
            </div>

            <div>
                <label for="sifre" style="font-weight:bold; display:block; margin-bottom:8px;">Yeni Şifre:</label>
                <input type="password" id="sifre" name="sifre" 
                       placeholder="Değiştirmek istemiyorsanız boş bırakın" 
                       style="width:100%; padding:10px; border-radius:6px; border:1px solid #ccc;">
            </div>

            <button type="submit" style="padding:12px 20px; background:#7c5cb1; color:white; border:none; border-radius:6px; font-size:16px; cursor:pointer; font-weight:600;">
                💾 Değişiklikleri Kaydet
            </button>
        </form>

        <div style="margin-top:30px; text-align: center;">
            <a href="profil.php" style="color:#2e4d3a; text-decoration:none; font-weight:600;">🔙 Profilime Dön</a>
        </div>
    </div>
</main>
</body>
</html>
