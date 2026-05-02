import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class RekapNilaiModel {
  final String id;
  final String nim;
  final String nama;
  final double nilai;
  final String grade;
  final String status;
  final DateTime? tanggalSidang;

  const RekapNilaiModel({
    required this.id,
    required this.nim,
    required this.nama,
    required this.nilai,
    required this.grade,
    required this.status,
    this.tanggalSidang,
  });
}

class KaprodiRekapNilaiNotifier extends ChangeNotifier {
  List<RekapNilaiModel> _data = [];
  String _searchQuery = '';
  String _sortColumn = 'nama';
  bool _sortAsc = true;
  int _currentPage = 0;
  final _pageSize = 20;
  bool _isLoading = true;
  bool _isExporting = false;

  List<RekapNilaiModel> get filteredData {
    var list = _data.where((d) => d.nama.toLowerCase().contains(_searchQuery.toLowerCase()) || d.nim.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    list.sort((a, b) {
      final cmp = a.nama.compareTo(b.nama);
      return _sortAsc ? cmp : -cmp;
    });
    return list;
  }

  List<RekapNilaiModel> get paginatedData {
    final start = _currentPage * _pageSize;
    final end = (start + _pageSize > filteredData.length) ? filteredData.length : start + _pageSize;
    return filteredData.sublist(start.clamp(0, filteredData.length), end);
  }

  int get totalPages => (filteredData.length / _pageSize).ceil();
  String get searchQuery => _searchQuery;
  int get currentPage => _currentPage;
  bool get isLoading => _isLoading;
  bool get isExporting => _isExporting;

  double get rataRata => _data.isEmpty ? 0 : _data.fold<double>(0, (sum, d) => sum + d.nilai) / _data.length;
  double get tertinggi => _data.isEmpty ? 0 : _data.map((d) => d.nilai).reduce((a, b) => a > b ? a : b);
  double get terendah => _data.isEmpty ? 0 : _data.map((d) => d.nilai).reduce((a, b) => a < b ? a : b);

  Map<String, int> get gradeDist {
    final dist = <String, int>{};
    for (final d in _data) {
      dist[d.grade] = (dist[d.grade] ?? 0) + 1;
    }
    return dist;
  }

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _data = List.generate(
        50,
        (i) => RekapNilaiModel(
          id: '${i + 1}',
          nim: '20201100${i + 1}',
          nama: 'Mahasiswa ${i + 1}',
          nilai: 70 + (i % 30).toDouble(),
          grade: _getGrade(70 + (i % 30).toDouble()),
          status: i % 10 == 0 ? 'REVISI' : 'LULUS',
        ),
      );
    } catch (e) {
      debugPrint('Error loading rekap nilai: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _getGrade(double nilai) {
    if (nilai >= 85) return 'A';
    if (nilai >= 80) return 'A-';
    if (nilai >= 75) return 'B+';
    if (nilai >= 70) return 'B';
    if (nilai >= 65) return 'B-';
    return 'C';
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _currentPage = 0;
    notifyListeners();
  }

  void setSort(String column) {
    if (_sortColumn == column) {
      _sortAsc = !_sortAsc;
    } else {
      _sortColumn = column;
      _sortAsc = true;
    }
    notifyListeners();
  }

  void setPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  Future<void> exportExcel() async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    setState(() => _isExporting = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Berhasil mengekspor Excel'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> exportPdf() async {
    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    setState(() => _isExporting = true);
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (ctx.mounted) {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            content: Text('Berhasil mengekspor PDF'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  void viewDetail(RekapNilaiModel data) {
    context.push('/kaprodi/nilai/${data.id}');
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  BuildContext get context => navigatorKey.currentContext!;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class KaprodiRekapNilaiScreen extends StatefulWidget {
  const KaprodiRekapNilaiScreen({super.key});

  @override
  State<KaprodiRekapNilaiScreen> createState() => _KaprodiRekapNilaiScreenState();
}

class _KaprodiRekapNilaiScreenState extends State<KaprodiRekapNilaiScreen> {
  final notifier = KaprodiRekapNilaiNotifier();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    notifier.loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
            title: const Text('Rekap Nilai Sidang'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () => notifier.exportPdf(),
                icon: const Icon(Icons.picture_as_pdf_rounded),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildFilterRow(),
              _buildStatsMiniRow(),
              _buildGradeDistBar(),
              Expanded(child: _buildDataTable()),
              _buildPagination(),
              _buildExportButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama atau NIM...',
                prefixIcon: const Icon(Icons.search, size: 20),
                filled: true,
                fillColor: AppColors.scaffoldBackground,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: notifier.setSearchQuery,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsMiniRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _buildMiniStatCard('Rata-rata', notifier.rataRata.toStringAsFixed(2), Icons.trending_up_rounded, AppColors.primary)),
          const SizedBox(width: 8),
          Expanded(child: _buildMiniStatCard('Tertinggi', notifier.tertinggi.toStringAsFixed(2), Icons.arrow_upward_rounded, AppColors.success)),
          const SizedBox(width: 8),
          Expanded(child: _buildMiniStatCard('Terendah', notifier.terendah.toStringAsFixed(2), Icons.arrow_downward_rounded, AppColors.error)),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w700, color: color)),
          Text(label, style: AppTheme.caption.copyWith(fontSize: 10, color: AppColors.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildGradeDistBar() {
    final dist = notifier.gradeDist;
    final total = dist.values.fold<int>(0, (sum, c) => sum + c);
    if (total == 0) return const SizedBox.shrink();

    final colors = {'A': AppColors.success, 'A-': const Color(0xFF90EE90), 'B+': AppColors.primary, 'B': const Color(0xFF87CEEB), 'B-': Colors.orange, 'C': AppColors.error};
    final grades = ['A', 'A-', 'B+', 'B', 'B-', 'C'];

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 20,
              child: Row(
                children: grades.where((g) => dist[g]! > 0).map((g) => Expanded(
                      flex: dist[g]!,
                      child: Container(color: colors[g]),
                    )).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: grades.where((g) => dist[g]! > 0).map((g) => Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: 12, height: 12, decoration: BoxDecoration(color: colors[g], borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 4),
                    Text('$g: ${dist[g]}', style: AppTheme.caption.copyWith(fontSize: 11)),
                  ],
                )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    final data = notifier.paginatedData;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.scaffoldBackground),
          columns: [
            DataColumn(label: Text('No', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('NIM', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Nama', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Nilai', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Grade', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Status', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
            DataColumn(label: Text('Aksi', style: AppTheme.caption.copyWith(fontWeight: FontWeight.w600))),
          ],
          rows: data.asMap().entries.map((e) {
            final d = e.value;
            final i = e.key;
            final colors = {'A': AppColors.success, 'A-': const Color(0xFF90EE90), 'B+': AppColors.primary, 'B': const Color(0xFF87CEEB), 'B-': Colors.orange, 'C': AppColors.error};
            return DataRow(
              color: WidgetStateProperty.all(i.isEven ? Colors.white : AppColors.scaffoldBackground),
              cells: [
                DataCell(Text('${notifier.currentPage * 20 + i + 1}', style: AppTheme.bodySmall)),
                DataCell(Text(d.nim, style: AppTheme.bodySmall)),
                DataCell(Text(d.nama, style: AppTheme.bodySmall)),
                DataCell(Text(d.nilai.toStringAsFixed(2), style: AppTheme.bodySmall)),
                DataCell(Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: colors[d.grade]!.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                  child: Text(d.grade, style: AppTheme.caption.copyWith(color: colors[d.grade], fontWeight: FontWeight.w600)),
                )),
                DataCell(_buildStatusChip(d.status)),
                DataCell(IconButton(
                  icon: const Icon(Icons.visibility_rounded, size: 20),
                  color: AppColors.primary,
                  onPressed: () => notifier.viewDetail(d),
                )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = status == 'LULUS' ? AppColors.success : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(status, style: AppTheme.caption.copyWith(color: color, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPagination() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: notifier.currentPage > 0 ? () => notifier.setPage(notifier.currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppColors.primary,
          ),
          Text('Halaman ${notifier.currentPage + 1} dari ${notifier.totalPages}', style: AppTheme.bodySmall),
          IconButton(
            onPressed: notifier.currentPage < notifier.totalPages - 1 ? () => notifier.setPage(notifier.currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildExportButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: SidangkuButton(
              label: notifier.isExporting ? '' : 'Ekspor Excel',
              type: SidangkuButtonType.outlined,
              icon: Icons.table_chart_rounded,
              isLoading: notifier.isExporting,
              onTap: () => notifier.exportExcel(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SidangkuButton(
              label: 'Cetak PDF',
              type: SidangkuButtonType.outlined,
              icon: Icons.picture_as_pdf_rounded,
              onTap: () => notifier.exportPdf(),
            ),
          ),
        ],
      ),
    );
  }
}
