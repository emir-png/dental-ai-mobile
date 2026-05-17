import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database_helper.dart';
import '../../../core/services/session_service.dart';
import '../../../shared/widgets/main_scaffold.dart';

class XrayUploadScreen extends StatefulWidget {
  const XrayUploadScreen({super.key});

  @override
  State<XrayUploadScreen> createState() => _XrayUploadScreenState();
}

class _XrayUploadScreenState extends State<XrayUploadScreen> {
  final _notesController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;
  final _picker = ImagePicker();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _uploadAndAnalyze() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir röntgen görüntüsü seçin.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Veritabanına kaydet
      final now = DateTime.now();
      final dateStr =
          '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final xrayId = await DatabaseHelper.instance.insertXray({
        'userId': SessionService.instance.userId,
        'imagePath': _selectedImage!.path,
        'notes': _notesController.text.trim(),
        'uploadDate': dateStr,
        'status': 'processing',
      });

      // Analiz ekranına git
      if (mounted) {
        context.go('/results/$xrayId');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Hata: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'Röntgen Yükle',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go('/upload'),
                  child: const Text('Dashboard'),
                ),
                const Icon(Icons.chevron_right, size: 16),
                const Text('Röntgen Yükle'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Röntgen Yükle',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 600;
                final uploadCard = Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          AppColors.primaryLight.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.upload_file,
                                size: 24,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Yeni Diş Röntgeni Analizi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // File selection area
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            color: AppColors.primaryLight.withOpacity(0.1),
                          ),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: _pickImage,
                                child: const Text('Dosya Seç'),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedImage != null
                                      ? _selectedImage!.path
                                            .split('/')
                                            .last
                                            .split('\\')
                                            .last
                                      : 'Dosya seçilmedi...',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Seçilen görsel önizleme
                        if (_selectedImage != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],

                        const SizedBox(height: 12),

                        // Notlar
                        TextField(
                          controller: _notesController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            hintText: 'Notlar (opsiyonel)',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Yükle butonu
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _uploadAndAnalyze,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Yükle'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

                final infoCard = Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accentGreen.withOpacity(0.1),
                          AppColors.primaryLight.withOpacity(0.05),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.info.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.info_outline,
                                color: AppColors.info,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'Bilgi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Bu panel, diş röntgenlerinden hastalık tespiti için YOLOv11 tabanlı modeli kullanır.',
                          style: TextStyle(fontSize: 13, height: 1.5),
                        ),
                        const SizedBox(height: 12),
                        const _BilgiItem(
                          text: 'Röntgen yüklendikten sonra model çalıştırılacaktır.',
                        ),
                        const _BilgiItem(
                          text: 'Sonuçlar Analiz Sonucu sayfasında gösterilecektir.',
                        ),
                        const _BilgiItem(
                          text: 'Bu sonuçlar hasta geçmişine kaydedilebilir.',
                        ),
                      ],
                    ),
                  ),
                );

                if (isWide) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: uploadCard),
                      const SizedBox(width: 16),
                      Expanded(flex: 1, child: infoCard),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      uploadCard,
                      const SizedBox(height: 16),
                      infoCard,
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BilgiItem extends StatelessWidget {
  final String text;
  const _BilgiItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
