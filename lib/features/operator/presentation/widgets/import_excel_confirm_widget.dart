import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class ImportExcelConfirmWidget extends StatefulWidget {
  final int totalRows;
  final List<Map<String, dynamic>> previewData;
  final List<Map<String, String>> errorRows;
  final VoidCallback? onImport;
  final VoidCallback? onBack;

  const ImportExcelConfirmWidget({
    super.key,
    required this.totalRows,
    required this.previewData,
    this.errorRows = const [],
    this.onImport,
    this.onBack,
  });

  @override
  State<ImportExcelConfirmWidget> createState() =>
      _ImportExcelConfirmWidgetState();
}

class _ImportExcelConfirmWidgetState extends State<ImportExcelConfirmWidget> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 24),
        _buildSummaryBanner(),
        const SizedBox(height: 16),
        if (widget.errorRows.isNotEmpty) ...[
          _buildWarningBanner(),
          const SizedBox(height: 16),
        ],
        Expanded(child: _buildPreviewTable()),
        _buildBottomButtons(),
      ],
    );
  }

  Widget _buildStepIndicator() {
    final steps = [
      ('1', 'Upload'),
      ('2', 'Mapping'),
      ('3', 'Konfirmasi'),
    ];

    return Row(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final stepNum = int.parse(step.$1);
        final isActive = stepNum == 3;
        final isCompleted = stepNum < 3;

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

  Widget _buildSummaryBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.totalRows} data jadwal siap diimport',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${widget.errorRows.length} baris bermasalah ditemukan',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewTable() {
    if (widget.previewData.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data untuk ditampilkan',
          style: AppTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final columns = widget.previewData.first.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          headingRowColor: WidgetStateProperty.all(
            AppColors.surfaceContainerLow,
          ),
          columns: columns
              .map((col) => DataColumn(
                    label: Text(
                      col,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ))
              .toList(),
          rows: widget.previewData.take(10).map((row) {
            return DataRow(
              cells: columns.map((col) {
                return DataCell(
                  Text(
                    row[col]?.toString() ?? '-',
                    style: AppTheme.bodySmall,
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    final validRows = widget.totalRows - widget.errorRows.length;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (widget.errorRows.isNotEmpty) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _importValidOnly,
                child: Text('Import $validRows Data Valid Saja'),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  child: const Text('Kembali'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _doImport,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text('Import ${widget.totalRows} Data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _doImport() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal import: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _importValidOnly() {
    _doImport();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 48,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Berhasil!',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.totalRows} jadwal berhasil diimport',
              style: AppTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onImport?.call();
              },
              child: const Text('Tutup'),
            ),
          ),
        ],
      ),
    );
  }
}