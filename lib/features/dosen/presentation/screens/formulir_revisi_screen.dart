import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';

// ── Models ────────────────────────────────────────────────────────────────

enum TingkatRevisi { ringan, sedang, berat }

extension TingkatRevisiExt on TingkatRevisi {
  String get label {
    switch (this) {
      case TingkatRevisi.ringan:
        return 'Ringan';
      case TingkatRevisi.sedang:
        return 'Sedang';
      case TingkatRevisi.berat:
        return 'Berat';
    }
  }
}

class RevisiModel {
  final String mahasiswaId;
  final String bab1;
  final String bab2;
  final String bab3;
  final String bab4;
  final String bab5;
  final String lainnya;
  final DateTime? batasWaktu;
  final TingkatRevisi tingkat;

  const RevisiModel({
    required this.mahasiswaId,
    this.bab1 = '',
    this.bab2 = '',
    this.bab3 = '',
    this.bab4 = '',
    this.bab5 = '',
    this.lainnya = '',
    this.batasWaktu,
    this.tingkat = TingkatRevisi.ringan,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────

class FormulirRevisiScreen extends StatefulWidget {
  final String mahasiswaId;

  const FormulirRevisiScreen({super.key, required this.mahasiswaId});

  @override
  State<FormulirRevisiScreen> createState() => _FormulirRevisiScreenState();
}

class _FormulirRevisiScreenState extends State<FormulirRevisiScreen> {
  final _formKey = GlobalKey<FormState>();

  // Bab controllers
  final _bab1Ctrl = TextEditingController();
  final _bab2Ctrl = TextEditingController();
  final _bab3Ctrl = TextEditingController();
  final _bab4Ctrl = TextEditingController();
  final _bab5Ctrl = TextEditingController();
  final _lainnyaCtrl = TextEditingController();

  DateTime? _batasWaktu = DateTime(2023, 11, 20);
  TingkatRevisi _tingkat = TingkatRevisi.ringan;

  // Signature state
  late final SignatureController _signatureController;
  Uint8List? _savedTTDBytes;
  bool _usingSavedTTD = false;
  bool _showNewTTDCanvas = false;

  bool _isSaving = false;
  bool _isUnduh = false;

  // TODO: Replace with Riverpod FormulirRevisiNotifier(mahasiswaId)
  final String _namaMahasiswa = 'Budi Setiawan';
  final String _nim = '1202184001';

  @override
  void initState() {
    super.initState();
    _signatureController = SignatureController(
      penStrokeWidth: 2.5,
      penColor: AppColors.textPrimary,
      exportBackgroundColor: Colors.white,
    );
    _loadSavedTTD();
  }

  @override
  void dispose() {
    _bab1Ctrl.dispose();
    _bab2Ctrl.dispose();
    _bab3Ctrl.dispose();
    _bab4Ctrl.dispose();
    _bab5Ctrl.dispose();
    _lainnyaCtrl.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  // ── TTD Logic ───────────────────────────────────────────────────────────

  Future<void> _loadSavedTTD() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/ttd_dosen.png');
      if (await file.exists()) {
        final bytes = await file.readAsBytes();
        setState(() => _savedTTDBytes = bytes);
      }
    } catch (_) {}
  }

  void _useSavedTTD() => setState(() {
        _usingSavedTTD = true;
        _showNewTTDCanvas = false;
        _signatureController.clear();
      });

  void _useNewTTD() => setState(() {
        _usingSavedTTD = false;
        _showNewTTDCanvas = true;
      });

  // ── Date Picker ─────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _batasWaktu ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primaryDark),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _batasWaktu = picked);
  }

  String get _formattedDate => _batasWaktu != null
      ? DateFormat('d MMM yyyy').format(_batasWaktu!)
      : 'Pilih tanggal';

  // ── Actions ─────────────────────────────────────────────────────────────

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    // TODO: Call Riverpod FormulirRevisiNotifier.save()
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnack('Draft tersimpan');
  }

  Future<void> _unduhDocx() async {
    setState(() => _isUnduh = true);
    // TODO: Call API to generate DOCX
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isUnduh = false);
    _showSnack('Dokumen sedang dibuat...');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: AppTheme.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Text('Formulir Revisi — $_namaMahasiswa'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: AppColors.primaryDark),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Student mini card ──────────────────────────────────
              _buildStudentCard(),
              const SizedBox(height: 16),

              // ── Detail Revisi header ───────────────────────────────
              Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      size: 18, color: AppColors.primaryDark),
                  const SizedBox(width: 6),
                  Text(
                    'Detail Revisi',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── Bab fields ─────────────────────────────────────────
              _buildBabField(
                  'Revisi Bab 1 - Pendahuluan', _bab1Ctrl),
              const SizedBox(height: 12),
              _buildBabField(
                  'Revisi Bab 2 - Tinjauan Pustaka', _bab2Ctrl),
              const SizedBox(height: 12),
              _buildBabField(
                  'Revisi Bab 3 - Metodologi', _bab3Ctrl),
              const SizedBox(height: 12),
              _buildBabField(
                  'Revisi Bab 4 - Hasil & Pembahasan', _bab4Ctrl),
              const SizedBox(height: 12),
              _buildBabField(
                  'Revisi Bab 5 - Penutup', _bab5Ctrl),
              const SizedBox(height: 12),
              _buildBabField(
                  'Lainnya', _lainnyaCtrl,
                  hint: 'Tambahan lainnya...'),
              const SizedBox(height: 20),

              // ── Divider ────────────────────────────────────────────
              Divider(color: AppColors.borderLight, height: 1),
              const SizedBox(height: 20),

              // ── Batas Waktu ────────────────────────────────────────
              _buildDateField(),
              const SizedBox(height: 16),

              // ── Tingkat Revisi ─────────────────────────────────────
              _buildTingkatDropdown(),
              const SizedBox(height: 20),

              // ── Tanda Tangan ───────────────────────────────────────
              _buildTandaTanganCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Student Mini Card ───────────────────────────────────────────────────

  Widget _buildStudentCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
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
              Text(
                'NIM: $_nim',
                style: AppTheme.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Bab Field ───────────────────────────────────────────────────────────

  Widget _buildBabField(
    String label,
    TextEditingController ctrl, {
    String hint = 'Masukkan catatan revisi...',
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl,
          maxLines: 3,
          style: AppTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTheme.bodyMedium
                .copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryDark, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ── Date Picker Field ───────────────────────────────────────────────────

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Batas Waktu Revisi',
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text(
                  _formattedDate,
                  style: AppTheme.bodyMedium.copyWith(
                    color: _batasWaktu != null
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                  ),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── Tingkat Dropdown ────────────────────────────────────────────────────

  Widget _buildTingkatDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tingkat Revisi',
          style: AppTheme.bodySmall.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<TingkatRevisi>(
          value: _tingkat,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.primaryDark, width: 1.5),
            ),
          ),
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary),
          style: AppTheme.bodyMedium.copyWith(color: AppColors.textPrimary),
          items: TingkatRevisi.values
              .map((t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.label),
                  ))
              .toList(),
          onChanged: (v) => setState(() => _tingkat = v!),
        ),
      ],
    );
  }

  // ── Tanda Tangan Card ───────────────────────────────────────────────────

  Widget _buildTandaTanganCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tanda Tangan Digital',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 12),

          // Option 1: Use saved TTD
          _TTDOptionButton(
            icon: Icons.draw_rounded,
            label: 'Gunakan TTD Tersimpan',
            isSelected: _usingSavedTTD,
            onTap: _savedTTDBytes != null ? _useSavedTTD : null,
            enabled: _savedTTDBytes != null,
          ),
          const SizedBox(height: 8),

          // Option 2: New TTD
          _TTDOptionButton(
            icon: Icons.edit_outlined,
            label: 'Tanda Tangan Baru',
            isSelected: _showNewTTDCanvas && !_usingSavedTTD,
            onTap: _useNewTTD,
          ),
          const SizedBox(height: 12),

          // Signature canvas (shown when "Tanda Tangan Baru" selected or as default)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: (_showNewTTDCanvas || !_usingSavedTTD)
                ? Column(
                    children: [
                      Container(
                        height: 120,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: AppColors.border,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(9),
                          child: Stack(
                            children: [
                              Signature(
                                controller: _signatureController,
                                backgroundColor: Colors.transparent,
                              ),
                              if (_signatureController.isEmpty &&
                                  !_usingSavedTTD)
                                Center(
                                  child: Text(
                                    'Area Tanda Tangan',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ),
                              // Saved TTD preview
                              if (_usingSavedTTD &&
                                  _savedTTDBytes != null)
                                Center(
                                  child: Image.memory(
                                    _savedTTDBytes!,
                                    fit: BoxFit.contain,
                                    height: 100,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── Bottom Bar ──────────────────────────────────────────────────────────

  Widget _buildBottomBar() {
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              // Simpan
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.save_rounded, size: 18),
                    label: const Text('Simpan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: AppTheme.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Unduh DOCX
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: _isUnduh ? null : _unduhDocx,
                    icon: _isUnduh
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  AppColors.primaryDark),
                            ),
                          )
                        : const Icon(Icons.description_outlined, size: 18),
                    label: const Text('Unduh DOCX'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(
                          color: AppColors.primaryDark, width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: AppTheme.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── TTD Option Button ─────────────────────────────────────────────────────

class _TTDOptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool enabled;

  const _TTDOptionButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDark.withValues(alpha: 0.06)
              : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primaryDark : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? AppColors.primaryDark
                  : enabled
                      ? AppColors.textSecondary
                      : AppColors.textTertiary,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryDark
                    : enabled
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
