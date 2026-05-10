import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/main_scaffold.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Gizlilik Politikası',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Gizlilik Politikası',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Son güncelleme: 23.12.2025',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Uyarı kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Builder(
                builder: (context) {
                  final bodyColor =
                      Theme.of(context).textTheme.bodyMedium?.color ??
                      Colors.black87;
                  return RichText(
                    text: TextSpan(
                      style: TextStyle(fontSize: 13, color: bodyColor),
                      children: [
                        const TextSpan(
                          text: 'Önemli: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                        TextSpan(
                          text: 'Dental AI Panel bir ',
                          style: TextStyle(color: bodyColor),
                        ),
                        TextSpan(
                          text: 'karar destek ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bodyColor,
                          ),
                        ),
                        TextSpan(
                          text:
                              'aracıdır. Üretilen sonuçlar tıbbi tanı değildir. Nihai değerlendirme ve klinik karar ',
                          style: TextStyle(color: bodyColor),
                        ),
                        const TextSpan(
                          text: 'hekim sorumluluğundadır.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            _PrivacySection(
              title: '1) Toplanan Veriler',
              bullets: const [
                (
                  'Röntgen Görüntüleri:',
                  'Yüklediğiniz dental X-ray görselleri.',
                ),
                (
                  'Analiz Sonuçları:',
                  'Modelin ürettiği etiketler, güven skorları ve varsa bbox koordinatları.',
                ),
                (
                  'Hesap Bilgileri:',
                  'Kullanıcı adı/e-posta gibi giriş ve yetkilendirme bilgileri (varsa).',
                ),
                (
                  'Teknik Veriler:',
                  'Hata kayıtları, temel kullanım log\'ları (güvenlik ve hata ayıklama amaçlı).',
                ),
              ],
            ),
            const SizedBox(height: 12),

            _PrivacySection(
              title: '2) Verileri Neden İşliyoruz?',
              bullets: const [
                (
                  '',
                  'Yüklediğiniz görüntüleri analiz etmek ve sonuç göstermek',
                ),
                ('', 'Hizmet kalitesini artırmak, hataları tespit etmek'),
                ('', 'Güvenlik, yetkilendirme ve kötüye kullanımı önlemek'),
              ],
            ),
            const SizedBox(height: 12),

            _PrivacySection(
              title: '3) Verileri Kimlerle Paylaşıyoruz?',
              content:
                  'Verileriniz üçüncü taraflarla satılmaz veya kiralanmaz. '
                  'Yalnızca yasal zorunluluk durumunda yetkili mercilerle paylaşılabilir.',
            ),
            const SizedBox(height: 12),

            _PrivacySection(
              title: '4) Haklarınız',
              bullets: const [
                ('', 'Verilerinize erişim talep edebilirsiniz.'),
                ('', 'Yanlış verilerin düzeltilmesini isteyebilirsiniz.'),
                ('', 'Verilerinizin silinmesini talep edebilirsiniz.'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacySection extends StatelessWidget {
  final String title;
  final String? content;
  final List<(String, String)>? bullets;

  const _PrivacySection({required this.title, this.content, this.bullets});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(content!, style: const TextStyle(fontSize: 13, height: 1.5)),
            if (bullets != null)
              ...bullets!.map((b) {
                final bodyColor =
                    Theme.of(context).textTheme.bodyMedium?.color ??
                    Colors.black87;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(color: AppColors.primary),
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(fontSize: 13, color: bodyColor),
                            children: [
                              if (b.$1.isNotEmpty)
                                TextSpan(
                                  text: '${b.$1} ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bodyColor,
                                  ),
                                ),
                              TextSpan(
                                text: b.$2,
                                style: TextStyle(
                                  color: bodyColor.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
