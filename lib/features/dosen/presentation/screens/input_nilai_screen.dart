import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';

// ── Models ────────────────────────────────────────────────────────────────

enum RekomendasiHasil { lulus, lulusDenganRevisi, tidakLulus }

/// Input komponen nilai dari dosen
class NilaiInputModel {
  final double penguasaanMateri;
  final double sistematikapenulisan;
  final double kemampuanPresentasi;
  final String catatan;
  final RekomendasiHasil rekomendasi;

  const NilaiInputModel({
    this.penguasaanMateri = 0,
    this.sistematikapenulisan = 0,
    this.kemampuanPresentasi = 0,
    this.catatan = '',
    this.rekomendasi = RekomendasiHasil.lulus,
  });
}

/// Hasil kalkulasi nilai akhir
class NilaiOutputModel {
  final double nilaiAkhir;
  final String grade;
  final Color gradeColor;

  const NilaiOutputModel({
    required this.nilaiAkhir,
    required this.grade,
    required this.gradeColor,
  });
}

// ── Grade Calculator ──────────────────────────────────────────────────────

NilaiOutputModel _calculateGrade(double n1, double n2, double n3) {
  final nilaiAkhir = (n1 * 0.4) + (n2 * 0.3) + (n3 * 0.3);

  String grade;
  Color gradeColor;

  if (nilaiAkhir >= 85) {
    grade = 'A';
    gradeColor = const Color(0xFF2E7D32);
  } else if (nilaiAkhir >= 80) {
    grade = 'A-';
    gradeColor = const Color(0xFF388E3C);
  } else if (nilaiAkhir >= 75) {
    grade = 'B+';
    gradeColor = const Color(0xFF1565C0);
  } else if (nilaiAkhir >= 70) {
    grade = 'B';
    gradeColor = const Color(0xFF1565C0);
  } else if (nilaiAkhir >= 65) {
    grade = 'B-';
    gradeColor = const Color(0xFF1976D2);
  } else if (nilaiAkhir >= 60) {
    grade = 'C';
    gradeColor = const Color(0xFFF57C00);
  } else if (nilaiAkhir >= 50) {
    grade = 'D';
    gradeColor = const Color(0xFFD32F2F);
  } else {
    grade = 'E';
    gradeColor = const Color(0xFFB71C1C);
  }

  return NilaiOutputModel(
    nilaiAkhir: nilaiAkhir,
    grade: grade,
    gradeColor: gradeColor,
  );
}

// ── Screen ────────────────────────────────────────────────────────────────

/// Halaman Input Nilai — Dosen
class InputNilaiScreen extends StatefulWidget {
  final String mahasiswaId;

  const InputNilaiScreen({
    super.key,
    required this.mahasiswaId,
  });

  @override
  State<InputNilaiScreen> createState() => _InputNilaiScreenState();
}

class _InputNilaiScreenState extends State<InputNilaiScreen> {
  final _formKey = GlobalKey<FormState>();

  // Nilai controllers
  final _nilaiController1 = TextEditingController(text: '90');
  final _nilaiController2 = TextEditingController(text: '85');
  final _nilaiController3 = TextEditingController(text: '87');
  final _catatanController = TextEditingController();

  double _slider1 = 90;
  double _slider2 = 85;
  double _slider3 = 87;

  RekomendasiHasil _rekomendasi = RekomendasiHasil.lulus;
  bool _isSubmitting = false;
  bool _isSavingDraft = false;

  final String _namaMahasiswa = 'Budi Setiawan';
  final String _nim = '123456789';
  final String _judulSkripsi =
      'Pengembangan Sistem Manajemen Sidang Skripsi Berbasis Mobile...';

  NilaiOutputModel get _output =>
      _calculateGrade(_slider1, _slider2, _slider3);

  @override
  void initState() {
    super.initState();
    _nilaiController1.addListener(_onNilai1Changed);
    _nilaiController2.addListener(_onNilai2Changed);
    _nilaiController3.addListener(_onNilai3Changed);
  }

  @override
  void dispose() {
    _nilaiController1.removeListener(_onNilai1Changed);
    _nilaiController2.removeListener(_onNilai2Changed);
    _nilaiController3.removeListener(_onNilai3Changed);
    _nilaiController1.dispose();
    _nilaiController2.dispose();
    _nilaiController3.dispose();
    _catatanController.dispose();
    super.dispose();
  }

  void _onNilai1Changed() {
    final v = double.tryParse(_nilaiController1.text);
    if (v != null && v >= 0 && v <= 100) {
      setState(() => _slider1 = v);
    }
  }

  void _onNilai2Changed() {
    final v = double.tryParse(_nilaiController2.text);
    if (v != null && v >= 0 && v <= 100) {
      setState(() => _slider2 = v);
    }
  }

  void _onNilai3Changed() {
    final v = double.tryParse(_nilaiController3.text);
    if (v != null && v >= 0 && v <= 100) {
      setState(() => _slider3 = v);
    }
  }

  String? _validateNilai(String? value) {
    if (value == null || value.trim().isEmpty) return 'Wajib diisi';
    final n = double.tryParse(value);
    if (n == null) return 'Masukkan angka';
    if (n < 0 || n > 100) return 'Nilai 0–100';
    return null;
  }

  Future<void> _saveDraft() async {
    setState(() => _isSavingDraft = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSavingDraft = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Draft tersimpan', style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusSmall),
      ),
    );
  }

  Future<void> _submitNilai() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      // Simulate API call - replace with actual API via Riverpod
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Nilai berhasil disubmit & dokumen digenerate', style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadiusSmall),
        ),
      );
      context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal submit nilai: $e', style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Input Nilai — $_namaMahasiswa'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Mini Info Card ─────────────────────────────────────
              _buildInfoCard(),
              const SizedBox(height: 20),

              // ── Komponen Penilaian ─────────────────────────────────
              _buildKomponenHeader(),
              const SizedBox(height: 12),
              _buildNilaiRow(
                label: 'Penguasaan Materi',
                bobot: '40%',
                controller: _nilaiController1,
                sliderValue: _slider1,
                onSliderChanged: (v) {
                  setState(() {
                    _slider1 = v;
                    _nilaiController1.text = v.round().toString();
                  });
                },
                activeColor: AppColors.primary,
              ),
              const SizedBox(height: 10),
              _buildNilaiRow(
                label: 'Sistematika Penulisan',
                bobot: '30%',
                controller: _nilaiController2,
                sliderValue: _slider2,
                onSliderChanged: (v) {
                  setState(() {
                    _slider2 = v;
                    _nilaiController2.text = v.round().toString();
                  });
                },
                activeColor: const Color(0xFF00897B),
              ),
              const SizedBox(height: 10),
              _buildNilaiRow(
                label: 'Kemampuan Presentasi',
                bobot: '30%',
                controller: _nilaiController3,
                sliderValue: _slider3,
                onSliderChanged: (v) {
                  setState(() {
                    _slider3 = v;
                    _nilaiController3.text = v.round().toString();
                  });
                },
                activeColor: const Color(0xFF1565C0),
              ),
              const SizedBox(height: 16),

              // ── Live Calculation Card ──────────────────────────────
              _buildNilaiAkhirCard(),
              const SizedBox(height: 20),

              // ── Catatan ────────────────────────────────────────────
              Text(
                'Catatan/Komentar',
                style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: TextFormField(
                  controller: _catatanController,
                  maxLines: 4,
                  style: AppTheme.bodyMedium,
                  decoration: InputDecoration(
                    hintText: 'Berikan masukan atau catatan untuk revisi mahasiswa...',
                    hintStyle: AppTheme.bodyMedium.copyWith(color: AppColors.textTertiary),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Rekomendasi ────────────────────────────────────────
              Text(
                'Rekomendasi Hasil Sidang',
                style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              _buildRekomendasiGroup(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(),
    );
  }

  // ── Mini Info Card ──────────────────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AvatarInitials(
                name: _namaMahasiswa,
                size: 44,
                backgroundColor: AppColors.primaryDark,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _namaMahasiswa,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _nim,
                    style: AppTheme.caption.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: AppColors.borderLight, height: 20),
          Text(
            'JUDUL SKRIPSI',
            style: AppTheme.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _judulSkripsi,
            style: AppTheme.bodySmall.copyWith(
              color: AppColors.textPrimary,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ── Komponen Header ─────────────────────────────────────────────────────

  Widget _buildKomponenHeader() {
    return Row(
      children: [
        Text(
          'Komponen Penilaian',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            'SIDANG AKHIR',
            style: AppTheme.caption.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  // ── Nilai Row ───────────────────────────────────────────────────────────

  Widget _buildNilaiRow({
    required String label,
    required String bobot,
    required TextEditingController controller,
    required double sliderValue,
    required ValueChanged<double> onSliderChanged,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Bobot: $bobot',
                      style: AppTheme.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Nilai input box
              SizedBox(
                width: 60,
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: _validateNilai,
                  style: AppTheme.headingMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.primary.withValues(alpha: 0.06),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorStyle: const TextStyle(fontSize: 10, height: 0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: activeColor,
              inactiveTrackColor: activeColor.withValues(alpha: 0.15),
              thumbColor: activeColor,
              overlayColor: activeColor.withValues(alpha: 0.1),
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: sliderValue.clamp(0, 100),
              min: 0,
              max: 100,
              divisions: 100,
              onChanged: onSliderChanged,
            ),
          ),
        ],
      ),
    );
  }

  // ── Live Calculation Card ───────────────────────────────────────────────

  Widget _buildNilaiAkhirCard() {
    final output = _output;
    final formula =
        '(${_slider1.round()}×0.4) + (${_slider2.round()}×0.3) + (${_slider3.round()}×0.3) = ${output.nilaiAkhir.toStringAsFixed(1)}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            'NILAI AKHIR',
            style: AppTheme.caption.copyWith(
              color: const Color(0xFF00897B),
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                FadeTransition(opacity: anim, child: child),
            child: Text(
              output.nilaiAkhir.toStringAsFixed(2),
              key: ValueKey(output.nilaiAkhir.toStringAsFixed(2)),
              style: AppTheme.headingLarge.copyWith(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF00897B),
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Grade chip
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(output.grade),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              decoration: BoxDecoration(
                color: output.gradeColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Grade: ${output.grade}',
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Formula
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              formula,
              style: AppTheme.caption.copyWith(
                color: const Color(0xFF00897B).withValues(alpha: 0.8),
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // ── Rekomendasi ─────────────────────────────────────────────────────────

  Widget _buildRekomendasiGroup() {
    final options = [
      (RekomendasiHasil.lulus, 'Lulus'),
      (RekomendasiHasil.lulusDenganRevisi, 'Lulus dengan Revisi'),
      (RekomendasiHasil.tidakLulus, 'Tidak Lulus'),
    ];

    return RadioGroup<RekomendasiHasil>(
      groupValue: _rekomendasi,
      onChanged: (value) {
        if (value != null) {
          setState(() => _rekomendasi = value);
        }
      },
      child: Column(
        children: options.map((opt) {
          final isSelected = _rekomendasi == opt.$1;
          return GestureDetector(
            onTap: () => setState(() => _rekomendasi = opt.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? const Color(0xFF00897B) : AppColors.border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: RadioListTile<RekomendasiHasil>(
                contentPadding: EdgeInsets.zero,
                value: opt.$1,
                activeColor: const Color(0xFF00897B),
                title: Text(
                  opt.$2,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected ? const Color(0xFF00897B) : AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Bottom Buttons ──────────────────────────────────────────────────────

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
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
            Row(
              children: [
                // Simpan Draft
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isSavingDraft ? null : _saveDraft,
                      icon: _isSavingDraft
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(AppColors.primary),
                              ),
                            )
                          : const Icon(Icons.save_outlined, size: 18),
                      label: const Text('Simpan Draft'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Submit
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _isSubmitting ? null : _submitNilai,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : const Icon(Icons.upload_rounded, size: 18),
                      label: const Text('Submit Nilai'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00897B),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Dokumen Berita Acara akan di-generate otomatis',
              style: AppTheme.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
