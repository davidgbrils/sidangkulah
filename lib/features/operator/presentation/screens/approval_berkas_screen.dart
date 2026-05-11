import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';

class BerkasMahasiswaItem {
  final String nama;
  final String nim;
  final String judul;
  final String status; // 'menunggu', 'disetujui', 'ditolak'

  BerkasMahasiswaItem({
    required this.nama,
    required this.nim,
    required this.judul,
    this.status = 'menunggu',
  });
}

class ApprovalBerkasScreen extends StatefulWidget {
  const ApprovalBerkasScreen({super.key});

  @override
  State<ApprovalBerkasScreen> createState() => _ApprovalBerkasScreenState();
}

class _ApprovalBerkasScreenState extends State<ApprovalBerkasScreen> {
  final List<BerkasMahasiswaItem> _berkasList = [
    BerkasMahasiswaItem(
      nama: 'Budi Setiawan',
      nim: '123456789',
      judul: 'Pengembangan Sistem Informasi Geografis Pemetaan Lahan Pertanian',
    ),
    BerkasMahasiswaItem(
      nama: 'Andi Saputra',
      nim: '987654321',
      judul: 'Analisis Sentimen Pengguna Twitter terhadap Pemilu Menggunakan Naive Bayes',
    ),
    BerkasMahasiswaItem(
      nama: 'Siti Aminah',
      nim: '112233445',
      judul: 'Aplikasi Mobile Deteksi Penyakit Daun Padi Menggunakan CNN',
    ),
  ];

  Future<void> _handleAction(int index, String action) async {
    if (action == 'reject') {
      final reasonController = TextEditingController();
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Tolak Berkas'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Masukkan alasan penolakan:'),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Alasan penolakan',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                if (reasonController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Alasan harus diisi!'), backgroundColor: AppColors.error),
                  );
                  return;
                }
                Navigator.pop(context, true);
              },
              child: const Text('Tolak', style: TextStyle(color: AppColors.error)),
            ),
          ],
        ),
      );

      if (confirm != true) return;
    }

    setState(() {
      _berkasList.removeAt(index);
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(action == 'approve' ? 'Berkas disetujui.' : 'Berkas ditolak.'),
        backgroundColor: action == 'approve' ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Approval Berkas'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: _berkasList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 64, color: AppColors.success.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text('Semua berkas telah diproses.', style: AppTheme.bodyMedium),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _berkasList.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _berkasList[index];
                return _buildBerkasCard(item, index);
              },
            ),
    );
  }

  Widget _buildBerkasCard(BerkasMahasiswaItem item, int index) {
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
              AvatarInitials(name: item.nama, size: 40, backgroundColor: AppColors.primaryLight),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.nama, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    Text(item.nim, style: AppTheme.caption.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.warningLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Menunggu',
                  style: AppTheme.caption.copyWith(color: AppColors.warning, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Judul Skripsi:',
            style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.textTertiary),
          ),
          const SizedBox(height: 4),
          Text(
            item.judul,
            style: AppTheme.bodySmall,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleAction(index, 'reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                  ),
                  child: const Text('Tolak'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleAction(index, 'approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Setujui'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
