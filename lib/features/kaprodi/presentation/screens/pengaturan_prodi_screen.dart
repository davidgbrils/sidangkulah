import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:sidangkufix/core/widgets/sidangku_text_field.dart';

class PengaturanProdiScreen extends ConsumerStatefulWidget {
  const PengaturanProdiScreen({super.key});

  @override
  ConsumerState<PengaturanProdiScreen> createState() => _PengaturanProdiScreenState();
}

class _PengaturanProdiScreenState extends ConsumerState<PengaturanProdiScreen> {
  final _batasBimbinganController = TextEditingController(text: '6');
  
  String _selectedSemester = 'Ganjil 2026/2027';
  String _selectedUploadDeadline = '14 Hari sebelum Sidang';
  String _selectedRevisionDuration = '7 Hari setelah Sidang';

  bool _notifyWA = true;
  bool _notifyEmail = true;

  bool _isLoading = false;

  @override
  void dispose() {
    _batasBimbinganController.dispose();
    super.dispose();
  }

  void _incrementBatas() {
    int current = int.tryParse(_batasBimbinganController.text) ?? 0;
    _batasBimbinganController.text = (current + 1).toString();
  }

  void _decrementBatas() {
    int current = int.tryParse(_batasBimbinganController.text) ?? 0;
    if (current > 1) {
      _batasBimbinganController.text = (current - 1).toString();
    }
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    // Mock API Call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan berhasil disimpan.'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Prodi'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pengaturan Sistem',
              style: AppTheme.headingLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Atur batasan dan konfigurasi global untuk sistem manajemen sidang.',
              style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 32),

            // Batas Bimbingan
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadiusLarge,
                border: Border.all(color: AppColors.border),
                boxShadow: AppTheme.shadowSmall,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Batas Maksimal Bimbingan', style: AppTheme.headingSmall),
                  const SizedBox(height: 4),
                  Text(
                    'Jumlah maksimal mahasiswa per dosen pembimbing.',
                    style: AppTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: _decrementBatas,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SidangkuTextField(
                          controller: _batasBimbinganController,
                          keyboardType: TextInputType.number,
                          label: '', // No label needed here
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _incrementBatas,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Dropdowns
            Text('Periode & Jadwal', style: AppTheme.headingMedium),
            const SizedBox(height: 16),
            _buildDropdown(
              'Semester Aktif',
              _selectedSemester,
              ['Ganjil 2026/2027', 'Genap 2026/2027', 'Pendek 2026'],
              (val) => setState(() => _selectedSemester = val!),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Batas Upload Berkas',
              _selectedUploadDeadline,
              ['7 Hari sebelum Sidang', '14 Hari sebelum Sidang', '30 Hari sebelum Sidang'],
              (val) => setState(() => _selectedUploadDeadline = val!),
            ),
            const SizedBox(height: 16),
            _buildDropdown(
              'Durasi Revisi',
              _selectedRevisionDuration,
              ['3 Hari setelah Sidang', '7 Hari setelah Sidang', '14 Hari setelah Sidang'],
              (val) => setState(() => _selectedRevisionDuration = val!),
            ),
            const SizedBox(height: 32),

            // Notifikasi
            Text('Notifikasi Otomatis', style: AppTheme.headingMedium),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Notifikasi WhatsApp'),
                    subtitle: const Text('Kirim pesan otomatis via WhatsApp Bot.'),
                    value: _notifyWA,
                    onChanged: (val) => setState(() => _notifyWA = val),
                    activeTrackColor: AppColors.primary,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Notifikasi Email'),
                    subtitle: const Text('Kirim pemberitahuan resmi via Email.'),
                    value: _notifyEmail,
                    onChanged: (val) => setState(() => _notifyEmail = val),
                    activeTrackColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            SidangkuButton(
              label: 'Simpan Pengaturan',
              type: SidangkuButtonType.primary,
              isLoading: _isLoading,
              onTap: _handleSave,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelMedium),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: AppTheme.borderRadiusMedium,
            border: Border.all(color: AppColors.border),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: value,
              items: items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
