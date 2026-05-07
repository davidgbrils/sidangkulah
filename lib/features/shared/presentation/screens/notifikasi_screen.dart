import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

enum NotifikasiType { jadwal, berkas, nilai, sistem }

class NotifikasiModel {
  final String id;
  final NotifikasiType type;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final String? payload;

  const NotifikasiModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.payload,
  });

  NotifikasiModel copyWith({bool? isRead}) {
    return NotifikasiModel(
      id: id,
      type: type,
      title: title,
      body: body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt,
      payload: payload,
    );
  }
}

class NotifikasiNotifier extends ChangeNotifier {
  List<NotifikasiModel> _notifikasi = [];
  NotifikasiType? _filter;
  bool _isLoading = true;
  bool _isMarkingRead = false;

  List<NotifikasiModel> get notifikasi => _filter == null ? _notifikasi : _notifikasi.where((n) => n.type == _filter).toList();
  NotifikasiType? get filter => _filter;
  bool get isLoading => _isLoading;
  bool get isMarkingRead => _isMarkingRead;
  int get unreadCount => _notifikasi.where((n) => !n.isRead).length;

  Future<void> loadNotifikasi() async {
    setState(() => _isLoading = true);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      _notifikasi = [
        NotifikasiModel(id: '1', type: NotifikasiType.jadwal, title: 'Jadwal Sidang Berubah', body: 'Jadwal sidang Anda telah berpindah dari 15 Januari ke 20 Januari 2025', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 2)), payload: '/mahasiswa/jadwal'),
        NotifikasiModel(id: '2', type: NotifikasiType.berkas, title: 'Berkas Diterima', body: 'Berkas "Lembar Persetujuan" telah diverifikasi dan diterima oleh pembimbing', isRead: false, createdAt: DateTime.now().subtract(const Duration(hours: 5)), payload: '/mahasiswa/berkas'),
        NotifikasiModel(id: '3', type: NotifikasiType.nilai, title: 'Nilai Tersedia', body: 'Nilai hasil sidang skripsi Anda telah diinput oleh penguji', isRead: false, createdAt: DateTime.now().subtract(const Duration(days: 1)), payload: '/mahasiswa/nilai'),
        NotifikasiModel(id: '4', type: NotifikasiType.sistem, title: 'Pengumuman', body: 'periode pendaftaran sidang skripsi semester ganjil 2024/2025 telah dibuka', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 3)), payload: null),
        NotifikasiModel(id: '5', type: NotifikasiType.berkas, title: 'Berkas Ditolak', body: 'Berkas "Transkrip Nilai" perlu perbaikan. Silakan upload ulang.', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 4)), payload: '/mahasiswa/berkas'),
        NotifikasiModel(id: '6', type: NotifikasiType.jadwal, title: 'Penguji Diganti', body: 'Penguji utama Anda diganti ke dosen lain karena kesibukan', isRead: true, createdAt: DateTime.now().subtract(const Duration(days: 5)), payload: '/mahasiswa/jadwal'),
      ];
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void setFilter(NotifikasiType? type) {
    _filter = type;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    if (_isMarkingRead) return;
    setState(() => _isMarkingRead = true);
    try {
      final index = _notifikasi.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifikasi[index] = _notifikasi[index].copyWith(isRead: true);
        notifyListeners();
      }
    } finally {
      setState(() => _isMarkingRead = false);
    }
  }

  Future<void> markAllAsRead() async {
    setState(() => _isMarkingRead = true);
    try {
      _notifikasi = _notifikasi.map((n) => n.copyWith(isRead: true)).toList();
      notifyListeners();
    } finally {
      setState(() => _isMarkingRead = false);
    }
  }

  void onTap(NotifikasiModel notif) {
    markAsRead(notif.id);
    if (notif.payload != null) {
      context.push(notif.payload!);
    }
  }

  void setState(VoidCallback fn) {
    fn();
    notifyListeners();
  }

  BuildContext get context => navigatorKey.currentContext!;
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final notifier = NotifikasiNotifier();

  @override
  void initState() {
    super.initState();
    notifier.loadNotifikasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Notifikasi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => notifier.markAllAsRead(),
            child: Text('Tandai Semua Dibaca', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, _) {
          if (notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _buildFilterChips(),
              Expanded(child: _buildList()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    final chips = [
      {'label': 'Semua', 'type': null},
      {'label': 'Jadwal', 'type': NotifikasiType.jadwal},
      {'label': 'Berkas', 'type': NotifikasiType.berkas},
      {'label': 'Nilai', 'type': NotifikasiType.nilai},
      {'label': 'Sistem', 'type': NotifikasiType.sistem},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: chips.map((c) {
            final isSelected = notifier.filter == c['type'];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(c['label'] as String),
                selected: isSelected,
                onSelected: (_) => notifier.setFilter(c['type'] as NotifikasiType?),
                selectedColor: AppColors.primary.withValues(alpha: 0.1),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(color: isSelected ? AppColors.primary : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList() {
    if (notifier.notifikasi.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.textTertiary),
            const SizedBox(height: 16),
            Text('Tidak ada notifikasi', style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: notifier.notifikasi.length,
      itemBuilder: (context, index) {
        final notif = notifier.notifikasi[index];
        return _NotifikasiTile(notif: notif, onTap: () => notifier.onTap(notif));
      },
    );
  }

  @override
  void setState(VoidCallback fn) {}
}

class _NotifikasiTile extends StatelessWidget {
  final NotifikasiModel notif;
  final VoidCallback onTap;

  const _NotifikasiTile({required this.notif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: notif.isRead ? Colors.white : const Color(0xFFEFF5FF),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: notif.isRead ? AppColors.borderLight : AppColors.primary.withValues(alpha: 0.2))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: _getTypeColor().withValues(alpha: 0.1),
                      child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 20),
                    ),
                    if (!notif.isRead)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notif.title, style: AppTheme.bodySmall.copyWith(fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(notif.body, style: AppTheme.caption.copyWith(color: AppColors.textSecondary), maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 6),
                      Text(_formatTimeAgo(notif.createdAt), style: AppTheme.caption.copyWith(color: AppColors.textTertiary, fontSize: 10)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (notif.type) {
      case NotifikasiType.jadwal:
        return Icons.schedule_rounded;
      case NotifikasiType.berkas:
        return notif.title.contains('Diterima') ? Icons.check_circle_rounded : Icons.cancel_rounded;
      case NotifikasiType.nilai:
        return Icons.star_rounded;
      case NotifikasiType.sistem:
        return Icons.info_rounded;
    }
  }

  Color _getTypeColor() {
    switch (notif.type) {
      case NotifikasiType.jadwal:
        return Colors.orange;
      case NotifikasiType.berkas:
        return notif.title.contains('Diterima') ? AppColors.success : AppColors.error;
      case NotifikasiType.nilai:
        return Colors.amber;
      case NotifikasiType.sistem:
        return AppColors.textTertiary;
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inHours < 24) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}