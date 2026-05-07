import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class MahasiswaHomeNotifier extends ChangeNotifier {
  String _nama = '';
  String _nim = '';
  String _prodi = '';
  String _judulSkripsi = '';
  String _statusBerkas = 'BELUM_LENGKAP';
  String? _jadwalSidang;
  String? _waktuSidang;
  String? _ruangan;
  String? _statusSidang;
  String _pembimbing1 = '';
  String _pembimbing2 = '';
  int _unreadCount = 0;
  bool _isLoading = true;

  String get nama => _nama;
  String get nim => _nim;
  String get prodi => _prodi;
  String get judulSkripsi => _judulSkripsi;
  String get statusBerkas => _statusBerkas;
  String? get jadwalSidang => _jadwalSidang;
  String? get waktuSidang => _waktuSidang;
  String? get ruangan => _ruangan;
  String? get statusSidang => _statusSidang;
  String get pembimbing1 => _pembimbing1;
  String get pembimbing2 => _pembimbing2;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  Future<void> loadData() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      _nama = prefs.getString('user_nama') ?? 'Mahasiswa';
      _nim = prefs.getString('user_id') ?? '202011001';
      
      _prodi = 'Teknik Informatika';
      _judulSkripsi = 'Analisis Sistem Keamanan Jaringan Menggunakan Metode Deep Learning pada IoT';
      _statusBerkas = 'LENGKAP';
      _jadwalSidang = '15 Januari 2025';
      _waktuSidang = '09:00 WIB';
      _ruangan = 'Ruang Sidang 1';
      _statusSidang = 'TERJADWAL';
      _pembimbing1 = 'Dr. Ir. Heru Setiawan, M.T.';
      _pembimbing2 = 'Dr. Siti Rahayu, M.Kom.';
      _unreadCount = 3;
    } catch (e) {
      debugPrint('Error loading mahasiswa data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setState(VoidCallback fn) {
    notifyListeners();
  }
}

class MahasiswaHomeScreen extends StatefulWidget {
  const MahasiswaHomeScreen({super.key});

  @override
  State<MahasiswaHomeScreen> createState() => _MahasiswaHomeScreenState();
}

class _MahasiswaHomeScreenState extends State<MahasiswaHomeScreen> {
  int _currentNavIndex = 0;
  final notifier = MahasiswaHomeNotifier();

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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
                      _buildJadwalSidangCard(),
                      const SizedBox(height: 16),
                      _buildStatsRow(),
                      const SizedBox(height: 16),
                      _buildTimDosenSection(),
                      const SizedBox(height: 24),
                      _buildQuickMenuGrid(),
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
      floating: false,
      expandedHeight: 120,
      backgroundColor: AppColors.primary,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      title: const Text('Beranda', style: TextStyle(color: Colors.white)),
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () => context.push('/notifikasi'),
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            ),
            if (notifier.unreadCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${notifier.unreadCount}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
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
                  Text(
                    'Selamat datang, ${notifier.nama}',
                    style: AppTheme.headingSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NIM: ${notifier.nim}',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
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

  Widget _buildJadwalSidangCard() {
    final hasJadwal = notifier.jadwalSidang != null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: hasJadwal ? AppColors.primaryGradient : null,
        color: hasJadwal ? null : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: hasJadwal
            ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))]
            : [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: hasJadwal
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Jadwal Sidang', style: AppTheme.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.8))),
                    _buildStatusChip(notifier.statusSidang ?? 'TERJADWAL'),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(notifier.jadwalSidang!, style: AppTheme.headingMedium.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text(notifier.waktuSidang!, style: AppTheme.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(Icons.location_on_rounded, color: Colors.white.withValues(alpha: 0.8), size: 20),
                        const SizedBox(height: 4),
                        Text(notifier.ruangan ?? '-', style: AppTheme.bodySmall.copyWith(color: Colors.white)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => context.push('/mahasiswa/jadwal'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Lihat Detail', style: AppTheme.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Icon(Icons.calendar_today_rounded, size: 48, color: AppColors.textTertiary),
                const SizedBox(height: 12),
                Text('Belum ada jadwal sidang', style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary)),
                const SizedBox(height: 8),
                Text('Silakan lengkapi persyaratan terlebih dahulu', style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
              ],
            ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color bgColor;
    Color textColor;
    switch (status) {
      case 'TERJADWAL':
        bgColor = AppColors.primary;
        textColor = Colors.white;
        break;
      case 'MENUNGGU':
        bgColor = AppColors.warning;
        textColor = Colors.white;
        break;
      case 'SELESAI':
        bgColor = AppColors.success;
        textColor = Colors.white;
        break;
      default:
        bgColor = AppColors.textTertiary;
        textColor = Colors.white;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: AppTheme.caption.copyWith(color: textColor, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(child: _buildInfoCard('Status Berkas', notifier.statusBerkas, Icons.verified_user_rounded, AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: _buildInfoCard('Status Nilai', 'BELUM', Icons.lock_rounded, AppColors.textTertiary)),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.borderLight)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                Text(value, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimDosenSection() {
    final dosen = [
      {'nama': notifier.pembimbing1, 'role': 'Pembimbing 1'},
      {'nama': notifier.pembimbing2, 'role': 'Pembimbing 2'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tim Dosen', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 50,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: dosen.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final d = dosen[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      child: Text(d['nama']![0], style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(d['nama']!, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500)),
                        Text(d['role']!, style: AppTheme.caption.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickMenuGrid() {
    final menuItems = [
      {'icon': Icons.calendar_month_rounded, 'label': 'Jadwal Sidang', 'route': '/mahasiswa/jadwal'},
      {'icon': Icons.upload_file_rounded, 'label': 'Upload Berkas', 'route': '/mahasiswa/berkas'},
      {'icon': Icons.grade_rounded, 'label': 'Nilai', 'route': '/mahasiswa/nilai'},
      {'icon': Icons.notifications_rounded, 'label': 'Notifikasi', 'route': '/notifikasi'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Menu Utama', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.4),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final menu = menuItems[index];
            return _buildMenuCard(menu['icon'] as IconData, menu['label'] as String, menu['route'] as String);
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard(IconData icon, String label, String route) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => context.push(route),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.borderLight)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              const Spacer(),
              Text(label, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final items = [
      {'icon': Icons.home_rounded, 'activeIcon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.calendar_month_outlined, 'activeIcon': Icons.calendar_month_rounded, 'label': 'Jadwal'},
      {'icon': Icons.description_outlined, 'activeIcon': Icons.description_rounded, 'label': 'Berkas'},
      {'icon': Icons.grade_outlined, 'activeIcon': Icons.grade_rounded, 'label': 'Nilai'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person_rounded, 'label': 'Profil'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 16, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isSelected = i == _currentNavIndex;
              return InkWell(
                onTap: () => _handleBottomNavTap(i),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(isSelected ? item['activeIcon'] as IconData : item['icon'] as IconData, size: 24, color: isSelected ? AppColors.primary : AppColors.textTertiary),
                      const SizedBox(height: 4),
                      Text(item['label'] as String, style: TextStyle(fontSize: 11, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? AppColors.primary : AppColors.textTertiary)),
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

  void _handleBottomNavTap(int index) {
    setState(() => _currentNavIndex = index);
    switch (index) {
      case 0:
        context.go('/mahasiswa');
        break;
      case 1:
        context.go('/mahasiswa/jadwal');
        break;
      case 2:
        context.go('/mahasiswa/berkas');
        break;
      case 3:
        context.go('/mahasiswa/nilai');
        break;
      case 4:
        context.go('/mahasiswa/profil');
        break;
    }
  }
}