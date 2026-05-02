import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';
import 'package:sidangkufix/core/widgets/status_chip.dart';

// ── Models ────────────────────────────────────────────────────────────────

/// Anggota tim penguji / pembimbing
class TimDosenModel {
  final String nama;
  final String role; // "Penguji 1", "Pembimbing 1", etc.

  const TimDosenModel({required this.nama, required this.role});
}

/// Ringkasan nilai (jika sudah dinilai)
class NilaiSummaryModel {
  final String nilaiHuruf;
  final double nilaiAngka;
  final String tanggalInput;

  const NilaiSummaryModel({
    required this.nilaiHuruf,
    required this.nilaiAngka,
    required this.tanggalInput,
  });
}

/// Model detail mahasiswa untuk halaman dosen
class MahasiswaDetailModel {
  final String id;
  final String nama;
  final String nim;
  final String judulSkripsi;
  final String statusSidang; // "terjadwal", "sudah_nilai", "revisi"
  final String tanggal;
  final String waktu;
  final String ruangan;
  final List<TimDosenModel> timDosen;
  final NilaiSummaryModel? nilai;
  final String? catatanRevisi;

  const MahasiswaDetailModel({
    required this.id,
    required this.nama,
    required this.nim,
    required this.judulSkripsi,
    required this.statusSidang,
    required this.tanggal,
    required this.waktu,
    required this.ruangan,
    required this.timDosen,
    this.nilai,
    this.catatanRevisi,
  });
}

// ── Screen ────────────────────────────────────────────────────────────────

/// Halaman Detail Mahasiswa — Dosen
class DosenMahasiswaDetailScreen extends StatefulWidget {
  final String mahasiswaId;

  const DosenMahasiswaDetailScreen({
    super.key,
    required this.mahasiswaId,
  });

  @override
  State<DosenMahasiswaDetailScreen> createState() =>
      _DosenMahasiswaDetailScreenState();
}

class _DosenMahasiswaDetailScreenState
    extends State<DosenMahasiswaDetailScreen> {
  final _catatanController = TextEditingController();

  // TODO: Replace with Riverpod DosenMahasiswaDetailNotifier
  late final MahasiswaDetailModel _data;

  @override
  void initState() {
    super.initState();
    // Dummy data matching the design
    _data = const MahasiswaDetailModel(
      id: '1',
      nama: 'Budi Setiawan',
      nim: '1202184001',
      judulSkripsi: 'Implementasi Blockchain pada Sistem Keamanan IOT',
      statusSidang: 'terjadwal',
      tanggal: '20 Okt 2023',
      waktu: '09:00 WIB',
      ruangan: 'Ruang 302, Gedung A',
      timDosen: [
        TimDosenModel(nama: 'Dr. Siti Aminah', role: 'Penguji 2'),
        TimDosenModel(nama: 'Irfan Hakim', role: 'Penguji 3'),
        TimDosenModel(nama: 'Dr. Ahmad', role: 'Pembimbing 1'),
      ],
    );
    _catatanController.text = _data.catatanRevisi ?? '';
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Detail Mahasiswa'),
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
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {
              // TODO: Show options menu
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Card ──────────────────────────────────────────
            _buildHeroCard(),
            const SizedBox(height: 14),

            // ── Waktu & Tempat ─────────────────────────────────────
            _buildInfoCard(),
            const SizedBox(height: 14),

            // ── Tim Penguji & Pembimbing ───────────────────────────
            _buildTimDosenCard(),
            const SizedBox(height: 20),

            // ── Action Buttons ─────────────────────────────────────
            _buildActionButtons(),
            const SizedBox(height: 14),

            // ── Nilai Summary (if submitted) ───────────────────────
            if (_data.nilai != null) ...[
              _buildNilaiSummaryCard(),
              const SizedBox(height: 14),
            ],

            // ── Catatan Penguji ────────────────────────────────────
            _buildCatatanSection(),
          ],
        ),
      ),
    );
  }

  // ── Hero Card ───────────────────────────────────────────────────────────

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              AvatarInitials(
                name: _data.nama,
                size: 80,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                textColor: AppColors.primary,
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Name
          Text(
            _data.nama,
            style: AppTheme.headingSmall.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 17,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // NIM
          Text(
            _data.nim,
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),

          // Status badge
          _buildStatusBadge(),
          const SizedBox(height: 18),

          // Divider
          Divider(color: AppColors.borderLight, height: 1),
          const SizedBox(height: 18),

          // Judul Skripsi
          Text(
            'JUDUL SKRIPSI',
            style: AppTheme.caption.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${_data.judulSkripsi}"',
            style: AppTheme.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color fgColor;
    String label;

    switch (_data.statusSidang) {
      case 'terjadwal':
        bgColor = AppColors.chipScheduledBg;
        fgColor = AppColors.chipScheduledFg;
        label = 'Terjadwal';
        break;
      case 'sudah_nilai':
        bgColor = AppColors.chipDoneBg;
        fgColor = AppColors.chipDoneFg;
        label = 'Sudah Dinilai';
        break;
      case 'revisi':
        bgColor = AppColors.chipRevisionBg;
        fgColor = AppColors.chipRevisionFg;
        label = 'Revisi';
        break;
      default:
        bgColor = AppColors.chipPendingBg;
        fgColor = AppColors.chipPendingFg;
        label = _data.statusSidang;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: fgColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: fgColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ── Info Card (Waktu & Tempat) ──────────────────────────────────────────

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.calendar_month_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Waktu & Tempat',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_data.tanggal}, ${_data.waktu}',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                Text(
                  _data.ruangan,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Tim Dosen Card ─────────────────────────────────────────────────────

  Widget _buildTimDosenCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF00897B).withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.groups_rounded,
                  size: 22,
                  color: Color(0xFF00897B),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Tim Penguji & Pembimbing',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Dosen list
          ..._data.timDosen.asMap().entries.map((entry) {
            final dosen = entry.value;
            final isLast = entry.key == _data.timDosen.length - 1;
            return _buildDosenRow(dosen, isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildDosenRow(TimDosenModel dosen, bool isLast) {
    final isPembimbing = dosen.role.toLowerCase().contains('pembimbing');

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: Row(
        children: [
          AvatarInitials(
            name: dosen.nama,
            size: 36,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dosen.nama,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  dosen.role,
                  style: AppTheme.caption.copyWith(
                    color: isPembimbing
                        ? AppColors.primary
                        : const Color(0xFF00897B),
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chat_bubble_rounded,
            size: 18,
            color: const Color(0xFF00897B).withValues(alpha: 0.6),
          ),
        ],
      ),
    );
  }

  // ── Action Buttons ─────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Primary: Input Nilai (full width)
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              context.push('/dosen/input-nilai/${widget.mahasiswaId}');
            },
            icon: const Icon(Icons.star_rounded, size: 20),
            label: const Text('Input Nilai'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00897B),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Row: Absensi + Revisi
        Row(
          children: [
            Expanded(
              child: _ActionOutlinedButton(
                icon: Icons.fact_check_outlined,
                label: 'Absensi',
                onTap: () {
                  // TODO: Navigate to formulir absen
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _ActionOutlinedButton(
                icon: Icons.tune_rounded,
                label: 'Revisi',
                onTap: () {
                  context.push('/dosen/formulir-revisi/${widget.mahasiswaId}');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // Full width: Lihat Dokumen Skripsi
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Navigate to dokumen skripsi
            },
            icon: Icon(Icons.description_outlined,
                size: 18, color: AppColors.textSecondary),
            label: Text(
              'Lihat Dokumen Skripsi',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Nilai Summary Card ─────────────────────────────────────────────────

  Widget _buildNilaiSummaryCard() {
    final nilai = _data.nilai!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.chipDoneBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.chipDoneFg.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.chipDoneFg.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                nilai.nilaiHuruf,
                style: AppTheme.headingLarge.copyWith(
                  color: AppColors.chipDoneFg,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nilai Sudah Diinput',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.chipDoneFg,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Nilai: ${nilai.nilaiAngka} · ${nilai.tanggalInput}',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.chipDoneFg.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.check_circle_rounded,
            color: AppColors.chipDoneFg,
            size: 24,
          ),
        ],
      ),
    );
  }

  // ── Catatan Section ────────────────────────────────────────────────────

  Widget _buildCatatanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Catatan Penguji',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _catatanController,
                maxLines: 4,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.6,
                ),
                decoration: InputDecoration(
                  hintText:
                      'Tuliskan catatan revisi atau feedback untuk mahasiswa di sini...',
                  hintStyle: AppTheme.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    height: 1.6,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: (_) {
                  // TODO: Auto-save via debounce + Riverpod
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 14, bottom: 10),
                child: Text(
                  'Auto-saved',
                  style: AppTheme.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Action Outlined Button ────────────────────────────────────────────────

class _ActionOutlinedButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionOutlinedButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: AppColors.textSecondary),
        label: Text(
          label,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
