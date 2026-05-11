import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class SidangBerlangsungScreen extends StatefulWidget {
  const SidangBerlangsungScreen({super.key});

  @override
  State<SidangBerlangsungScreen> createState() => _SidangBerlangsungScreenState();
}

class _SidangBerlangsungScreenState extends State<SidangBerlangsungScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> _ongoingSessions = [
    {
      'mahasiswa': 'Budi Santoso',
      'nim': '202011001',
      'ruangan': 'Ruang Sidang 1 (Lantai 2)',
      'waktuMulai': '08:30',
      'estimasiSelesai': '10:30',
      'tahap': 'Presentasi Mahasiswa',
      'progress': 0.45,
    },
    {
      'mahasiswa': 'Anisa Maharani',
      'nim': '202011002',
      'ruangan': 'Ruang Sidang 2 (Lantai 2)',
      'waktuMulai': '09:00',
      'estimasiSelesai': '11:00',
      'tahap': 'Tanya Jawab Penguji 1',
      'progress': 0.65,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sidang Berlangsung'),
        actions: [
          Row(
            children: [
              FadeTransition(
                opacity: _pulseController,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text('LIVE', style: AppTheme.labelMedium.copyWith(color: AppColors.error)),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: _ongoingSessions.isEmpty 
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy_rounded, size: 64, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text('Tidak ada sidang berlangsung saat ini', style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _ongoingSessions.length,
            itemBuilder: (context, index) {
              final session = _ongoingSessions[index];
              return _buildSessionCard(session);
            },
          ),
    );
  }

  Widget _buildSessionCard(Map<String, dynamic> session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
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
                          Text(session['mahasiswa'], style: AppTheme.labelMedium),
                          Text(session['nim'], style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        'ONGOING',
                        style: AppTheme.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Expanded(child: Text(session['ruangan'], style: AppTheme.bodySmall)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 16, color: AppColors.textTertiary),
                    const SizedBox(width: 8),
                    Text('${session['waktuMulai']} - ${session['estimasiSelesai']}', style: AppTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tahap Sekarang:', style: AppTheme.caption),
                    Text(session['tahap'], style: AppTheme.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: session['progress'],
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.videocam_outlined, size: 18),
                  label: const Text('Pantau CCTV'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Detail'),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
