import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/bottom_nav_bar.dart';

class KaprodiStatsModel {
  final int totalSidang;
  final int lulus;
  final int revisi;
  final int tidakLulus;
  final int pengujiRequest;

  const KaprodiStatsModel({
    required this.totalSidang,
    required this.lulus,
    required this.revisi,
    required this.tidakLulus,
    this.pengujiRequest = 0,
  });

  double get presentaseLulus => totalSidang > 0 ? (lulus / totalSidang) * 100 : 0;
}

class SidangHariIni {
  final String waktu;
  final String nama;
  final String nim;
  final String ruangan;
  final String status;

  const SidangHariIni({required this.waktu, required this.nama, required this.nim, required this.ruangan, required this.status});
}

class GradeDist {
  final String grade;
  final int count;
  final Color color;

  const GradeDist({required this.grade, required this.count, required this.color});
}

class KaprodiHomeNotifier extends ChangeNotifier {
  KaprodiStatsModel? _stats;
  String _nama = '';
  final String _semester = 'Ganjil 2024/2025';
  List<GradeDist> _gradeDist = [];
  List<SidangHariIni> _sidangHariIni = [];
  bool _isLoading = true;

  KaprodiStatsModel? get stats => _stats;
  String get nama => _nama;
  String get semester => _semester;
  List<GradeDist> get gradeDist => _gradeDist;
  List<SidangHariIni> get sidangHariIni => _sidangHariIni;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _nama = prefs.getString('user_nama') ?? 'Dr. Ahmad Wijaya';

      _stats = const KaprodiStatsModel(totalSidang: 156, lulus: 138, revisi: 15, tidakLulus: 3, pengujiRequest: 5);
      _gradeDist = [
        const GradeDist(grade: 'A', count: 45, color: AppColors.success),
        const GradeDist(grade: 'A-', count: 38, color: Color(0xFF90EE90)),
        const GradeDist(grade: 'B+', count: 30, color: AppColors.primary),
        const GradeDist(grade: 'B', count: 25, color: Color(0xFF87CEEB)),
        const GradeDist(grade: 'C', count: 18, color: Colors.orange),
      ];
      _sidangHariIni = [
        const SidangHariIni(waktu: '08:00 - 10:00', nama: 'Budi Santoso', nim: '202011001', ruangan: 'Ruang Sidang 1', status: 'BERLANGSUNG'),
        const SidangHariIni(waktu: '10:00 - 12:00', nama: 'Siti Aminah', nim: '202011002', ruangan: 'Ruang Sidang 2', status: 'TERJADWAL'),
        const SidangHariIni(waktu: '13:00 - 15:00', nama: 'Ahmad Fauzi', nim: '202011003', ruangan: 'Ruang Sidang 1', status: 'TERJADWAL'),
      ];
    } catch (e) {
      debugPrint('Error loading kaprodi data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }
}

class KaprodiHomeScreen extends StatefulWidget {
  const KaprodiHomeScreen({super.key});

  @override
  State<KaprodiHomeScreen> createState() => _KaprodiHomeScreenState();
}

class _KaprodiHomeScreenState extends State<KaprodiHomeScreen> {
  int _currentNavIndex = 0;
  final notifier = KaprodiHomeNotifier();

  @override
  void initState() {
    super.initState();
    notifier.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        if (notifier.isLoading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

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
                      _buildExecutiveStats(),
                      const SizedBox(height: 16),
                      if (notifier.stats!.pengujiRequest > 0) ...[
                        _buildAlertCard(),
                        const SizedBox(height: 16),
                      ],
                      _buildGradeDistBar(),
                      const SizedBox(height: 24),
                      _buildQuickLinks(),
                      const SizedBox(height: 24),
                      _buildSidangHariIni(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildBottomNavBar(),
        );
      },
    );
  }

  SliverAppBar _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      title: Text('Dashboard Kaprodi', style: TextStyle(color: Colors.white, fontSize: 18)),
      actions: [
        Container(
          padding: const EdgeInsets.only(right: 16),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
              child: DropdownButton<String>(
                value: notifier.semester,
                dropdownColor: AppColors.primary,
                underline: const SizedBox(),
                icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20),
                items: ['Ganjil 2024/2025', 'Genap 2023/2024'].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(color: Colors.white, fontSize: 12)))).toList(),
                onChanged: (v) {},
              ),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.headerGradient),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(notifier.nama, style: AppTheme.headingSmall.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('Ketua Program Studi Informatika', style: AppTheme.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExecutiveStats() {
    final stats = notifier.stats!;
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard('Total Sidang', '${stats.totalSidang}', Icons.calendar_month_rounded, AppColors.primary),
        _buildStatCard('Lulus', '${stats.lulus} (${stats.presentaseLulus.toStringAsFixed(0)}%)', Icons.check_circle_rounded, AppColors.success),
        _buildStatCard('Revisi', '${stats.revisi}', Icons.build_rounded, Colors.orange),
        _buildStatCard('Tidak Lulus', '${stats.tidakLulus}', Icons.cancel_rounded, AppColors.error),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const Spacer(),
          Text(label, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 2),
          Text(value, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    final count = notifier.stats!.pengujiRequest;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.swap_horiz_rounded, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$count request ganti penguji', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600, color: Colors.orange)),
                Text('Menunggu persetujuan Anda', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/kaprodi/approval-penguji'),
            icon: const Icon(Icons.arrow_forward_rounded, color: Colors.orange),
          ),
        ],
      ),
    );
  }

  Widget _buildGradeDistBar() {
    final gradeDist = notifier.gradeDist;
    final total = gradeDist.fold<int>(0, (sum, g) => sum + g.count);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Distribusi Nilai', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 24,
              child: Row(
                children: gradeDist.map((g) => Expanded(
                  flex: g.count,
                  child: Container(color: g.color),
                )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: gradeDist.map((g) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 12, height: 12, decoration: BoxDecoration(color: g.color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Text('${g.grade}: ${g.count}', style: AppTheme.caption.copyWith(fontSize: 11)),
              ],
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLinks() {
    final menuItems = [
      {'icon': Icons.calendar_month_rounded, 'label': 'Jadwal Final', 'route': '/kaprodi/jadwal-final'},
      {'icon': Icons.grade_rounded, 'label': 'Rekap Nilai', 'route': '/kaprodi/rekap-nilai'},
      {'icon': Icons.payments_rounded, 'label': 'Rekap Honor', 'route': '/kaprodi/rekap-honor'},
      {'icon': Icons.assessment_rounded, 'label': 'Laporan', 'route': '/kaprodi/laporan-sidang'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Menu Utama', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.2),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final menu = menuItems[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: () => context.push(menu['route'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                        child: Icon(menu['icon'] as IconData, color: AppColors.primary, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(menu['label'] as String, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500))),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSidangHariIni() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Sidang Hari Ini', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        ...notifier.sidangHariIni.map((s) => _buildSidangCard(s)),
      ],
    );
  }

  Widget _buildSidangCard(SidangHariIni sidang) {
    Color statusColor;
    switch (sidang.status) {
      case 'BERLANGSUNG':
        statusColor = AppColors.success;
        break;
      case 'SELESAI':
        statusColor = AppColors.textTertiary;
        break;
      default:
        statusColor = AppColors.primary;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.schedule_rounded, color: statusColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sidang.waktu, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                Text('${sidang.nama} - ${sidang.nim}', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                Text(sidang.ruangan, style: AppTheme.caption.copyWith(color: AppColors.textTertiary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Text(sidang.status, style: AppTheme.caption.copyWith(color: statusColor, fontWeight: FontWeight.w600, fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavBar(
      currentIndex: _currentNavIndex,
      items: BottomNavBar.kaprodiItems,
      onTap: _handleBottomNavTap,
    );
  }

  void _handleBottomNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/kaprodi');
        break;
      case 1:
        context.go('/kaprodi/jadwal-final');
        break;
      case 2:
        context.go('/kaprodi/approval-penguji');
        break;
      case 3:
        context.go('/kaprodi/rekap-nilai');
        break;
      case 4:
        context.go('/kaprodi/profil');
        break;
    }
  }
}