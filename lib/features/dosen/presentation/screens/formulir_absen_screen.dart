import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';

// ── Models ────────────────────────────────────────────────────────────────

class PesertaSidangModel {
  final String id;
  final String nama;
  final String role;
  bool hadir;
  String keterangan;

  PesertaSidangModel({
    required this.id,
    required this.nama,
    required this.role,
    this.hadir = true,
    this.keterangan = '',
  });
}

class AbsensiSidangModel {
  final String mahasiswaNama;
  final String ruangan;
  final String tanggal;
  final String waktu;
  final List<PesertaSidangModel> peserta;

  const AbsensiSidangModel({
    required this.mahasiswaNama,
    required this.ruangan,
    required this.tanggal,
    required this.waktu,
    required this.peserta,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────

class FormulirAbsenScreen extends StatefulWidget {
  final String? sidangId;
  const FormulirAbsenScreen({super.key, this.sidangId});

  @override
  State<FormulirAbsenScreen> createState() => _FormulirAbsenScreenState();
}

class _FormulirAbsenScreenState extends State<FormulirAbsenScreen> {
  final _formKey = GlobalKey<FormState>();

  // Status kehadiran dosen sendiri
  bool _statusHadir = true;
  TimeOfDay _jamHadir = const TimeOfDay(hour: 8, minute: 50);
  final _keteranganController = TextEditingController();

  bool _isSaving = false;
  bool _isCetak = false;

  final AbsensiSidangModel _sidang = AbsensiSidangModel(
    mahasiswaNama: 'Budi Setiawan',
    ruangan: 'Ruang 302, Gedung A',
    tanggal: '20 Okt 2023',
    waktu: '09:00 - 10:30 WIB',
    peserta: [
      PesertaSidangModel(id: '1', nama: 'Budi Setiawan', role: 'Mahasiswa'),
      PesertaSidangModel(id: '2', nama: 'Dr. Siti Aminah', role: 'Penguji 1'),
      PesertaSidangModel(id: '3', nama: 'Irfan Hakim', role: 'Penguji 2'),
      PesertaSidangModel(id: '4', nama: 'Dr. Ahmad', role: 'Pembimbing 1'),
    ],
  );

  // Keterangan controllers per peserta
  final Map<String, TextEditingController> _keteranganPeserta = {};

  @override
  void initState() {
    super.initState();
    for (final p in _sidang.peserta) {
      _keteranganPeserta[p.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _keteranganController.dispose();
    for (final c in _keteranganPeserta.values) {
      c.dispose();
    }
    super.dispose();
  }

  String _formatTime(TimeOfDay t) {
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.hour < 12 ? 'AM' : 'PM';
    final hour12 = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    return '${hour12.toString().padLeft(2, '0')}:$m $period';
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _jamHadir,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00897B),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _jamHadir = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);
    _showSnack('Formulir kehadiran tersimpan');
  }

  Future<void> _cetak() async {
    setState(() => _isCetak = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isCetak = false);
    _showSnack('Formulir sedang digenerate...');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Formulir Kehadiran Sidang'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print_rounded),
            onPressed: _isCetak ? null : _cetak,
            tooltip: 'Cetak Formulir',
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
              _buildInfoSidangCard(),
              const SizedBox(height: 14),
              _buildKehadiranSayaCard(),
              const SizedBox(height: 14),
              _buildDaftarPesertaCard(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // ── Info Sidang Card ────────────────────────────────────────────────────

  Widget _buildInfoSidangCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Informasi Sidang',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00897B),
                  fontSize: 15,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF00897B).withValues(alpha: 0.3)),
                ),
                child: Text(
                  'Aktif',
                  style: AppTheme.caption.copyWith(
                    color: const Color(0xFF00897B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                    label: 'Mahasiswa', value: _sidang.mahasiswaNama),
              ),
              Expanded(
                child: _InfoRow(label: 'Ruang', value: _sidang.ruangan),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _InfoRow(
                  label: 'Tanggal',
                  value: _sidang.tanggal,
                  icon: Icons.calendar_today_rounded,
                  iconColor: AppColors.primary,
                ),
              ),
              Expanded(
                child: _InfoRow(
                  label: 'Waktu',
                  value: _sidang.waktu,
                  icon: Icons.schedule_rounded,
                  iconColor: const Color(0xFF00897B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Kehadiran Saya Card ─────────────────────────────────────────────────

  Widget _buildKehadiranSayaCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kehadiran Saya',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00897B),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 14),

          // Status Hadir toggle row
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_rounded,
                    size: 22, color: Color(0xFF00897B)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Status Hadir',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Switch(
                value: _statusHadir,
                activeTrackColor: const Color(0xFF00897B),
                onChanged: (v) => setState(() => _statusHadir = v),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Jam Hadir (always shown)
          Text(
            'Jam Hadir',
            style: AppTheme.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickTime,
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
                    _formatTime(_jamHadir),
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.alarm_add_rounded,
                      size: 20, color: AppColors.textTertiary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Keterangan
          Text(
            'Keterangan',
            style: AppTheme.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _keteranganController,
            maxLines: 3,
            style: AppTheme.bodyMedium,
            validator: !_statusHadir
                ? (v) => (v == null || v.trim().isEmpty)
                    ? 'Keterangan wajib diisi jika tidak hadir'
                    : null
                : null,
            decoration: InputDecoration(
              hintText: 'Tulis catatan jika berhalangan hadir...',
              hintStyle: AppTheme.bodyMedium
                  .copyWith(color: AppColors.textTertiary),
              filled: true,
              fillColor: AppColors.scaffoldBackground,
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
                borderSide: const BorderSide(
                    color: Color(0xFF00897B), width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  // ── Daftar Peserta Card ─────────────────────────────────────────────────

  Widget _buildDaftarPesertaCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Peserta',
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00897B),
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          ..._sidang.peserta.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final isLast = i == _sidang.peserta.length - 1;
            return _buildPesertaRow(p, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildPesertaRow(PesertaSidangModel peserta, bool isLast) {
    return Column(
      children: [
        Row(
          children: [
            AvatarInitials(name: peserta.nama, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    peserta.nama,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    peserta.role,
                    style: AppTheme.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: peserta.hadir,
              activeTrackColor: const Color(0xFF00897B),
              onChanged: (v) => setState(() => peserta.hadir = v),
            ),
          ],
        ),
        // Expand keterangan if tidak hadir
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: peserta.hadir
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: TextFormField(
                    controller: _keteranganPeserta[peserta.id],
                    maxLines: 2,
                    style: AppTheme.bodySmall,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Wajib diisi'
                        : null,
                    decoration: InputDecoration(
                      hintText: 'Keterangan ketidakhadiran ${peserta.nama}...',
                      hintStyle: AppTheme.bodySmall
                          .copyWith(color: AppColors.textTertiary),
                      filled: true,
                      fillColor: AppColors.error.withValues(alpha: 0.04),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                            color: AppColors.error.withValues(alpha: 0.3)),
                      ),
                      contentPadding: const EdgeInsets.all(10),
                      isDense: true,
                    ),
                  ),
                ),
        ),
        if (!isLast)
          Divider(color: AppColors.borderLight, height: 16),
      ],
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
                  child: OutlinedButton.icon(
                    onPressed: _isSaving ? null : _save,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                  Color(0xFF00897B)),
                            ),
                          )
                        : const Icon(Icons.save_outlined, size: 18),
                    label: const Text('Simpan'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      textStyle: AppTheme.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Cetak
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isCetak ? null : _cetak,
                    icon: _isCetak
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Icon(Icons.print_rounded, size: 18),
                    label: const Text('Cetak'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00897B),
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
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: iconColor ?? AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                value,
                style: AppTheme.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
