# CDSS - Klinik Qarorlarni Qo'llab-quvvatlash Tizimi

Clinical Decision Support System (CDSS) - Kasallik Bashorat Qilish Tizimi

Bu loyiha 3-4 soatda ishlab chiqilgan oddiy lekin to'liq ishlayotgan demo versiyasi bo'lib, bemor ma'lumotlari asosida kasallik bashoratini amalga oshiradi.

## ⚠️ Muhim Ogohlantirish

**Bu tizim faqat demo va ta'lim maqsadida yaratilgan. Haqiqiy tibbiy qarorlar uchun mutlaqo shifokorga murojaat qiling!**

## 📋 Loyiha Haqida

### Funksiyalar

- ✅ Bemorning asosiy ma'lumotlarini kiritish
- ✅ Machine Learning model orqali kasallik bashorati
- ✅ Natijalarni vizualizatsiya qilish (grafiklar)
- ✅ RESTful API backend (FastAPI)
- ✅ Zamonaviy frontend interface (Vue.js 3)
- ✅ Responsive dizayn (mobile-friendly)

### Texnologiyalar

**Backend:**
- Python 3.8+
- FastAPI - zamonaviy, tez API framework
- scikit-learn - Machine Learning
- pandas & numpy - ma'lumotlar bilan ishlash
- uvicorn - ASGI server

**Frontend:**
- HTML5, CSS3, JavaScript
- Vue.js 3 - Progressive JavaScript framework
- Chart.js - ma'lumotlar vizualizatsiyasi
- Axios - HTTP so'rovlar uchun

**DevOps:**
- Docker & Docker Compose
- Nginx - frontend web server
- GPU support (NVIDIA Docker)

## 🐳 Docker bilan Ishga Tushirish (TAVSIYA ETILADI)

Docker bilan ishga tushirish eng oson va tez usul! Barcha kerakli muhit avtomatik sozlanadi.

### Talablar

- Docker va Docker Compose o'rnatilgan bo'lishi kerak
- GPU ishlatish uchun: NVIDIA Docker runtime

### Tezkor Ishga Tushirish

**Usul 1: Makefile bilan (eng oson)**

```bash
# Hammasini bir buyruq bilan o'rnatish va ishga tushirish
make install

# Yoki bosqichma-bosqich:
make build    # Docker image'larni yaratish
make up       # Servislarni ishga tushirish
make logs     # Loglarni ko'rish
make test     # API test qilish
```

**Usul 2: Docker Compose bilan**

```bash
# Servislarni ishga tushirish (GPU bilan)
docker-compose up -d

# Loglarni ko'rish
docker-compose logs -f

# To'xtatish
docker-compose down
```

### GPU Sozlamalari (Avtomatik)

**Avtomatik GPU Detection:**

Tizim avtomatik ravishda GPU mavjudligini aniqlaydi:
- ✅ **GPU bor** → Avtomatik GPU bilan ishga tushadi
- ✅ **GPU yo'q** → CPU mode'da ishlaydi (hech qanday xatolik yo'q!)

**GPU statusini tekshirish:**
```bash
make help        # GPU statusini ko'rsatadi
make gpu-check   # Batafsil GPU ma'lumotlari
```

**Manual GPU boshqarish:**
```bash
make up-gpu      # GPU bilan ishga tushirish (majburiy)
make up-cpu      # CPU mode (majburiy)
```

**GPU fayllari:**
- `docker-compose.yml` - Asosiy (GPU'siz)
- `docker-compose.gpu.yml` - GPU override

Demo loyiha CPU'da ham mukammal ishlaydi - GPU ixtiyoriy!

### Foydali Buyruqlar

```bash
make help              # Barcha buyruqlarni ko'rish (GPU statusini ko'rsatadi)
make install           # Bir buyruqda build + run
make build             # Docker image'larni build qilish
make up                # Servislarni ishga tushirish (auto GPU detection)
make up-gpu            # GPU bilan ishga tushirish (majburiy)
make up-cpu            # CPU mode (majburiy)
make down              # Servislarni to'xtatish
make restart           # Qayta ishga tushirish
make logs              # Barcha loglar
make logs-backend      # Faqat backend loglari
make logs-frontend     # Faqat frontend loglari
make ps                # Ishlab turgan containerlar
make health            # Servislar holatini tekshirish
make test              # API test
make gpu-check         # GPU tekshirish (batafsil)
make clean             # Hammasini tozalash
make rebuild           # Qayta build va ishga tushirish
make shell-backend     # Backend containerga kirish
make shell-frontend    # Frontend containerga kirish
```

### Docker bilan Kirish

✅ Servislar ishga tushgandan so'ng:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/docs

## 📁 Loyiha Strukturasi

```
cdss/
├── backend/
│   ├── main.py              # FastAPI dasturi va endpointlar
│   ├── ml_model.py          # ML model o'rgatish va bashorat
│   ├── requirements.txt     # Python kutubxonalari
│   ├── Dockerfile           # Backend Docker image
│   ├── .dockerignore        # Docker ignore fayllari
│   ├── model.pkl           # O'rgatilgan model (auto-generated)
│   └── scaler.pkl          # Feature scaler (auto-generated)
├── frontend/
│   ├── index.html          # Asosiy interfeys
│   ├── app.js             # Vue.js dastur logikasi
│   ├── style.css          # Stillar
│   ├── nginx.conf         # Nginx konfiguratsiyasi
│   ├── Dockerfile         # Frontend Docker image
│   └── .dockerignore      # Docker ignore fayllari
├── docker-compose.yml     # Docker Compose konfiguratsiyasi
├── Makefile              # Automation buyruqlari
├── README.md
└── CLAUDE.md
```

## 🔧 Manual Ishga Tushirish (Docker'siz)

### 1. Backend Ishga Tushirish

```bash
# Backend papkasiga o'tish
cd backend

# Virtual environment yaratish (ixtiyoriy lekin tavsiya etiladi)
python -m venv venv

# Virtual environment faollashtirish
# Windows uchun:
venv\Scripts\activate
# Mac/Linux uchun:
source venv/bin/activate

# Kutubxonalarni o'rnatish
pip install -r requirements.txt

# Serverni ishga tushirish
python main.py
```

✅ Backend ishga tushdi:
- API: http://localhost:8000
- API Dokumentatsiya: http://localhost:8000/docs
- Health Check: http://localhost:8000/health

### 2. Frontend Ishga Tushirish

Yangi terminal oynasini oching va:

```bash
# Frontend papkasiga o'tish
cd frontend

# HTTP server ishga tushirish
# Option 1: Python bilan
python -m http.server 3000

# Option 2: Node.js bilan (agar o'rnatilgan bo'lsa)
npx http-server -p 3000
```

✅ Frontend ishga tushdi:
- UI: http://localhost:3000

## 🧪 Test Qilish

### 1. Backend API Test

Brauzerda http://localhost:8000/docs ga kiring va quyidagi ma'lumotlar bilan `/api/predict` endpointni test qiling:

```json
{
  "age": 45,
  "blood_pressure": 140,
  "cholesterol": 220,
  "glucose": 120,
  "bmi": 30,
  "heart_rate": 85
}
```

### 2. Frontend Test

1. http://localhost:3000 ga kiring
2. Formani to'ldiring (default qiymatlar allaqachon kiritilgan)
3. "🔍 Tahlil qilish" tugmasini bosing
4. Natijalarni ko'ring:
   - Kasallik bashorati
   - Ishonch darajasi
   - Barcha kasalliklar ehtimolligi
   - Grafik vizualizatsiya

### Test Ma'lumotlari

Turli xil natijalarni ko'rish uchun quyidagi ma'lumotlarni sinab ko'ring:

**Test 1: Yosh bemor, yaxshi ko'rsatkichlar**
- Yosh: 30
- Qon bosimi: 110
- Xolesterin: 170
- Qon shakar: 90
- BMI: 23
- Yurak urishi: 70

**Test 2: O'rta yosh, yuqori xavf**
- Yosh: 55
- Qon bosimi: 150
- Xolesterin: 250
- Qon shakar: 140
- BMI: 32
- Yurak urishi: 90

**Test 3: Katta yosh, turli ko'rsatkichlar**
- Yosh: 65
- Qon bosimi: 135
- Xolesterin: 210
- Qon shakar: 115
- BMI: 27
- Yurak urishi: 80

## 📊 API Endpointlar

### `GET /`
Asosiy ma'lumot va mavjud endpointlar ro'yxati

### `GET /health`
Tizim va model holatini tekshirish

**Response:**
```json
{
  "status": "ok",
  "model_loaded": true
}
```

### `POST /api/predict`
Bemor ma'lumotlari asosida kasallik bashorati

**Request Body:**
```json
{
  "age": 45,
  "blood_pressure": 130,
  "cholesterol": 200,
  "glucose": 110,
  "bmi": 28.5,
  "heart_rate": 75
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "prediction": "Yurak kasalligi",
    "confidence": 35.2,
    "all_probabilities": {
      "Sog'lom": 15.3,
      "Yurak kasalligi": 35.2,
      "Diabet": 20.1,
      "Gipertenziya": 18.4,
      "Astma": 11.0
    }
  },
  "patient_info": {...}
}
```

### `GET /api/diseases`
Barcha kasalliklar ro'yxati

**Response:**
```json
{
  "diseases": [
    "Sog'lom",
    "Yurak kasalligi",
    "Diabet",
    "Gipertenziya",
    "Astma"
  ]
}
```

## 🤖 Machine Learning Model

### Kiritish Ma'lumotlari (Features)
Model 6 ta xususiyatni qabul qiladi:

1. **age** - Yosh (0-120)
2. **blood_pressure** - Sistolic qon bosimi (60-200 mmHg)
3. **cholesterol** - Xolesterin darajasi (100-400 mg/dL)
4. **glucose** - Qon shakar (50-300 mg/dL)
5. **bmi** - Tana Massa Indeksi (10-50 kg/m²)
6. **heart_rate** - Yurak urish tezligi (40-200 bpm)

### Model Arxitekturasi

- **Algoritm**: RandomForestClassifier
- **Daraxtlar soni**: 100
- **Preprocessing**: StandardScaler
- **Training data**: 1000 simulyatsiya qilingan namuna (demo uchun)

### Bashorat Siniflari

1. Sog'lom
2. Yurak kasalligi
3. Diabet
4. Gipertenziya
5. Astma

### Model Fayllari

Birinchi ishga tushirishda model avtomatik o'rgatiladi va quyidagi fayllar yaratiladi:
- `backend/model.pkl` - o'rgatilgan model
- `backend/scaler.pkl` - feature normalizatsiya qiluvchi

## 🛠️ Kengaytirish Imkoniyatlari

Kelajakda qo'shish mumkin bo'lgan xususiyatlar:

- 📊 Ko'proq kasalliklar va aniqroq model
- 💾 Ma'lumotlar bazasi integratsiyasi
- 👤 Foydalanuvchi autentifikatsiyasi
- 📈 Bemor tarixini saqlash
- 📱 Mobile dastur
- 🔔 Email/SMS bildirishnomalar
- 📄 PDF hisobotlar generatsiyasi
- 🌐 Ko'p tillilik (Ingliz, Rus, O'zbek)
- 🔒 HIPAA/Ma'lumotlar xavfsizligi
- 🧠 Chuqur o'rganish (Deep Learning) modellari

## 🐛 Muammolarni Hal Qilish

### Backend ishga tushmayapti

```bash
# Python versiyasini tekshiring
python --version  # 3.8+ bo'lishi kerak

# Kutubxonalarni qayta o'rnating
pip install --upgrade pip
pip install -r requirements.txt
```

### Frontend serverga ulanmayapti

1. Backend ishlab turganini tekshiring: http://localhost:8000/health
2. CORS xatoligi bo'lsa, brauzer konsolini tekshiring
3. Backend `main.py` da CORS sozlamalari to'g'riligini tasdiqlang

### Model yuklash xatoligi

```bash
# Backend papkasida model fayllarini o'chiring va qayta yarating
cd backend
rm model.pkl scaler.pkl
python main.py  # Model avtomatik qayta yaratiladi
```

## 📝 Litsenziya

Bu loyiha ta'lim maqsadida yaratilgan va ochiq kodli.

## 👨‍💻 Muallif

CDSS Mini Demo Project - 2024

## 📞 Aloqa

Savollar yoki takliflar uchun issue yarating yoki pull request yuboring.

---

**Eslatma:** Bu demo loyiha haqiqiy tibbiy amaliyotda foydalanish uchun mo'ljallanmagan. Har qanday tibbiy qarorlarni faqat malakali shifokorlar bilan maslahatlashib qabul qiling.
