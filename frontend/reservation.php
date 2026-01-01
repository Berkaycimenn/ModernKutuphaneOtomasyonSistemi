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
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kütüphane Oda Rezervasyon Sistemi</title>
<style>
:root {
    --primary-color: #2c3e50; 
    --accent-color: #e67e22;  
    --bg-color: #ecf0f1;      
    --text-color: #333;
}
body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: var(--bg-color); margin:0; padding:0; color: var(--text-color);}
header { background-color: var(--primary-color); color:white; padding:1.5rem; text-align:center; box-shadow:0 2px 10px rgba(0,0,0,0.1);}
header h1 { margin:0; font-weight:300; letter-spacing:1px;}
.container { max-width:1000px; margin:2rem auto; padding:0 1rem; }
#time-selection-area { background:white; padding:25px; border-radius:12px; margin-bottom:30px; box-shadow:0 4px 10px rgba(0,0,0,0.05); display:flex; flex-wrap:wrap; align-items:center; gap:20px;}
#time-selection-area label { font-weight:bold; }
#time-selection-area input, #time-selection-area select { padding:10px; border-radius:5px; border:1px solid #ccc; font-size:1rem;}
.grid-rooms { display:grid; grid-template-columns:repeat(auto-fit,minmax(280px,1fr)); gap:25px; margin-top:20px;}
.room-card { background:white; border-radius:12px; padding:0; overflow:hidden; box-shadow:0 4px 8px rgba(0,0,0,0.1); transition:0.3s; cursor:pointer; border:2px solid transparent;}
.room-card:hover { transform:translateY(-5px); box-shadow:0 10px 20px rgba(0,0,0,0.15); border-color:var(--accent-color); }
.room-card-image { height:150px; background-color:#bdc3c7; background-size:cover; background-position:center; border-bottom:1px solid #eee; display:flex; align-items:center; justify-content:center; color:white; font-weight:bold;}
.room-content { padding:15px 20px;}
.room-title { font-size:1.3rem; font-weight:bold; margin-bottom:5px; color:var(--primary-color);}
.room-info { font-size:0.9rem; color:#7f8c8d; margin-bottom:8px;}
.room-info strong { color:var(--accent-color); }
.status-tag { display:inline-block; padding:5px 10px; border-radius:5px; font-weight:bold; font-size:0.8rem; margin-top:10px;}
.status-available { background-color:#2ecc71; color:white; }
.status-full { background-color:#e74c3c; color:white; }
.modal { display:none; position:fixed; z-index:100; left:0; top:0; width:100%; height:100%; overflow:auto; background-color: rgba(0,0,0,0.5); backdrop-filter: blur(3px);}
.modal-content { background-color:#fefefe; margin:10% auto; padding:30px; border-radius:10px; width:90%; max-width:450px; box-shadow:0 5px 15px rgba(0,0,0,0.3); animation:fadeIn 0.3s;}
.close-btn { color:#aaa; float:right; font-size:28px; font-weight:bold; cursor:pointer;}
.close-btn:hover { color:#000;}
.confirm-btn { width:100%; padding:12px; background-color:var(--accent-color); color:white; border:none; border-radius:5px; font-size:1.1rem; cursor:pointer; margin-top:15px; transition:0.3s;}
.confirm-btn:hover { background-color:#d35400; }
@keyframes fadeIn { from{opacity:0; transform:translateY(-20px);} to{opacity:1; transform:translateY(0);} }
@media (max-width:600px) { #time-selection-area { flex-direction:column; align-items:flex-start; } #time-selection-area label, #time-selection-area input, #time-selection-area select{width:100%; box-sizing:border-box;} }
</style>
</head>
<body>

<header><h1>VIP Oda Rezervasyon Sistemi</h1></header>

<div class="container">
    <div id="time-selection-area">
        <h3>1. Tarih ve Saat Seçimi</h3>
        <label for="reservationDate">Tarih:</label>
        <input type="date" id="reservationDate" value="2025-12-22">

        <label for="reservationStartTime">Başlangıç Saati:</label>
        <select id="reservationStartTime">
            <option value="09:00">09:00</option>
            <option value="10:00" selected>10:00</option>
            <option value="11:00">11:00</option>
            <option value="12:00">12:00</option>
            <option value="13:00">13:00</option>
            <option value="14:00">14:00</option>
            <option value="15:00">15:00</option>
            <option value="16:00">16:00</option>
        </select>

        <label for="reservationDuration">Süre (Saat):</label>
        <select id="reservationDuration">
            <option value="1">1 Saat</option>
            <option value="2">2 Saat</option>
            <option value="3" selected>3 Saat</option>
            <option value="4">4 Saat</option>
        </select>
    </div>

    <h2 style="text-align:center; color:var(--primary-color);">2. VIP Odayı Seçiniz</h2>
    <div class="grid-rooms" id="rooms-container"></div>
</div>

<div id="reservationModal" class="modal">
    <div class="modal-content">
        <span class="close-btn" onclick="closeModal()">&times;</span>
        <h2 style="color: var(--accent-color);">Rezervasyon Onayı</h2>
        <p>Aşağıdaki detaylarla VIP Odayı rezerve etmek üzeresiniz:</p>
        <ul id="reservationSummaryList" style="list-style:none; padding:0; line-height:1.8;">
            <li><strong>Oda Adı:</strong> <span id="summaryRoomName"></span></li>
            <li><strong>Tarih & Saat:</strong> <span id="summaryDate"></span></li>
            <li><strong>Süre:</strong> <span id="summaryDuration"></span></li>
            <li><strong>Kapasite:</strong> <span id="summaryCapacity"></span></li>
        </ul>
        <button class="confirm-btn" id="finalConfirmBtn" onclick="completeReservation()">Rezervasyonu Şimdi Tamamla</button>
    </div>
</div>

<script>
const roomsData = [
    {
        id: 1,
        name: "VIP Oda Akasya",
        capacity: 8,
        available: true,
        image: "../images/oda1.jpg"
    },
    {
        id: 2,
        name: "VIP Oda Sedir",
        capacity: 8,
        available: true,
        image: "../images/oda2.jpg"
    },
    {
        id: 3,
        name: "VIP Oda Çınar",
        capacity: 8,
        available: true,
        image: "../images/oda3.jpg"
    }
];

let selectedRoom = null;

function initRooms(){ renderRooms(roomsData); }

function renderRooms(rooms) {
    const container = document.getElementById("rooms-container");
    container.innerHTML = "";

    rooms.forEach(room => {
        const card = document.createElement("div");
        card.className = "room-card";

        // Oda seçilebilir mi?
        if (room.available) {
            card.onclick = () => openModal(room);
        } else {
            card.style.cursor = "not-allowed";
        }

        // Resim güvenliği (path yoksa boş kalmasın)
        const bgImage = room.image && room.image.trim() !== ""
            ? room.image
            : "../images/no-image.jpg";

        card.innerHTML = `
            <div class="room-card-image"
                 style="background-image: url('${bgImage}')">
            </div>

            <div class="room-content">
                <div class="room-title">${room.name}</div>

                <div class="room-info">
                    Kapasite: <strong>${room.capacity} Kişi</strong>
                </div>

                ${
                    room.available
                        ? `<span class="status-tag status-available">Şimdi Ayırt</span>`
                        : `<span class="status-tag status-full">DOLU</span>`
                }
            </div>
        `;

        container.appendChild(card);
    });
}
window.onload = initRooms;

function openModal(room){
    selectedRoom=room;
    const date=document.getElementById('reservationDate').value;
    const duration=document.getElementById('reservationDuration').value;
    const startTime=document.getElementById('reservationStartTime').value;

    document.getElementById('summaryRoomName').innerText=room.name;
    document.getElementById('summaryDate').innerText=date + " " + startTime;
    document.getElementById('summaryDuration').innerText=duration+" Saat";
    document.getElementById('summaryCapacity').innerText=room.capacity+" Kişilik";
    document.getElementById('reservationModal').style.display='block';
}

function closeModal(){ document.getElementById('reservationModal').style.display='none'; selectedRoom=null; }
window.onclick=function(event){ if(event.target==document.getElementById('reservationModal')){ closeModal(); } }

// 🟢 Saat düzeltmesi ve local time format
function formatDateTimeForDB(date){
    const yyyy = date.getFullYear();
    const mm = String(date.getMonth()+1).padStart(2,'0');
    const dd = String(date.getDate()).padStart(2,'0');
    const hh = String(date.getHours()).padStart(2,'0');
    const mi = String(date.getMinutes()).padStart(2,'0');
    const ss = String(date.getSeconds()).padStart(2,'0');
    return `${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}`;
}

async function completeReservation(){
    if(!selectedRoom) return;

    const date=document.getElementById('reservationDate').value;
    const duration=parseInt(document.getElementById('reservationDuration').value);
    const startTime=document.getElementById('reservationStartTime').value;

    const [startHour, startMinute] = startTime.split(':');
    const startDateTime = new Date(date);
    startDateTime.setHours(parseInt(startHour), parseInt(startMinute),0);

    const endDateTime = new Date(startDateTime);
    endDateTime.setHours(endDateTime.getHours() + duration);

    const data = {
        OdaID: selectedRoom.id,
        KullaniciID: <?= $_SESSION['kullanici_id'] ?>,
        BaslangicTarihi: formatDateTimeForDB(startDateTime),
        BitisTarihi: formatDateTimeForDB(endDateTime),
        Durum: "Aktif",
        Aciklama: "VIP Rezervasyon"
    };

    try{
        const res = await fetch("/kutuphane_backend/api/oda_rezervasyon_ekle.php", {
            method:"POST",
            headers:{"Content-Type":"application/json"},
            body:JSON.stringify(data)
        });
        const result = await res.json();
        if(result.status==="ok"){ 
			alert("Tebrikler! Rezervasyon oluşturuldu."); 
			// 🟢 Rezervasyonlarım sayfasına yönlendirme
			window.location.href = 'rezervasyonlarim.php';
		}

        else{ 
            alert("❌ Rezervasyon hatası: " + result.message); 
        }
    } catch(e){ 
        alert("❌ Rezervasyon hatası: " + e.message); 
    }
}

window.onload=initRooms;
</script>

</body>
</html>
