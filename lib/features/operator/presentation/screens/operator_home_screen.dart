import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatsSection(),
                const SizedBox(height: 16),
                if (_stats.menungguApproval > 0) ...[
                  _buildAlertBanner(),
                  const SizedBox(height: 20),
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
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 100,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.primary,
          child: const Text('Op',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13)),
        ),
      ),
      title: const Text('SidangKu',
          style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 20)),
      actions: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: AppColors.textSecondary, size: 26),
              onPressed: () {},
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: AppColors.error, shape: BoxShape.circle),
              ),
            ),
          ],
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(16, 70, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard Operator — FTEN',
                  style: AppTheme.headingSmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontSize: 16)),
              const SizedBox(height: 2),
              Text(_todayLabel,
                  style: AppTheme.caption
                      .copyWith(color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    final items = [
      _StatCard(
          label: 'Total\nMahasiswa',
          value: '${_stats.totalMahasiswa}',
          sub: 'FTEN',
          subIcon: Icons.groups_rounded,
          accentColor: AppColors.warning),
      _StatCard(
          label: 'Jadwal Hari\nIni',
          value: '${_stats.jadwalHariIni}',
          sub: 'Aktif',
          subIcon: Icons.schedule_rounded,
          accentColor: AppColors.warning),
      _StatCard(
          label: 'Menunggu\nApproval',
          value: '${_stats.menungguApproval}',
          sub: 'Request',
          subIcon: Icons.pending_rounded,
          accentColor: AppColors.error),
      _StatCard(
          label: 'Berkas\nReview',
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
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) => items[i],
          ),
        ),
      ],
    );
  }

  Widget _buildAlertBanner() {
    return GestureDetector(
      onTap: () => context.push('/operator/approval'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.warningLight,
          borderRadius: BorderRadius.circular(12),
          border: const Border(
            left: BorderSide(color: AppColors.warning, width: 4),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded,
                  color: AppColors.warning, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Persetujuan Penguji',
                      style: AppTheme.bodySmall.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE65100))),
                  const SizedBox(height: 2),
                  Text(
                    '${_stats.menungguApproval} request pergantian penguji menunggu persetujuan',
                    style: AppTheme.caption.copyWith(
                        color: const Color(0xFFF57C00), height: 1.4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text('PROSES SEKARANG',
                          style: AppTheme.caption.copyWith(
                              color: const Color(0xFFE65100),
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded,
                          size: 14, color: Color(0xFFE65100)),
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
        label: 'Input Jadwal\nSidang',
        bgColor: AppColors.warningLight,
        iconColor: AppColors.warning,
        onTap: () => context.push('/operator/jadwal/tambah'),
      ),
      _ActionItem(
        icon: Icons.upload_file_outlined,
        label: 'Import Excel',
        bgColor: AppColors.warningLight,
        iconColor: AppColors.warning,
        onTap: () {},
      ),
      _ActionItem(
        icon: Icons.manage_accounts_outlined,
        label: 'Kelola Data\nMahasiswa',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () => context.push('/operator/mahasiswa'),
      ),
      _ActionItem(
        icon: Icons.badge_outlined,
        label: 'Kelola Data\nDosen',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () => context.push('/operator/dosen'),
      ),
      _ActionItem(
        icon: Icons.how_to_reg_outlined,
        label: 'Approval\nPenguji',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        badge: _stats.menungguApproval > 0 ? '${_stats.menungguApproval}' : null,
        onTap: () => context.push('/operator/approval'),
      ),
      _ActionItem(
        icon: Icons.description_outlined,
        label: 'Generate SK',
        bgColor: AppColors.surfaceContainerLow,
        iconColor: AppColors.primary,
        onTap: () {},
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.15,
      ),
      itemBuilder: (_, i) => _buildActionCard(actions[i]),
    );
  }

  Widget _buildActionCard(_ActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.bgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item.icon, color: item.iconColor, size: 22),
                ),
                if (item.badge != null)
                  Positioned(
                    top: -6,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          color: AppColors.error, shape: BoxShape.circle),
                      child: Text(item.badge!,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              item.label,
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.4,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _activities.length,
        separatorBuilder: (_, __) =>
            Divider(color: AppColors.borderLight, height: 1, indent: 56),
        itemBuilder: (_, i) => _buildActivityTile(_activities[i]),
      ),
    );
  }

  Widget _buildActivityTile(ActivityLogModel log) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: log.iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(log.icon, size: 18, color: log.iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.aksi,
                    style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                const SizedBox(height: 2),
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
            .copyWith(fontWeight: FontWeight.w700, fontSize: 15));
  }

  Widget _buildBottomNav() {
    final items = [
      (Icons.dashboard_rounded, Icons.dashboard_outlined, 'Dashboard'),
      (Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Jadwal'),
      (Icons.storage_rounded, Icons.storage_outlined, 'Data'),
      (Icons.how_to_reg_rounded, Icons.how_to_reg_outlined, 'Approval'),
      (Icons.description_rounded, Icons.description_outlined, 'Dokumen'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderLight)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isActive = i == _currentNavIndex;
              final hasApprovalBadge =
                  i == 3 && _stats.menungguApproval > 0;

              return GestureDetector(
                onTap: () => setState(() => _currentNavIndex = i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isActive ? item.$1 : item.$2,
                            color: isActive
                                ? AppColors.warning
                                : AppColors.textTertiary,
                            size: 24,
                          ),
                          if (hasApprovalBadge)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(item.$3,
                          style: AppTheme.caption.copyWith(
                            fontSize: 10,
                            color: isActive
                                ? AppColors.warning
                                : AppColors.textTertiary,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                          )),
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
      width: 130,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: accentColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTheme.caption.copyWith(
                  color: AppColors.textSecondary, height: 1.3)),
          const Spacer(),
          Text(value,
              style: AppTheme.headingLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  fontSize: 28)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(subIcon, size: 13, color: accentColor),
              const SizedBox(width: 4),
              Text(sub,
                  style: AppTheme.caption.copyWith(
                      color: accentColor, fontWeight: FontWeight.w600)),
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