import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:file_picker/file_picker.dart';

class BerkasSidangScreen extends StatefulWidget {
  const BerkasSidangScreen({super.key});

  @override
  State<BerkasSidangScreen> createState() => _BerkasSidangScreenState();
}

class _BerkasSidangScreenState extends State<BerkasSidangScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  String? _selectedFileName;
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'zip'],
    );

    if (result != null) {
      setState(() {
        _selectedFileName = result.files.single.name;
      });
    }
  }

  Future<void> _uploadFile() async {
    if (_selectedFileName == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    // Mock upload progress
    for (int i = 1; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      setState(() {
        _uploadProgress = i / 10;
      });
    }

    setState(() {
      _isUploading = false;
      _selectedFileName = null; // Clear after upload
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Berkas berhasil diunggah!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Switch back to status tab to see update
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berkas Sidang'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textTertiary,
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Status Pengajuan'),
            Tab(text: 'Upload Berkas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildUploadTab(),
        ],
      ),
    );
  }

  Widget _buildStatusTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Progres Pengajuan', style: AppTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            'Pantau status pengajuan sidang Anda saat ini.',
            style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          
          _buildStep(
            step: '1',
            title: 'Persetujuan Pembimbing',
            description: 'Telah disetujui oleh Dr. Budi Santoso',
            isCompleted: true,
            isActive: false,
          ),
          _buildStepLine(isCompleted: true),
          
          _buildStep(
            step: '2',
            title: 'Validasi Kaprodi',
            description: 'Sedang menunggu persetujuan Kaprodi',
            isCompleted: false,
            isActive: true,
          ),
          _buildStepLine(isCompleted: false),
          
          _buildStep(
            step: '3',
            title: 'Penjadwalan Sidang',
            description: 'Belum dijadwalkan oleh Operator',
            isCompleted: false,
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildStep({
    required String step,
    required String title,
    required String description,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted ? AppColors.success : (isActive ? AppColors.primaryContainer : Colors.transparent),
            shape: BoxShape.circle,
            border: isCompleted || isActive ? null : Border.all(color: AppColors.border, width: 2),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : Text(
                    step,
                    style: AppTheme.labelMedium.copyWith(
                      color: isActive ? AppColors.primary : AppColors.textTertiary,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.headingSmall.copyWith(
                  color: isActive || isCompleted ? AppColors.textPrimary : AppColors.textTertiary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine({required bool isCompleted}) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 4, bottom: 4),
      width: 2,
      height: 30,
      color: isCompleted ? AppColors.success : AppColors.border,
    );
  }

  Widget _buildUploadTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Berkas', style: AppTheme.headingLarge),
          const SizedBox(height: 8),
          Text(
            'Unggah draft skripsi (PDF) atau lampiran kode (ZIP).',
            style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),

          GestureDetector(
            onTap: _isUploading ? null : _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: AppTheme.borderRadiusLarge,
                border: Border.all(
                  color: _selectedFileName != null ? AppColors.primary : AppColors.border,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedFileName != null ? Icons.file_present : Icons.cloud_upload_outlined,
                    size: 48,
                    color: _selectedFileName != null ? AppColors.primary : AppColors.textTertiary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFileName ?? 'Ketuk untuk memilih file',
                    style: AppTheme.labelMedium.copyWith(
                      color: _selectedFileName != null ? AppColors.primary : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedFileName == null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Maks. 10MB (PDF/ZIP)',
                        style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
                      ),
                    ),
                ],
              ),
            ),
          ),
          
          if (_isUploading) ...[
            const SizedBox(height: 24),
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: AppColors.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'Mengunggah... ${(_uploadProgress * 100).toInt()}%',
              style: AppTheme.caption,
            ),
          ],

          const SizedBox(height: 40),
          SidangkuButton(
            label: 'Upload Berkas',
            type: SidangkuButtonType.primary,
            onTap: _selectedFileName != null && !_isUploading ? _uploadFile : null,
          ),
        ],
      ),
    );
  }
}
