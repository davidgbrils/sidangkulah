import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class MahasiswaStatsModel {
  final String nim;
  final String nama;
  final String judulSkripsi;
  final String statusBerkas;
  final String? jadwalSidang;
  final String? waktuSidang;
  final String? nilaiAkhir;
  final String namaPembimbing;

  const MahasiswaStatsModel({
    required this.nim,
    required this.nama,
    required this.judulSkripsi,
    required this.statusBerkas,
    this.jadwalSidang,
    this.waktuSidang,
    this.nilaiAkhir,
    required this.namaPembimbing,
  });
}

class MenuItemModel {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const MenuItemModel({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class MahasiswaHomeScreen extends StatefulWidget {
  const MahasiswaHomeScreen({super.key});

  @override
  State<MahasiswaHomeScreen> createState() => _MahasiswaHomeScreenState();
}

class _MahasiswaHomeScreenState extends State<MahasiswaHomeScreen> {
  int _currentNavIndex = 0;

  final _stats = const MahasiswaStatsModel(
    nim: '202011001',
    nama: 'Budi Santoso',
    judulSkripsi: 'Analisis Sistem Keamanan Jaringan Menggunakan...',
    statusBerkas: 'LENGKAP',
    jadwalSidang: '24 Jan 2024',
    waktuSidang: '10:00 WIB',
    nilaiAkhir: null,
    namaPembimbing: 'Dr. Ir. Heru Setiawan',
  );

  final _menuItems = const [
    MenuItemModel(
      icon: Icons.calendar_month_rounded,
      label: 'Jadwal Sidang',
    ),
    MenuItemModel(
      icon: Icons.upload_file_rounded,
      label: 'Upload Berkas',
    ),
    MenuItemModel(
      icon: Icons.grade_rounded,
      label: 'Nilai',
    ),
    MenuItemModel(
      icon: Icons.notifications_rounded,
      label: 'Notifikasi',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(),
                  const SizedBox(height: 16),
                  _buildQuickInfoGrid(),
                  const SizedBox(height: 24),
                  _buildMenuSection(),
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
      pinned: true,
      floating: false,
      expandedHeight: 60,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: const Text(''),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
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
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hi, ${_stats.nama}!',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          'Selamat datang, ${_stats.nama}',
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _stats.nama,
                      style: AppTheme.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'NIM: ${_stats.nim}',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'TERJADWAL',
                  style: AppTheme.caption.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 16),
          Text(
            'Judul Skripsi',
            style: AppTheme.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _stats.judulSkripsi,
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
      children: [
        _QuickInfoCard(
          icon: Icons.calendar_month_rounded,
          label: 'Jadwal Sidang',
          value: _stats.jadwalSidang ?? '-',
          subValue: _stats.waktuSidang ?? '',
          color: AppColors.primary,
        ),
        _QuickInfoCard(
          icon: Icons.verified_user_rounded,
          label: 'Status Berkas',
          value: _stats.statusBerkas,
          subValue: 'Telah Diverifikasi',
          color: AppColors.success,
        ),
        _QuickInfoCard(
          icon: Icons.lock_rounded,
          label: 'Nilai Akhir',
          value: _stats.nilaiAkhir ?? 'Terkunci',
          subValue: _stats.nilaiAkhir == null ? 'Belum Diproses' : '',
          color: AppColors.textTertiary,
        ),
        _QuickInfoCard(
          icon: Icons.person_search_rounded,
          label: 'Pembimbing',
          value: _stats.namaPembimbing,
          subValue: '',
          color: AppColors.primary,
          isSmallText: true,
        ),
      ],
    );
  }

  Widget _buildMenuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Menu Utama',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
          ),
          itemCount: _menuItems.length,
          itemBuilder: (context, index) {
            final item = _menuItems[index];
            return _MenuCard(
              icon: item.icon,
              label: item.label,
              onTap: item.onTap,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      _BottomNavData(Icons.home_rounded, Icons.home_outlined, 'Home'),
      _BottomNavData(Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Jadwal'),
      _BottomNavData(Icons.description_rounded, Icons.description_outlined, 'Berkas'),
      _BottomNavData(Icons.notifications_rounded, Icons.notifications_outlined, 'Notif'),
      _BottomNavData(Icons.person_rounded, Icons.person_outlined, 'Profil'),
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
                onTap: () => setState(() => _currentNavIndex = i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.1)
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
                            ? AppColors.primary
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
                              ? AppColors.primary
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

class _QuickInfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String subValue;
  final Color color;
  final bool isSmallText;

  const _QuickInfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.subValue,
    required this.color,
    this.isSmallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const Spacer(),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: AppTheme.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              fontSize: isSmallText ? 12 : 14,
            ),
            maxLines: isSmallText ? 2 : 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subValue.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              subValue,
              style: AppTheme.caption.copyWith(
                color: color,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _MenuCard({
    required this.icon,
    required this.label,
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const Spacer(),
              Text(
                label,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavData(this.icon, this.activeIcon, this.label);
}