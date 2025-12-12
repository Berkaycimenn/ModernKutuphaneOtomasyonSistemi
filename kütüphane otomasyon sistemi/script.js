// script.js dosyası
const navbar = document.querySelector('.navbar');

window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        // Kullanıcı 50 piksel aşağı kaydırınca arka plan rengini değiştir
        navbar.style.backgroundColor = 'rgba(20, 20, 20, 0.95)'; 
    } else {
        // En üstteyken şeffaf tut
        navbar.style.backgroundColor = 'rgba(0, 0, 0, 0.3)';
    }
});
