import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:signature/signature.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

// ── Models ────────────────────────────────────────────────────────────────

/// Dokumen yang tersedia untuk ditandatangani
class DokumenTTDModel {
  final String id;
  final String judul;
  final String subtitle;
  bool dipilih;

  DokumenTTDModel({
    required this.id,
    required this.judul,
    required this.subtitle,
    this.dipilih = true,
  });
}

/// State TTD (TODO: migrate to Riverpod TTDNotifier)
enum TTDGenerationState { idle, generating, done, error }

// ── Screen ────────────────────────────────────────────────────────────────

/// Layar Tanda Tangan & Dokumen — Dosen
class TTDDokumenScreen extends StatefulWidget {
  final String? mahasiswaId;

  const TTDDokumenScreen({super.key, this.mahasiswaId});

  @override
  State<TTDDokumenScreen> createState() => _TTDDokumenScreenState();
}

class _TTDDokumenScreenState extends State<TTDDokumenScreen> {
  late final SignatureController _signatureController;

  // Saved signature bitmap (PNG bytes)
  Uint8List? _savedSignatureBytes;
  bool _usingSavedTTD = false;
  bool _hasDrawn = false;

  TTDGenerationState _genState = TTDGenerationState.idle;

  // Dokumen list
  final List<DokumenTTDModel> _dokumenList = [
    DokumenTTDModel(
      id: 'berita_acara',
      judul: 'Berita Acara Sidang',
      subtitle: 'Dokumen resmi pelaksanaan sidang',
      dipilih: true,
    ),
    DokumenTTDModel(
      id: 'lembar_nilai',
      judul: 'Lembar Nilai Akhir',
      subtitle: 'Rekap nilai sidang skripsi',
      dipilih: false,
    ),
    DokumenTTDModel(
      id: 'formulir_revisi',
      judul: 'Formulir Revisi',
      subtitle: 'Catatan revisi dari penguji',
      dipilih: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: AppColors.textPrimary,
      exportBackgroundColor: Colors.white,
    );
    _signatureController.addListener(() {
      if (_signatureController.isNotEmpty && !_hasDrawn) {
        setState(() => _hasDrawn = true);
      } else if (_signatureController.isEmpty && _hasDrawn) {
        setState(() => _hasDrawn = false);
      }
    });
    _loadSavedSignature();
  }

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  // ── Signature Logic ─────────────────────────────────────────────────────

  Future<void> _loadSavedSignature() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ttd_dosen.png');
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        setState(() => _savedSignatureBytes = bytes);
      }
    } catch (_) {}
  }

  Future<void> _saveSignature() async {
    final data = await _signatureController.toPngBytes();
    if (data == null) {
      _showSnack('Tanda tangan kosong', isError: true);
      return;
    }
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ttd_dosen.png');
      await file.writeAsBytes(data);
      setState(() {
        _savedSignatureBytes = data;
        _usingSavedTTD = false;
      });
      _showSnack('Tanda tangan tersimpan');
    } catch (e) {
      _showSnack('Gagal menyimpan tanda tangan', isError: true);
    }
  }

  void _clearSignature() {
    _signatureController.clear();
    setState(() {
      _hasDrawn = false;
      _usingSavedTTD = false;
    });
  }

  void _useSavedTTD() {
    setState(() => _usingSavedTTD = true);
    _showSnack('Menggunakan tanda tangan tersimpan');
  }

  // ── Document Generation ─────────────────────────────────────────────────

  Future<void> _generateAndDownload({bool exportPdf = false}) async {
    final selectedDocs = _dokumenList.where((d) => d.dipilih).toList();
    if (selectedDocs.isEmpty) {
      _showSnack('Pilih minimal satu dokumen', isError: true);
      return;
    }
    if (!_usingSavedTTD && _signatureController.isEmpty) {
      _showSnack('Tambahkan tanda tangan terlebih dahulu', isError: true);
      return;
    }

    setState(() => _genState = TTDGenerationState.generating);
    _showGeneratingDialog(exportPdf);

    try {
      // Simulate API call - replace with actual DOCX/PDF generation via Riverpod
      await Future.delayed(const Duration(seconds: 2));

      final dir = await getTemporaryDirectory();
      final ext = exportPdf ? 'pdf' : 'docx';
      final fileName = 'sidangku_dokumen_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final filePath = '${dir.path}/$fileName';

      // Placeholder file for share_plus demo
      await File(filePath).writeAsString('SidangKu Document Placeholder');

      if (!mounted) return;
      Navigator.of(context).pop(); // close dialog

      setState(() => _genState = TTDGenerationState.done);

      await Share.shareXFiles(
        [XFile(filePath)],
        subject: 'Dokumen Sidang Skripsi',
      );
    } catch (e) {
      if (mounted) Navigator.of(context).pop();
      setState(() => _genState = TTDGenerationState.error);
      _showSnack('Gagal membuat dokumen: $e', isError: true);
    } finally {
      if (mounted) setState(() => _genState = TTDGenerationState.idle);
    }
  }

  void _showGeneratingDialog(bool isPdf) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Color(0xFF00897B)),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  isPdf ? 'Mengekspor PDF...' : 'Membuat DOCX & Menandatangani...',
                  style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Mohon tunggu sebentar',
                  style: AppTheme.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: AppTheme.bodySmall.copyWith(color: Colors.white)),
        backgroundColor: isError ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Tanda Tangan & Dokumen'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person_rounded,
                  size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Pratinjau Dokumen ──────────────────────────────────
            _buildPratinjauSection(),
            const SizedBox(height: 24),

            // ── Area Tanda Tangan ──────────────────────────────────
            _buildSignatureSection(),
            const SizedBox(height: 14),

            // ── Saved TTD Option ───────────────────────────────────
            if (_savedSignatureBytes != null) ...[
              _buildSavedTTDCard(),
              const SizedBox(height: 24),
            ],

            // ── Pilih Dokumen ──────────────────────────────────────
            _buildPilihDokumenSection(),
            const SizedBox(height: 8),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  // ── Pratinjau Dokumen ───────────────────────────────────────────────────

  Widget _buildPratinjauSection() {
    final selected = _dokumenList.where((d) => d.dipilih).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Pratinjau Dokumen',
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            Text(
              '${selected.length} Dokumen',
              style: AppTheme.bodySmall.copyWith(color: AppColors.textTertiary),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 148,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _dokumenList.length,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (context, i) => _buildDocPreviewCard(_dokumenList[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildDocPreviewCard(DokumenTTDModel doc) {
    final isSelected = doc.dipilih;
    return GestureDetector(
      onTap: () => setState(() => doc.dipilih = !doc.dipilih),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF00897B)
                : AppColors.borderLight,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Thumbnail
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.06),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(13)),
                    ),
                    child: Icon(
                      Icons.description_rounded,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.5),
                    ),
                  ),
                  if (isSelected)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00897B),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            size: 13, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            // Label
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(
                doc.judul,
                style: AppTheme.caption.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF00897B)
                      : AppColors.textPrimary,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Signature Section ───────────────────────────────────────────────────

  Widget _buildSignatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Area Tanda Tangan',
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),

        // Dashed border canvas
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF00BCD4).withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: Stack(
              children: [
                // Dashed effect via CustomPaint overlay
                CustomPaint(
                  painter: _DashedBorderPainter(),
                  child: const SizedBox.expand(),
                ),
                // Signature canvas
                Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.transparent,
                ),
                // Placeholder hint
                if (!_hasDrawn && !_usingSavedTTD)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.draw_outlined,
                          size: 36,
                          color: const Color(0xFF00BCD4).withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tanda tangan di sini',
                          style: AppTheme.bodySmall.copyWith(
                            color: const Color(0xFF00BCD4).withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Saved TTD preview overlay
                if (_usingSavedTTD && _savedSignatureBytes != null)
                  Center(
                    child: Image.memory(
                      _savedSignatureBytes!,
                      fit: BoxFit.contain,
                      height: 140,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Bersihkan + Gunakan buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _clearSignature,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Bersihkan'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                  side: const BorderSide(color: AppColors.border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle:
                      AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _hasDrawn ? _saveSignature : null,
                icon: const Icon(Icons.check_circle_rounded, size: 18),
                label: const Text('Gunakan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  textStyle:
                      AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Saved TTD Card ──────────────────────────────────────────────────────

  Widget _buildSavedTTDCard() {
    return GestureDetector(
      onTap: _useSavedTTD,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _usingSavedTTD
                ? const Color(0xFF00897B)
                : AppColors.borderLight,
            width: _usingSavedTTD ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // TTD thumbnail
            Container(
              width: 64,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _savedSignatureBytes!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gunakan TTD tersimpan',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Terakhir digunakan 2 jam lalu',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              _usingSavedTTD
                  ? Icons.check_circle_rounded
                  : Icons.add_circle_outline_rounded,
              color: _usingSavedTTD
                  ? const Color(0xFF00897B)
                  : AppColors.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  // ── Pilih Dokumen ───────────────────────────────────────────────────────

  Widget _buildPilihDokumenSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih Dokumen untuk Ditandatangani',
          style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        ..._dokumenList.map((doc) => _buildDocCheckTile(doc)),
      ],
    );
  }

  Widget _buildDocCheckTile(DokumenTTDModel doc) {
    return GestureDetector(
      onTap: () => setState(() => doc.dipilih = !doc.dipilih),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: doc.dipilih
                ? const Color(0xFF00897B)
                : AppColors.borderLight,
            width: doc.dipilih ? 1.5 : 1,
          ),
        ),
        child: CheckboxListTile(
          value: doc.dipilih,
          onChanged: (v) => setState(() => doc.dipilih = v ?? false),
          activeColor: const Color(0xFF00897B),
          checkColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
          title: Text(
            doc.judul,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight:
                  doc.dipilih ? FontWeight.w600 : FontWeight.w400,
              color: doc.dipilih
                  ? const Color(0xFF00897B)
                  : AppColors.textPrimary,
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ),
    );
  }

  // ── Bottom Buttons ──────────────────────────────────────────────────────

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Primary: Tanda Tangani & Unduh
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _genState == TTDGenerationState.generating
                    ? null
                    : () => _generateAndDownload(exportPdf: false),
                icon: const Icon(Icons.edit_rounded, size: 20),
                label: const Text('Tanda Tangani & Unduh'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: AppTheme.bodyMedium
                      .copyWith(fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Outlined: Ekspor PDF
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: _genState == TTDGenerationState.generating
                    ? null
                    : () => _generateAndDownload(exportPdf: true),
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
                label: const Text('Ekspor PDF'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.border, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  textStyle: AppTheme.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ── Dashed Border Painter ─────────────────────────────────────────────────

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 8.0;
    const dashSpace = 5.0;
    const strokeWidth = 1.5;
    final paint = Paint()
      ..color = const Color(0xFF00BCD4).withValues(alpha: 0.4)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const radius = 14.0;

    // Draw dashed rounded rect
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(
            strokeWidth / 2, strokeWidth / 2,
            size.width - strokeWidth, size.height - strokeWidth),
        const Radius.circular(radius),
      ));

    final dashPath = _createDashedPath(path, dashWidth, dashSpace);
    canvas.drawPath(dashPath, paint);
  }

  Path _createDashedPath(Path source, double dashWidth, double dashSpace) {
    final dest = Path();
    for (final metric in source.computeMetrics()) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final len = draw ? dashWidth : dashSpace;
        if (draw) {
          dest.addPath(
            metric.extractPath(distance, distance + len),
            Offset.zero,
          );
        }
        distance += len;
        draw = !draw;
      }
    }
    return dest;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
