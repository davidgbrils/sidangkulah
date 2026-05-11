import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:sidangkufix/core/widgets/sidangku_text_field.dart';

class GantiPengujiScreen extends StatefulWidget {
  const GantiPengujiScreen({super.key});

  @override
  State<GantiPengujiScreen> createState() => _GantiPengujiScreenState();
}

class _GantiPengujiScreenState extends State<GantiPengujiScreen> {
  final _reasonController = TextEditingController();
  String? _selectedMahasiswa;
  String? _selectedPengujiLama;
  
  final List<Map<String, dynamic>> _mySessions = [
    {
      'id': 's1',
      'mahasiswa': 'Budi Santoso (202011001)',
      'pengujiLama': 'Dr. Ir. Heru Setiawan, M.T.',
    },
    {
      'id': 's2',
      'mahasiswa': 'Anisa Maharani (202011002)',
      'pengujiLama': 'Dr. Siti Aminah, M.Kom.',
    },
  ];

  void _handleSubmit() {
    if (_selectedMahasiswa == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mohon pilih mahasiswa dan isi alasan penggantian')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Permintaan ganti penguji telah dikirim ke Kaprodi.'),
        backgroundColor: AppColors.success,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ganti Penguji'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Permintaan penggantian penguji harus disetujui oleh Kaprodi.',
                      style: AppTheme.bodySmall.copyWith(color: Colors.orange[800]),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text('Pilih Mahasiswa', style: AppTheme.labelMedium),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppTheme.borderRadiusMedium,
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedMahasiswa,
                  isExpanded: true,
                  hint: Text('Pilih Sesi Sidang', style: AppTheme.bodyMedium.copyWith(color: AppColors.textTertiary)),
                  items: _mySessions.map((s) => DropdownMenuItem(
                    value: s['id'] as String,
                    child: Text(s['mahasiswa'] as String, style: AppTheme.bodyMedium),
                  )).toList(),
                  onChanged: (v) {
                    setState(() {
                      _selectedMahasiswa = v;
                      _selectedPengujiLama = _mySessions.firstWhere((s) => s['id'] == v)['pengujiLama'] as String;
                    });
                  },
                ),
              ),
            ),
            if (_selectedPengujiLama != null) ...[
              const SizedBox(height: 24),
              Text('Penguji Sekarang', style: AppTheme.labelMedium),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppTheme.borderRadiusMedium,
                ),
                child: Text(_selectedPengujiLama!, style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ),
            ],
            const SizedBox(height: 24),
            SidangkuTextField(
              label: 'Alasan Penggantian',
              hint: 'Tuliskan alasan lengkap (misal: berhalangan hadir, tugas luar kota, dll)',
              controller: _reasonController,
              maxLines: 4,
            ),
            const SizedBox(height: 40),
            SidangkuButton(
              label: 'Kirim Permintaan',
              onTap: _handleSubmit,
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text('Batal', style: TextStyle(color: AppColors.textTertiary)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
