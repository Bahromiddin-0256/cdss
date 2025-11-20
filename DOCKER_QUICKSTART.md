# Docker Quick Start Guide

## 🚀 Tezkor Ishga Tushirish

### 1-Buyruqda Ishga Tushirish (Eng Oson)

```bash
make install
```

Bu buyruq avtomatik ravishda:
- ✅ GPU mavjudligini tekshiradi
- ✅ Docker image'larni build qiladi
- ✅ Barcha servislarni ishga tushiradi (backend + frontend)
- ✅ GPU bor bo'lsa avtomatik ishlatadi, yo'q bo'lsa CPU mode

### 2. Manual Ishga Tushirish

```bash
# Build
make build

# Ishga tushirish (avtomatik GPU detection)
make up

# Loglarni ko'rish
make logs
```

### 3. Kirish

Servislar ishga tushgandan so'ng:

- **Frontend (UI)**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Documentation**: http://localhost:8000/docs
- **Health Check**: http://localhost:8000/health

## 🎮 GPU Sozlamalari

### Avtomatik GPU Detection

Makefile avtomatik ravishda GPU mavjudligini tekshiradi va kerakli konfiguratsiyani tanlaydi:

```bash
# GPU statusini ko'rish
make help
# yoki
make gpu-check
```

### GPU bilan Ishga Tushirish

Agar GPU bor va avtomatik ishlatilmasa:

```bash
make up-gpu
```

### CPU Mode (GPU'siz)

GPU'ni o'chirish yoki faqat CPU ishlatish:

```bash
make up-cpu
```

### Manual GPU Configuration

Agar qo'lda GPU konfiguratsiyasini boshqarmoqchi bo'lsangiz:

**GPU bilan:**
```bash
docker-compose -f docker-compose.yml -f docker-compose.gpu.yml up -d
```

**GPU'siz (CPU only):**
```bash
docker-compose -f docker-compose.yml up -d
```

## 📋 Foydali Buyruqlar

### Asosiy Buyruqlar

```bash
make help              # Barcha buyruqlarni ko'rish (GPU statusini ko'rsatadi)
make install           # Bir buyruqda build + run
make build             # Docker image'larni build qilish
make up                # Servislarni ishga tushirish (auto GPU detection)
make up-gpu            # GPU bilan ishga tushirish (forced)
make up-cpu            # CPU mode (GPU'siz, forced)
make down              # Servislarni to'xtatish
make restart           # Qayta ishga tushirish
make ps                # Ishlab turgan containerlar
```

### Logs va Monitoring

```bash
make logs              # Barcha loglar
make logs-backend      # Faqat backend loglari
make logs-frontend     # Faqat frontend loglari
make health            # Health check
```

### Test va Debug

```bash
make test              # API test
make gpu-check         # GPU tekshirish (detailed)
make shell-backend     # Backend containerga kirish
make shell-frontend    # Frontend containerga kirish
```

### Tozalash va Rebuild

```bash
make clean             # Hammasini o'chirish (volumes bilan)
make rebuild           # Qayta build va ishga tushirish
```

## 🧪 Test Qilish

### 1. API Test

```bash
make test
```

### 2. Manual Test

Frontend'ga kiring: http://localhost:3000

**Test ma'lumotlari:**
- Yosh: 45
- Qon bosimi: 140
- Xolesterin: 220
- Qon shakar: 120
- BMI: 30
- Yurak urishi: 85

"🔍 Tahlil qilish" tugmasini bosing va natijalarni ko'ring.

## ⚙️ GPU Konfiguratsiyasi Haqida

### Fayllar

- `docker-compose.yml` - Asosiy konfiguratsiya (GPU'siz)
- `docker-compose.gpu.yml` - GPU override konfiguratsiyasi

### GPU Requirements

- NVIDIA GPU
- NVIDIA Driver o'rnatilgan
- NVIDIA Container Toolkit (nvidia-docker) o'rnatilgan

### GPU Driver O'rnatish

**Ubuntu/Debian:**
```bash
# NVIDIA drivers
sudo apt-get install nvidia-driver-535

# NVIDIA Docker
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
```

**Tekshirish:**
```bash
make gpu-check
```

## 🐛 Muammolarni Hal Qilish

### GPU Error

**Xatolik:** `could not select device driver "nvidia" with capabilities: [[gpu]]`

**Hal qilish:**
1. GPU'siz ishlatish:
   ```bash
   make up-cpu
   ```

2. Yoki NVIDIA Docker o'rnatish (yuqoridagi yo'riqnoma)

### Port Band

Agar 3000 yoki 8000 portlar band bo'lsa:

**Yechim 1:** Portlarni o'zgartirish

`docker-compose.yml` faylini tahrirlang:
```yaml
services:
  backend:
    ports:
      - "8001:8000"  # 8001 ga o'zgartirish
  frontend:
    ports:
      - "3001:80"    # 3001 ga o'zgartirish
```

**Yechim 2:** Band portni bo'shatish
```bash
# Portni band qilgan processni topish
sudo lsof -i :8000
sudo lsof -i :3000

# Process'ni to'xtatish
sudo kill -9 <PID>
```

### Docker Ishlamayapti

```bash
# Docker version tekshirish
docker --version
docker-compose --version

# Docker daemon ishga tushirish
# Linux:
sudo systemctl start docker
sudo systemctl enable docker

# macOS/Windows:
# Docker Desktop'ni ishga tushiring
```

### Container To'xtab Qolsa

```bash
# Loglarni ko'ring
make logs

# Status tekshirish
make ps

# Qayta ishga tushiring
make restart

# Yoki to'liq rebuild
make clean
make install
```

### Build Xatoligi

```bash
# Cache'siz qayta build
make rebuild
```

## 🔄 Development vs Production

### Development Mode (Hozirgi)

- ✅ Code hot-reload (volume mount)
- ✅ Debug logs
- ✅ Development ports

### Production Mode

Production uchun o'zgartirishlar:

1. **Volume mount'ni o'chirish** (`docker-compose.yml`):
   ```yaml
   # Bu qatorni o'chirish yoki comment qilish:
   # - ./backend:/app
   ```

2. **Environment variables**:
   ```yaml
   environment:
     - ENV=production
     - DEBUG=false
   ```

3. **Reverse proxy** (nginx, traefik)

4. **SSL/HTTPS** sozlash

5. **Monitoring** (prometheus, grafana)

## 📚 Qo'shimcha Ma'lumot

- **To'liq dokumentatsiya**: [README.md](README.md)
- **Dasturchilar uchun**: [CLAUDE.md](CLAUDE.md)
- **Asosiy konfiguratsiya**: [docker-compose.yml](docker-compose.yml)
- **GPU konfiguratsiya**: [docker-compose.gpu.yml](docker-compose.gpu.yml)

## 💡 Pro Tips

1. **GPU auto-detection ishlaydi** - `make install` yetarli!
2. **`make help` buyrug'i** GPU statusini ko'rsatadi
3. **Development uchun** code'ni o'zgartirganingizda container avtomatik update bo'ladi (volume mount)
4. **GPU kerak emas** - Demo loyiha CPU'da ham yaxshi ishlaydi
5. **Loglarni doim tekshiring** - `make logs` muhim ma'lumotlarni ko'rsatadi
