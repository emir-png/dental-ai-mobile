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
