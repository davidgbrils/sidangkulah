import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class JadwalSidangItem {
  final String namaMahasiswa;
  final String nim;
  final String judul;
  final String tanggal;
  final String waktu;
  final String ruangan;

  JadwalSidangItem({
    required this.namaMahasiswa,
    required this.nim,
    required this.judul,
    required this.tanggal,
    required this.waktu,
    required this.ruangan,
  });
}

class JadwalSidangScreen extends StatefulWidget {
  final String role; // 'mahasiswa', 'dosen', 'operator'

  const JadwalSidangScreen({super.key, required this.role});

  @override
  State<JadwalSidangScreen> createState() => _JadwalSidangScreenState();
}

class _JadwalSidangScreenState extends State<JadwalSidangScreen> {
  final List<JadwalSidangItem> _jadwalList = [
    JadwalSidangItem(
      namaMahasiswa: 'Budi Setiawan',
      nim: '123456789',
      judul: 'Pengembangan Sistem Informasi Geografis Pemetaan Lahan Pertanian',
      tanggal: 'Senin, 20 Oktober 2026',
      waktu: '09:00 - 10:30',
      ruangan: 'Ruang Sidang 1 (Gedung A)',
    ),
    JadwalSidangItem(
      namaMahasiswa: 'Andi Saputra',
      nim: '987654321',
      judul: 'Analisis Sentimen Pengguna Twitter terhadap Pemilu Menggunakan Naive Bayes',
      tanggal: 'Selasa, 21 Oktober 2026',
      waktu: '13:00 - 14:30',
      ruangan: 'Ruang Sidang 2 (Gedung B)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Jadwal Sidang'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _jadwalList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: AppColors.textTertiary),
                  const SizedBox(height: 16),
                  Text('Belum ada jadwal sidang', style: AppTheme.bodyMedium),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _jadwalList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _jadwalList[index];
                return _buildJadwalCard(item);
              },
            ),
    );
  }

  Widget _buildJadwalCard(JadwalSidangItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(color: AppColors.borderLight),
        boxShadow: AppTheme.shadowSmall,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.tanggal,
                  style: AppTheme.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.access_time_rounded, size: 14, color: AppColors.textTertiary),
                  const SizedBox(width: 4),
                  Text(item.waktu, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(item.namaMahasiswa, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          Text(item.nim, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(item.judul, style: AppTheme.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on_rounded, size: 16, color: AppColors.error),
              const SizedBox(width: 8),
              Text(item.ruangan, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}
