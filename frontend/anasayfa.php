<?php
session_start();
?>
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kütüphane Luna</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Montserrat:wght@400;600&display=swap" rel="stylesheet">
</head>
<body class="anasayfa">

<header class="navbar">
    <div class="logo">
        <img src="" class="logo-image" alt="">

    </div>
    <nav class="nav-links">
        <a href="anasayfa.php" class="nav-item active">ANASAYFA</a>
        <a href="hakkimizda.html" class="nav-link">Hakkımızda</a>
        <a href="reservation.php" class="nav-item reservation-btn">REZERVASYON</a>

 

        <?php if (isset($_SESSION['kullanici_id'])): ?>
            <a href="profil.php" class="nav-link">
                HESABIM (<?= htmlspecialchars($_SESSION['adsoyad']) ?>)
            </a>
            <a href="cikis.php" class="nav-link">ÇIKIŞ</a>
        <?php else: ?>
            <a href="giris.html" class="nav-link">GİRİŞ</a>
        <?php endif; ?>
    </nav>
</header>

<section class="hero-section">
    <div class="hero-content">
        <h1>KÜTÜPHANE LUNA</h1>
        <p>Aklınızda kalacak işler için...</p>
        <div class="hero-buttons">
            <a href="../html/menu_kategoriler.html" class="action-btn">MENÜ</a>
            <a href="kampanya.html" class="action-btn">KAMPANYALAR</a>
        </div>
    </div>
</section>

<section class="repeating-strip">
    <div class="strip-content">
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
        <span>KÜTÜPHANE LUNA +</span>
    </div>
</section>

<section class="mission-section">
    <div class="mission-icon">★</div> 
    <div class="mission-content">
        <h2>Zihninize Alan <br> Ruhunuza Huzur</h2>
        <p class="mission-text">
            Kütüphane Luna, sadece kitaplarla değil, sohbetlerle de dolu bir buluşma noktası.
            Çayınızı alıp okuma köşemizde vakit geçirebilirsiniz.
            Dilerseniz sesli alanda, sessiz alanda ve özel odalarda çalışmalarınızı yapabilirsiniz.
            Üstelik grup çalışma odalarımızı rezervasyon yaparak toplantılarınızı,
            sunumlarınızı ve özel derslerinizi rahatlıkla yapabilirsiniz.
        </p>
    </div>
</section>

<section class="sections-container">
    <h2 class="main-title">Bölümlerimiz</h2>
    <div class="cards-wrapper">
        <div class="section-card">
            <img src="../images/sessizalan.jpeg" alt="Sessiz çalışma alanı" class="card-image">
            <h3 class="card-title">Sessiz Alan</h3>
            <p class="card-description">
                Birlikte ama yalnız! Her şeyden uzak, tek başına çalışmayı sevenler için tasarlandı.
            </p>
        </div>
        <div class="section-card">
            <img src="../images/seslialan.jpeg" alt="Sesli sosyalleşme alanı" class="card-image">
            <h3 class="card-title">Sesli Alan</h3>
            <p class="card-description">
                Birlikte çalışmak isteyenler için tasarlandı.
            </p>
        </div>
        <div class="section-card">
            <img src="../images/grupoda.jpeg" alt="Grup çalışma alanı" class="card-image">
            <h3 class="card-title">Grup Çalışma Alanı</h3>
            <p class="card-description">
                En az 5 en çok 10 kişilik projeleriniz ve etkinlikleriniz için idealdir.
            </p>
        </div>
    </div>
</section>

<section class="gallery-section">
    <h2 class="section-title">Kütüphanemizden Kareler</h2>

    <div class="gallery-container">
        <button class="slider-btn prev-btn" id="prevBtn">&#10094;</button>

        <div class="slider-window">
            <div class="slider-track" id="sliderTrack">
                <div class="slide-item"><img src="../images/galeri1.png"></div>
                <div class="slide-item"><img src="../images/galeri2.png"></div>
                <div class="slide-item"><img src="../images/galeri3.png"></div>
                <div class="slide-item"><img src="../images/galeri5.png"></div>
                <div class="slide-item"><img src="../images/galeri6.png"></div>
                <div class="slide-item"><img src="../images/hakkimizda_fotoğraf.jpg"></div>
            </div>
        </div>

        <button class="slider-btn next-btn" id="nextBtn">&#10095;</button>
    </div>
</section>

<footer class="site-footer">
    <footer class="site-footer" style="padding-top: 10px;"> <div class="footer-header" style="margin-bottom: 15px;">
        <h2 class="footer-title" style="font-family: 'Bebas Neue', sans-serif; margin-top: 0;">KÜTÜPHANE LUNA</h2>
        <p class="footer-slogan" style="font-family: 'Montserrat', sans-serif; margin-bottom: 10px;">yeni nesil kütüphane &nbsp; + &nbsp; kitap &nbsp; + &nbsp; kahve</p>
    </div>
    <div class="footer-columns">
        <div class="footer-col footer-links">
            <h3 class="col-title">HIZLI LİNKLER</h3>
            <ul>
                <li><a href="anasayfa.php">ANASAYFA</a></li>
                <li><a href="hakkimizda.html">HAKKIMIZDA</a></li>
                
            </ul>
        </div>
        <div class="footer-col">
            <h3 class="col-title">ÇALIŞMA SAATLERİ</h3>
            <p>Her gün</p>
            <p><strong>08:00 - 22:00</strong></p>
            <p>arası hizmetinizdeyiz.</p>
        </div>
        <div class="footer-col">
            <h3 class="col-title">ADRES</h3>
            <p>Kennedy Cd No:17, 06420</p>
            <p>Kızılay / Ankara, Türkiye</p>
        </div>
        <div class="footer-col footer-contact">
            <h3 class="col-title">İLETİŞİM</h3>
            <p>Tel: 0312 417 4181</p>
            <p>e-posta: kutuphaneluna@gmail.com</p>
            <div class="footer-legal">
                <a href="../html/kvkk.html">(KVKK) Aydınlatma Metni</a>
            </div>
        </div>
    </div>
</footer>

<script src="../js/script.js"></script>

</body>
</html>

