import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';
import '../../../core/theme/app_colors.dart';
import '../../../core/database/database_helper.dart';
import '../../../shared/widgets/main_scaffold.dart';

class ResultsScreen extends StatefulWidget {
  final String analysisId;
  const ResultsScreen({super.key, required this.analysisId});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, dynamic>? _xray;
  List<Map<String, dynamic>> _predictions = [];
  bool _isLoading = true;
  bool _isAnalyzing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final id = int.tryParse(widget.analysisId);
    if (id == null) return;

    final xray = await DatabaseHelper.instance.getXrayById(id);
    final predictions =
    await DatabaseHelper.instance.getPredictionsByXrayId(id);

    if (xray != null && predictions.isEmpty) {
      await _runAnalysis(id, xray['imagePath']);
    } else {
      setState(() {
        _xray = xray;
        _predictions = predictions;
        _isLoading = false;
      });
    }
  }

  Future<void> _runAnalysis(int id, String imagePath) async {
    setState(() => _isAnalyzing = true);

    // Simüle edilmiş analiz (best.pt entegrasyonu bir sonraki adımda)
    await Future.delayed(const Duration(seconds: 2));

    final mockPredictions = [
      {'disease': 'Crown - bridge', 'confidence': 0.96, 'x1': 0.3, 'y1': 0.4, 'x2': 0.45, 'y2': 0.6},
      {'disease': 'Crown - bridge', 'confidence': 0.96, 'x1': 0.5, 'y1': 0.35, 'x2': 0.65, 'y2': 0.55},
      {'disease': 'Filling', 'confidence': 0.95, 'x1': 0.2, 'y1': 0.5, 'x2': 0.35, 'y2': 0.65},
      {'disease': 'Crown - bridge', 'confidence': 0.95, 'x1': 0.6, 'y1': 0.4, 'x2': 0.75, 'y2': 0.6},
      {'disease': 'Caries', 'confidence': 0.93, 'x1': 0.4, 'y1': 0.55, 'x2': 0.55, 'y2': 0.7},
      {'disease': 'Filling', 'confidence': 0.92, 'x1': 0.25, 'y1': 0.45, 'x2': 0.38, 'y2': 0.58},
      {'disease': 'Root Canal Obturation', 'confidence': 0.91, 'x1': 0.55, 'y1': 0.3, 'x2': 0.7, 'y2': 0.5},
      {'disease': 'Implant', 'confidence': 0.89, 'x1': 0.7, 'y1': 0.4, 'x2': 0.82, 'y2': 0.6},
    ];

    for (final p in mockPredictions) {
      await DatabaseHelper.instance.insertPrediction({
        'xrayId': id,
        'disease': p['disease'],
        'confidence': p['confidence'],
        'x1': p['x1'],
        'y1': p['y1'],
        'x2': p['x2'],
        'y2': p['y2'],
      });
    }

    await DatabaseHelper.instance.updateXray(id, {'status': 'done'});

    final xray = await DatabaseHelper.instance.getXrayById(id);
    final predictions = await DatabaseHelper.instance.getPredictionsByXrayId(id);

    setState(() {
      _xray = xray;
      _predictions = predictions;
      _isLoading = false;
      _isAnalyzing = false;
    });
  }

  Color _getBboxColor(String disease) {
    switch (disease) {
      case 'Crown - bridge':
        return AppColors.bboxOrange;
      case 'Filling':
        return AppColors.bboxBlue;
      case 'Caries':
        return AppColors.bboxRed;
      case 'Root Canal Obturation':
        return AppColors.bboxPurple;
      default:
        return AppColors.bboxWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _isAnalyzing) {
      return MainScaffold(
        title: 'Analiz Sonucu',
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                _isAnalyzing ? 'YOLOv11 modeli çalışıyor...' : 'Yükleniyor...',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (_xray == null) {
      return MainScaffold(
        title: 'Analiz Sonucu',
        body: const Center(child: Text('Kayıt bulunamadı.')),
      );
    }

    return MainScaffold(
      title: 'Röntgen Sonuçları',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go('/history'),
                  child: const Text('Röntgen Sonuçları'),
                ),
                const Icon(Icons.chevron_right, size: 16),
                Text('#${widget.analysisId}'),
              ],
            ),
            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sol - Röntgen görseli + bounding box
                Expanded(
                  flex: 3,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          // Bounding box görseli
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final imgWidth = constraints.maxWidth;
                                final imgHeight = imgWidth * 0.6;
                                return SizedBox(
                                  width: imgWidth,
                                  height: imgHeight,
                                  child: Stack(
                                    children: [
                                      // Röntgen görseli
                                      Image.file(
                                        File(_xray!['imagePath']),
                                        width: imgWidth,
                                        height: imgHeight,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Container(
                                              color: Colors.black87,
                                              child: const Center(
                                                child: Icon(Icons.image,
                                                    color: Colors.white54,
                                                    size: 48),
                                              ),
                                            ),
                                      ),
                                      // Bounding box'lar
                                      ..._predictions.map((p) {
                                        final x1 = (p['x1'] as num).toDouble() * imgWidth;
                                        final y1 = (p['y1'] as num).toDouble() * imgHeight;
                                        final x2 = (p['x2'] as num).toDouble() * imgWidth;
                                        final y2 = (p['y2'] as num).toDouble() * imgHeight;
                                        final color = _getBboxColor(p['disease']);
                                        return Positioned(
                                          left: x1,
                                          top: y1,
                                          width: x2 - x1,
                                          height: y2 - y1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: color, width: 2),
                                            ),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Container(
                                                color: color.withOpacity(0.8),
                                                padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 3,
                                                    vertical: 1),
                                                child: Text(
                                                  '${p['disease']} %${((p['confidence'] as num) * 100).toStringAsFixed(1)}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 7,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Kutulara dokunarak detayları görebilirsiniz.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Sağ - Hastalık tablosu
                Expanded(
                  flex: 2,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tespit Edilen Bulgular',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 8),
                          // Tablo başlığı
                          Row(
                            children: const [
                              Expanded(
                                  flex: 1,
                                  child: Text('#',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              Expanded(
                                  flex: 4,
                                  child: Text('Hastalık',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                              Expanded(
                                  flex: 2,
                                  child: Text('Güven (%)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12))),
                            ],
                          ),
                          const Divider(),
                          // Tablo satırları
                          ..._predictions.asMap().entries.map((entry) {
                            final i = entry.key;
                            final p = entry.value;
                            final conf =
                            ((p['confidence'] as num) * 100).toStringAsFixed(0);
                            return Container(
                              color: i % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey.withOpacity(0.05),
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text('${i + 1}',
                                          style:
                                          const TextStyle(fontSize: 12))),
                                  Expanded(
                                    flex: 4,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: _getBboxColor(p['disease']),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            p['disease'],
                                            style:
                                            const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Text('%$conf',
                                          style:
                                          const TextStyle(fontSize: 12))),
                                ],
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // PDF butonu
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('AI Dental Raporu İndir (PDF)'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}