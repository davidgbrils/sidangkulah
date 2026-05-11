import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/sidangku_button.dart';
import 'package:sidangkufix/core/widgets/sidangku_text_field.dart';

class InputJadwalScreen extends StatefulWidget {
  const InputJadwalScreen({super.key});

  @override
  State<InputJadwalScreen> createState() => _InputJadwalScreenState();
}

class _InputJadwalScreenState extends State<InputJadwalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mahasiswaController = TextEditingController();
  final _judulController = TextEditingController();
  final _ruanganController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  String? _selectedPembimbing1;
  String? _selectedPembimbing2;
  String? _selectedPenguji1;
  String? _selectedPenguji2;

  final List<String> _dosenList = [
    'Dr. Ir. Heru Setiawan, M.T.',
    'Dr. Siti Aminah, M.Kom.',
    'Dr. Ahmad Fauzi, M.T.',
    'Irfan Hakim, M.Kom.',
    'Drs. M. Taufik, M.Eng.',
  ];

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart 
          ? const TimeOfDay(hour: 8, minute: 0) 
          : const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mohon lengkapi tanggal dan waktu sidang')),
        );
        return;
      }

      // Conflict checking logic mock
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jadwal berhasil disimpan dan dikirim ke mahasiswa/dosen.'),
          backgroundColor: AppColors.success,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Jadwal Sidang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Mahasiswa', style: AppTheme.headingSmall),
              const SizedBox(height: 16),
              SidangkuTextField(
                label: 'Nama Mahasiswa / NIM',
                hint: 'Cari Mahasiswa...',
                controller: _mahasiswaController,
                prefixIcon: Icons.search_rounded,
                validator: (v) => v?.isEmpty ?? true ? 'Mahasiswa wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              SidangkuTextField(
                label: 'Judul Skripsi',
                hint: 'Judul akan muncul otomatis jika mahasiswa dipilih',
                controller: _judulController,
                maxLines: 2,
                readOnly: true,
              ),
              
              const SizedBox(height: 32),
              Text('Waktu & Lokasi', style: AppTheme.headingSmall),
              const SizedBox(height: 16),
              _buildPickerTile(
                icon: Icons.calendar_today_rounded,
                label: 'Tanggal Sidang',
                value: _selectedDate == null 
                    ? 'Pilih Tanggal' 
                    : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                onTap: _selectDate,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildPickerTile(
                      icon: Icons.access_time_rounded,
                      label: 'Mulai',
                      value: _startTime?.format(context) ?? '00:00',
                      onTap: () => _selectTime(true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildPickerTile(
                      icon: Icons.access_time_rounded,
                      label: 'Selesai',
                      value: _endTime?.format(context) ?? '00:00',
                      onTap: () => _selectTime(false),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SidangkuTextField(
                label: 'Ruangan / Link Meet',
                hint: 'Contoh: Ruang Sidang 1 atau URL Zoom',
                controller: _ruanganController,
                prefixIcon: Icons.location_on_outlined,
                validator: (v) => v?.isEmpty ?? true ? 'Lokasi wajib diisi' : null,
              ),

              const SizedBox(height: 32),
              Text('Tim Penguji', style: AppTheme.headingSmall),
              const SizedBox(height: 16),
              _buildDropdown('Pembimbing 1', _selectedPembimbing1, (v) => setState(() => _selectedPembimbing1 = v)),
              const SizedBox(height: 12),
              _buildDropdown('Pembimbing 2', _selectedPembimbing2, (v) => setState(() => _selectedPembimbing2 = v)),
              const SizedBox(height: 12),
              _buildDropdown('Penguji 1', _selectedPenguji1, (v) => setState(() => _selectedPenguji1 = v)),
              const SizedBox(height: 12),
              _buildDropdown('Penguji 2', _selectedPenguji2, (v) => setState(() => _selectedPenguji2 = v)),

              const SizedBox(height: 40),
              SidangkuButton(
                label: 'Simpan Jadwal',
                onTap: _handleSubmit,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPickerTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelMedium),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: AppTheme.borderRadiusMedium,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppTheme.borderRadiusMedium,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 12),
                Text(value, style: AppTheme.bodyMedium),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textTertiary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, String? value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTheme.labelMedium),
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
              value: value,
              isExpanded: true,
              hint: Text('Pilih Dosen', style: AppTheme.bodyMedium.copyWith(color: AppColors.textTertiary)),
              items: _dosenList.map((d) => DropdownMenuItem(value: d, child: Text(d, style: AppTheme.bodyMedium))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
