import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';
import 'package:sidangkufix/core/widgets/empty_state.dart';
import 'package:sidangkufix/core/widgets/status_chip.dart';

// ── Model ─────────────────────────────────────────────────────────────────

/// Model data mahasiswa dari perspektif dosen
class MahasiswaDosenModel {
  final String id;
  final String nama;
  final String nim;
  final String judulSkripsi;
  final String roleDosen; // "Pembimbing 1", "Pembimbing 2", "Penguji 1", "Penguji 2"
  final String tanggalSidang;
  final String statusNilai; // "terjadwal", "sudah_nilai", "revisi"
  final String? nilai; // e.g. "A-"

  const MahasiswaDosenModel({
    required this.id,
    required this.nama,
    required this.nim,
    required this.judulSkripsi,
    required this.roleDosen,
    required this.tanggalSidang,
    required this.statusNilai,
    this.nilai,
  });

  /// Apakah role ini termasuk pembimbing
  bool get isPembimbing => roleDosen.toLowerCase().contains('pembimbing');

  /// Apakah role ini termasuk penguji
  bool get isPenguji => roleDosen.toLowerCase().contains('penguji');
}

// ── Screen ────────────────────────────────────────────────────────────────

/// Layar Daftar Mahasiswa Saya — Dosen
class DosenMahasiswaScreen extends StatefulWidget {
  const DosenMahasiswaScreen({super.key});

  @override
  State<DosenMahasiswaScreen> createState() => _DosenMahasiswaScreenState();
}

class _DosenMahasiswaScreenState extends State<DosenMahasiswaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<MahasiswaDosenModel> _allMahasiswa = const [
    MahasiswaDosenModel(
      id: '1',
      nama: 'Budi Setiawan',
      nim: '123456789',
      judulSkripsi:
          'Pengembangan Sistem Manajemen Sidang Skripsi Berbasis Mobile Menggunakan Flutter',
      roleDosen: 'Pembimbing 1',
      tanggalSidang: '20 Okt 2023',
      statusNilai: 'terjadwal',
    ),
    MahasiswaDosenModel(
      id: '2',
      nama: 'Anisa Maharani',
      nim: '123456790',
      judulSkripsi:
          'Implementasi Deep Learning untuk Deteksi Kerusakan Jalan Berbasis Citra Udara',
      roleDosen: 'Penguji 2',
      tanggalSidang: '18 Okt 2023',
      statusNilai: 'sudah_nilai',
      nilai: 'A-',
    ),
    MahasiswaDosenModel(
      id: '3',
      nama: 'Dian Permana',
      nim: '123456791',
      judulSkripsi:
          'Analisis Sentimen Pengguna Media Sosial terhadap Kebijakan Transportasi Publik',
      roleDosen: 'Pembimbing 2',
      tanggalSidang: '15 Okt 2023',
      statusNilai: 'revisi',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // ── Filtering ───────────────────────────────────────────────────────────

  List<MahasiswaDosenModel> _getFiltered(String tabFilter) {
    var list = _allMahasiswa;

    // Tab filter
    if (tabFilter == 'pembimbing') {
      list = list.where((m) => m.isPembimbing).toList();
    } else if (tabFilter == 'penguji') {
      list = list.where((m) => m.isPenguji).toList();
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      list = list.where((m) {
        return m.nama.toLowerCase().contains(_searchQuery) ||
            m.nim.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return list;
  }

  int get _belumDinilaiCount =>
      _allMahasiswa.where((m) => m.statusNilai != 'sudah_nilai').length;

  // ── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Mahasiswa Saya'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () {
              // Navigate to profile
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildTabBar(),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          _buildSearchBar(),
          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMahasiswaList('semua'),
                _buildMahasiswaList('pembimbing'),
                _buildMahasiswaList('penguji'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Summary bar (shows only if belum dinilai > 0)
          if (_belumDinilaiCount > 0) _buildSummaryBar(),
        ],
      ),
    );
  }

  // ── Tab Bar ─────────────────────────────────────────────────────────────

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.8),
        labelStyle: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w400),
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(8),
        padding: const EdgeInsets.all(3),
        tabs: const [
          Tab(text: 'Semua', height: 36),
          Tab(text: 'Pembimbing', height: 36),
          Tab(text: 'Penguji', height: 36),
        ],
      ),
    );
  }

  // ── Search Bar ──────────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: TextField(
        controller: _searchController,
        style: AppTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Cari nama atau NIM...',
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search_rounded,
              size: 20, color: AppColors.textTertiary),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded,
                      size: 18, color: AppColors.textTertiary),
                  onPressed: () {
                    _searchController.clear();
                  },
                )
              : null,
        ),
      ),
    );
  }

  // ── Mahasiswa List ──────────────────────────────────────────────────────

  Widget _buildMahasiswaList(String filter) {
    final list = _getFiltered(filter);

    if (list.isEmpty) {
      return EmptyState.notFound(
        title: _searchQuery.isNotEmpty
            ? 'Mahasiswa Tidak Ditemukan'
            : 'Belum Ada Mahasiswa',
        subtitle: _searchQuery.isNotEmpty
            ? 'Coba ubah kata kunci pencarian Anda'
            : 'Data mahasiswa akan muncul di sini',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: list.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        return _MahasiswaDosenCard(
          mahasiswa: list[index],
          onTap: () => context.push('/dosen/mahasiswa/${list[index].id}'),
        );
      },
    );
  }

  // ── Summary Bar ─────────────────────────────────────────────────────────

  Widget _buildSummaryBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D47A1), Color(0xFF1565C0)],
        ),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.assignment_late_outlined,
            color: Colors.white.withValues(alpha: 0.8),
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$_belumDinilaiCount belum dinilai',
              style: AppTheme.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              _showDetailBelumDinilai(context);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Detail',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDetailBelumDinilai(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mahasiswa Belum Dinilai',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Silakan input nilai untuk mahasiswa yang belum dinilai.',
              style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Mahasiswa Card ────────────────────────────────────────────────────────

class _MahasiswaDosenCard extends StatelessWidget {
  final MahasiswaDosenModel mahasiswa;
  final VoidCallback? onTap;

  const _MahasiswaDosenCard({
    required this.mahasiswa,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: Avatar + Name + NIM + Chevron ──────────────
              Row(
                children: [
                  AvatarInitials(name: mahasiswa.nama, size: 48),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mahasiswa.nama,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          mahasiswa.nim,
                          style: AppTheme.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textTertiary,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Judul Skripsi ──────────────────────────────────────
              Text(
                mahasiswa.judulSkripsi,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // ── Role Badge + Tanggal ───────────────────────────────
              Row(
                children: [
                  _RoleBadge(role: mahasiswa.roleDosen),
                  const Spacer(),
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    mahasiswa.tanggalSidang,
                    style: AppTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Status + Action ────────────────────────────────────
              Row(
                children: [
                  _buildStatusChip(),
                  const Spacer(),
                  _buildAction(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    switch (mahasiswa.statusNilai) {
      case 'terjadwal':
        return const StatusChip(
          label: 'Terjadwal',
          type: StatusChipType.scheduled,
        );
      case 'sudah_nilai':
        return const StatusChip(
          label: 'Sudah Nilai',
          type: StatusChipType.done,
        );
      case 'revisi':
        return const StatusChip(
          label: 'Revisi',
          type: StatusChipType.revision,
        );
      default:
        return StatusChip.fromString(mahasiswa.statusNilai);
    }
  }

  Widget _buildAction(BuildContext context) {
    switch (mahasiswa.statusNilai) {
      case 'terjadwal':
        return _ActionLink(
          label: 'Input Nilai',
          icon: Icons.arrow_forward_rounded,
          onTap: () {
            context.go('/dosen/input-nilai/${mahasiswa.id}');
          },
        );
      case 'sudah_nilai':
        return Text(
          'Nilai: ${mahasiswa.nilai ?? '-'}',
          style: AppTheme.bodySmall.copyWith(
            color: AppColors.textSecondary,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        );
      case 'revisi':
        return _ActionLink(
          label: 'Lihat Revisi',
          onTap: () {
            context.go('/dosen/formulir-revisi/${mahasiswa.id}');
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

}

// ── Role Badge ────────────────────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  final String role;

  const _RoleBadge({required this.role});

  @override
  Widget build(BuildContext context) {
    final isPembimbing = role.toLowerCase().contains('pembimbing');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPembimbing
            ? AppColors.primary.withValues(alpha: 0.08)
            : const Color(0xFF00897B).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isPembimbing
              ? AppColors.primary.withValues(alpha: 0.2)
              : const Color(0xFF00897B).withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        role,
        style: AppTheme.caption.copyWith(
          color: isPembimbing ? AppColors.primary : const Color(0xFF00897B),
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ── Action Link ───────────────────────────────────────────────────────────

class _ActionLink extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onTap;

  const _ActionLink({
    required this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: AppColors.textPrimary),
            ],
          ],
        ),
      ),
    );
  }
}
