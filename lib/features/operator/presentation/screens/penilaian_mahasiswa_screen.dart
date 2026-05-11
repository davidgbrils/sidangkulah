import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class PenilaianMahasiswaScreen extends StatefulWidget {
  const PenilaianMahasiswaScreen({super.key});

  @override
  State<PenilaianMahasiswaScreen> createState() => _PenilaianMahasiswaScreenState();
}

class _PenilaianMahasiswaScreenState extends State<PenilaianMahasiswaScreen> {
  final List<Map<String, dynamic>> _dataNilai = [
    {
      'nama': 'Budi Santoso',
      'nim': '202011001',
      'judul': 'Analisis Jaringan IoT menggunakan Machine Learning',
      'pembimbing': 85.5,
      'penguji1': 82.0,
      'penguji2': 88.0,
      'status': 'VERIFIED',
    },
    {
      'nama': 'Siti Aminah',
      'nim': '202011002',
      'judul': 'Sistem Pakar Diagnosa Penyakit Tanaman Padi',
      'pembimbing': 90.0,
      'penguji1': 88.0,
      'penguji2': 92.0,
      'status': 'WAITING',
    },
    {
      'nama': 'Ahmad Fauzi',
      'nim': '202011003',
      'judul': 'Pengembangan Aplikasi E-Learning Berbasis Web',
      'pembimbing': 78.0,
      'penguji1': 75.0,
      'penguji2': 80.0,
      'status': 'WAITING',
    },
  ];

  double _calculateAverage(Map<String, dynamic> item) {
    return (item['pembimbing'] + item['penguji1'] + item['penguji2']) / 3;
  }

  String _getGrade(double score) {
    if (score >= 85) return 'A';
    if (score >= 80) return 'A-';
    if (score >= 75) return 'B+';
    if (score >= 70) return 'B';
    return 'C';
  }

  void _handlePublish(int index) {
    setState(() {
      _dataNilai[index]['status'] = 'PUBLISHED';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nilai ${_dataNilai[index]['nama']} telah dipublikasikan.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian Mahasiswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.primary.withValues(alpha: 0.05),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryItem('Total Mahasiswa', '${_dataNilai.length}', Icons.people_outline),
                ),
                Expanded(
                  child: _buildSummaryItem('Belum Publish', '${_dataNilai.where((e) => e['status'] != 'PUBLISHED').length}', Icons.pending_actions),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: _dataNilai.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
                final item = _dataNilai[index];
                final avg = _calculateAverage(item);
                
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['nama'], style: AppTheme.labelMedium),
                                Text(item['nim'], style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          _buildStatusBadge(item['status']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildScoreDetail('Pembimbing', item['pembimbing']),
                          _buildScoreDetail('Penguji 1', item['penguji1']),
                          _buildScoreDetail('Penguji 2', item['penguji2']),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nilai Akhir:', style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Text(avg.toStringAsFixed(2), style: AppTheme.headingSmall.copyWith(color: AppColors.primary)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(_getGrade(avg), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (item['status'] != 'PUBLISHED')
                        SidangkuButton(
                          label: 'Publikasikan Nilai',
                          onTap: () => _handlePublish(index),
                          height: 40,
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
            Text(value, style: AppTheme.labelMedium.copyWith(color: AppColors.primary)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label;
    
    switch (status) {
      case 'PUBLISHED':
        color = AppColors.success;
        label = 'Terbit';
        break;
      case 'VERIFIED':
        color = AppColors.primary;
        label = 'Terverifikasi';
        break;
      default:
        color = Colors.orange;
        label = 'Pending';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: AppTheme.caption.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildScoreDetail(String label, double score) {
    return Column(
      children: [
        Text(label, style: AppTheme.caption.copyWith(color: AppColors.textTertiary)),
        const SizedBox(height: 4),
        Text(score.toString(), style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
