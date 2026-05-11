import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/bottom_nav_bar.dart';

class OperatorStatsModel {
  final int totalMahasiswa;
  final int jadwalHariIni;
  final int menungguApproval;
  final int berkasReview;

  const OperatorStatsModel({
    this.totalMahasiswa = 0,
    this.jadwalHariIni = 0,
    this.menungguApproval = 0,
    this.berkasReview = 0,
  });
}

class ActivityLogModel {
  final String aksi;
  final String timestamp;
  final IconData icon;
  final Color iconColor;

  const ActivityLogModel({
    required this.aksi,
    required this.timestamp,
    required this.icon,
    required this.iconColor,
  });
}

class OperatorHomeScreen extends StatefulWidget {
  const OperatorHomeScreen({super.key});

  @override
  State<OperatorHomeScreen> createState() => _OperatorHomeScreenState();
}

class _OperatorHomeScreenState extends State<OperatorHomeScreen> {
  int _currentNavIndex = 0;

  final OperatorStatsModel _stats = const OperatorStatsModel(
    totalMahasiswa: 42,
    jadwalHariIni: 5,
    menungguApproval: 3,
    berkasReview: 7,
  );

  final List<ActivityLogModel> _activities = const [
    ActivityLogModel(
      aksi: 'Jadwal Sidang #A23 diperbarui',
      timestamp: '2 jam yang lalu',
      icon: Icons.schedule_rounded,
      iconColor: AppColors.primary,
    ),
    ActivityLogModel(
      aksi: 'SK Sidang Periode II selesai',
      timestamp: '5 jam yang lalu',
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.success,
    ),
    ActivityLogModel(
      aksi: 'Import Excel mahasiswa berhasil',
      timestamp: '1 hari yang lalu',
      icon: Icons.upload_file_rounded,
      iconColor: AppColors.tertiary,
    ),
    ActivityLogModel(
      aksi: 'Request ganti penguji dari Dr. Ahmad',
      timestamp: '1 hari yang lalu',
      icon: Icons.swap_horiz_rounded,
      iconColor: AppColors.warning,
    ),
    ActivityLogModel(
      aksi: 'Data dosen Dr. Siti Aminah diupdate',
      timestamp: '2 hari yang lalu',
      icon: Icons.person_rounded,
      iconColor: Colors.purple,
    ),
  ];

  String get _todayLabel =>
      DateFormat("EEEE, d MMMM yyyy", 'id_ID').format(DateTime.now());

  void _handleBottomNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/operator');
        break;
      case 1:
        context.go('/operator/jadwal');
        break;
      case 2:
        context.go('/operator/mahasiswa');
        break;
      case 3:
        context.go('/operator/approval-ganti-penguji');
        break;
      case 4:
        context.go('/operator/rekap-honor');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsSection(),
                  const SizedBox(height: 20),
                  if (_stats.menungguApproval > 0) ...[
                    _buildAlertBanner(),
                    const SizedBox(height: 24),
                  ],
                  _buildSectionHeader('Aksi Cepat'),
                  const SizedBox(height: 12),
                  _buildActionGrid(),
                  const SizedBox(height: 24),
                  _buildSectionHeader('Aktivitas Terkini'),
                  const SizedBox(height: 12),
                  _buildActivityList(),
                ]),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 160,
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: Text('Op',
              style: AppTheme.labelMedium.copyWith(
                  color: AppColors.textOnPrimary,
                  fontWeight: FontWeight.w700)),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded,
                    color: AppColors.textPrimary, size: 28),
                onPressed: () => context.push('/notifikasi'),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2)),
                ),
              ),
            ],
          ),
        ),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          // Hitung progres scroll (0.0 = collapsed, 1.0 = fully expanded)
          final double expandedHeight = 160.0;
          final double collapsedHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
          final double t = ((constraints.maxHeight - collapsedHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

          return FlexibleSpaceBar(
            centerTitle: true,
            title: Opacity(
              opacity: (1.0 - (t * 2.0)).clamp(0.0, 1.0), // Muncul hanya saat collapsed
              child: Text(
                'Dashboard',
                style: AppTheme.headingMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            background: Container(
              color: AppColors.surface,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(AppTheme.spacing16, AppTheme.spacing12, AppTheme.spacing16, 0),
                  child: Opacity(
                    opacity: (t * 1.5 - 0.5).clamp(0.0, 1.0), // Hilang saat collapsed
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppTheme.spacing12),
                        Text(
                          'SidangKu',
                          style: AppTheme.headingLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          'Dashboard Operator',
                          style: AppTheme.headingSmall.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary),
                        ),
                        const SizedBox(height: AppTheme.spacing4),
                        Text(
                          _todayLabel,
                          style: AppTheme.caption.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsSection() {
    final items = [
      _StatCard(
          label: 'Total Mahasiswa',
          value: '${_stats.totalMahasiswa}',
          sub: 'FTEN',
          subIcon: Icons.groups_rounded,
          accentColor: AppColors.warning),
      _StatCard(
          label: 'Jadwal Hari Ini',
          value: '${_stats.jadwalHariIni}',
          sub: 'Aktif',
          subIcon: Icons.schedule_rounded,
          accentColor: AppColors.warning),
      _StatCard(
          label: 'Menunggu Approval',
          value: '${_stats.menungguApproval}',
          sub: 'Request',
          subIcon: Icons.pending_rounded,
          accentColor: AppColors.error),
      _StatCard(
          label: 'Berkas Review',
          value: '${_stats.berkasReview}',
          sub: 'Dokumen',
          subIcon: Icons.folder_outlined,
          accentColor: AppColors.primary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Overview Statistik',
                style: AppTheme.bodyMedium
                    .copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text('Update: Today',
                style: AppTheme.caption
                    .copyWith(color: AppColors.textTertiary)),
          ],
        ),
        const SizedBox(height: AppTheme.spacing12),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppTheme.spacing12),
            itemBuilder: (_, i) => items[i],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBanner() {
    return GestureDetector(
      onTap: () => context.push('/operator/approval-ganti-penguji'),
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: AppTheme.borderRadiusLarge,
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 24),
            ),
            const SizedBox(width: AppTheme.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Persetujuan Penguji',
                      style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: AppTheme.spacing4),
                  Text(
                    '${_stats.menungguApproval} request perlu diproses',
                    style: AppTheme.bodySmall.copyWith(
                        color: AppColors.warning, height: 1.3, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Row(
                    children: [
                      Text('PROSES SEKARANG',
                          style: AppTheme.caption.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8)),
                      const SizedBox(width: AppTheme.spacing4),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 10, color: AppColors.warning),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid() {
    final actions = [
      _ActionItem(
        icon: Icons.add_box_outlined,
        label: 'Input Jadwal',
        bgColor: AppColors.warningLight,
        iconColor: AppColors.warning,
        onTap: () => context.push('/operator/jadwal'),
      ),
      _ActionItem(
        icon: Icons.upload_file_outlined,
        label: 'Import Excel',
        bgColor: AppColors.warningLight,
        iconColor: AppColors.warning,
        onTap: () => context.push('/operator/import-excel'),
      ),
      _ActionItem(
        icon: Icons.manage_accounts_outlined,
        label: 'Kelola Mahasiswa',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () => context.push('/operator/mahasiswa'),
      ),
      _ActionItem(
        icon: Icons.badge_outlined,
        label: 'Kelola Dosen',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () => context.push('/operator/dosen'),
      ),
      _ActionItem(
        icon: Icons.how_to_reg_outlined,
        label: 'Approval Penguji',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        badge: _stats.menungguApproval > 0 ? '${_stats.menungguApproval}' : null,
        onTap: () => context.push('/operator/approval-ganti-penguji'),
      ),
      _ActionItem(
        icon: Icons.description_outlined,
        label: 'Generate SK',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () => context.push('/operator/generate-sk'),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spacing12,
        mainAxisSpacing: AppTheme.spacing12,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (_, i) => _buildActionCard(actions[i]),
    );
  }

  Widget _buildActionCard(_ActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppTheme.borderRadiusLarge,
          border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
          boxShadow: AppTheme.shadowSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: AppTheme.borderRadiusMedium,
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 20),
                ),
                if (item.badge != null)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: AppColors.error, 
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 1.5)),
                      child: Text(item.badge!,
                          style: const TextStyle(
                              color: AppColors.textOnDark,
                              fontSize: 9,
                              fontWeight: FontWeight.w900)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              item.label,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                fontSize: 13,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activities.length,
        separatorBuilder: (_, __) =>
            const Divider(color: AppColors.divider, height: 1, indent: 64),
        itemBuilder: (_, i) => _buildActivityTile(_activities[i]),
      ),
    );
  }

  Widget _buildActivityTile(ActivityLogModel log) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: log.iconColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.borderRadiusMedium,
            ),
            child: Icon(log.icon, size: 20, color: log.iconColor),
          ),
          const SizedBox(width: AppTheme.spacing16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.aksi,
                    style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
                const SizedBox(height: AppTheme.spacing4),
                Text(log.timestamp,
                    style: AppTheme.caption
                        .copyWith(color: AppColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: AppTheme.bodyMedium
            .copyWith(fontWeight: FontWeight.w800, fontSize: 16));
  }

  Widget _buildBottomNav() {
    return BottomNavBar(
      currentIndex: _currentNavIndex,
      items: BottomNavBar.operatorItems,
      onTap: _handleBottomNavTap,
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final IconData subIcon;
  final Color accentColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.subIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(AppTheme.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.borderRadiusMedium,
        border: Border(left: BorderSide(color: accentColor, width: 4)),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTheme.caption.copyWith(
                  color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text(value,
              style: AppTheme.headingLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  fontSize: 28)),
          const SizedBox(height: AppTheme.spacing4),
          Row(
            children: [
              Icon(subIcon, size: 14, color: accentColor),
              const SizedBox(width: AppTheme.spacing4),
              Expanded(
                child: Text(sub,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTheme.caption.copyWith(
                        color: accentColor, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final String? badge;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    this.badge,
    this.onTap,
  });
}
