import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class JadwalSidangModel {
  final String id;
  final String waktu;
  final String nama;
  final String nim;
  final String judul;
  final String ruangan;
  final String status;
  final List<DosenModel> dosen;

  const JadwalSidangModel({
    required this.id,
    required this.waktu,
    required this.nama,
    required this.nim,
    required this.judul,
    required this.ruangan,
    required this.status,
    required this.dosen,
  });
}

class DosenModel {
  final String nama;
  final String role;

  const DosenModel({required this.nama, required this.role});
}

class KaprodiJadwalNotifier extends ChangeNotifier {
  int _viewMode = 0;
  DateTime _selectedDay = DateTime.now();
  Map<String, List<JadwalSidangModel>> _jadwal = {};
  bool _isLoading = true;
  String? _filterDosen;
  String? _filterRuangan;
  String? _filterStatus;

  int get viewMode => _viewMode;
  DateTime get selectedDay => _selectedDay;
  List<JadwalSidangModel> get filteredJadwal => _getFilteredJadwal();
  bool get isLoading => _isLoading;
  String? get filterDosen => _filterDosen;
  String? get filterRuangan => _filterRuangan;
  String? get filterStatus => _filterStatus;

  List<JadwalSidangModel> _getFilteredJadwal() {
    var list = _jadwal[_formatDate(_selectedDay)] ?? [];
    if (_filterDosen != null) {
      list = list.where((j) => j.dosen.any((d) => d.nama.contains(_filterDosen!))).toList();
    }
    if (_filterRuangan != null) {
      list = list.where((j) => j.ruangan == _filterRuangan).toList();
    }
    if (_filterStatus != null) {
      list = list.where((j) => j.status == _filterStatus).toList();
    }
    return list;
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  Future<void> loadJadwal() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _jadwal = {
        '20/1/2025': [
          JadwalSidangModel(id: '1', waktu: '08:00 - 10:00', nama: 'Budi Santoso', nim: '202011001', judul: 'Analisis Sistem Keamanan Jaringan Menggunakan Deep Learning', ruangan: 'Ruang Sidang 1', status: 'SELESAI', dosen: [DosenModel(nama: 'Heru', role: 'P1'), DosenModel(nama: 'Siti', role: 'P2'), DosenModel(nama: 'Ahmad', role: 'Pen1'), DosenModel(nama: 'Irfan', role: 'Pen2')]),
          JadwalSidangModel(id: '2', waktu: '10:00 - 12:00', nama: 'Siti Aminah', nim: '202011002', judul: 'Implementasi IoT untuk Smart Home dengan Machine Learning', ruangan: 'Ruang Sidang 2', status: 'BERLANGSUNG', dosen: [DosenModel(nama: 'Heru', role: 'P1'), DosenModel(nama: 'Siti', role: 'P2'), DosenModel(nama: 'Ahmad', role: 'Pen1'), DosenModel(nama: 'Irfan', role: 'Pen2')]),
          JadwalSidangModel(id: '3', waktu: '13:00 - 15:00', nama: 'Ahmad Fauzi', nim: '202011003', judul: 'Sistema Pendeteksian Malware menggunakan CNN', ruangan: 'Ruang Sidang 1', status: 'TERJADWAL', dosen: [DosenModel(nama: 'Heru', role: 'P1'), DosenModel(nama: 'Siti', role: 'P2'), DosenModel(nama: 'Ahmad', role: 'Pen1'), DosenModel(nama: 'Irfan', role: 'Pen2')]),
        ],
        '21/1/2025': [
          JadwalSidangModel(id: '4', waktu: '08:00 - 10:00', nama: 'Diana Putri', nim: '202011004', judul: ' Sistem Informasi Akademik berbasis Web', ruangan: 'Ruang Sidang 1', status: 'TERJADWAL', dosen: [DosenModel(nama: 'Heru', role: 'P1'), DosenModel(nama: 'Siti', role: 'P2'), DosenModel(nama: 'Ahmad', role: 'Pen1'), DosenModel(nama: 'Irfan', role: 'Pen2')]),
        ],
        '22/1/2025': [],
      };
    } catch (e) {
      debugPrint('Error loading jadwal: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setViewMode(int mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setSelectedDay(DateTime day) {
    _selectedDay = day;
    notifyListeners();
  }

  void setFilter({String? dosen, String? ruangan, String? status}) {
    _filterDosen = dosen;
    _filterRuangan = ruangan;
    _filterStatus = status;
    notifyListeners();
  }

  void clearFilters() {
    _filterDosen = null;
    _filterRuangan = null;
    _filterStatus = null;
    notifyListeners();
  }

  Future<void> exportPdf() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mengekspor PDF...'), backgroundColor: AppColors.primary));
    await Future.delayed(const Duration(seconds: 2));
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  BuildContext get context => navigatorKey.currentContext!;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class KaprodiJadwalScreen extends StatefulWidget {
  const KaprodiJadwalScreen({super.key});

  @override
  State<KaprodiJadwalScreen> createState() => _KaprodiJadwalScreenState();
}

class _KaprodiJadwalScreenState extends State<KaprodiJadwalScreen> with SingleTickerProviderStateMixin {
  final notifier = KaprodiJadwalNotifier();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    notifier.loadJadwal();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
          appBar: AppBar(
            title: const Text('Jadwal Sidang Final'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => _showFilterSheet(),
                icon: const Icon(Icons.tune_rounded),
              ),
              IconButton(
                onPressed: () => notifier.exportPdf(),
                icon: const Icon(Icons.download_rounded),
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: Colors.white,
              onTap: (i) => notifier.setViewMode(i),
              tabs: const [Tab(text: 'List'), Tab(text: 'Kalender')],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [_buildListView(), _buildKalenderView()],
          ),
        );
      },
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filter', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            Text('Berdasarkan Dosen', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Heru', 'Siti', 'Ahmad', 'Irfan'].map((d) => ChoiceChip(label: Text(d), selected: notifier.filterDosen == d, onSelected: (_) => notifier.setFilter(dosen: d))).toList(),
            ),
            const SizedBox(height: 16),
            Text('Berdasarkan Ruangan', style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Ruang Sidang 1', 'Ruang Sidang 2'].map((r) => ChoiceChip(label: Text(r), selected: notifier.filterRuangan == r, onSelected: (_) => notifier.setFilter(ruangan: r))).toList(),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: SidangkuButton(label: 'Terapkan Filter', onTap: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    final jadwal = notifier.filteredJadwal;
    if (jadwal.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.event_busy_rounded, size: 64, color: AppColors.textTertiary), const SizedBox(height: 16), Text('Tidak ada jadwal', style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary))],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: jadwal.length,
      itemBuilder: (context, index) {
        final j = jadwal[index];
        return _buildJadwalCard(j);
      },
    );
  }

  Widget _buildJadwalCard(JadwalSidangModel jadwal) {
    Color statusColor;
    switch (jadwal.status) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(jadwal.waktu, style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary)),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(jadwal.status, style: AppTheme.caption.copyWith(color: statusColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('${jadwal.nama} - ${jadwal.nim}', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(jadwal.judul, style: AppTheme.caption.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(jadwal.ruangan, style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
              const Spacer(),
              ...jadwal.dosen.take(4).map((d) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(d.nama[0], style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKalenderView() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          child: _buildKalender(),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: notifier.filteredJadwal.length,
            itemBuilder: (context, index) => _buildJadwalCard(notifier.filteredJadwal[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildKalender() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        children: [
          Text('${_bulan[now.month - 1]} ${now.year}', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _hari.take(7).map((h) => Text(h, style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600, fontSize: 10))).toList(),
          ),
          const SizedBox(height: 8),
          ...List.generate(6, (week) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(7, (day) {
                  final dayNum = week * 7 + day - 2;
                  if (dayNum < 1 || dayNum > daysInMonth) return const SizedBox(width: 36, height: 36);
                  final isSelected = dayNum == notifier.selectedDay.day;
                  final hasEvent = _hasEventOnDay(dayNum);
                  return InkWell(
                    onTap: () => notifier.setSelectedDay(DateTime(now.year, now.month, dayNum)),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary : Colors.transparent,
                        shape: BoxShape.circle,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Text('$dayNum', style: TextStyle(color: isSelected ? Colors.white : AppColors.textPrimary, fontSize: 12)),
                          if (hasEvent)
                            Positioned(
                              bottom: 4,
                              child: Container(width: 6, height: 6, decoration: BoxDecoration(color: isSelected ? Colors.white : AppColors.primary, shape: BoxShape.circle)),
                            ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            );
          }),
        ],
      ),
    );
  }

  bool _hasEventOnDay(int day) {
    final key = '$day/${DateTime.now().month}/${DateTime.now().year}';
    return notifier._jadwal[key]?.isNotEmpty ?? false;
  }

  static const _bulan = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
  static const _hari = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
}