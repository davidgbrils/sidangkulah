import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

// ── Models ────────────────────────────────────────────────────────────────

enum StatusPengajuan { belumDikirim, menungguReview, selesai }

class RequestGantiPengujiModel {
  final String mahasiswaId;
  final String mahasiswaNama;
  final String jadwalSidang;
  final String pengujiDigantiId;
  final String pengujiPenggantiId;
  final String alasan;
  final String? dokumenPath;
  final DateTime timestamp;
  final StatusPengajuan status;

  const RequestGantiPengujiModel({
    required this.mahasiswaId,
    required this.mahasiswaNama,
    required this.jadwalSidang,
    required this.pengujiDigantiId,
    required this.pengujiPenggantiId,
    required this.alasan,
    this.dokumenPath,
    required this.timestamp,
    this.status = StatusPengajuan.belumDikirim,
  });
}

// ── Dummy Data ────────────────────────────────────────────────────────────

class _MahasiswaOption {
  final String id;
  final String nama;
  final String jadwal;
  _MahasiswaOption(this.id, this.nama, this.jadwal);
}

class _DosenOption {
  final String id;
  final String nama;
  _DosenOption(this.id, this.nama);
}

// ── Screen ────────────────────────────────────────────────────────────────

class GantiPengujiScreen extends StatefulWidget {
  const GantiPengujiScreen({super.key});

  @override
  State<GantiPengujiScreen> createState() => _GantiPengujiScreenState();
}

class _GantiPengujiScreenState extends State<GantiPengujiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mahasiswaSearchCtrl = TextEditingController();
  final _pengujiPenggantiCtrl = TextEditingController();
  final _alasanCtrl = TextEditingController();

  _MahasiswaOption? _selectedMahasiswa;
  String? _selectedPengujiDigantiId;
  _DosenOption? _selectedPenggantiDosen;
  PlatformFile? _dokumenFile;
  bool _isSubmitting = false;
  bool _alreadySubmitted = false;

  final List<_MahasiswaOption> _allMahasiswa = [
    _MahasiswaOption('1', 'Budi Setiawan', 'Senin, 3 Juni 2024 (10:00–12:00)'),
    _MahasiswaOption('2', 'Anisa Maharani', 'Selasa, 4 Juni 2024 (09:00–11:00)'),
    _MahasiswaOption('3', 'Dian Permana', 'Rabu, 5 Juni 2024 (13:00–15:00)'),
  ];

  final List<_DosenOption> _pengujiList = [
    _DosenOption('p1', 'Dr. Siti Aminah (Penguji 1)'),
    _DosenOption('p2', 'Irfan Hakim (Penguji 2)'),
    _DosenOption('p3', 'Dr. Rizal (Penguji 3)'),
  ];

  final List<_DosenOption> _dosenList = [
    _DosenOption('d1', 'Dr. Hendra Kusuma'),
    _DosenOption('d2', 'Prof. Wahyu Santoso'),
    _DosenOption('d3', 'Dr. Rina Marlina'),
    _DosenOption('d4', 'Agus Prabowo, M.T.'),
  ];

  List<_MahasiswaOption> get _filteredMahasiswa {
    final q = _mahasiswaSearchCtrl.text.toLowerCase();
    if (q.isEmpty) return _allMahasiswa;
    return _allMahasiswa.where((m) => m.nama.toLowerCase().contains(q)).toList();
  }

  List<_DosenOption> get _filteredDosen {
    final q = _pengujiPenggantiCtrl.text.toLowerCase();
    if (q.isEmpty) return _dosenList;
    return _dosenList.where((d) => d.nama.toLowerCase().contains(q)).toList();
  }

  String get _timestampLabel {
    return DateFormat("d MMMM yyyy, HH:mm 'WIB'", 'id_ID')
        .format(DateTime.now());
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null) setState(() => _dokumenFile = result.files.first);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMahasiswa == null) {
      _showSnack('Pilih mahasiswa terlebih dahulu', isError: true);
      return;
    }
    if (_selectedPengujiDigantiId == null) {
      _showSnack('Pilih penguji yang diganti', isError: true);
      return;
    }
    if (_selectedPenggantiDosen == null) {
      _showSnack('Pilih penguji pengganti', isError: true);
      return;
    }
    setState(() => _isSubmitting = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isSubmitting = false;
      _alreadySubmitted = true;
    });
    _showSnack('Pengajuan berhasil dikirim ke Kaprodi');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: AppTheme.bodySmall.copyWith(color: Colors.white)),
      backgroundColor: isError ? AppColors.error : AppColors.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.all(16),
    ));
  }

  @override
  void dispose() {
    _mahasiswaSearchCtrl.dispose();
    _pengujiPenggantiCtrl.dispose();
    _alasanCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Pengajuan Ganti Penguji',
            style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.w700)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primaryDark),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person_rounded, size: 20, color: AppColors.primary),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBanner(),
              const SizedBox(height: 20),
              _buildMahasiswaSearch(),
              const SizedBox(height: 14),
              _buildJadwalField(),
              const SizedBox(height: 14),
              _buildPengujiDigantiDropdown(),
              const SizedBox(height: 14),
              _buildPengujiPenggantiSearch(),
              const SizedBox(height: 14),
              _buildAlasanField(),
              const SizedBox(height: 14),
              _buildDokumenUpload(),
              const SizedBox(height: 16),
              _buildTimestampRow(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildStatusTracker(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Info Banner ───────────────────────────────────────────────────────────

  Widget _buildInfoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2F1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF00897B).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: Color(0xFF00897B), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Ajukan pergantian penguji kepada Kaprodi',
              style: AppTheme.bodySmall.copyWith(
                color: const Color(0xFF00695C),
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mahasiswa Search ──────────────────────────────────────────────────────

  Widget _buildMahasiswaSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Nama Mahasiswa'),
        const SizedBox(height: 6),
        Autocomplete<_MahasiswaOption>(
          optionsBuilder: (editing) => _filteredMahasiswa,
          displayStringForOption: (m) => m.nama,
          fieldViewBuilder: (ctx, ctrl, focusNode, onSubmitted) {
            _mahasiswaSearchCtrl.text = ctrl.text;
            return _styledTextField(
              controller: ctrl,
              focusNode: focusNode,
              hint: 'Cari Nama Mahasiswa',
              suffixIcon: const Icon(Icons.search_rounded,
                  size: 20, color: AppColors.textTertiary),
            );
          },
          optionsViewBuilder: (ctx, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: MediaQuery.of(ctx).size.width - 32,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: options.map((m) => ListTile(
                    title: Text(m.nama, style: AppTheme.bodySmall),
                    subtitle: Text(m.jadwal,
                        style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
                    onTap: () {
                      onSelected(m);
                      setState(() => _selectedMahasiswa = m);
                    },
                  )).toList(),
                ),
              ),
            ),
          ),
          onSelected: (m) => setState(() => _selectedMahasiswa = m),
        ),
      ],
    );
  }

  // ── Jadwal Sidang (read-only) ─────────────────────────────────────────────

  Widget _buildJadwalField() {
    final jadwal = _selectedMahasiswa?.jadwal ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Jadwal Sidang'),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: jadwal.isEmpty ? Colors.white : AppColors.primary.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_outlined,
                  size: 16,
                  color: jadwal.isEmpty ? AppColors.textTertiary : AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  jadwal.isEmpty ? 'Otomatis terisi setelah pilih mahasiswa' : jadwal,
                  style: AppTheme.bodySmall.copyWith(
                    color: jadwal.isEmpty ? AppColors.textTertiary : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── Penguji yang Diganti ──────────────────────────────────────────────────

  Widget _buildPengujiDigantiDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Penguji yang diganti'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: _selectedPengujiDigantiId,
          hint: Text('Pilih Penguji',
              style: AppTheme.bodySmall.copyWith(color: AppColors.textTertiary)),
          validator: (v) => v == null ? 'Wajib dipilih' : null,
          decoration: _inputDecoration(),
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
          style: AppTheme.bodySmall.copyWith(color: AppColors.textPrimary),
          items: _pengujiList
              .map((p) => DropdownMenuItem(value: p.id, child: Text(p.nama)))
              .toList(),
          onChanged: (v) => setState(() => _selectedPengujiDigantiId = v),
        ),
      ],
    );
  }

  // ── Penguji Pengganti Search ──────────────────────────────────────────────

  Widget _buildPengujiPenggantiSearch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Penguji pengganti'),
        const SizedBox(height: 6),
        Autocomplete<_DosenOption>(
          optionsBuilder: (editing) => _filteredDosen,
          displayStringForOption: (d) => d.nama,
          fieldViewBuilder: (ctx, ctrl, focusNode, onSubmitted) {
            return _styledTextField(
              controller: ctrl,
              focusNode: focusNode,
              hint: 'Cari Nama Dosen',
              suffixIcon: const Icon(Icons.person_search_rounded,
                  size: 20, color: AppColors.textTertiary),
            );
          },
          optionsViewBuilder: (ctx, onSelected, options) => Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: MediaQuery.of(ctx).size.width - 32,
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: options.map((d) => ListTile(
                    leading: CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(d.nama[0],
                          style: AppTheme.caption.copyWith(color: AppColors.primary)),
                    ),
                    title: Text(d.nama, style: AppTheme.bodySmall),
                    onTap: () {
                      onSelected(d);
                      setState(() => _selectedPenggantiDosen = d);
                    },
                  )).toList(),
                ),
              ),
            ),
          ),
          onSelected: (d) => setState(() => _selectedPenggantiDosen = d),
        ),
      ],
    );
  }

  // ── Alasan Field ──────────────────────────────────────────────────────────

  Widget _buildAlasanField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _fieldLabel('Alasan pergantian'),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: _alasanCtrl,
          maxLines: 4,
          maxLength: 500,
          style: AppTheme.bodySmall,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Alasan wajib diisi';
            if (v.trim().length < 20) return 'Minimal 20 karakter';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Tuliskan alasan detail pergantian penguji...',
            hintStyle: AppTheme.bodySmall.copyWith(color: AppColors.textTertiary),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5)),
            counterStyle: AppTheme.caption.copyWith(color: AppColors.textTertiary),
          ),
        ),
      ],
    );
  }

  // ── Dokumen Upload ────────────────────────────────────────────────────────

  Widget _buildDokumenUpload() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Dokumen pendukung'),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickFile,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.border,
                style: BorderStyle.solid,
              ),
            ),
            child: _dokumenFile == null
                ? Column(
                    children: [
                      Icon(Icons.cloud_upload_rounded,
                          size: 36, color: const Color(0xFF00897B)),
                      const SizedBox(height: 8),
                      Text('Upload Dokumen (.pdf)',
                          style: AppTheme.bodySmall.copyWith(
                            color: const Color(0xFF00897B),
                            fontWeight: FontWeight.w600,
                          )),
                      const SizedBox(height: 4),
                      Text('Maksimal file 5MB',
                          style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(Icons.description_rounded,
                          color: AppColors.primary, size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(_dokumenFile!.name,
                            style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded,
                            size: 18, color: AppColors.textTertiary),
                        onPressed: () => setState(() => _dokumenFile = null),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // ── Timestamp ─────────────────────────────────────────────────────────────

  Widget _buildTimestampRow() {
    return Center(
      child: Text(
        'Dikirim pada: $_timestampLabel',
        style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
      ),
    );
  }

  // ── Submit Button ─────────────────────────────────────────────────────────

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: (_isSubmitting || _alreadySubmitted) ? null : _submit,
        icon: _isSubmitting
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : const Icon(Icons.send_rounded, size: 18),
        label: Text(_alreadySubmitted ? 'Sudah Diajukan' : 'Ajukan Pergantian'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00897B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700, fontSize: 15),
          disabledBackgroundColor: AppColors.textTertiary.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  // ── Status Tracker ────────────────────────────────────────────────────────

  Widget _buildStatusTracker() {
    final steps = [
      (Icons.hourglass_empty_rounded, 'Belum\nDikirim', StatusPengajuan.belumDikirim),
      (Icons.assignment_outlined, 'Menunggu\nReview', StatusPengajuan.menungguReview),
      (Icons.verified_outlined, 'Selesai', StatusPengajuan.selesai),
    ];

    final currentStatus = _alreadySubmitted
        ? StatusPengajuan.menungguReview
        : StatusPengajuan.belumDikirim;
    final currentIdx = StatusPengajuan.values.indexOf(currentStatus);

    return Column(
      children: [
        Text('Status Pengajuan',
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        Row(
          children: steps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isActive = i <= currentIdx;
            final isLast = i == steps.length - 1;

            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFF00897B)
                                : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? const Color(0xFF00897B)
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: Icon(step.$1,
                              size: 20,
                              color: isActive ? Colors.white : AppColors.textTertiary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          step.$2,
                          style: AppTheme.caption.copyWith(
                            color: isActive
                                ? const Color(0xFF00897B)
                                : AppColors.textTertiary,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        height: 2,
                        margin: const EdgeInsets.only(bottom: 22),
                        color: i < currentIdx
                            ? const Color(0xFF00897B)
                            : AppColors.borderLight,
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _fieldLabel(String text) => Text(
        text,
        style: AppTheme.bodySmall.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      );

  InputDecoration _inputDecoration({String? hint}) => InputDecoration(
        hintText: hint,
        hintStyle: AppTheme.bodySmall.copyWith(color: AppColors.textTertiary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryDark, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.error)),
      );

  Widget _styledTextField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String hint,
    Widget? suffixIcon,
  }) =>
      TextField(
        controller: controller,
        focusNode: focusNode,
        style: AppTheme.bodySmall.copyWith(color: AppColors.textPrimary),
        decoration: _inputDecoration(hint: hint).copyWith(suffixIcon: suffixIcon),
      );
}
