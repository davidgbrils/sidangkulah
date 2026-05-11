import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';

class ImportedData {
  final String nama;
  final String nim;
  final String dosenPembimbing;

  ImportedData({required this.nama, required this.nim, required this.dosenPembimbing});
}

class ImportExcelScreen extends StatefulWidget {
  const ImportExcelScreen({super.key});

  @override
  State<ImportExcelScreen> createState() => _ImportExcelScreenState();
}

class _ImportExcelScreenState extends State<ImportExcelScreen> {
  bool _isLoading = false;
  bool _isFilePicked = false;
  String _fileName = '';
  List<ImportedData> _importedDataList = [];

  Future<void> _pickExcelFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      setState(() {
        _fileName = result.files.single.name;
        _isLoading = true;
      });

      // Mock processing delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
        _isFilePicked = true;
        _importedDataList = [
          ImportedData(nama: 'Budi Setiawan', nim: '123456789', dosenPembimbing: 'Dr. Rina Wati'),
          ImportedData(nama: 'Andi Saputra', nim: '987654321', dosenPembimbing: 'Prof. Hasanuddin'),
          ImportedData(nama: 'Siti Aminah', nim: '112233445', dosenPembimbing: 'Dr. Ahmad'),
        ];
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File berhasil di-import dan diproses!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Import Excel'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppTheme.borderRadiusLarge,
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Icon(Icons.upload_file, size: 64, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Pilih file Excel (.xlsx, .xls)',
                    style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  SidangkuButton(
                    label: _isLoading ? 'Memproses...' : 'Import Data (Excel)',
                    type: SidangkuButtonType.primary,
                    onTap: _isLoading ? null : _pickExcelFile,
                  ),
                  if (_fileName.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text('File terpilih: $_fileName', style: AppTheme.caption),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_isFilePicked) ...[
              Text('Data Ter-import:', style: AppTheme.headingSmall),
              const SizedBox(height: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTheme.borderRadiusLarge,
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Nama')),
                            DataColumn(label: Text('NIM')),
                            DataColumn(label: Text('Dosen Pembimbing')),
                          ],
                          rows: _importedDataList.map((data) {
                            return DataRow(cells: [
                              DataCell(Text(data.nama)),
                              DataCell(Text(data.nim)),
                              DataCell(Text(data.dosenPembimbing)),
                            ]);
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
