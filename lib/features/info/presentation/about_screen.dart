import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/main_scaffold.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Hakkımızda',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YOLOv11 Teknolojisi',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _InfoCard(
              icon: Icons.info_outline,
              title: 'YOLOv11 Nedir?',
              content:
              'YOLOv11 (You Only Look Once v11), gerçek zamanlı nesne tespiti için '
                  'geliştirilmiş en güncel derin öğrenme modelidir. Dental AI Panel, '
                  'diş röntgenlerindeki patolojileri tespit etmek için bu modeli kullanır.\n\n'
                  'Model, 15.000\'den fazla diş röntgeni görüntüsü ile eğitilmiş olup '
                  '%99\'a varan doğruluk oranına sahiptir.',
            ),
            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.settings,
              title: 'YOLOv11 Nasıl Çalışır?',
              content: 'YOLOv11, bir görüntüyü girdi olarak alır ve bu görüntü '
                  'üzerinde aşağıdaki bilgileri üretir:',
              bullets: const [
                'Bounding Box (BBox): Nesnenin görüntü içindeki konumu',
                'Label: Nesnenin sınıfı (ör. çürük, dolgu, implant)',
                'Confidence Score: Tahminin güven oranı',
              ],
              footer:
              'Model, evrişimli sinir ağları (CNN) ve modern feature extraction '
                  'teknikleri kullanarak görüntüdeki önemli bölgeleri öğrenir ve '
                  'tahmin üretir.\n\nYOLOv11\'in en büyük avantajı, bu işlemleri '
                  'milisaniyeler içinde yapabilmesidir.',
            ),
            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.public,
              title: 'YOLOv11 Nerelerde Kullanılır?',
              bullets: const [
                'Otonom araçlar (yaya, araç, trafik işareti tespiti)',
                'Tıbbi görüntü analizi',
                'Güvenlik ve gözetim sistemleri',
                'Endüstriyel kalite kontrol',
                'Tarım ve biyomedikal görüntü işleme',
              ],
            ),
            const SizedBox(height: 12),

            _InfoCard(
              icon: Icons.medical_services,
              title: 'Dental AI\'da Kullanılan Sınıflar',
              bullets: const [
                'Caries (Çürük)',
                'Filling (Dolgu)',
                'Crown - Bridge (Kron - Köprü)',
                'Root Canal Obturation (Kanal Tedavisi)',
                'Implant',
                'Periapical Lesion',
                'Bone Loss',
              ],
            ),

            const SizedBox(height, 16),

            // Uyarı kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.warning_amber, color: Colors.amber),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Önemli: Dental AI Panel bir karar destek aracıdır. '
                          'Üretilen sonuçlar tıbbi tanı değildir. Nihai değerlendirme '
                          've klinik karar hekim sorumluluğundadır.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? content;
  final List<String>? bullets;
  final String? footer;

  const _InfoCard({
    required this.icon,
    required this.title,
    this.content,
    this.bullets,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(content!, style: const TextStyle(fontSize: 13, height: 1.5)),
            if (bullets != null) ...[
              const SizedBox(height: 8),
              ...bullets!.map((b) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ',
                        style: TextStyle(color: AppColors.primary)),
                    Expanded(
                        child: Text(b,
                            style: const TextStyle(fontSize: 13))),
                  ],
                ),
              )),
            ],
            if (footer != null) ...[
              const SizedBox(height: 8),
              Text(footer!,
                  style: const TextStyle(fontSize: 13, height: 1.5)),
            ],
          ],
        ),
      ),
    );
  }
}