import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

class MappingRowWidget extends StatelessWidget {
  final String excelColumn;
  final String? selectedField;
  final List<String> fieldOptions;
  final bool isAutoMatched;
  final bool isUnmatched;
  final ValueChanged<String?> onChanged;

  const MappingRowWidget({
    super.key,
    required this.excelColumn,
    required this.selectedField,
    required this.fieldOptions,
    this.isAutoMatched = false,
    this.isUnmatched = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isAutoMatched
            ? AppColors.success.withValues(alpha: 0.08)
            : isUnmatched
                ? AppColors.warning.withValues(alpha: 0.08)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              excelColumn,
              style: AppTheme.bodySmall.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Icon(
            Icons.arrow_forward_rounded,
            size: 18,
            color: AppColors.textTertiary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedField,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: Text(
                'Pilih field...',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
              items: fieldOptions.map((field) {
                return DropdownMenuItem(
                  value: field,
                  child: Text(
                    field,
                    style: AppTheme.bodySmall,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class ImportExcelMappingWidget extends StatefulWidget {
  final List<String> excelHeaders;
  final Function(Map<String, String>) onMappingComplete;
  final VoidCallback? onBack;

  const ImportExcelMappingWidget({
    super.key,
    required this.excelHeaders,
    required this.onMappingComplete,
    this.onBack,
  });

  @override
  State<ImportExcelMappingWidget> createState() => _ImportExcelMappingWidgetState();
}

class _ImportExcelMappingWidgetState extends State<ImportExcelMappingWidget> {
  Map<String, String> _mapping = {};
  final _fieldOptions = [
    'Nama Mahasiswa',
    'NIM',
    'Judul Skripsi',
    'Tanggal Sidang',
    'Waktu Mulai',
    'Waktu Selesai',
    'Ruangan',
    'Pembimbing 1',
    'Pembimbing 2',
    'Penguji 1',
    'Penguji 2',
    'Penguji 3',
    'Abaikan',
  ];

  final _autoMatchKeywords = {
    'nama': 'Nama Mahasiswa',
    'nama lengkap': 'Nama Mahasiswa',
    'nama mahasiswa': 'Nama Mahasiswa',
    'nim': 'NIM',
    'no mhs': 'NIM',
    'judul': 'Judul Skripsi',
    'judul skripsi': 'Judul Skripsi',
    'tanggal': 'Tanggal Sidang',
    'tgl sidang': 'Tanggal Sidang',
    'tanggal sidang': 'Tanggal Sidang',
    'waktu': 'Waktu Mulai',
    'jam': 'Waktu Mulai',
    'mulai': 'Waktu Mulai',
    'selesai': 'Waktu Selesai',
    'ruang': 'Ruangan',
    'ruangan': 'Ruangan',
    'pembimbing 1': 'Pembimbing 1',
    'pembimbing 1': 'Pembimbing 1',
    'pembimbing 2': 'Pembimbing 2',
    'pembimbing 2': 'Pembimbing 2',
    'penguji 1': 'Penguji 1',
    'penguji 1': 'Penguji 1',
    'penguji 2': 'Penguji 2',
    'penguji 2': 'Penguji 2',
    'penguji 3': 'Penguji 3',
    'penguji 3': 'Penguji 3',
  };

  @override
  void initState() {
    super.initState();
    _autoMatchHeaders();
  }

  void _autoMatchHeaders() {
    for (final header in widget.excelHeaders) {
      final lowerHeader = header.toLowerCase();
      String? matchedField;

      for (final entry in _autoMatchKeywords.entries) {
        if (lowerHeader.contains(entry.key)) {
          matchedField = entry.value;
          break;
        }
      }

      _mapping[header] = matchedField ?? 'Abaikan';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStepIndicator(),
        const SizedBox(height: 24),
        Text(
          'Petakan kolom Excel ke field aplikasi',
          style: AppTheme.headingSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: widget.excelHeaders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final header = widget.excelHeaders[index];
              final mappedField = _mapping[header];

              return MappingRowWidget(
                excelColumn: header,
                selectedField: mappedField,
                fieldOptions: _fieldOptions,
                isAutoMatched: mappedField != 'Abaikan' &&
                    mappedField != null,
                isUnmatched: mappedField == 'Abaikan',
                onChanged: (value) {
                  setState(() {
                    _mapping[header] = value ?? 'Abaikan';
                  });
                },
              );
            },
          ),
        ),
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
        final isActive = stepNum == 2;
        final isCompleted = stepNum < 2;

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

  Widget _buildBottomButtons() {
    final unmappedFields = _mapping.entries
        .where((e) =>
            e.value == 'Abaikan' &&
            widget.excelHeaders.contains(e.key))
        .length;
    final isValid = unmappedFields == 0;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
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
              onPressed: isValid ? _goNext : null,
              child: Text(
                isValid
                    ? 'Lanjut ke Preview ($unmappedFields belum dipetakan)'
                    : 'Lanjut ke Preview',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goNext() {
    widget.onMappingComplete(_mapping);
  }
}