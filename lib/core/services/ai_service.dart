import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

/// Dental AI backend adresi.
///
/// Android emülatöründe bilgisayarın localhost'u 10.0.2.2'dir.
/// Gerçek bir cihaz kullanıyorsanız bilgisayarınızın LAN IP adresini yazın,
/// örn: 'http://192.168.1.105:8000'
const String kAiBaseUrl = 'http://10.0.2.2:8000';

class AiService {
  AiService._();

  /// [imagePath] dosyasını backend'e gönderir, tahminleri döndürür.
  ///
  /// Her tahmin şu anahtarları içerir:
  ///   disease     → String   (sınıf adı)
  ///   confidence  → double   (0–1)
  ///   x1, y1, x2, y2 → double  (0–1 normalize bbox)
  static Future<List<Map<String, dynamic>>> analyzeXray(
    String imagePath,
  ) async {
    final uri = Uri.parse('$kAiBaseUrl/predict');

    final request = http.MultipartRequest('POST', uri);
    
    // Dosya uzantısına göre content-type belirle
    final fileExtension = path.extension(imagePath).toLowerCase();
    MediaType? contentType;
    
    switch (fileExtension) {
      case '.jpg':
      case '.jpeg':
        contentType = MediaType('image', 'jpeg');
        break;
      case '.png':
        contentType = MediaType('image', 'png');
        break;
      case '.gif':
        contentType = MediaType('image', 'gif');
        break;
      case '.bmp':
        contentType = MediaType('image', 'bmp');
        break;
      case '.webp':
        contentType = MediaType('image', 'webp');
        break;
      default:
        contentType = MediaType('image', 'jpeg'); // Varsayılan
    }
    
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imagePath,
        contentType: contentType,
      ),
    );

    late http.StreamedResponse streamed;
    try {
      streamed = await request
          .send()
          .timeout(const Duration(seconds: 30));
    } on SocketException {
      throw Exception(
        'Backend\'e bağlanılamadı ($kAiBaseUrl).\n'
        'Lütfen Python backend\'ini başlatın:\n'
        '  cd backend\n'
        '  uvicorn main:app --host 0.0.0.0 --port 8000',
      );
    } catch (e) {
      if (e.toString().contains('TimeoutException')) {
        throw Exception(
          'Bağlantı zaman aşımına uğradı.\n'
          'Backend çalışıyor mu? Adres: $kAiBaseUrl\n'
          'Gerçek cihaz kullanıyorsanız kAiBaseUrl\'i LAN IP ile güncelleyin.',
        );
      }
      rethrow;
    }

    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final list = data['predictions'] as List<dynamic>;
      return list.cast<Map<String, dynamic>>();
    } else {
      throw Exception(
        'Analiz başarısız (HTTP ${response.statusCode}):\n${response.body}',
      );
    }
  }

  /// Backend sağlık durumunu kontrol eder.
  static Future<bool> checkHealth() async {
    try {
      final response = await http
          .get(Uri.parse('$kAiBaseUrl/health'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
