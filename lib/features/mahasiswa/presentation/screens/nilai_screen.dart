import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';

class NilaiDetailModel {
  final String grade;
  final double nilaiAngka;
  final String predikat;
  final String status;
  final List<KomponenNilai> komponen;
  final String? catatan;
  final bool hasBeritaAcara;
  final bool hasLembarNilai;

  const NilaiDetailModel({
    required this.grade,
    required this.nilaiAngka,
    required this.predikat,
    required this.status,
    required this.komponen,
    this.catatan,
    this.hasBeritaAcara = false,
    this.hasLembarNilai = false,
  });
}

class KomponenNilai {
  final String komponen;
  final double bobot;
  final double nilai;
  final double subTotal;

  const KomponenNilai({required this.komponen, required this.bobot, required this.nilai, required this.subTotal});
}

class NilaiMahasiswaNotifier extends ChangeNotifier {
  NilaiDetailModel? _nilai;
  bool _isLoading = true;
  bool _isDownloading = false;
  String? _downloadType;

  NilaiDetailModel? get nilai => _nilai;
  bool get isLoading => _isLoading;
  bool get isDownloading => _isDownloading;
  String? get downloadType => _downloadType;

  Future<void> loadNilai() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      _nilai = const NilaiDetailModel(
        grade: 'A-',
        nilaiAngka: 87.50,
        predikat: 'Sangat Memuaskan',
        status: 'LULUS',
        komponen: [
          KomponenNilai(komponen: 'Penguasaan Materi', bobot: 40, nilai: 90, subTotal: 36),
          KomponenNilai(komponen: 'Sesi Tanya Jawab', bobot: 30, nilai: 85, subTotal: 25.5),
          KomponenNilai(komponen: 'Presentasi', bobot: 30, nilai: 86.67, subTotal: 26),
        ],
        catatan: 'Skripsi ini membahas implementasi machine learning untuk deteksi ancaman siber dengan hasil yang sangat baik.',
        hasBeritaAcara: false,
        hasLembarNilai: false,
      );
    } catch (e) {
      debugPrint('Error loading nilai: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> download(String type) async {
    setState(() {
      _isDownloading = true;
      _downloadType = type;
    });
    try {
      final dir = await getTemporaryDirectory();
      final ext = type.toLowerCase().contains('docx') ? 'docx' : 'pdf';
      final fileName = 'sidangku_${type.replaceAll(' ', '_').toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = '${dir.path}/$fileName';

      // Mock download from a real URL (using a placeholder for now)
      // In a real app, this would be: await dio.download(apiUrl, filePath);
      // For slicing, we create a placeholder file
      await File(filePath).writeAsString('SidangKu Document Placeholder for $type');

      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text('Berhasil mengunduh $type. Membuka file...'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      await OpenFile.open(filePath);
    } catch (e) {
      if (navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
          SnackBar(content: Text('Gagal mengunduh: $e'), backgroundColor: AppColors.error),
        );
      }
    } finally {
      setState(() {
        _isDownloading = false;
        _downloadType = null;
      });
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  final notifier = NilaiMahasiswaNotifier();

  @override
  void initState() {
    super.initState();
    notifier.loadNilai();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Hasil Sidang Skripsi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (notifier.nilai == null) {
            return _buildEmptyState();
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeroGradeCard(),
                const SizedBox(height: 16),
                _buildStatusChip(),
                const SizedBox(height: 16),
                _buildScoreBreakdown(),
                if (notifier.nilai!.catatan != null) ...[
                  const SizedBox(height: 16),
                  _buildCatatanCard(),
                ],
                const SizedBox(height: 16),
                _buildDownloadButtons(),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.grade_rounded, size: 64, color: AppColors.textTertiary),
          const SizedBox(height: 16),
          Text('Nilai belum tersedia', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text('Dosen penguji belum menginput nilai', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildHeroGradeCard() {
    final nilai = notifier.nilai!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 180,
            height: 180,
            child: CustomPaint(
              painter: CircularGradePainter(
                percentage: nilai.nilaiAngka / 100,
                color: AppColors.primary,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      nilai.grade,
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                    Text(
                      nilai.nilaiAngka.toStringAsFixed(2),
                      style: AppTheme.headingSmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              nilai.predikat,
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip() {
    final nilai = notifier.nilai!;
    Color bgColor;
    switch (nilai.status) {
      case 'LULUS':
        bgColor = AppColors.success;
        break;
      case 'REVISI':
        bgColor = AppColors.warning;
        break;
      default:
        bgColor = AppColors.error;
    }
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: bgColor)),
      child: Center(
        child: Text(nilai.status, style: AppTheme.bodyMedium.copyWith(color: bgColor, fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildScoreBreakdown() {
    final komponen = notifier.nilai!.komponen;
    final total = komponen.fold<double>(0, (sum, k) => sum + k.subTotal);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Rincian Nilai', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Table(
            columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(1), 2: FlexColumnWidth(1), 3: FlexColumnWidth(1)},
            children: [
              TableRow(children: [
                Padding(padding: const EdgeInsets.all(8), child: Text('Komponen', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
                Padding(padding: const EdgeInsets.all(8), child: Text('Bobot', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(8), child: Text('Nilai', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
                Padding(padding: const EdgeInsets.all(8), child: Text('Sub-total', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center)),
              ]),
              ...komponen.map((k) => TableRow(children: [
                    Padding(padding: const EdgeInsets.all(8), child: Text(k.komponen, style: AppTheme.bodySmall)),
                    Padding(padding: const EdgeInsets.all(8), child: Text('${k.bobot.toInt()}%', style: AppTheme.bodySmall, textAlign: TextAlign.center)),
                    Padding(padding: const EdgeInsets.all(8), child: Text(k.nilai.toStringAsFixed(2), style: AppTheme.bodySmall, textAlign: TextAlign.center)),
                    Padding(padding: const EdgeInsets.all(8), child: Text(k.subTotal.toStringAsFixed(2), style: AppTheme.bodySmall, textAlign: TextAlign.center)),
                  ])),
              TableRow(children: [
                Padding(padding: const EdgeInsets.all(8), child: Text('Total', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold))),
                const SizedBox(),
                const SizedBox(),
                Padding(padding: const EdgeInsets.all(8), child: Text(total.toStringAsFixed(2), style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
              ]),
            ],
          ),
          const SizedBox(height: 12),
          Text('Formula: (Penguasaan Materi × 40%) + (Sesi Tanya Jawab × 30%) + (Presentasi × 30%)', style: AppTheme.caption.copyWith(color: AppColors.textTertiary, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  Widget _buildCatatanCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.infoLight.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.info.withValues(alpha: 0.3))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(Icons.format_quote, color: AppColors.info, size: 20), const SizedBox(width: 8), Text('Catatan Penguji', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600))]),
          const SizedBox(height: 8),
          Text(notifier.nilai!.catatan!, style: AppTheme.bodySmall.copyWith(fontStyle: FontStyle.italic, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildDownloadButtons() {
    return Row(
      children: [
        Expanded(
          child: SidangkuButton(
            label: notifier.isDownloading && notifier.downloadType == 'berita' ? '' : 'Unduh Berita Acara (.PDF)',
            type: SidangkuButtonType.outlined,
            icon: Icons.picture_as_pdf_rounded,
            isLoading: notifier.isDownloading && notifier.downloadType == 'berita',
            onTap: () => notifier.download('berita acara'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SidangkuButton(
            label: notifier.isDownloading && notifier.downloadType == 'lembar' ? '' : 'Unduh Lembar Nilai (.DOCX)',
            type: SidangkuButtonType.outlined,
            icon: Icons.description_rounded,
            isLoading: notifier.isDownloading && notifier.downloadType == 'lembar',
            onTap: () => notifier.download('lembar nilai'),
          ),
        ),
      ],
    );
  }
}

class CircularGradePainter extends CustomPainter {
  final double percentage;
  final Color color;

  CircularGradePainter({required this.percentage, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint = Paint()
      ..color = color.withValues(alpha: 0.1)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Paint progressPaint = Paint()
      ..color = color
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * 3.141592653589793 * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}