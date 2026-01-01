<?php
session_start();

/* Giriş kontrolü */
if (!isset($_SESSION['kullanici_id'])) {
    header("Location: giris.html");
    exit;
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <title>Hesabım | Kütüphane Luna</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>

<body>

<!-- NAVBAR -->
<header class="navbar">
    <div class="logo">
        <span style="color:white;font-weight:bold;">LUNA</span>
    </div>

    <nav class="nav-links">
        <a href="anasayfa.php" class="nav-item">ANASAYFA</a>
        <a href="profil.php" class="nav-item active">HESABIM</a>
        <a href="cikis.php" class="nav-item">ÇIKIŞ</a>
    </nav>
</header>

<!-- PROFİL ALANI -->
<main style="padding-top:120px; min-height:80vh; background:#f5f5f5;">
    <div style="
        max-width:600px;
        margin:0 auto;
        background:white;
        padding:40px;
        border-radius:10px;
        box-shadow:0 10px 30px rgba(0,0,0,0.1);
    ">

        <h2 style="margin-bottom:30px; color:#2e4d3a;">
            👤 Hesabım
        </h2>

<?php 
	if (isset($_SESSION['basari'])): ?>
		<div style="color:green; margin-bottom:20px;">
			<?= $_SESSION['basari']; unset($_SESSION['basari']); ?>
		</div>
<?php endif; ?>


        <p style="font-size:18px; margin-bottom:25px;">
            <strong>Ad Soyad:</strong>
            <?= htmlspecialchars($_SESSION['adsoyad']) ?>
        </p>

        <hr style="margin:30px 0;">

        <div style="display:flex; gap:15px; flex-wrap:wrap;">
            <a href="rezervasyonlarim.php" style="
				padding:12px 20px;
				background:#2e4d3a;
				color:white;
				text-decoration:none;
				border-radius:6px;
			">📚 Rezervasyonlarım</a>

            <!-- Güncellenen Hesap Ayarları Butonu -->
            <a href="hesap_ayarlar.php" style="
                padding:12px 20px;
                background:#7c5cb1;
                color:white;
                text-decoration:none;
                border-radius:6px;
            ">⚙️ Hesap Ayarları</a>

            <a href="cikis.php" style="
                padding:12px 20px;
                background:#b23b3b;
                color:white;
                text-decoration:none;
                border-radius:6px;
            ">🚪 Çıkış Yap</a>
        </div>

    </div>
</main>

</body>
</html>
