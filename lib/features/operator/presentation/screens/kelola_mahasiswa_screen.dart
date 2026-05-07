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
  bool _isSearching = false;
  final Set<String> _selectedIds = {};
  String _searchQuery = '';

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
    MahasiswaModel(
      id: '4',
      nama: 'Rizki Pratama',
      nim: '1202184004',
      prodi: 'Teknik Informatika',
      angkatan: 2020,
      email: 'rizki.pratama@student.itpln.ac.id',
      noHp: '081234567893',
      status: 'Sudah Daftar',
    ),
    MahasiswaModel(
      id: '5',
      nama: 'Fitri Rahayu',
      nim: '1202184005',
      prodi: 'Teknik Informatika',
      angkatan: 2020,
      email: 'fitri.rahayu@student.itpln.ac.id',
      noHp: '081234567894',
      status: 'Sudah Sidang',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<MahasiswaModel> get _filteredList {
    final filters = ['Semua', 'Sudah Daftar', 'Belum Daftar', 'Sudah Sidang'];
    final filterStatus = filters[_selectedFilter];

    return _mahasiswaList.where((m) {
      final matchSearch = _searchQuery.isEmpty ||
          m.nama.toLowerCase().contains(_searchQuery) ||
          m.nim.toLowerCase().contains(_searchQuery) ||
          m.email.toLowerCase().contains(_searchQuery);

      final matchFilter =
          filterStatus == 'Semua' || m.status == filterStatus;

      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: _isSelectionMode ? _buildSelectionAppBar() : _buildNormalAppBar(),
      body: Column(
        children: [
          if (_isSearching) _buildSearchBar(),
          _buildStatsRow(),
          _buildFilterChips(),
          Expanded(
            child: _buildMahasiswaList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddForm,
        icon: const Icon(Icons.person_add_rounded),
        label: const Text('Tambah'),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar() {
    return AppBar(
      title: const Text('Data Mahasiswa'),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.search_off : Icons.search_rounded),
          tooltip: 'Cari',
          onPressed: () {
            setState(() {
              _isSearching = !_isSearching;
              if (!_isSearching) {
                _searchController.clear();
              }
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.download_rounded),
          tooltip: 'Ekspor Data',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Mengekspor data...')),
            );
          },
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSelectionAppBar() {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
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
          icon: const Icon(Icons.delete_outline_rounded),
          tooltip: 'Hapus yang dipilih',
          onPressed: _deleteSelected,
        ),
        IconButton(
          icon: const Icon(Icons.download_rounded),
          tooltip: 'Ekspor yang dipilih',
          onPressed: _exportSelected,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Cari nama, NIM, atau email...',
          prefixIcon: const Icon(Icons.search_rounded, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 18),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'Total',
            value: '${_mahasiswaList.length}',
            color: AppColors.primary,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Sudah Sidang',
            value:
                '${_mahasiswaList.where((m) => m.status == 'Sudah Sidang').length}',
            color: AppColors.success,
          ),
          const SizedBox(width: 10),
          _StatCard(
            label: 'Belum Daftar',
            value:
                '${_mahasiswaList.where((m) => m.status == 'Belum Daftar').length}',
            color: AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Semua', 'Sudah Daftar', 'Belum Daftar', 'Sudah Sidang'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedFilter == index;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(label),
              onSelected: (_) {
                setState(() => _selectedFilter = index);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMahasiswaList() {
    final filtered = _filteredList;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded,
                size: 56, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Tidak ditemukan untuk "$_searchQuery"'
                  : 'Tidak ada data mahasiswa',
              style:
                  AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final mahasiswa = filtered[index];
        final isSelected = _selectedIds.contains(mahasiswa.id);

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.white,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  if (_isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleSelection(mahasiswa.id),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  AvatarInitials(name: mahasiswa.nama),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          mahasiswa.nama,
                          style: AppTheme.bodyMedium
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${mahasiswa.nim} • ${mahasiswa.prodi}',
                          style: AppTheme.caption.copyWith(
                              color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        StatusChip.fromString(mahasiswa.status),
                      ],
                    ),
                  ),
                  if (!_isSelectionMode)
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded,
                          color: AppColors.textTertiary),
                      onSelected: (value) {
                        if (value == 'edit') _showEditForm(mahasiswa);
                        if (value == 'detail') _showDetail(mahasiswa);
                        if (value == 'hapus') _deleteMahasiswa(mahasiswa);
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'detail',
                          child: Row(
                            children: [
                              Icon(Icons.visibility_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Lihat Detail'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit_outlined, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'hapus',
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline_rounded,
                                  size: 18, color: AppColors.error),
                              const SizedBox(width: 8),
                              Text('Hapus',
                                  style:
                                      TextStyle(color: AppColors.error)),
                            ],
                          ),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Data'),
        content:
            Text('Hapus ${_selectedIds.length} data mahasiswa yang dipilih?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isSelectionMode = false;
                _selectedIds.clear();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Data berhasil dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _exportSelected() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Mengekspor ${_selectedIds.length} data...')),
    );
  }

  void _showAddForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _MahasiswaFormSheet(),
    );
  }

  void _showEditForm(MahasiswaModel mahasiswa) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MahasiswaFormSheet(mahasiswa: mahasiswa),
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
            Row(
              children: [
                AvatarInitials(name: mahasiswa.nama),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(mahasiswa.nama,
                          style: AppTheme.headingSmall),
                      Text(mahasiswa.nim,
                          style: AppTheme.bodySmall.copyWith(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                StatusChip.fromString(mahasiswa.status),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(),
            const SizedBox(height: 12),
            _DetailRow(label: 'Prodi', value: mahasiswa.prodi),
            _DetailRow(
                label: 'Angkatan', value: '${mahasiswa.angkatan}'),
            _DetailRow(label: 'Email', value: mahasiswa.email),
            _DetailRow(label: 'No HP', value: mahasiswa.noHp),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _showEditForm(mahasiswa);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteMahasiswa(mahasiswa);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error),
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 16),
                    label: const Text('Hapus'),
                  ),
                ),
              ],
            ),
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
        content: Text(
            'Yakin hapus data ${mahasiswa.nama}? Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text('${mahasiswa.nama} berhasil dihapus')),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────────────
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTheme.headingMedium.copyWith(
                  color: color, fontWeight: FontWeight.w700),
            ),
            Text(
              label,
              style: AppTheme.caption.copyWith(color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────────────
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
            width: 90,
            child: Text(
              label,
              style: AppTheme.bodySmall
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(value, style: AppTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

// ── Mahasiswa Form Sheet ──────────────────────────────────────────────────
class _MahasiswaFormSheet extends StatefulWidget {
  final MahasiswaModel? mahasiswa;

  const _MahasiswaFormSheet({this.mahasiswa});

  @override
  State<_MahasiswaFormSheet> createState() => _MahasiswaFormSheetState();
}

class _MahasiswaFormSheetState extends State<_MahasiswaFormSheet> {
  late final TextEditingController _nimController;
  late final TextEditingController _namaController;
  late final TextEditingController _emailController;
  late final TextEditingController _noHpController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nimController =
        TextEditingController(text: widget.mahasiswa?.nim ?? '');
    _namaController =
        TextEditingController(text: widget.mahasiswa?.nama ?? '');
    _emailController =
        TextEditingController(text: widget.mahasiswa?.email ?? '');
    _noHpController =
        TextEditingController(text: widget.mahasiswa?.noHp ?? '');
  }

  @override
  void dispose() {
    _nimController.dispose();
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mahasiswa != null;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEdit ? 'Edit Mahasiswa' : 'Tambah Mahasiswa',
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nimController,
                decoration: const InputDecoration(
                  labelText: 'NIM',
                  hintText: 'Masukkan NIM',
                  prefixIcon: Icon(Icons.badge_outlined),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'NIM wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan Nama Lengkap',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'contoh@student.itpln.ac.id',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _noHpController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'No HP',
                  hintText: '08xxxxxxxxxx',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isEdit
                              ? 'Data berhasil diperbarui'
                              : 'Mahasiswa berhasil ditambahkan'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Mahasiswa'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
