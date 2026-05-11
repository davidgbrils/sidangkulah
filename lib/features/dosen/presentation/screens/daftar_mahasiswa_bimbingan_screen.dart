import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class DaftarMahasiswaBimbinganScreen extends StatelessWidget {
  const DaftarMahasiswaBimbinganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mahasiswa Bimbingan'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Capacity Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: AppColors.primaryContainer.withValues(alpha: 0.1),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Kapasitas Bimbingan: 4 dari maksimal 6 Mahasiswa',
                    style: AppTheme.labelMedium.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: 4,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _buildFullStudentCard(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullStudentCard(int index) {
    final titles = [
      'Analisis Performa Jaringan Menggunakan Machine Learning',
      'Sistem Pakar Diagnosa Penyakit Tanaman',
      'Pengembangan Aplikasi Mobile untuk E-Commerce',
      'Implementasi Blockchain pada Rantai Pasok',
    ];
    
    final statuses = [
      'Revisi Bab 3',
      'Menunggu Sidang',
      'Penyusunan Bab 1',
      'Lulus',
    ];
    
    final dates = [
      '12 Okt 2026',
      '01 Sep 2026',
      '15 Nov 2026',
      '10 Jul 2026',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primaryContainer,
                child: Text('M${index + 1}', style: TextStyle(color: AppColors.onPrimaryContainer)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mahasiswa ${index + 1}', style: AppTheme.labelMedium),
                    Text('20201100${index + 1}', style: AppTheme.bodySmall),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statuses[index] == 'Lulus' ? AppColors.success.withValues(alpha: 0.1) : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statuses[index],
                  style: AppTheme.caption.copyWith(
                    color: statuses[index] == 'Lulus' ? AppColors.success : AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 12),
          Text('Judul Skripsi:', style: AppTheme.caption),
          const SizedBox(height: 4),
          Text(
            titles[index],
            style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 6),
              Text(
                'Mulai bimbingan: ${dates[index]}',
                style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
