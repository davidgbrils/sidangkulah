import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/section_header.dart';

class DosenStatsModel {
  final int totalMahasiswa;
  final int sudahDinilai;
  final int belumDinilai;
  final int sidangHariIni;

  const DosenStatsModel({
    required this.totalMahasiswa,
    required this.sudahDinilai,
    required this.belumDinilai,
    required this.sidangHariIni,
  });
}

class JadwalSingkatModel {
  final String id;
  final String namaMahasiswa;
  final String bulan;
  final String tanggal;
  final String waktu;

  const JadwalSingkatModel({
    required this.id,
    required this.namaMahasiswa,
    required this.bulan,
    required this.tanggal,
    required this.waktu,
  });
}

class DosenHomeScreen extends StatefulWidget {
  const DosenHomeScreen({super.key});

  @override
  State<DosenHomeScreen> createState() => _DosenHomeScreenState();
}

class _DosenHomeScreenState extends State<DosenHomeScreen> {
  int _currentNavIndex = 0;

  final _stats = const DosenStatsModel(
    totalMahasiswa: 5,
    sudahDinilai: 3,
    belumDinilai: 2,
    sidangHariIni: 1,
  );

  final _jadwalList = const [
    JadwalSingkatModel(
      id: '1',
      namaMahasiswa: 'Budi Setiawan',
      bulan: 'OKT',
      tanggal: '20',
      waktu: '09:00 WIB',
    ),
    JadwalSingkatModel(
      id: '2',
      namaMahasiswa: 'Siti Aminah',
      bulan: 'OKT',
      tanggal: '21',
      waktu: '13:00 WIB',
    ),
    JadwalSingkatModel(
      id: '3',
      namaMahasiswa: 'Irfan Hakim',
      bulan: 'OKT',
      tanggal: '22',
      waktu: '10:30 WIB',
    ),
  ];

  void _handleBottomNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/dosen');
        break;
      case 1:
        context.go('/dosen/mahasiswa');
        break;
      case 2:
        context.go('/dosen/jadwal');
        break;
      case 3:
        context.go('/dosen/formulir');
        break;
      case 4:
        context.go('/dosen/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildProfileSection(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 28),
                  _buildQuickAccessSection(),
                  const SizedBox(height: 28),
                  _buildJadwalSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      floating: false,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      title: const Text('Beranda'),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 2,
                      ),
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo,',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        Text(
                          'Dosen Penguji',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.push('/notifikasi'),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.1),
                    ),
                    icon: const Icon(
                      Icons.notifications_outlined,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dr. Ahmad',
          style: AppTheme.headingLarge.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.tertiary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_rounded,
                size: 16,
                color: AppColors.tertiary,
              ),
              const SizedBox(width: 6),
              Text(
                'Dosen Penguji & Pembimbing',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final statsData = [
      _StatItem(
        label: 'Jumlah\nMahasiswa',
        value: '${_stats.totalMahasiswa}',
        color: AppColors.tertiary,
      ),
      _StatItem(
        label: 'Sudah Dinilai',
        value: '${_stats.sudahDinilai} / ${_stats.totalMahasiswa}',
        color: AppColors.success,
      ),
      _StatItem(
        label: 'Belum Dinilai',
        value: '${_stats.belumDinilai}',
        color: AppColors.error,
      ),
      _StatItem(
        label: 'Sidang\nHari Ini',
        value: '${_stats.sidangHariIni}',
        color: AppColors.tertiary,
      ),
    ];

    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: statsData.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = statsData[index];
          return _buildStatCard(item);
        },
      ),
    );
  }

  Widget _buildStatCard(_StatItem item) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            item.label,
            style: AppTheme.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            maxLines: 2,
          ),
          Text(
            item.value,
            style: AppTheme.headingMedium.copyWith(
              color: item.color,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
          children: [
            _QuickAccessCard(
              icon: Icons.people_outline_rounded,
              label: 'Daftar Mahasiswa',
              color: AppColors.tertiary,
              onTap: () => context.push('/dosen/mahasiswa'),
            ),
            _QuickAccessCard(
              icon: Icons.edit_note_rounded,
              label: 'Input Nilai',
              color: AppColors.success,
              onTap: () => context.push('/dosen/input-nilai/1'),
            ),
            _QuickAccessCard(
              icon: Icons.calendar_month_rounded,
              label: 'Jadwal Sidang',
              color: AppColors.info,
              onTap: () => context.push('/dosen/jadwal'),
            ),
            _QuickAccessCard(
              icon: Icons.description_rounded,
              label: 'Formulir &\nDokumen',
              color: AppColors.warning,
              onTap: () => context.push('/dosen/formulir'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJadwalSection() {
    return Column(
      children: [
        SectionHeader(
          title: 'Sidang Mendatang',
          actionLabel: 'Lihat Semua',
          onAction: () => context.push('/dosen/jadwal'),
        ),
        const SizedBox(height: 8),
        ..._jadwalList.map((jadwal) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _JadwalMiniCard(jadwal: jadwal),
            )),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      _BottomNavData(Icons.home_outlined, Icons.home_rounded, 'Home'),
      _BottomNavData(Icons.people_outline_rounded, Icons.people_rounded, 'Mahasiswa'),
      _BottomNavData(Icons.calendar_today_outlined, Icons.calendar_today_rounded, 'Jadwal'),
      _BottomNavData(Icons.description_outlined, Icons.description_rounded, 'Formulir'),
      _BottomNavData(Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = i == _currentNavIndex;

              return InkWell(
                onTap: () => _handleBottomNavTap(i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.tertiary.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.activeIcon : item.icon,
                        size: 24,
                        color: isSelected
                            ? AppColors.tertiary
                            : AppColors.textTertiary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? AppColors.tertiary
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.color,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JadwalMiniCard extends StatelessWidget {
  final JadwalSingkatModel jadwal;

  const _JadwalMiniCard({required this.jadwal});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.push('/dosen/mahasiswa/${jadwal.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.tertiary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      jadwal.bulan,
                      style: AppTheme.caption.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Text(
                      jadwal.tanggal,
                      style: AppTheme.headingMedium.copyWith(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jadwal.namaMahasiswa,
                      style: AppTheme.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          jadwal.waktu,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
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
        ),
      ),
    );
  }
}

class _StatItem {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });
}

class _BottomNavData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavData(this.icon, this.activeIcon, this.label);
}
