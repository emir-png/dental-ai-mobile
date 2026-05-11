import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final id = int.tryParse(widget.analysisId);
    if (id == null) return;

    final xray = await DatabaseHelper.instance.getXrayById(id);
    final predictions = await DatabaseHelper.instance.getPredictionsByXrayId(
      id,
    );

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

    await Future.delayed(const Duration(seconds: 2));

    final mockPredictions = [
      {
        'disease': 'Crown - bridge',
        'confidence': 0.96,
        'x1': 0.3,
        'y1': 0.4,
        'x2': 0.45,
        'y2': 0.6,
      },
      {
        'disease': 'Crown - bridge',
        'confidence': 0.96,
        'x1': 0.5,
        'y1': 0.35,
        'x2': 0.65,
        'y2': 0.55,
      },
      {
        'disease': 'Filling',
        'confidence': 0.95,
        'x1': 0.2,
        'y1': 0.5,
        'x2': 0.35,
        'y2': 0.65,
      },
      {
        'disease': 'Crown - bridge',
        'confidence': 0.95,
        'x1': 0.6,
        'y1': 0.4,
        'x2': 0.75,
        'y2': 0.6,
      },
      {
        'disease': 'Caries',
        'confidence': 0.93,
        'x1': 0.4,
        'y1': 0.55,
        'x2': 0.55,
        'y2': 0.7,
      },
      {
        'disease': 'Filling',
        'confidence': 0.92,
        'x1': 0.25,
        'y1': 0.45,
        'x2': 0.38,
        'y2': 0.58,
      },
      {
        'disease': 'Root Canal Obturation',
        'confidence': 0.91,
        'x1': 0.55,
        'y1': 0.3,
        'x2': 0.7,
        'y2': 0.5,
      },
      {
        'disease': 'Implant',
        'confidence': 0.89,
        'x1': 0.7,
        'y1': 0.4,
        'x2': 0.82,
        'y2': 0.6,
      },
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
    final predictions = await DatabaseHelper.instance.getPredictionsByXrayId(
      id,
    );

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

  PdfColor _getPdfColor(String disease) {
    switch (disease) {
      case 'Crown - bridge':
        return const PdfColor.fromInt(0xFFFF6B00);
      case 'Filling':
        return const PdfColor.fromInt(0xFF2196F3);
      case 'Caries':
        return const PdfColor.fromInt(0xFFF44336);
      case 'Root Canal Obturation':
        return const PdfColor.fromInt(0xFF9C27B0);
      default:
        return PdfColors.grey;
    }
  }

  Future<void> _generatePdf() async {
    if (_xray == null || _predictions.isEmpty) return;
    setState(() => _isGeneratingPdf = true);

    try {
      final doc = pw.Document();
      final now = DateTime.now();
      final generatedAt =
          '${now.day.toString().padLeft(2, '0')}.${now.month.toString().padLeft(2, '0')}.${now.year} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // Türkçe karakter destekli font yükle
      final fontRegular = await PdfGoogleFonts.nunitoRegular();
      final fontBold = await PdfGoogleFonts.nunitoBold();
      final fontItalic = await PdfGoogleFonts.nunitoItalic();
      final theme = pw.ThemeData.withFont(
        base: fontRegular,
        bold: fontBold,
        italic: fontItalic,
      );

      // Röntgen görselini yükle
      pw.MemoryImage? xrayImage;
      try {
        final imgBytes = await File(_xray!['imagePath']).readAsBytes();
        xrayImage = pw.MemoryImage(imgBytes);
      } catch (_) {
        xrayImage = null;
      }

      // Renk sabitleri
      const primaryColor = PdfColor.fromInt(0xFF1A73E8);
      const primaryDark = PdfColor.fromInt(0xFF1557B0);
      const successColor = PdfColor.fromInt(0xFF4CAF50);
      const bgLight = PdfColor.fromInt(0xFFF5F7FF);
      const borderColor = PdfColor.fromInt(0xFFE0E6F0);

      // Özet istatistikler
      final uniqueDiseases = _predictions
          .map((p) => p['disease'] as String)
          .toSet();
      final avgConf = _predictions.isEmpty
          ? 0.0
          : _predictions
                    .map((p) => (p['confidence'] as num).toDouble())
                    .reduce((a, b) => a + b) /
                _predictions.length;
      final maxConf = _predictions.isEmpty
          ? 0.0
          : _predictions
                .map((p) => (p['confidence'] as num).toDouble())
                .reduce((a, b) => a > b ? a : b);

      doc.addPage(
        pw.MultiPage(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          header: (context) => pw.Container(
            color: primaryColor,
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 20,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'AI Dental Analiz Raporu',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      'YOLOv11 Tabanlı Diş Röntgeni Değerlendirmesi',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Dental AI',
                      style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      'v1.0',
                      style: const pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          footer: (context) => pw.Container(
            color: const PdfColor.fromInt(0xFFF0F4FF),
            padding: const pw.EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 10,
            ),
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'UYARI: Bu rapor yalnizca bilgi amaclidir. Kesin tani icin uzman hekime basvurunuz.',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 8,
                  ),
                ),
                pw.Text(
                  'Sayfa ${context.pageNumber} / ${context.pagesCount}',
                  style: const pw.TextStyle(
                    color: PdfColors.grey600,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          build: (context) => [
            pw.SizedBox(height: 16),

            // ── Rapor Bilgileri ──────────────────────────────────────────
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 32),
              child: pw.Container(
                padding: const pw.EdgeInsets.all(16),
                decoration: pw.BoxDecoration(
                  color: bgLight,
                  borderRadius: pw.BorderRadius.circular(8),
                  border: pw.Border.all(color: borderColor),
                ),
                child: pw.Row(
                  children: [
                    _infoCell(
                      'Röntgen ID',
                      '#${_xray!['id'] ?? widget.analysisId}',
                      primaryColor,
                    ),
                    pw.SizedBox(width: 24),
                    _infoCell(
                      'Yükleme Tarihi',
                      _xray!['uploadDate'] ?? '-',
                      primaryColor,
                    ),
                    pw.SizedBox(width: 24),
                    _infoCell('Oluşturulma', generatedAt, primaryColor),
                    pw.SizedBox(width: 24),
                    _infoCell('Durum', 'Tamamlandi', successColor),
                  ],
                ),
              ),
            ),

            // Notlar varsa göster
            if ((_xray!['notes'] ?? '').toString().isNotEmpty) ...[
              pw.SizedBox(height: 12),
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 32),
                child: pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      left: pw.BorderSide(color: primaryColor, width: 3),
                    ),
                    color: bgLight,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Notlar',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 10,
                          color: primaryColor,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        _xray!['notes'].toString(),
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            pw.SizedBox(height: 20),

            // ── Röntgen Görseli + Bulgular Tablosu ───────────────────────
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 32),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Görsel
                  pw.Expanded(
                    flex: 5,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Röntgen Görseli', primaryColor),
                        pw.SizedBox(height: 8),
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            borderRadius: pw.BorderRadius.circular(8),
                            border: pw.Border.all(color: borderColor),
                          ),
                          child: pw.ClipRRect(
                            horizontalRadius: 8,
                            verticalRadius: 8,
                            child: pw.LayoutBuilder(
                              builder: (context, constraints) {
                                final imgW = constraints?.maxWidth ?? 280.0;
                                const imgH = 220.0;
                                return pw.SizedBox(
                                  width: imgW,
                                  height: imgH,
                                  child: pw.Stack(
                                    children: [
                                      xrayImage != null
                                          ? pw.Image(
                                              xrayImage,
                                              width: imgW,
                                              height: imgH,
                                              fit: pw.BoxFit.cover,
                                            )
                                          : pw.Container(
                                              width: imgW,
                                              height: imgH,
                                              color: PdfColors.grey200,
                                              child: pw.Center(
                                                child: pw.Text(
                                                  'Görsel yüklenemedi',
                                                  style: const pw.TextStyle(
                                                    color: PdfColors.grey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ..._predictions.map((p) {
                                        final x1 =
                                            (p['x1'] as num).toDouble() * imgW;
                                        final y1 =
                                            (p['y1'] as num).toDouble() * imgH;
                                        final x2 =
                                            (p['x2'] as num).toDouble() * imgW;
                                        final y2 =
                                            (p['y2'] as num).toDouble() * imgH;
                                        final bColor = _getPdfColor(
                                          p['disease'] as String,
                                        );
                                        final disease = p['disease'] as String;
                                        final conf =
                                            ((p['confidence'] as num) * 100)
                                                .toStringAsFixed(0);
                                        return pw.Positioned(
                                          left: x1,
                                          top: y1,
                                          child: pw.Container(
                                            width: x2 - x1,
                                            height: y2 - y1,
                                            decoration: pw.BoxDecoration(
                                              border: pw.Border.all(
                                                color: bColor,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: pw.Align(
                                              alignment: pw.Alignment.topLeft,
                                              child: pw.Container(
                                                color: bColor,
                                                padding:
                                                    const pw.EdgeInsets.symmetric(
                                                      horizontal: 2,
                                                      vertical: 1,
                                                    ),
                                                child: pw.Text(
                                                  '$disease %$conf',
                                                  style: pw.TextStyle(
                                                    color: PdfColors.white,
                                                    fontSize: 5,
                                                    fontWeight:
                                                        pw.FontWeight.bold,
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
                        ),
                        pw.SizedBox(height: 6),
                        pw.Text(
                          'Renkli kutular: AI tarafından tespit edilen bulgular.',
                          style: const pw.TextStyle(
                            color: PdfColors.grey500,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.SizedBox(width: 20),

                  // Bulgular tablosu
                  pw.Expanded(
                    flex: 4,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        _sectionTitle('Tespit Edilen Bulgular', primaryColor),
                        pw.SizedBox(height: 8),
                        // Tablo başlığı
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 7,
                          ),
                          decoration: pw.BoxDecoration(
                            color: primaryColor,
                            borderRadius: const pw.BorderRadius.only(
                              topLeft: pw.Radius.circular(6),
                              topRight: pw.Radius.circular(6),
                            ),
                          ),
                          child: pw.Row(
                            children: [
                              pw.Expanded(
                                flex: 1,
                                child: pw.Text(
                                  '#',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                flex: 5,
                                child: pw.Text(
                                  'Tanı',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                              pw.Expanded(
                                flex: 2,
                                child: pw.Text(
                                  'Güven',
                                  style: pw.TextStyle(
                                    color: PdfColors.white,
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Tablo satırları
                        ..._predictions.asMap().entries.map((entry) {
                          final i = entry.key;
                          final p = entry.value;
                          final conf = ((p['confidence'] as num) * 100)
                              .toStringAsFixed(1);
                          final disease = p['disease'] as String;
                          final dColor = _getPdfColor(disease);
                          return pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: pw.BoxDecoration(
                              color: i % 2 == 0
                                  ? PdfColors.white
                                  : const PdfColor.fromInt(0xFFF8FAFF),
                              border: pw.Border(
                                bottom: pw.BorderSide(
                                  color: borderColor,
                                  width: 0.5,
                                ),
                                left: pw.BorderSide(color: borderColor),
                                right: pw.BorderSide(color: borderColor),
                              ),
                            ),
                            child: pw.Row(
                              children: [
                                pw.Expanded(
                                  flex: 1,
                                  child: pw.Text(
                                    '${i + 1}',
                                    style: const pw.TextStyle(
                                      fontSize: 9,
                                      color: PdfColors.grey700,
                                    ),
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 5,
                                  child: pw.Row(
                                    children: [
                                      pw.Container(
                                        width: 8,
                                        height: 8,
                                        decoration: pw.BoxDecoration(
                                          color: dColor,
                                          shape: pw.BoxShape.circle,
                                        ),
                                      ),
                                      pw.SizedBox(width: 5),
                                      pw.Expanded(
                                        child: pw.Text(
                                          disease,
                                          style: const pw.TextStyle(
                                            fontSize: 9,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                pw.Expanded(
                                  flex: 2,
                                  child: pw.Text(
                                    '%$conf',
                                    style: pw.TextStyle(
                                      fontSize: 9,
                                      fontWeight: pw.FontWeight.bold,
                                      color: successColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        // Alt köşe yuvarlama
                        pw.Container(
                          height: 6,
                          decoration: pw.BoxDecoration(
                            color: bgLight,
                            borderRadius: const pw.BorderRadius.only(
                              bottomLeft: pw.Radius.circular(6),
                              bottomRight: pw.Radius.circular(6),
                            ),
                            border: pw.Border.all(color: borderColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 24),

            // ── Özet İstatistikler ────────────────────────────────────────
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 32),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _sectionTitle('Analiz Özeti', primaryColor),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    children: [
                      _statCard(
                        'Toplam Bulgu',
                        '${_predictions.length}',
                        primaryColor,
                        bgLight,
                        borderColor,
                      ),
                      pw.SizedBox(width: 12),
                      _statCard(
                        'Farklı Tanı Türü',
                        '${uniqueDiseases.length}',
                        primaryDark,
                        bgLight,
                        borderColor,
                      ),
                      pw.SizedBox(width: 12),
                      _statCard(
                        'Ort. Güven',
                        '%${(avgConf * 100).toStringAsFixed(1)}',
                        successColor,
                        bgLight,
                        borderColor,
                      ),
                      pw.SizedBox(width: 12),
                      _statCard(
                        'Maks. Güven',
                        '%${(maxConf * 100).toStringAsFixed(1)}',
                        successColor,
                        bgLight,
                        borderColor,
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  // Renk lejantı
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: bgLight,
                      borderRadius: pw.BorderRadius.circular(6),
                      border: pw.Border.all(color: borderColor),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Renk Lejantı',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                            color: primaryColor,
                          ),
                        ),
                        pw.SizedBox(height: 8),
                        pw.Wrap(
                          spacing: 16,
                          runSpacing: 6,
                          children: [
                            _legendItem(
                              'Crown - bridge',
                              const PdfColor.fromInt(0xFFFF6B00),
                            ),
                            _legendItem(
                              'Filling',
                              const PdfColor.fromInt(0xFF2196F3),
                            ),
                            _legendItem(
                              'Caries',
                              const PdfColor.fromInt(0xFFF44336),
                            ),
                            _legendItem(
                              'Root Canal Obturation',
                              const PdfColor.fromInt(0xFF9C27B0),
                            ),
                            _legendItem('Diğer', PdfColors.grey500),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),
          ],
        ),
      );

      // PDF bytes'ını önceden üret — hata varsa Dart catch bloğu yakalar
      final pdfBytes = await doc.save();

      // PDF'i önizle / paylaş
      await Printing.layoutPdf(
        onLayout: (_) async => pdfBytes,
        name: 'AI_Dental_Rapor_${widget.analysisId}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF oluşturulamadı: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  // ── PDF yardımcı widget'ları ─────────────────────────────────────────────

  pw.Widget _sectionTitle(String title, PdfColor color) => pw.Row(
    children: [
      pw.Container(
        width: 4,
        height: 16,
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: pw.BorderRadius.circular(2),
        ),
      ),
      pw.SizedBox(width: 8),
      pw.Text(
        title,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 13,
          color: color,
        ),
      ),
    ],
  );

  pw.Widget _infoCell(String label, String value, PdfColor color) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        label,
        style: const pw.TextStyle(color: PdfColors.grey600, fontSize: 8),
      ),
      pw.SizedBox(height: 2),
      pw.Text(
        value,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
          color: color,
        ),
      ),
    ],
  );

  pw.Widget _statCard(
    String label,
    String value,
    PdfColor valueColor,
    PdfColor bg,
    PdfColor border,
  ) => pw.Expanded(
    child: pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: pw.BoxDecoration(
        color: bg,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: border),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: valueColor,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            label,
            textAlign: pw.TextAlign.center,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
          ),
        ],
      ),
    ),
  );

  pw.Widget _legendItem(String label, PdfColor color) => pw.Row(
    mainAxisSize: pw.MainAxisSize.min,
    children: [
      pw.Container(
        width: 10,
        height: 10,
        decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
      ),
      pw.SizedBox(width: 5),
      pw.Text(
        label,
        style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
      ),
    ],
  );

  // ── Flutter UI ────────────────────────────────────────────────────────────

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Breadcrumb ─────────────────────────────────────────────────
            Row(
              children: [
                TextButton(
                  onPressed: () => context.go('/history'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Röntgen Sonuçları'),
                ),
                const Icon(Icons.chevron_right, size: 16),
                Text(
                  '#${widget.analysisId}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ── Röntgen Görseli (tam genişlik) ─────────────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.medical_information_outlined, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Röntgen Görseli',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final imgWidth = constraints.maxWidth;
                          final imgHeight = imgWidth * 0.65;
                          return SizedBox(
                            width: imgWidth,
                            height: imgHeight,
                            child: Stack(
                              children: [
                                Image.file(
                                  File(_xray!['imagePath']),
                                  width: imgWidth,
                                  height: imgHeight,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.black87,
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        color: Colors.white54,
                                        size: 56,
                                      ),
                                    ),
                                  ),
                                ),
                                ..._predictions.map((p) {
                                  final x1 =
                                      (p['x1'] as num).toDouble() * imgWidth;
                                  final y1 =
                                      (p['y1'] as num).toDouble() * imgHeight;
                                  final x2 =
                                      (p['x2'] as num).toDouble() * imgWidth;
                                  final y2 =
                                      (p['y2'] as num).toDouble() * imgHeight;
                                  final color = _getBboxColor(p['disease']);
                                  return Positioned(
                                    left: x1,
                                    top: y1,
                                    width: x2 - x1,
                                    height: y2 - y1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: color,
                                          width: 2,
                                        ),
                                      ),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          color: color.withOpacity(0.85),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 3,
                                            vertical: 1,
                                          ),
                                          child: Text(
                                            '${p['disease']} %${((p['confidence'] as num) * 100).toStringAsFixed(0)}',
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
                      'Renkli kutular AI tarafından tespit edilen bulgulardır.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Tespit Edilen Bulgular (tam genişlik) ──────────────────────
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.bar_chart_outlined, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Tespit Edilen Bulgular',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Tablo başlığı
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: const [
                          SizedBox(
                            width: 28,
                            child: Text(
                              '#',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Hastalık',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 72,
                            child: Text(
                              'Güven (%)',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Tablo satırları
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: _predictions.asMap().entries.map((entry) {
                          final i = entry.key;
                          final p = entry.value;
                          final conf = ((p['confidence'] as num) * 100)
                              .toStringAsFixed(0);
                          final isLast = i == _predictions.length - 1;
                          return Container(
                            decoration: BoxDecoration(
                              color: i % 2 == 0
                                  ? Colors.transparent
                                  : Colors.grey.withOpacity(0.05),
                              border: isLast
                                  ? null
                                  : Border(
                                      bottom: BorderSide(
                                        color: Colors.grey.withOpacity(0.15),
                                      ),
                                    ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '${i + 1}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: _getBboxColor(p['disease']),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          p['disease'],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 72,
                                  child: Text(
                                    '%$conf',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── PDF Butonu (tam genişlik) ───────────────────────────────────
            SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isGeneratingPdf ? null : _generatePdf,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isGeneratingPdf
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(
                  _isGeneratingPdf
                      ? 'PDF Oluşturuluyor...'
                      : 'AI Dental Raporu İndir (PDF)',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
