<?php
session_start();
date_default_timezone_set('Europe/Istanbul'); // 🟢 Türkiye saat dilimi
if (!isset($_SESSION['kullanici_id'])) {
    header("Location: giris.html");
    exit;
}

// DB bağlantısı
require_once __DIR__ . "/../../kutuphane_backend/config/db.php";

// Kullanıcının rezervasyonlarını çek
try {
    $stmt = $conn->prepare("EXEC dbo.sp_KullaniciRezervasyonlariGetir @KullaniciID=:kul");
    $stmt->execute([':kul' => $_SESSION['kullanici_id']]);
    $rezervasyonlar = $stmt->fetchAll(PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    die("Hata: " . $e->getMessage());
}
?>
<!DOCTYPE html>
<html lang="tr">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Rezervasyonlarım</title>
<style>
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#ecf0f1; margin:0; padding:0; color:#333; }
header { background:#2c3e50; color:white; padding:1rem; text-align:center; }
header h1 { margin:0; font-weight:300; }
.navbar { display:flex; justify-content:center; gap:15px; padding:10px 0; background:#34495e; }
.navbar a { color:white; text-decoration:none; padding:5px 10px; border-radius:5px; transition:0.3s; }
.navbar a:hover { background:#e67e22; }
.container { max-width:900px; margin:2rem auto; padding:0 1rem; }
.rezervasyon-card { background:white; border-radius:10px; padding:15px 20px; margin-bottom:15px; box-shadow:0 4px 8px rgba(0,0,0,0.1); }
.rezervasyon-card h3 { margin:0 0 10px 0; color:#2c3e50; }
.rezervasyon-info { margin:5px 0; }
.status-tag { display:inline-block; padding:5px 10px; border-radius:5px; font-weight:bold; font-size:0.9rem; margin-top:10px; }
.status-aktif { background:#2ecc71; color:white; }
.status-tamamlandi { background:#e74c3c; color:white; }
</style>
</head>
<body>

<header>
    <h1>Rezervasyonlarım</h1>
    <div class="navbar">
        <a href="anasayfa.php">Anasayfa</a>
        <a href="profil.php">Hesabım</a>
        <a href="cikis.php">Çıkış</a>
    </div>
</header>

<div class="container">
    <?php if(empty($rezervasyonlar)): ?>
        <p>Henüz rezervasyonunuz bulunmamaktadır.</p>
    <?php else: ?>
        <?php foreach($rezervasyonlar as $row): ?>
            <?php
                $baslangic = date("H:i", strtotime($row["BaslangicTarihi"]));
                $bitis = date("H:i", strtotime($row["BitisTarihi"]));
                $durum = strtolower($row["Durum"]) === "aktif" ? "status-aktif" : "status-tamamlandi";
                $aciklama = $row["Aciklama"] ?? "-";
            ?>
            <div class="rezervasyon-card">
                <h3><?= htmlspecialchars($row["OdaAdi"]) ?></h3>
                <div class="rezervasyon-info"><strong>Tarih Başlangıcı:</strong> <?= date("Y-m-d", strtotime($row["BaslangicTarihi"])) ?> <?= $baslangic ?></div>
                <div class="rezervasyon-info"><strong>Tarih Bitiş:</strong> <?= date("Y-m-d", strtotime($row["BitisTarihi"])) ?> <?= $bitis ?></div>
                <div class="rezervasyon-info"><strong>Açıklama:</strong> <?= htmlspecialchars($aciklama) ?></div>
                <span class="status-tag <?= $durum ?>"><?= htmlspecialchars($row["Durum"]) ?></span>
            </div>
        <?php endforeach; ?>
    <?php endif; ?>
</div>

</body>
</html>
