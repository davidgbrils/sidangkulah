import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class RevisionItem {
  final String description;
  final String pengujiName;
  bool isDone;

  RevisionItem({required this.description, required this.pengujiName, this.isDone = false});
}

class RevisiSidangScreen extends StatefulWidget {
  const RevisiSidangScreen({super.key});

  @override
  State<RevisiSidangScreen> createState() => _RevisiSidangScreenState();
}

class _RevisiSidangScreenState extends State<RevisiSidangScreen> {
  final List<RevisionItem> _revisions = [
    RevisionItem(
      description: 'Perbaiki latar belakang masalah agar lebih tajam dan sesuai dengan rumusan masalah.',
      pengujiName: 'Dr. Rina Wati',
      isDone: true,
    ),
    RevisionItem(
      description: 'Tambahkan referensi jurnal internasional minimal 5 tahun terakhir di Bab 2.',
      pengujiName: 'Dr. Rina Wati',
    ),
    RevisionItem(
      description: 'Metodologi penelitian harus menjelaskan alasan pemilihan algoritma secara detail.',
      pengujiName: 'Prof. Hasanuddin',
    ),
  ];

  int get _completedCount => _revisions.where((r) => r.isDone).length;
  double get _progress => _revisions.isEmpty ? 0 : _completedCount / _revisions.length;

  Future<void> _submitRevisi() async {
    if (_completedCount < _revisions.length) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Anda belum menyelesaikan semua poin revisi.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Revisi berhasil disubmit untuk diverifikasi!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Revisi Sidang'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Header
          Container(
            padding: const EdgeInsets.all(24),
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progres Revisi',
                      style: AppTheme.headingSmall.copyWith(color: Colors.white),
                    ),
                    Text(
                      '$_completedCount / ${_revisions.length} Selesai',
                      style: AppTheme.labelMedium.copyWith(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Batas waktu: 20 Oktober 2026',
                  style: AppTheme.caption.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: _revisions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final item = _revisions[index];
                return _buildRevisionCard(item);
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
              label: 'Submit Revisi',
              type: SidangkuButtonType.primary,
              onTap: _completedCount == _revisions.length ? _submitRevisi : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevisionCard(RevisionItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppTheme.borderRadiusLarge,
        border: Border.all(
          color: item.isDone ? AppColors.success : AppColors.border,
          width: item.isDone ? 2 : 1,
        ),
        boxShadow: AppTheme.shadowSmall,
      ),
      child: CheckboxListTile(
        value: item.isDone,
        activeColor: AppColors.success,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onChanged: (val) {
          setState(() {
            item.isDone = val ?? false;
          });
        },
        title: Text(
          item.description,
          style: AppTheme.bodyMedium.copyWith(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
            color: item.isDone ? AppColors.textTertiary : AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              Icon(Icons.person, size: 14, color: AppColors.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Penguji: ${item.pengujiName}',
                style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
