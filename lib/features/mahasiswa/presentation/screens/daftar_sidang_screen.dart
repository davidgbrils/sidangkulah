import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

enum DaftarSidangStep { dataDiri, uploadBerkas, konfirmasi }

class BerkasItem {
  final String nama;
  final bool isUploaded;
  final String? fileName;

  const BerkasItem({required this.nama, this.isUploaded = false, this.fileName});

  BerkasItem copyWith({bool? isUploaded, String? fileName}) {
    return BerkasItem(nama: nama, isUploaded: isUploaded ?? this.isUploaded, fileName: fileName ?? this.fileName);
  }
}

class DaftarSidangNotifier extends ChangeNotifier {
  int _currentStep = 0;
  String _nama = '';
  String _nim = '';
  String _prodi = '';
  String _judulSkripsi = '';
  String _pembimbing1 = '';
  String _pembimbing2 = '';
  final Map<String, BerkasItem> _berkas = {
    'KRS Aktif': const BerkasItem(nama: 'KRS Aktif'),
    'Transkrip Nilai': const BerkasItem(nama: 'Transkrip Nilai'),
    'Lembar Persetujuan': const BerkasItem(nama: 'Lembar Persetujuan'),
    'Hasil Plagiasi': const BerkasItem(nama: 'Hasil Plagiasi'),
    'Lembar Konsultasi': const BerkasItem(nama: 'Lembar Konsultasi'),
    'Foto Formal': const BerkasItem(nama: 'Foto Formal'),
    'Surat Keterangan Bebas Pustaka': const BerkasItem(nama: 'Surat Keterangan Bebas Pustaka'),
  };
  bool _isLoading = false;
  bool _isSubmitting = false;

  int get currentStep => _currentStep;
  String get nama => _nama;
  String get nim => _nim;
  String get prodi => _prodi;
  String get judulSkripsi => _judulSkripsi;
  String get pembimbing1 => _pembimbing1;
  String get pembimbing2 => _pembimbing2;
  List<BerkasItem> get berkasList => _berkas.values.toList();
  int get uploadedCount => _berkas.values.where((b) => b.isUploaded).length;
  int get totalBerkas => _berkas.length;
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get canSubmit => uploadedCount == totalBerkas && _judulSkripsi.isNotEmpty;

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _nama = prefs.getString('user_nama') ?? 'Mahasiswa';
      _nim = prefs.getString('user_id') ?? '202011001';
      _prodi = 'Teknik Informatika';
      _judulSkripsi = '';
      _pembimbing1 = 'Dr. Ir. Heru Setiawan, M.T.';
      _pembimbing2 = 'Dr. Siti Rahayu, M.Kom.';
    } catch (e) {
      debugPrint('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setJudulSkripsi(String value) {
    _judulSkripsi = value;
    notifyListeners();
  }

  Future<void> uploadBerkas(String key) async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf'], allowMultiple: false);
      if (result != null && result.files.isNotEmpty) {
        _berkas[key] = _berkas[key]!.copyWith(isUploaded: true, fileName: result.files.first.name);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  void nextStep() {
    if (_currentStep < 2) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      notifyListeners();
    }
  }

  void goToStep(int step) {
    _currentStep = step;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;
    setState(() => _isSubmitting = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      return true;
    } catch (e) {
      debugPrint('Error submitting: $e');
      return false;
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

class DaftarSidangScreen extends StatefulWidget {
  const DaftarSidangScreen({super.key});

  @override
  State<DaftarSidangScreen> createState() => _DaftarSidangScreenState();
}

class _DaftarSidangScreenState extends State<DaftarSidangScreen> {
  final notifier = DaftarSidangNotifier();
  final _judulController = TextEditingController();
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    notifier.loadData();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        if (notifier.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldBackground,
          appBar: AppBar(
            title: const Text('Pendaftaran Sidang'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: Column(
            children: [
              _buildStepIndicator(),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [_buildPage1(), _buildPage2(), _buildPage3()],
                ),
              ),
              _buildNavigationButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepIndicator() {
    final steps = ['Data Diri', 'Upload Berkas', 'Konfirmasi'];
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length, (i) {
          final isActive = i <= notifier.currentStep;
          final isCurrent = i == notifier.currentStep;
          return Expanded(
            child: Row(
              children: [
                if (i > 0) Expanded(child: Container(height: 2, color: isActive ? AppColors.primary : AppColors.border)),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? AppColors.primary : Colors.transparent,
                    border: Border.all(color: isActive ? AppColors.primary : AppColors.border, width: 2),
                  ),
                  child: Center(
                    child: isActive
                        ? Icon(Icons.check, size: 14, color: isCurrent ? Colors.white : AppColors.primary)
                        : Text('${i + 1}', style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
                  ),
                ),
                if (i < steps.length - 1) Expanded(child: Container(height: 2, color: isActive ? AppColors.primary : AppColors.border)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPage1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildReadOnlyField('Nama', notifier.nama),
          _buildReadOnlyField('NIM', notifier.nim),
          _buildReadOnlyField('Program Studi', notifier.prodi),
          const SizedBox(height: 16),
          Text('Judul Skripsi', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          TextFormField(
            controller: _judulController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Masukkan judul skripsi...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.border)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
            ),
            onChanged: notifier.setJudulSkripsi,
          ),
          const SizedBox(height: 16),
          _buildReadOnlyField('Nama Pembimbing 1', notifier.pembimbing1),
          _buildReadOnlyField('Nama Pembimbing 2', notifier.pembimbing2),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceContainerLow, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
            child: Text(value, style: AppTheme.bodyMedium.copyWith(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Kelengkapan Berkas Sidang', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Text('Pastikan semua berkas dalam format PDF', style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 16),
        ...notifier.berkasList.map((berkas) => _buildBerkasRow(berkas)),
      ],
    );
  }

  Widget _buildBerkasRow(BerkasItem berkas) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(berkas.nama, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                if (berkas.isUploaded && berkas.fileName != null)
                  Text(berkas.fileName!, style: AppTheme.caption.copyWith(color: AppColors.success, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: berkas.isUploaded ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(berkas.isUploaded ? 'Terupload' : 'Belum', style: AppTheme.caption.copyWith(color: berkas.isUploaded ? AppColors.success : AppColors.warning, fontWeight: FontWeight.w500)),
          ),
          const SizedBox(width: 12),
          SidangkuButton(
            label: berkas.isUploaded ? 'Ganti' : 'Upload',
            type: SidangkuButtonType.outlined,
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onTap: () => notifier.uploadBerkas(berkas.nama),
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ringkasan Pendaftaran', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryRow('Nama', notifier.nama),
                _buildSummaryRow('NIM', notifier.nim),
                _buildSummaryRow('Program Studi', notifier.prodi),
                _buildSummaryRow('Judul Skripsi', notifier.judulSkripsi.isEmpty ? '-' : notifier.judulSkripsi),
                _buildSummaryRow('Pembimbing 1', notifier.pembimbing1),
                _buildSummaryRow('Pembimbing 2', notifier.pembimbing2),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: notifier.canSubmit ? AppColors.success.withValues(alpha: 0.1) : AppColors.warning.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: notifier.canSubmit ? AppColors.success : AppColors.warning),
            ),
            child: Row(
              children: [
                Icon(notifier.canSubmit ? Icons.check_circle : Icons.warning, color: notifier.canSubmit ? AppColors.success : AppColors.warning),
                const SizedBox(width: 12),
                Text('${notifier.uploadedCount}/${notifier.totalBerkas} berkas terupload', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600, color: notifier.canSubmit ? AppColors.success : AppColors.warning)),
              ],
            ),
          ),
          if (!notifier.canSubmit) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [Icon(Icons.info_outline, color: AppColors.error, size: 20), const SizedBox(width: 8), Expanded(child: Text('Silakan lengkapi semua berkas terlebih dahulu sebelum mendaftar.', style: AppTheme.caption.copyWith(color: AppColors.error)))],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: AppTheme.caption.copyWith(color: AppColors.textSecondary))),
          Expanded(child: Text(value, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    final isFirst = notifier.currentStep == 0;
    final isLast = notifier.currentStep == 2;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: const Offset(0, -2))]),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (!isFirst)
              Expanded(
                child: SidangkuButton(label: 'Kembali', type: SidangkuButtonType.outlined, onTap: () => _handlePrevious()),
              ),
            if (!isFirst) const SizedBox(width: 12),
            Expanded(
              flex: isFirst ? 1 : 1,
              child: SidangkuButton(label: isLast ? 'Daftar Sidang' : 'Lanjut', onTap: () => _handleNext()),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (notifier.currentStep < 2) {
      notifier.nextStep();
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _handleSubmit();
    }
  }

  void _handlePrevious() {
    if (notifier.currentStep > 0) {
      notifier.previousStep();
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  Future<void> _handleSubmit() async {
    final success = await notifier.submit();
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pendaftaran berhasil!'), backgroundColor: AppColors.success),
      );
      context.go('/mahasiswa');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mendaftar. Silakan coba lagi.'), backgroundColor: AppColors.error),
      );
    }
  }
}
