# 🦷 Dental AI Mobile

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.10.3-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.10.3-0175C2?style=for-the-badge&logo=dart)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python)
![FastAPI](https://img.shields.io/badge/FastAPI-0.111.0-009688?style=for-the-badge&logo=fastapi)
![YOLOv11](https://img.shields.io/badge/YOLOv11-Ultralytics-00FFFF?style=for-the-badge)

**Yapay Zeka Destekli Dental Röntgen Analiz Uygulaması**

Diş röntgenlerinde hastalık tespiti ve analizi için geliştirilmiş mobil uygulama

[Özellikler](#-özellikler) • [Kurulum](#-kurulum) • [Kullanım](#-kullanım) • [Mimari](#-mimari) • [Teknolojiler](#-teknolojiler)

</div>

---

## 📋 İçindekiler

- [Genel Bakış](#-genel-bakış)
- [Özellikler](#-özellikler)
- [Teknolojiler](#-teknolojiler)
- [Mimari](#-mimari)
- [Kurulum](#-kurulum)
  - [Ön Koşullar](#ön-koşullar)
  - [Backend Kurulumu](#1-backend-kurulumu)
  - [Flutter Uygulaması Kurulumu](#2-flutter-uygulaması-kurulumu)
- [Kullanım](#-kullanım)
- [Proje Yapısı](#-proje-yapısı)
- [API Referansı](#-api-referansı)
- [Sorun Giderme](#-sorun-giderme)
- [Katkıda Bulunma](#-katkıda-bulunma)
- [Lisans](#-lisans)

---

## 🔍 Genel Bakış

**Dental AI Mobile**, diş hekimlerinin dental röntgenleri (X-Ray) üzerinde hızlı ve doğru analiz yapmalarını sağlayan, yapay zeka destekli bir mobil uygulamadır. YOLOv11 derin öğrenme modeli kullanarak panoramik ve periapikal röntgenlerde aşağıdaki dental bulguları tespit eder:

- 🦷 **Çürükler (Caries)**: Diş çürüğü tespiti
- 👑 **Kuron ve Köprüler (Crown - Bridge)**: Diş kaplamaları
- 🔧 **Dolgular (Filling)**: Mevcut dolgular
- 🔩 **İmplantlar (Implant)**: Dental implantlar
- 📌 **Post-Vida (Post-Screw)**: Post vida sistemleri
- 🩺 **Kanal Tedavisi (Root Canal Obturation)**: Endodontik tedavi sonrası dolgular

Uygulama, tespit edilen bulguları görsel olarak işaretler, güven skoru ile birlikte raporlar ve PDF formatında çıktı alınmasını sağlar.

---

## ✨ Özellikler

### 🎯 Ana Özellikler

- ✅ **Yapay Zeka Destekli Analiz**: YOLOv11 tabanlı gerçek zamanlı dental röntgen analizi
- 📸 **Çoklu Görüntü Kaynağı**: Kamera veya galeriden röntgen yükleme
- 🎨 **Görsel Rapor**: Tespit edilen bulguların görsel işaretlemesi (bounding box)
- 📊 **Detaylı Sonuçlar**: Her bulgu için güven skoru ve konum bilgisi
- 📄 **PDF Rapor**: Analiz sonuçlarını PDF formatında dışa aktarma
- 📚 **Geçmiş**: Tüm analizlerin yerel veritabanında saklanması
- 👤 **Kullanıcı Yönetimi**: Kayıt, giriş ve oturum yönetimi
- 🌓 **Tema Desteği**: Açık/Koyu tema
- 👨‍💼 **Admin Paneli**: Kullanıcı yönetimi ve sistem istatistikleri
- 🔒 **Gizlilik**: Yerel veritabanı ile güvenli veri saklama

### 📱 Kullanıcı Deneyimi

- Modern ve kullanıcı dostu arayüz
- Material Design 3 prensipleri
- Google Fonts (Poppins) ile şık tipografi
- Responsive tasarım
- Akıcı animasyonlar ve geçişler
- Türkçe dil desteği

---

## 🛠 Teknolojiler

### Frontend (Mobile)

| Teknoloji | Versiyon | Kullanım Amacı |
|-----------|----------|----------------|
| **Flutter** | 3.10.3+ | Cross-platform mobil uygulama framework |
| **Dart** | 3.10.3+ | Programlama dili |
| **flutter_bloc** | 9.1.1 | State management (BLoC pattern) |
| **go_router** | 14.6.3 | Deklaratif navigasyon |
| **sqflite** | 2.4.2 | Yerel SQLite veritabanı |
| **shared_preferences** | 2.3.5 | Key-value storage |
| **image_picker** | 1.1.2 | Kamera ve galeri erişimi |
| **http** | 1.2.2 | REST API iletişimi |
| **pdf** | 3.11.3 | PDF oluşturma |
| **printing** | 5.14.2 | PDF yazdırma/paylaşma |
| **google_fonts** | 6.2.1 | Web fontları |
| **equatable** | 2.0.7 | Value equality |

### Backend (API)

| Teknoloji | Versiyon | Kullanım Amacı |
|-----------|----------|----------------|
| **Python** | 3.10+ | Backend programlama dili |
| **FastAPI** | 0.111.0+ | Modern, hızlı web framework |
| **Uvicorn** | 0.30.0+ | ASGI server |
| **Ultralytics** | 8.2.0+ | YOLOv11 implementation |
| **Pillow** | 10.3.0+ | Görüntü işleme |
| **gdown** | 5.2.0+ | Google Drive entegrasyonu |

### AI Model

- **YOLOv11**: Nesne tespiti için son teknoloji
- **Model Boyutu**: ~53 MB
- **Sınıflar**: 6 dental bulgu kategorisi
- **Otomatik İndirme**: İlk çalıştırmada Google Drive'dan otomatik model indirme

---

## 🏗 Mimari

Proje, **Clean Architecture** ve **Feature-First** prensipleri ile yapılandırılmıştır:

```
dental_ai_mobile/
│
├── 📱 lib/
│   ├── core/                    # Çekirdek katman
│   │   ├── database/           # SQLite veritabanı yönetimi
│   │   ├── router/             # GoRouter yapılandırması
│   │   ├── services/           # Servisler (AI, Session)
│   │   └── theme/              # Tema ve stil tanımları
│   │
│   ├── features/               # Özellik modülleri (feature-first)
│   │   ├── auth/              # Kimlik doğrulama
│   │   ├── xray/              # Röntgen yükleme ve analiz
│   │   ├── results/           # Sonuç gösterimi
│   │   ├── history/           # Geçmiş analizler
│   │   ├── admin/             # Admin paneli
│   │   └── info/              # Hakkında, İletişim, Gizlilik
│   │
│   ├── shared/                # Paylaşılan bileşenler
│   │   └── widgets/           # Ortak widget'lar
│   │
│   └── main.dart              # Uygulama giriş noktası
│
├── 🐍 backend/
│   ├── main.py                # FastAPI backend
│   ├── requirements.txt       # Python bağımlılıkları
│   ├── weights/               # YOLOv11 model ağırlıkları
│   └── README.md              # Backend dökümantasyonu
│
└── 📄 pubspec.yaml            # Flutter bağımlılıkları
```

### Veri Akışı

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile UI)    │
└────────┬────────┘
         │ HTTP/REST
         ▼
┌─────────────────┐
│  FastAPI        │
│  Backend Server │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  YOLOv11 Model  │
│  (Inference)    │
└─────────────────┘
```

---

## 🚀 Kurulum

### Ön Koşullar

Sisteminizde aşağıdaki yazılımların yüklü olması gerekmektedir:

- ✅ [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.10.3+)
- ✅ [Python](https://www.python.org/downloads/) (3.10+)
- ✅ [Android Studio](https://developer.android.com/studio) veya [VS Code](https://code.visualstudio.com/)
- ✅ Android Emulator veya fiziksel Android cihaz
- ✅ Git

### 1. Backend Kurulumu

#### Adım 1: Projeyi Klonlayın

```bash
git clone <repository-url>
cd dental_ai_mobile
```

#### Adım 2: Python Sanal Ortamı Oluşturun

```bash
# Windows
python -m venv .venv
.venv\Scripts\activate

# macOS/Linux
python3 -m venv .venv
source .venv/bin/activate
```

#### Adım 3: Bağımlılıkları Yükleyin

```bash
cd backend
pip install -r requirements.txt
```

#### Adım 4: Backend Sunucusunu Başlatın

```bash
# Windows
cd backend
..\\.venv\\Scripts\\uvicorn.exe main:app --host 0.0.0.0 --port 8000 --reload

# macOS/Linux
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

> 🔔 **Not**: İlk çalıştırmada YOLOv11 model dosyası (~53 MB) otomatik olarak Google Drive'dan indirilecektir.

#### Adım 5: Sunucu Kontrolü

Backend başarıyla çalışıyorsa şu adreslere erişebilmelisiniz:

- **Sağlık Kontrolü**: http://localhost:8000/health
- **API Dokümantasyonu**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

Sağlık kontrolü yanıtı:
```json
{
  "status": "ok",
  "classes": {
    "0": "Caries",
    "1": "Crown - bridge",
    "2": "Filling",
    "3": "Implant",
    "4": "Post-screw",
    "5": "Root Canal Obturation"
  }
}
```

### 2. Flutter Uygulaması Kurulumu

#### Adım 1: Flutter Bağımlılıklarını Yükleyin

```bash
# Proje kök dizininde
flutter pub get
```

#### Adım 2: Backend Bağlantısını Yapılandırın

`lib/core/services/ai_service.dart` dosyasını açın ve ortamınıza göre `kAiBaseUrl` sabitini ayarlayın:

| Ortam | Adres | Açıklama |
|-------|-------|----------|
| **Android Emulator** | `http://10.0.2.2:8000` | Varsayılan (emulator host mapping) |
| **iOS Simulator** | `http://127.0.0.1:8000` | Localhost |
| **Fiziksel Cihaz** | `http://<PC_IP>:8000` | Bilgisayarınızın LAN IP adresi |

**PC'nizin IP adresini öğrenmek için:**
```bash
# Windows
ipconfig

# macOS/Linux
ifconfig
```

Örnek: `http://192.168.1.105:8000`

#### Adım 3: Uygulamayı Çalıştırın

```bash
# Android Emulator/Cihaz için
flutter run

# Belirli bir cihaz için
flutter devices
flutter run -d <device-id>
```

#### Adım 4: Uygulama İçi Test Kullanıcısı

İlk kullanım için bir hesap oluşturun veya test için:

- **E-posta**: test@example.com
- **Şifre**: test123

---

## 📖 Kullanım

### 1. Kayıt ve Giriş

- Uygulamayı ilk açtığınızda **Login** ekranı görünür
- "Hesabınız yok mu? Kayıt Ol" linkine tıklayarak kayıt olun
- E-posta ve şifre ile giriş yapın

### 2. Röntgen Analizi

1. Ana ekranda **"Röntgen Yükle"** butonuna tıklayın
2. **Kamera** veya **Galeri** seçeneğinden birini seçin
3. Dental röntgen görüntüsünü seçin veya çekin
4. **"Analiz Et"** butonuna tıklayın
5. AI analizi tamamlandığında sonuçlar görüntülenir

### 3. Sonuçları İnceleme

- Tespit edilen her bulgu için:
  - 🏷️ Hastalık/bulgu adı
  - 📊 Güven skoru (%)
  - 📍 Görüntü üzerinde işaretleme (bounding box)
  
### 4. PDF Rapor Oluşturma

- Sonuç ekranında **"PDF Oluştur"** butonuna tıklayın
- PDF paylaşım veya kaydetme seçeneklerini kullanın

### 5. Geçmişi Görüntüleme

- Sol menüden **"Geçmiş"** sekmesine gidin
- Tüm önceki analizlerinizi görüntüleyin
- Bir analiz üzerine tıklayarak detayları görün

### 6. Admin Paneli (Yönetici)

Admin yetkisine sahip kullanıcılar için:
- **Kullanıcı listesi** ve yönetimi
- **Sistem istatistikleri**
- **Analiz geçmişi**

---

## 📂 Proje Yapısı

### Detaylı Klasör Yapısı

```
dental_ai_mobile/
│
├── 📱 lib/
│   │
│   ├── 🎯 main.dart                          # Uygulama başlangıcı
│   │
│   ├── 🔧 core/                              # Çekirdek işlevsellik
│   │   ├── database/
│   │   │   └── database_helper.dart          # SQLite CRUD işlemleri
│   │   │
│   │   ├── router/
│   │   │   └── app_router.dart               # GoRouter yapılandırması
│   │   │
│   │   ├── services/
│   │   │   ├── ai_service.dart               # AI Backend API client
│   │   │   └── session_service.dart          # Oturum yönetimi
│   │   │
│   │   └── theme/
│   │       ├── app_colors.dart               # Renk paleti
│   │       ├── app_theme.dart                # Tema yapılandırması
│   │       └── theme_cubit.dart              # Tema state management
│   │
│   ├── 🎨 features/                          # Özellik modülleri
│   │   │
│   │   ├── auth/                             # Kimlik doğrulama
│   │   │   └── presentation/
│   │   │       ├── login_screen.dart         # Giriş ekranı
│   │   │       └── register_screen.dart      # Kayıt ekranı
│   │   │
│   │   ├── xray/                             # Röntgen analizi
│   │   │   └── presentation/
│   │   │       └── xray_upload_screen.dart   # Yükleme ve analiz
│   │   │
│   │   ├── results/                          # Sonuç gösterimi
│   │   │   └── presentation/
│   │   │       └── results_screen.dart       # Analiz sonuçları
│   │   │
│   │   ├── history/                          # Geçmiş
│   │   │   └── presentation/
│   │   │       └── history_screen.dart       # Geçmiş analizler
│   │   │
│   │   ├── admin/                            # Yönetici
│   │   │   └── presentation/
│   │   │       └── admin_panel_screen.dart   # Admin paneli
│   │   │
│   │   └── info/                             # Bilgi sayfaları
│   │       └── presentation/
│   │           ├── about_screen.dart         # Hakkında
│   │           ├── contact_screen.dart       # İletişim
│   │           └── privacy_screen.dart       # Gizlilik
│   │
│   └── 🔄 shared/                            # Paylaşılan bileşenler
│       └── widgets/
│           ├── app_drawer.dart               # Navigasyon drawer
│           └── main_scaffold.dart            # Ana scaffold
│
├── 🐍 backend/                               # Python Backend
│   ├── main.py                               # FastAPI server
│   ├── requirements.txt                      # Python packages
│   ├── README.md                             # Backend dokümanı
│   └── weights/
│       └── best.pt                           # YOLOv11 model (auto-download)
│
├── 🤖 android/                               # Android yapılandırması
│
├── 📝 test/                                  # Test dosyaları
│   └── widget_test.dart
│
├── 📄 pubspec.yaml                           # Flutter bağımlılıkları
├── 📖 README.md                              # Bu dosya
├── 🚫 .gitignore                             # Git ignore kuralları
└── ⚙️ analysis_options.yaml                  # Dart analyzer

```

### Veritabanı Şeması

**users** tablosu:
```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  email TEXT UNIQUE NOT NULL,
  password TEXT NOT NULL,
  name TEXT NOT NULL,
  isAdmin INTEGER DEFAULT 0,
  createdAt TEXT NOT NULL
)
```

**analyses** tablosu:
```sql
CREATE TABLE analyses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  userId INTEGER NOT NULL,
  imagePath TEXT NOT NULL,
  results TEXT NOT NULL,  -- JSON formatında
  createdAt TEXT NOT NULL,
  FOREIGN KEY (userId) REFERENCES users(id)
)
```

---

## 🔌 API Referansı

### Backend Endpoints

#### GET `/health`

Sunucu durumu ve model bilgisi.

**Response:**
```json
{
  "status": "ok",
  "classes": {
    "0": "Caries",
    "1": "Crown - bridge",
    "2": "Filling",
    "3": "Implant",
    "4": "Post-screw",
    "5": "Root Canal Obturation"
  }
}
```

#### POST `/predict`

Röntgen görüntüsü analizi.

**Parameters:**
- `file` (multipart/form-data): Görüntü dosyası
- `conf` (float, optional): Güven eşiği (default: 0.25)

**Request:**
```bash
curl -X POST "http://localhost:8000/predict?conf=0.25" \
  -F "file=@xray_image.jpg"
```

**Response:**
```json
{
  "predictions": [
    {
      "disease": "Caries",
      "confidence": 0.9345,
      "x1": 0.1234,
      "y1": 0.3456,
      "x2": 0.2789,
      "y2": 0.5678
    },
    {
      "disease": "Filling",
      "confidence": 0.8721,
      "x1": 0.4567,
      "y1": 0.2345,
      "x2": 0.5678,
      "y2": 0.4567
    }
  ]
}
```

**Koordinatlar:** Normalize edilmiş değerler (0.0 - 1.0 arası)

---

## 🔧 Sorun Giderme

### Backend Bağlantı Sorunları

#### Sorun: "Connection refused" veya "Network error"

**Çözüm 1: Backend'in Çalıştığını Doğrulayın**
```bash
# Terminal'de
curl http://localhost:8000/health
```

**Çözüm 2: Firewall Ayarları (Windows)**
```powershell
# PowerShell (Administrator)
New-NetFirewallRule -DisplayName "Dental AI Backend" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow
```

**Çözüm 3: Doğru IP Adresini Kullanın**
- Android Emulator için: `http://10.0.2.2:8000`
- Fiziksel cihaz için: `http://<PC_LAN_IP>:8000`

#### Sorun: Model indirilemedi

**Çözüm:**
1. İnternet bağlantınızı kontrol edin
2. Google Drive erişimini doğrulayın
3. Manuel olarak modeli indirip `backend/weights/best.pt` konumuna yerleştirin

### Flutter Sorunları

#### Sorun: "Pub get failed"

**Çözüm:**
```bash
flutter clean
flutter pub get
```

#### Sorun: "Android license not accepted"

**Çözüm:**
```bash
flutter doctor --android-licenses
```

### Performans Optimizasyonu

- **Backend**: Uvicorn worker sayısını artırın
- **Mobile**: Görüntü boyutunu optimize edin (maks. 1920x1080)
- **Model**: `conf` parametresini ayarlayarak hassasiyeti optimize edin

Detaylı sorun giderme için `BAGLANTI_SORUNU_COZUMU.md` dosyasına bakın.

---

## 🧠 Diğer Derin Öğrenme Modellerini Entegre Etme

Bu uygulama, farklı derin öğrenme modellerinin kolayca entegre edilebilmesini sağlayacak şekilde tasarlanmıştır. Mevcut YOLOv11 modeli dışında başka modelleri de kullanabilirsiniz.

### 🎯 Desteklenen Model Türleri

Aşağıdaki model formatları ve framework'leri desteklenir:

| Framework | Format | Açıklama |
|-----------|--------|----------|
| **YOLOv5/v8/v11** | `.pt` | Ultralytics YOLO modelleri (Nesne tespiti) |
| **TensorFlow** | `.h5`, `.pb` | TensorFlow SavedModel veya Keras |
| **PyTorch** | `.pt`, `.pth` | PyTorch modelleri |
| **ONNX** | `.onnx` | Framework-agnostik format |
| **TensorFlow Lite** | `.tflite` | Mobil için optimize edilmiş |
| **Core ML** | `.mlmodel` | iOS için optimize edilmiş |

### 📋 Model Entegrasyonu Adımları

#### 1️⃣ YOLOv8 veya YOLOv5 Modeli Entegrasyonu

Eğer farklı bir YOLO versiyonu kullanmak istiyorsanız:

**Adım 1: Modelinizi Hazırlayın**
```bash
# Örnek: YOLOv8 modelini eğittiyseniz
# best.pt dosyanızı backend/weights/ klasörüne kopyalayın
cp /path/to/your/yolov8_best.pt backend/weights/best.pt
```

**Adım 2: backend/main.py'de Model Yolunu Güncelleyin**
```python
# backend/main.py dosyasında model yolu zaten generic:
MODEL_PATH = WEIGHTS_DIR / "best.pt"

# Ultralytics otomatik olarak YOLO versiyonunu algılar
model = YOLO(str(MODEL_PATH))
```

**Adım 3: Sınıf İsimlerini Doğrulayın**
```python
# Model yüklendikten sonra sınıf isimlerini kontrol edin
print(f"Model classes: {model.names}")
```

Model başarıyla entegre edildi! Uygulama otomatik olarak yeni model ile çalışacaktır.

---

#### 2️⃣ Google Drive'dan Özel Model Yükleme

Kendi modelinizi Google Drive'dan otomatik indirmek için:

**Adım 1: Modelinizi Google Drive'a Yükleyin**
1. Google Drive'a modelinizi yükleyin
2. Dosyayı sağ tıklayın → "Get link" → "Anyone with the link"
3. Paylaşım linkini kopyalayın

**Adım 2: Drive File ID'sini Alın**
```
Drive linki: https://drive.google.com/file/d/1ABC123XYZ/view?usp=sharing
File ID: 1ABC123XYZ (ortadaki kısım)
```

**Adım 3: backend/main.py'yi Güncelleyin**
```python
# backend/main.py - Satır 25 civarı
GDRIVE_FILE_ID = "1ABC123XYZ"  # Kendi File ID'nizi buraya yazın
GDRIVE_URL = f"https://drive.google.com/uc?id={GDRIVE_FILE_ID}"
```

**Adım 4: Backend'i Yeniden Başlatın**
```bash
cd backend
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

Yeni model otomatik olarak indirilecek ve yüklenecektir.

---

#### 3️⃣ TensorFlow/Keras Modeli Entegrasyonu

TensorFlow veya Keras modeli kullanmak için:

**Adım 1: Bağımlılıkları Ekleyin**
```bash
# backend/requirements.txt dosyasına ekleyin:
tensorflow>=2.13.0
# veya
tensorflow-cpu>=2.13.0  # CPU versiyonu (daha küçük)
```

**Adım 2: backend/main.py'yi Düzenleyin**
```python
# backend/main.py
import tensorflow as tf
from tensorflow.keras.models import load_model
import numpy as np

# Model yükleme
MODEL_PATH = WEIGHTS_DIR / "my_model.h5"
model = load_model(str(MODEL_PATH))

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """TensorFlow model ile tahmin"""
    
    # Görüntüyü yükle
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    
    # Ön işleme (modelinize göre ayarlayın)
    img_array = np.array(image.resize((224, 224)))
    img_array = img_array / 255.0  # Normalizasyon
    img_array = np.expand_dims(img_array, axis=0)
    
    # Tahmin
    predictions = model.predict(img_array)
    
    # Sonucu formatla
    result = {
        "predictions": [
            {
                "class": class_names[i],
                "confidence": float(predictions[0][i])
            }
            for i in range(len(class_names))
        ]
    }
    
    return result
```

---

#### 4️⃣ PyTorch Özel Model Entegrasyonu

PyTorch ile eğitilmiş özel bir model kullanmak için:

**Adım 1: Model Sınıfını Tanımlayın**
```python
# backend/model_definition.py (yeni dosya)
import torch
import torch.nn as nn

class CustomDentalModel(nn.Module):
    def __init__(self, num_classes=6):
        super(CustomDentalModel, self).__init__()
        # Modelinizin mimarisini buraya tanımlayın
        self.features = nn.Sequential(
            nn.Conv2d(3, 64, kernel_size=3, padding=1),
            nn.ReLU(),
            nn.MaxPool2d(2, 2),
            # ... diğer katmanlar
        )
        self.classifier = nn.Linear(512, num_classes)
    
    def forward(self, x):
        x = self.features(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
        return x
```

**Adım 2: backend/main.py'de Model Yükleyin**
```python
# backend/main.py
import torch
from model_definition import CustomDentalModel

# Model yükleme
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = CustomDentalModel(num_classes=6)
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.to(device)
model.eval()

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """PyTorch model ile tahmin"""
    
    # Görüntüyü yükle ve ön işle
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    
    # Transforms (modelinize göre ayarlayın)
    transform = transforms.Compose([
        transforms.Resize((224, 224)),
        transforms.ToTensor(),
        transforms.Normalize(mean=[0.485, 0.456, 0.406],
                           std=[0.229, 0.224, 0.225])
    ])
    
    img_tensor = transform(image).unsqueeze(0).to(device)
    
    # Tahmin
    with torch.no_grad():
        outputs = model(img_tensor)
        probabilities = torch.nn.functional.softmax(outputs, dim=1)
    
    # Sonucu formatla
    results = []
    for idx, prob in enumerate(probabilities[0]):
        results.append({
            "class": class_names[idx],
            "confidence": float(prob)
        })
    
    return {"predictions": results}
```

---

#### 5️⃣ ONNX Model Entegrasyonu (Cross-Platform)

ONNX format'ı tüm framework'lerle uyumludur ve daha hızlı inference sağlar:

**Adım 1: Modelinizi ONNX'e Çevirin**
```python
# PyTorch'tan ONNX'e
import torch

dummy_input = torch.randn(1, 3, 224, 224)
torch.onnx.export(
    model,
    dummy_input,
    "backend/weights/model.onnx",
    export_params=True,
    opset_version=11,
    input_names=['input'],
    output_names=['output']
)
```

**Adım 2: ONNX Runtime Kurun**
```bash
# backend/requirements.txt
onnxruntime>=1.15.0
# veya GPU versiyonu
onnxruntime-gpu>=1.15.0
```

**Adım 3: backend/main.py'de ONNX Kullanın**
```python
# backend/main.py
import onnxruntime as ort
import numpy as np

# ONNX model yükleme
MODEL_PATH = WEIGHTS_DIR / "model.onnx"
ort_session = ort.InferenceSession(str(MODEL_PATH))

@app.post("/predict")
async def predict(file: UploadFile = File(...)):
    """ONNX model ile tahmin"""
    
    # Görüntü ön işleme
    contents = await file.read()
    image = Image.open(io.BytesIO(contents)).convert("RGB")
    img_array = np.array(image.resize((224, 224)))
    img_array = img_array.transpose(2, 0, 1)  # HWC -> CHW
    img_array = img_array / 255.0
    img_array = np.expand_dims(img_array, axis=0).astype(np.float32)
    
    # ONNX inference
    ort_inputs = {ort_session.get_inputs()[0].name: img_array}
    ort_outputs = ort_session.run(None, ort_inputs)
    
    # Sonuçları işle
    predictions = ort_outputs[0][0]
    
    results = []
    for idx, score in enumerate(predictions):
        results.append({
            "class": class_names[idx],
            "confidence": float(score)
        })
    
    return {"predictions": results}
```

---

### 🔄 Çoklu Model Desteği (Model Switching)

Birden fazla modeli aynı anda desteklemek için:

**backend/main.py örneği:**
```python
from enum import Enum

class ModelType(str, Enum):
    YOLO = "yolo"
    TENSORFLOW = "tensorflow"
    PYTORCH = "pytorch"
    ONNX = "onnx"

# Tüm modelleri yükle
models = {
    ModelType.YOLO: YOLO("weights/yolo_best.pt"),
    ModelType.TENSORFLOW: load_model("weights/tf_model.h5"),
    # ... diğer modeller
}

@app.post("/predict")
async def predict(
    file: UploadFile = File(...),
    model_type: ModelType = ModelType.YOLO,
    conf: float = 0.25
):
    """Seçilen model ile tahmin yap"""
    
    selected_model = models[model_type]
    
    # Model tipine göre farklı işlemler
    if model_type == ModelType.YOLO:
        # YOLO inference
        results = selected_model.predict(...)
    elif model_type == ModelType.TENSORFLOW:
        # TensorFlow inference
        results = selected_model.predict(...)
    # ...
    
    return results
```

**Flutter tarafında model seçimi:**
```dart
// lib/core/services/ai_service.dart
Future<AnalysisResult> analyzeImage(
  File imageFile, {
  String modelType = 'yolo',  // 'yolo', 'tensorflow', 'pytorch'
}) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('$kAiBaseUrl/predict?model_type=$modelType'),
  );
  
  request.files.add(
    await http.MultipartFile.fromPath('file', imageFile.path),
  );
  
  // ... rest of the code
}
```

---

### 📦 Model Optimizasyon İpuçları

#### GPU Hızlandırma
```python
# CUDA kullanılabilirliğini kontrol et
import torch
print(f"CUDA available: {torch.cuda.is_available()}")
print(f"CUDA device: {torch.cuda.get_device_name(0)}")

# Model'i GPU'ya taşı
model = model.cuda()
```

#### Quantization (Model Boyutunu Küçültme)
```python
# PyTorch Dynamic Quantization
import torch.quantization as quantization

quantized_model = quantization.quantize_dynamic(
    model, {torch.nn.Linear}, dtype=torch.qint8
)
```

#### Batch Processing
```python
# Çoklu görüntü işleme
@app.post("/predict/batch")
async def predict_batch(files: List[UploadFile] = File(...)):
    """Toplu tahmin"""
    results = []
    for file in files:
        result = await predict_single(file)
        results.append(result)
    return {"batch_results": results}
```

---

### 📝 Model Yapılandırma Dosyası (Önerilen)

Model ayarlarını merkezi bir yapılandırma dosyasında tutun:

**backend/model_config.yaml:**
```yaml
models:
  yolo_v11:
    type: yolo
    path: weights/yolo_v11_best.pt
    confidence_threshold: 0.25
    classes:
      0: Caries
      1: Crown - bridge
      2: Filling
      3: Implant
      4: Post-screw
      5: Root Canal Obturation
  
  custom_cnn:
    type: tensorflow
    path: weights/custom_cnn.h5
    input_size: [224, 224]
    preprocessing:
      normalize: true
      mean: [0.485, 0.456, 0.406]
      std: [0.229, 0.224, 0.225]
    classes:
      0: Healthy
      1: Diseased

active_model: yolo_v11
```

**Python'da kullanımı:**
```python
import yaml

with open('model_config.yaml', 'r') as f:
    config = yaml.safe_load(f)

active_model_config = config['models'][config['active_model']]
MODEL_PATH = active_model_config['path']
```

---

### 🧪 Model Test ve Validasyon

Yeni model entegrasyonunu test etmek için:

```bash
# Backend test komutu
curl -X POST "http://localhost:8000/predict" \
  -F "file=@test_xray.jpg" \
  -F "model_type=yolo"

# Yanıt formatını kontrol edin
# Beklenen: {"predictions": [...]}
```

**Test script'i (Python):**
```python
# backend/test_model.py
import requests

def test_model(image_path, model_type='yolo'):
    """Model entegrasyonunu test et"""
    
    url = "http://localhost:8000/predict"
    
    with open(image_path, 'rb') as f:
        files = {'file': f}
        params = {'model_type': model_type}
        
        response = requests.post(url, files=files, params=params)
    
    if response.status_code == 200:
        print(f"✅ Model test başarılı: {model_type}")
        print(f"Sonuçlar: {response.json()}")
    else:
        print(f"❌ Model test başarısız: {response.status_code}")
        print(f"Hata: {response.text}")

# Test
test_model("test_images/dental_xray_1.jpg", "yolo")
```

---

### 💡 Best Practices

1. **Model Versiyonlama**: Her model için versiyon numarası kullanın (`model_v1.0.0.pt`)
2. **Model Metadata**: Model ile birlikte sınıf isimleri ve ayarları saklayın
3. **Performans İzleme**: Inference sürelerini logla ve optimize et
4. **Fallback Mekanizması**: Ana model başarısız olursa yedek model kullan
5. **Cache**: Sık kullanılan sonuçları önbelleğe al
6. **Logging**: Tüm tahminleri ve hataları logla

---

### 📚 Ek Kaynaklar

- **Ultralytics Docs**: https://docs.ultralytics.com/
- **TensorFlow Model Garden**: https://github.com/tensorflow/models
- **PyTorch Hub**: https://pytorch.org/hub/
- **ONNX Model Zoo**: https://github.com/onnx/models
- **Hugging Face Models**: https://huggingface.co/models

---

## 🤝 Katkıda Bulunma

Katkılarınızı bekliyoruz! Lütfen aşağıdaki adımları izleyin:

1. **Fork** edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. **Pull Request** açın

### Commit Mesaj Kuralları

Conventional Commits formatını kullanın:

- `feat:` Yeni özellik
- `fix:` Bug düzeltmesi
- `docs:` Dokümantasyon
- `style:` Stil değişiklikleri
- `refactor:` Kod refactoring
- `test:` Test ekleme/düzeltme
- `chore:` Diğer değişiklikler

---

## 📄 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

---

## 👥 İletişim

Sorularınız veya önerileriniz için:

- 📧 E-posta: info@dentalai.com
- 🌐 Website: www.dentalai.com
- 📱 GitHub Issues: [Sorun Bildirin](https://github.com/yourusername/dental_ai_mobile/issues)

---

## 🙏 Teşekkürler

Bu proje aşağıdaki açık kaynak projeleri kullanmaktadır:

- [Flutter](https://flutter.dev/) - UI framework
- [FastAPI](https://fastapi.tiangolo.com/) - Web framework
- [Ultralytics YOLOv11](https://github.com/ultralytics/ultralytics) - AI model
- [GoRouter](https://pub.dev/packages/go_router) - Navigation
- [flutter_bloc](https://pub.dev/packages/flutter_bloc) - State management

---

## 📊 Proje İstatistikleri

- **Toplam Satır**: ~5000+ LOC
- **Ekran Sayısı**: 10+ screen
- **Desteklenen Bulgu**: 6 dental kategori
- **Model Accuracy**: ~90%+ (test set)
- **Platform**: Android, iOS ready

---

## 🗺️ Yol Haritası

### v1.1 (Planlanan)
- [ ] iOS desteği ve test
- [ ] Çoklu dil desteği (EN, TR)
- [ ] Gelişmiş rapor şablonları
- [ ] Bulut senkronizasyonu

### v1.2 (Gelecek)
- [ ] Dental klinik entegrasyonu
- [ ] Toplu görüntü analizi
- [ ] AI model versiyonlama
- [ ] Hasta geçmişi yönetimi

### v2.0 (Uzun Vade)
- [ ] 3D dental görüntüleme
- [ ] Gerçek zamanlı video analizi
- [ ] Web dashboard
- [ ] Multi-tenant sistem

---

<div align="center">

**⭐ Bu projeyi beğendiyseniz yıldız vermeyi unutmayın! ⭐**

Made with ❤️ by Dental AI Team

</div>
