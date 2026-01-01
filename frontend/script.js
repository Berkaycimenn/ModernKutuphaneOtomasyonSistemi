// ----------------- Fonksiyonlar global scope (Her yerden erişilebilir) -----------------

/**
 * Kayıt formunu görünür yapar, giriş formunu gizler.
 * CSS'teki 'hidden' class'ını kullanarak görünürlüğü tetikler.
 */
window.showRegister = function() {
    document.getElementById('login-section').classList.add('hidden');
    document.getElementById('register-section').classList.remove('hidden');
}

/**
 * Giriş formunu görünür yapar, kayıt formunu gizler.
 */
window.showLogin = function() {
    document.getElementById('register-section').classList.add('hidden');
    document.getElementById('login-section').classList.remove('hidden');
}

/**
 * Yeni kullanıcı kayıt işlemini gerçekleştirir.
 */
window.register = function() {
    // KVKK (Kişisel Verilerin Korunması Kanunu) onay kutusunun seçili olup olmadığını denetler.
    const kvkChecked = document.getElementById('regKvk').checked;
    if (!kvkChecked) {
        alert("KVKK metnini okudunuz ve kabul ettiniz mi? Onay kutusunu işaretleyin.");
        return; // Onay yoksa işlemi durdurur.
    }

    // Input alanlarındaki verileri alır ve sağındaki-solundaki boşlukları temizler (.trim()).
    const ad = document.getElementById('regAd').value.trim();
    const soyad = document.getElementById('regSoyad').value.trim();
    const email = document.getElementById('regEmail').value.trim();
    const sifre = document.getElementById('regSifre').value.trim();

    // Zorunlu alan kontrolü yapar.
    if(!ad || !soyad || !email || !sifre){
        alert("Lütfen tüm alanları doldurun!");
        return;
    }

    const adSoyad = ad + " " + soyad;

    // Backend API'sine POST isteği göndererek verileri JSON formatında iletir.
    fetch('../../kutuphane_backend/api/kullanici_ekle.php', {
        method:'POST',
        headers:{ 'Content-Type':'application/json' },
        body: JSON.stringify({ AdSoyad:adSoyad, Email:email, Sifre:sifre })
    })
    .then(res=>res.json()) // Sunucudan gelen cevabı JSON olarak ayrıştırır.
    .then(data=>{
        if(data.status==="ok"){
            alert("Kayıt başarılı! Kullanıcı ID: "+data.YeniKullaniciID);
            showLogin(); // Kayıt sonrası kullanıcıyı giriş ekranına yönlendirir.
        } else {
            alert("Hata: "+data.message);
        }
    })
    .catch(err=>console.error("Fetch hatası:", err)); // Bağlantı veya sunucu hatalarını yakalar.
}

/**
 * Kullanıcı giriş yapma mantığını yönetir.
 */
window.login = function() {
    // Giriş sayfasındaki KVKK onay kontrolü.
    const kvkChecked = document.getElementById('loginKvk').checked;
    if (!kvkChecked) {
        alert("KVKK metnini okudunuz ve kabul ettiniz mi? Onay kutusunu işaretleyin.");
        return;
    }

    const email = document.getElementById('loginEmail').value.trim();
    const sifre = document.getElementById('loginPassword').value.trim();

    if(!email || !sifre){
        alert("E-posta ve şifre gerekli!");
        return;
    }

    // Giriş bilgilerini kontrol etmek için backend'e gönderir.
    fetch('../../kutuphane_backend/api/giris.php', {
        method:'POST',
        headers:{ 'Content-Type':'application/json' },
        body: JSON.stringify({ Email:email, Sifre:sifre })
    })
    .then(res=>res.json())
    .then(data=>{
        if(data.status==="ok"){
            // Giriş başarılıysa, veritabanına giriş yapıldığına dair log kaydı atar.
            fetch('../../kutuphane_backend/api/kullanici_giris_kaydet.php', {
                method:'POST',
                headers:{ 'Content-Type':'application/json' },
                body: JSON.stringify({ KullaniciID:data.KullaniciID, Basarili:true })
            });
            alert("Giriş başarılı! Hoşgeldiniz "+data.AdSoyad);
            window.location.href='anasayfa.php'; // Başarılı girişte ana sayfaya yönlendirir.
        } else {
            alert("Hata: "+data.message);
        }
    })
    .catch(err=>console.error("Fetch hatası:", err));
}

// ================= SLIDER (Görsel Kaydırıcı) MANTIĞI =================
// Sayfa tamamen yüklendiğinde çalışacak olay yakalayıcı.
document.addEventListener("DOMContentLoaded", () => {
    const sliderTrack = document.getElementById("sliderTrack"); // Kayacak olan ana kapsayıcı
    const prevBtn = document.getElementById("prevBtn"); // Geri butonu
    const nextBtn = document.getElementById("nextBtn"); // İleri butonu

    // Eğer sayfada slider elemanları yoksa (hata vermemesi için) fonksiyonu durdurur.
    if (!sliderTrack || !prevBtn || !nextBtn) return;

    const slideItems = document.querySelectorAll(".slide-item");
    const slideGap = 25; // CSS'te tanımlanan boşluk (gap) değeri
    let currentIndex = 0; // Şu an kaçıncı görselde olduğumuzu tutan sayaç

    /**
     * Tek bir görselin genişliğini ve boşluğu hesaplar.
     */
    function getSlideWidth() {
        return slideItems[0].offsetWidth + slideGap;
    }

    /**
     * Slider'ın transform özelliğini güncelleyerek kayma hareketini sağlar.
     */
    function updateSlider() {
        const moveX = currentIndex * getSlideWidth();
        // translateX ile CSS üzerinden yatayda kaydırma yapar.
        sliderTrack.style.transform = `translateX(-${moveX}px)`;
    }

    // Sonraki butonu: Toplam görsel sayısından 3 eksik olana kadar ilerler (Görünüm alanına göre).
    nextBtn.addEventListener("click", () => {
        if (currentIndex < slideItems.length - 3) {
            currentIndex++;
            updateSlider();
        }
    });

    // Önceki butonu: İlk görsele kadar geri gelmeyi sağlar.
    prevBtn.addEventListener("click", () => {
        if (currentIndex > 0) {
            currentIndex--;
            updateSlider();
        }
    });

    // Ekran boyutu değiştiğinde (Resize), kayma miktarını yeniden hesaplar.
    window.addEventListener("resize", updateSlider);
});
