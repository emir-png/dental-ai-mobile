# Dental AI - Backend Kurulum Kılavuzu

## Ön Koşul: Python Kur

https://www.python.org/downloads/ adresinden Python 3.10+ indir ve kur.
Kurulum sırasında **"Add Python to PATH"** seçeneğini işaretle.

---

## 1. Bağımlılıkları Kur

```bash
cd backend
python -m venv venv
venv\Scripts\activate        # Windows
pip install -r requirements.txt
```

---

## 2. Sunucuyu Başlat

```bash
uvicorn main:app --host 0.0.0.0 --port 8000 --reload
```

İlk çalıştırmada **model otomatik olarak Google Drive'dan indirilir** (≈53 MB).
İndirme tamamlanınca sunucu hazır hale gelir.

Sağlık kontrolü: http://localhost:8000/health

---

## 3. Flutter Bağlantı Adresi

`lib/core/services/ai_service.dart` içindeki `kAiBaseUrl` sabitini ortama göre ayarlayın:

| Ortam | Adres |
|-------|-------|
| Android Emülatör | `http://10.0.2.2:8000` ✅ (varsayılan) |
| Gerçek cihaz (aynı Wi-Fi) | `http://<bilgisayar-LAN-IP>:8000` |
| iOS Simulator | `http://127.0.0.1:8000` |

Bilgisayarınızın LAN IP'sini öğrenmek için:
```bash
ipconfig        # Windows
```
`IPv4 Address` satırındaki adresi kullanın, örn: `http://192.168.1.105:8000`

---

## Klasör Yapısı

```
backend/
  weights/
    best.pt          ← otomatik indirilir (ilk çalıştırmada)
  main.py
  requirements.txt
  README.md
```
