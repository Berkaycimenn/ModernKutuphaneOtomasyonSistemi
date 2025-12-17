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

// Sayfa yüklendiğinde varsayılan olarak Sign In formunu aktif et
document.addEventListener('DOMContentLoaded', () => {
    showForm('signin');
});

function showForm(formId) {
    // Tüm formları ve düğmeleri seç
    const forms = document.querySelectorAll('.form');
    const buttons = document.querySelectorAll('.tab-button');
    const dots = document.querySelectorAll('.dot');
    
    // Tüm formları gizle
    forms.forEach(form => {
        form.classList.remove('active');
        form.classList.add('hidden');
    });

    // Tüm düğmelerden 'active' sınıfını kaldır
    buttons.forEach(button => {
        button.classList.remove('active');
    });
    
    // Tüm noktaların içini boşalt
    dots.forEach(dot => {
         dot.style.backgroundColor = 'transparent';
         dot.style.borderColor = 'white';
    });

    // İstenen formu görünür yap
    const activeForm = document.getElementById(formId + '-form');
    if (activeForm) {
        activeForm.classList.remove('hidden');
        activeForm.classList.add('active');
    }

    // İstenen düğmeyi aktif yap
    const activeButton = document.querySelector(`.tab-button[onclick*="${formId}"]`);
    if (activeButton) {
        activeButton.classList.add('active');
    }
    
    // Aktif olan noktanın içini doldur
    const activeDot = document.getElementById(formId + '-dot');
    if (activeDot) {
        activeDot.style.backgroundColor = '#e59a4c';
        activeDot.style.borderColor = '#e59a4c';
    }
}