import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class KaprodiStatsModel {
  final int totalMahasiswaSidang;
  final int lulus;
  final int revis;
  final int tidakLulus;
  final double presentaseLulus;
  final String semester;

  const KaprodiStatsModel({
    required this.totalMahasiswaSidang,
    required this.lulus,
    required this.revis,
    required this.tidakLulus,
    required this.presentaseLulus,
    required this.semester,
  });
}

class QuickLinkModel {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const QuickLinkModel({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class KaprodiHomeScreen extends StatefulWidget {
  const KaprodiHomeScreen({super.key});

  @override
  State<KaprodiHomeScreen> createState() => _KaprodiHomeScreenState();
}

class _KaprodiHomeScreenState extends State<KaprodiHomeScreen> {
  int _currentNavIndex = 0;

  final _stats = const KaprodiStatsModel(
    totalMahasiswaSidang: 156,
    lulus: 138,
    revis: 15,
    tidakLulus: 3,
    presentaseLulus: 89.0,
    semester: 'Ganjil 2024/2025',
  );

  final _quickLinks = const [
    QuickLinkModel(
      icon: Icons.calendar_month_rounded,
      label: 'Lihat Semua Jadwal',
    ),
    QuickLinkModel(
      icon: Icons.analytics_rounded,
      label: 'Rekap Nilai',
    ),
    QuickLinkModel(
      icon: Icons.payments_rounded,
      label: 'Rekap Honor',
    ),
    QuickLinkModel(
      icon: Icons.description_rounded,
      label: 'Laporan Sidang',
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
                  _buildWelcomeSection(),
                  const SizedBox(height: 16),
                  _buildStatsGrid(),
                  const SizedBox(height: 20),
                  _buildAlertSection(),
                  const SizedBox(height: 24),
                  _buildQuickLinksSection(),
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
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Kaprodi Dashboard',
                      style: AppTheme.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
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

  Widget _buildWelcomeSection() {
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
          Text(
            'Selamat Datang,',
            style: AppTheme.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dr. Academic Leader',
            style: AppTheme.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white.withValues(alpha: 0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _stats.semester,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.expand_more_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        _StatCard(
          label: 'Mahasiswa Sidang',
          value: '${_stats.totalMahasiswaSidang}',
          subValue: 'Total Periode Ini',
          color: AppColors.primary,
        ),
        _StatCard(
          label: 'Lulus',
          value: '${_stats.lulus}',
          subValue: '${_stats.presentaseLulus.toStringAsFixed(0)}% Mahasiswa',
          color: AppColors.success,
        ),
        _StatCard(
          label: 'Revisi',
          value: '${_stats.revis}',
          subValue: '${((_stats.revis / _stats.totalMahasiswaSidang) * 100).toStringAsFixed(1)}% Total',
          color: AppColors.warning,
        ),
        _StatCard(
          label: 'Tidak Lulus',
          value: '${_stats.tidakLulus}',
          subValue: '${((_stats.tidakLulus / _stats.totalMahasiswaSidang) * 100).toStringAsFixed(1)}% Tingkat',
          color: AppColors.error,
        ),
      ],
    );
  }

  Widget _buildAlertSection() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pending_actions_rounded,
                color: AppColors.warning,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5 Approval Menunggu',
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE65100),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Request ganti penguji sidang',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warning.withValues(alpha: 0.6),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Akses Cepat',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        ..._quickLinks.map((link) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _QuickLinkCard(
                icon: link.icon,
                label: link.label,
                onTap: link.onTap,
              ),
            )),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      _BottomNavData(Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard'),
      _BottomNavData(Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Jadwal'),
      _BottomNavData(Icons.verified_user_rounded, Icons.verified_user_outlined, 'Approval'),
      _BottomNavData(Icons.analytics_rounded, Icons.analytics_outlined, 'Rekap'),
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
                          fontSize: 10,
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

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subValue;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subValue,
    required this.color,
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: AppColors.textSecondary,
            ),
            maxLines: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTheme.headingMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                subValue,
                style: AppTheme.caption.copyWith(
                  color: color.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _QuickLinkCard({
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
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
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

class _BottomNavData {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavData(this.icon, this.activeIcon, this.label);
}