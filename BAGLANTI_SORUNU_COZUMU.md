# Bağlantı Sorunu Çözüm Adımları

## ✅ Yapılanlar:
1. Backend doğru şekilde başlatıldı: `uvicorn main:app --host 0.0.0.0 --port 8000`
2. Backend `0.0.0.0:8000` üzerinde dinliyor (Android emülatörü erişebilir)
3. Model yüklendi ve sağlık kontrolü (health check) başarılı

## 🔧 Şimdi Yapmanız Gerekenler:

### Adım 1: Uygulamayı Test Edin
1. Android emülatörünüzde uygulamayı **kapatıp yeniden açın** (hot restart yapın)
2. Bir röntgen görüntüsü yükleyip analiz etmeyi deneyin

### Adım 2: Hala Hata Alıyorsanız - Firewall Kuralı Ekleyin

**Windows Firewall'da Port 8000'i Açın:**

1. Windows Arama'da "Windows Defender Firewall" yazıp açın
2. Sol taraftan "**Advanced settings**" (Gelişmiş ayarlar) tıklayın
3. Sol panelden "**Inbound Rules**" (Gelen Kurallar) seçin
4. Sağ taraftan "**New Rule...**" (Yeni Kural) tıklayın
5. "**Port**" seçip **Next**
6. "**TCP**" seçin ve "**Specific local ports**" altına **8000** yazıp **Next**
7. "**Allow the connection**" seçip **Next**
8. Hepsini işaretli bırakıp **Next**
9. İsim: **Dental AI Backend** yazıp **Finish**

**VEYA PowerShell ile (Administrator olarak):**
```powershell
New-NetFirewallRule -DisplayName "Dental AI Backend" -Direction Inbound -LocalPort 8000 -Protocol TCP -Action Allow
```

### Adım 3: Emülatörü Yeniden Başlatın (Gerekirse)
1. Android emülatörünü kapatın
2. Yeniden başlatın
3. Uygulamayı yeniden açın ve test edin

### Adım 4: Backend Bağlantısını Test Edin

Terminal'de (emülatör içinden):
```bash
# Emülatör terminal'inde (adb shell):
curl http://10.0.2.2:8000/health
```

Bilgisayarınızdan:
```bash
curl http://localhost:8000/health
```

Her ikisi de başarılı olmalı ve şöyle bir yanıt dönmeli:
```json
{"status":"ok","classes":{"0":"Caries","1":"Crown - bridge","2":"Filling","3":"Implant","4":"Post-screw","5":"Root Canal Obturation"}}
```

## 📱 Backend'i Her Zaman Doğru Başlatın

Backend'i her zaman şu komutla başlatın:
```bash
cd backend
..\\.venv\\Scripts\\uvicorn.exe main:app --host 0.0.0.0 --port 8000 --reload
```

**Önemli:** `--host 0.0.0.0` parametresi olmadan Android emülatörü erişemez!

## ❓ Sorun Devam Ediyorsa

1. Backend'in çalıştığını doğrulayın:
   ```bash
   netstat -an | findstr "8000"
   ```
   Çıktıda `0.0.0.0:8000` görmelisiniz

2. Emülatör loglarını kontrol edin
3. Uygulamada farklı bir IP deneyin (LAN IP'niz):
   - `lib/core/services/ai_service.dart` dosyasında `kAiBaseUrl` değerini değiştirin
   - Bilgisayarınızın LAN IP'sini bulun: `ipconfig` komutu ile
   - Örnek: `const String kAiBaseUrl = 'http://192.168.1.105:8000';`
