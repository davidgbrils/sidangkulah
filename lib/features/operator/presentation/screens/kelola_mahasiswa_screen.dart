import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';
import 'package:sidangkufix/core/widgets/status_chip.dart';

class MahasiswaModel {
  final String id;
  final String nama;
  final String nim;
  final String prodi;
  final int angkatan;
  final String email;
  final String noHp;
  final String status;

  const MahasiswaModel({
    required this.id,
    required this.nama,
    required this.nim,
    required this.prodi,
    required this.angkatan,
    required this.email,
    required this.noHp,
    required this.status,
  });
}

class KelolaMahasiswaScreen extends StatefulWidget {
  const KelolaMahasiswaScreen({super.key});

  @override
  State<KelolaMahasiswaScreen> createState() => _KelolaMahasiswaScreenState();
}

class _KelolaMahasiswaScreenState extends State<KelolaMahasiswaScreen> {
  final _searchController = TextEditingController();
  int _selectedFilter = 0;
  bool _isSelectionMode = false;
  final Set<String> _selectedIds = {};

  final _mahasiswaList = const [
    MahasiswaModel(
      id: '1',
      nama: 'Budi Setiawan',
      nim: '1202184001',
      prodi: 'Teknik Informatika',
      angkatan: 2020,
      email: 'budi.setiawan@student.itpln.ac.id',
      noHp: '081234567890',
      status: 'Sudah Sidang',
    ),
    MahasiswaModel(
      id: '2',
      nama: 'Anisa Maharani',
      nim: '1202184002',
      prodi: 'Teknik Informatika',
      angkatan: 2020,
      email: 'anisa.maharani@student.itpln.ac.id',
      noHp: '081234567891',
      status: 'Belum Daftar',
    ),
    MahasiswaModel(
      id: '3',
      nama: 'Dian Permana',
      nim: '1202184003',
      prodi: 'Teknik Informatika',
      angkatan: 2020,
      email: 'dian.permana@student.itpln.ac.id',
      noHp: '081234567892',
      status: 'Sudah Daftar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSelectionMode ? _buildSelectionAppBar() : _buildNormalAppBar(),
      body: Column(
        children: [
          _buildStatsRow(),
          _buildFilterChips(),
          Expanded(
            child: _buildMahasiswaList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddForm,
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: const Text('Data Mahasiswa'),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {},
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          setState(() {
            _isSelectionMode = false;
            _selectedIds.clear();
          });
        },
      ),
      title: Text('${_selectedIds.length} dipilih'),
      actions: [
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: _deleteSelected,
        ),
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: _exportSelected,
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _StatCard(
            label: 'Total',
            value: '${_mahasiswaList.length}',
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'Sudah Sidang',
            value: '${_mahasiswaList.where((m) => m.status == 'Sudah Sidang').length}',
            color: AppColors.success,
          ),
          const SizedBox(width: 12),
          _StatCard(
            label: 'Belum Sidang',
            value: '${_mahasiswaList.where((m) => m.status != 'Sudah Sidang').length}',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Sudah Daftar', 'Belum Daftar', 'Sudah Sidang'];
    final selectedIndex = _selectedFilter;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: selectedIndex == index,
              label: Text(label),
              onSelected: (selected) {
                setState(() => _selectedFilter = index);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMahasiswaList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _mahasiswaList.length,
      itemBuilder: (context, index) {
        final mahasiswa = _mahasiswaList[index];

        return Listener(
          onPointerUp: (_) {
            if (_isSelectionMode) {
              _toggleSelection(mahasiswa.id);
            }
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              onTap: () {
                if (_isSelectionMode) {
                  _toggleSelection(mahasiswa.id);
                } else {
                  _showDetail(mahasiswa);
                }
              },
              onLongPress: () {
                setState(() {
                  _isSelectionMode = true;
                  _selectedIds.add(mahasiswa.id);
                });
              },
              leading: AvatarInitials(name: mahasiswa.nama),
              title: Text(
                mahasiswa.nama,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(mahasiswa.nim),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusChip.fromString(mahasiswa.status),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                        onTap: () => _showEditForm(mahasiswa),
                      ),
                      PopupMenuItem(
                        child: const Row(
                          children: [
                            Icon(Icons.visibility_outlined, size: 18),
                            SizedBox(width: 8),
                            Text('Lihat Detail'),
                          ],
                        ),
                        onTap: () => _showDetail(mahasiswa),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline,
                                size: 18, color: AppColors.error),
                            const SizedBox(width: 8),
                            Text('Hapus',
                                style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                        onTap: () => _deleteMahasiswa(mahasiswa),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }

      if (_selectedIds.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _deleteSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Menghapus ${_selectedIds.length} data...')),
    );
  }

  void _exportSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Mengekspor ${_selectedIds.length} data...')),
    );
  }

  void _showAddForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MahasiswaFormSheet(),
    );
  }

  void _showEditForm(MahasiswaModel mahasiswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _MahasiswaFormSheet(mahasiswa: mahasiswa),
    );
  }

  void _showDetail(MahasiswaModel mahasiswa) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mahasiswa.nama, style: AppTheme.headingMedium),
            Text(mahasiswa.nim, style: AppTheme.bodyMedium),
            const SizedBox(height: 16),
            _DetailRow(label: 'Prodi', value: mahasiswa.prodi),
            _DetailRow(label: 'Angkatan', value: '${mahasiswa.angkatan}'),
            _DetailRow(label: 'Email', value: mahasiswa.email),
            _DetailRow(label: 'No HP', value: mahasiswa.noHp),
            _DetailRow(label: 'Status', value: mahasiswa.status),
          ],
        ),
      ),
    );
  }

  void _deleteMahasiswa(MahasiswaModel mahasiswa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Mahasiswa'),
        content: Text('Hapus ${mahasiswa.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.headingMedium.copyWith(color: color),
            ),
            Text(
              label,
              style: AppTheme.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: AppTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _MahasiswaFormSheet extends StatefulWidget {
  final MahasiswaModel? mahasiswa;

  const _MahasiswaFormSheet({this.mahasiswa});

  @override
  State<_MahasiswaFormSheet> createState() => _MahasiswaFormSheetState();
}

class _MahasiswaFormSheetState extends State<_MahasiswaFormSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.mahasiswa == null
                  ? 'Tambah Mahasiswa'
                  : 'Edit Mahasiswa',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'NIM',
                hintText: 'Masukkan NIM',
              ),
              controller: TextEditingController(
                text: widget.mahasiswa?.nim,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Nama Lengkap',
                hintText: 'Masukkan Nama Lengkap',
              ),
              controller: TextEditingController(
                text: widget.mahasiswa?.nama,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Masukkan Email',
              ),
              controller: TextEditingController(
                text: widget.mahasiswa?.email,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'No HP',
                hintText: 'Masukkan No HP',
              ),
              controller: TextEditingController(
                text: widget.mahasiswa?.noHp,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
