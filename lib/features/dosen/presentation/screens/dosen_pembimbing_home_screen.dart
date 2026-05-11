import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class DosenPembimbingHomeScreen extends StatelessWidget {
  const DosenPembimbingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Pembimbing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selamat datang,', style: AppTheme.bodyMedium),
            Text('Dr. Budi Santoso', style: AppTheme.headingLarge),
            const SizedBox(height: 24),

            // Stats Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: AppTheme.borderRadiusLarge,
                boxShadow: AppTheme.shadowMedium,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kapasitas Bimbingan',
                          style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '4',
                              style: AppTheme.headingLarge.copyWith(color: Colors.white, fontSize: 36),
                            ),
                            Text(
                              ' / 6',
                              style: AppTheme.bodyLarge.copyWith(color: Colors.white70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.groups, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mahasiswa Aktif', style: AppTheme.headingMedium),
                TextButton(
                  onPressed: () => context.push('/dosen-pembimbing/mahasiswa'),
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Mini list
            _buildStudentCard('Andi Wijaya', '202011001', 'Revisi Bab 3'),
            const SizedBox(height: 12),
            _buildStudentCard('Siti Aminah', '202011002', 'Menunggu Sidang'),
            const SizedBox(height: 12),
            _buildStudentCard('Budi Doremi', '202011003', 'Penyusunan Bab 1'),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(String name, String nim, String status) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryContainer,
            child: Text(name[0], style: TextStyle(color: AppColors.onPrimaryContainer)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTheme.labelMedium),
                Text(nim, style: AppTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: AppTheme.caption.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
