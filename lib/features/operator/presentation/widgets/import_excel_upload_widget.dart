import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

enum ImportStep { upload, mapping, confirm }

class ImportExcelUploadWidget extends StatefulWidget {
  final Function(int currentStep, Map<String, List<String>> mappingData) onComplete;
  final VoidCallback? onBack;

  const ImportExcelUploadWidget({
    super.key,
    required this.onComplete,
    this.onBack,
  });

  @override
  State<ImportExcelUploadWidget> createState() => _ImportExcelUploadWidgetState();
}

class _ImportExcelUploadWidgetState extends State<ImportExcelUploadWidget> {
  ImportStep _currentStep = ImportStep.upload;
  PlatformFile? _selectedFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 24),
        Expanded(
          child: _currentStep == ImportStep.upload
              ? _buildUploadStep()
              : _currentStep == ImportStep.mapping
                  ? _buildMappingStep()
                  : _buildConfirmStep(),
        ),
        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      ('1', 'Upload', ImportStep.upload),
      ('2', 'Mapping', ImportStep.mapping),
      ('3', 'Konfirmasi', ImportStep.confirm),
    ];

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isActive = _currentStep == step.$3;
        final isCompleted = _currentStep.index > step.$3.index;

        return Expanded(
          child: Row(
            children: [
              if (index > 0)
                Container(
                  height: 2,
                  color: isCompleted
                      ? AppColors.primary
                      : AppColors.border,
                ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary
                      : isCompleted
                          ? AppColors.primary.withValues(alpha: 0.1)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? AppColors.primary
                        : isCompleted
                            ? AppColors.primary
                            : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      step.$1,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.white
                            : isCompleted
                                ? AppColors.primary
                                : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      step.$2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? Colors.white
                            : isCompleted
                                ? AppColors.primary
                                : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (index < steps.length - 1)
                Container(
                  height: 2,
                  color: isCompleted
                      ? AppColors.primary
                      : AppColors.border,
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUploadStep() {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: _isLoading ? null : _pickFile,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignCenter,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: CustomPaint(
                painter: DashedBorderPainter(
                  color: AppColors.primary,
                  strokeWidth: 2,
                  gap: 8,
                ),
                child: Center(
                  child: _selectedFile != null
                      ? _buildSelectedFileCard()
                      : _buildUploadPlaceholder(),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Format yang diterima: .xlsx, .xls',
            style: AppTheme.caption.copyWith(color: AppColors.textSecondary),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: _downloadTemplate,
          icon: const Icon(Icons.download_rounded, size: 18),
          label: const Text('Unduh Template Excel'),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file_rounded,
          size: 48,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Drag & Drop file Excel di sini',
          style: AppTheme.headingSmall.copyWith(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          'atau',
          style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: _isLoading ? null : _pickFile,
          child: const Text('Pilih File'),
        ),
      ],
    );
  }

  Widget _buildSelectedFileCard() {
    final fileName = _selectedFile!.name;
    final fileSize = _formatFileSize(_selectedFile!.size);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_rounded,
              size: 48,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            fileName,
            style: AppTheme.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            fileSize,
            style: AppTheme.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () {
              setState(() => _selectedFile = null);
            },
            icon: const Icon(Icons.close, size: 18),
            label: const Text('Hapus'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMappingStep() {
    return Center(
      child: Text('Mapping Step - Coming Soon'),
    );
  }

  Widget _buildConfirmStep() {
    return Center(
      child: Text('Confirm Step - Coming Soon'),
    );
  }

  Widget _buildBottomButtons() {
    final canProceed = _selectedFile != null && !_isLoading;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          if (_currentStep != ImportStep.upload)
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                child: const Text('Kembali'),
              ),
            ),
          if (_currentStep != ImportStep.upload) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: canProceed ? _goNext : null,
              child: Text(
                _currentStep == ImportStep.confirm
                    ? 'Import ${_selectedFile?.name.split('.').first}'
                    : 'Lanjut',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null && result.files.isNotEmpty) {
        setState(() {
          _selectedFile = result.files.first;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memilih file: $e')),
      );
    }
  }

  void _downloadTemplate() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengunduh template...')),
    );
  }

  void _goBack() {
    setState(() {
      if (_currentStep == ImportStep.mapping) {
        _currentStep = ImportStep.upload;
      } else if (_currentStep == ImportStep.confirm) {
        _currentStep = ImportStep.mapping;
      }
    });
  }

  void _goNext() {
    setState(() {
      if (_currentStep == ImportStep.upload) {
        _currentStep = ImportStep.mapping;
      } else if (_currentStep == ImportStep.mapping) {
        _currentStep = ImportStep.confirm;
      } else {
        _finalizeImport();
      }
    });
  }

  void _finalizeImport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Import selesai!'),
        backgroundColor: AppColors.success,
      ),
    );
    widget.onComplete(2, {});
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1,
    this.gap = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ));

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}