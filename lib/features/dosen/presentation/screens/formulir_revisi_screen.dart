import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class RevisionVerificationItem {
  final String description;
  bool isVerified;

  RevisionVerificationItem({required this.description, this.isVerified = false});
}

class FormulirRevisiScreen extends StatefulWidget {
  final String mahasiswaId;

  const FormulirRevisiScreen({super.key, required this.mahasiswaId});

  @override
  State<FormulirRevisiScreen> createState() => _FormulirRevisiScreenState();
}

class _FormulirRevisiScreenState extends State<FormulirRevisiScreen> {
  final String _namaMahasiswa = 'Budi Setiawan';
  final String _nim = '123456789';

  final List<RevisionVerificationItem> _revisions = [
    RevisionVerificationItem(description: 'Perbaiki latar belakang masalah agar lebih tajam dan sesuai dengan rumusan masalah.'),
    RevisionVerificationItem(description: 'Tambahkan referensi jurnal internasional minimal 5 tahun terakhir di Bab 2.'),
  ];

  int get _verifiedCount => _revisions.where((r) => r.isVerified).length;

  Future<void> _submitVerification() async {
    if (_verifiedCount < _revisions.length) {
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Peringatan'),
          content: const Text('Masih ada poin revisi yang belum diverifikasi. Lanjutkan submit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Lanjutkan'),
            ),
          ],
        ),
      );
      if (confirm != true) return;
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Status revisi berhasil disimpan.'),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Verifikasi Revisi'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryContainer,
                  child: Text(_namaMahasiswa[0], style: TextStyle(color: AppColors.onPrimaryContainer)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_namaMahasiswa, style: AppTheme.headingSmall),
                      Text(_nim, style: AppTheme.bodySmall.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$_verifiedCount / ${_revisions.length} Tervrifikasi',
                    style: AppTheme.caption.copyWith(color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _revisions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _revisions[index];
                return _buildVerificationCard(item);
              },
            ),
          ),

          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SidangkuButton(
              label: 'Simpan Verifikasi',
              type: SidangkuButtonType.primary,
              onTap: _submitVerification,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCard(RevisionVerificationItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: item.isVerified ? AppColors.success : AppColors.borderLight,
        ),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          item.description,
          style: AppTheme.bodyMedium,
        ),
        trailing: IconButton(
          icon: Icon(
            item.isVerified ? Icons.check_circle : Icons.check_circle_outline,
            color: item.isVerified ? AppColors.success : AppColors.border,
            size: 32,
          ),
          onPressed: () {
            setState(() {
              item.isVerified = !item.isVerified;
            });
          },
        ),
      ),
    );
  }
}
