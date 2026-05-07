import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';
import 'package:sidangkufix/core/widgets/status_chip.dart';

enum DokumenStatus { belumGenerate, draft, final_, cetak }

class HonorDosenModel {
  final String id;
  final String nama;
  final String nidn;
  final int jumlahSidangPenguji;
  final int jumlahSidangPembimbing;
  final int totalHonor;
  final String status;

  const HonorDosenModel({
    required this.id,
    required this.nama,
    required this.nidn,
    required this.jumlahSidangPenguji,
    required this.jumlahSidangPembimbing,
    required this.totalHonor,
    required this.status,
  });
}

class SKCard {
  final String id;
  final String mahasiswaNama;
  final String tanggalSidang;
  final DokumenStatus status;

  const SKCard({
    required this.id,
    required this.mahasiswaNama,
    required this.tanggalSidang,
    required this.status,
  });
}

class DokumenHonorScreen extends StatefulWidget {
  const DokumenHonorScreen({super.key});

  @override
  State<DokumenHonorScreen> createState() => _DokumenHonorScreenState();
}

class _DokumenHonorScreenState extends State<DokumenHonorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedBulan = 'Juni';
  String _selectedTahun = '2024';

  final _currencyFormat = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  final _skCards = const [
    SKCard(
      id: '1',
      mahasiswaNama: 'Budi Setiawan',
      tanggalSidang: 'Senin, 3 Juni 2024',
      status: DokumenStatus.final_,
    ),
    SKCard(
      id: '2',
      mahasiswaNama: 'Anisa Maharani',
      tanggalSidang: 'Selasa, 4 Juni 2024',
      status: DokumenStatus.belumGenerate,
    ),
    SKCard(
      id: '3',
      mahasiswaNama: 'Dian Permana',
      tanggalSidang: 'Rabu, 5 Juni 2024',
      status: DokumenStatus.draft,
    ),
  ];

  final _honorDosenList = const [
    HonorDosenModel(
      id: '1',
      nama: 'Dr. Siti Aminah, M.T.',
      nidn: '197001012000012001',
      jumlahSidangPenguji: 5,
      jumlahSidangPembimbing: 3,
      totalHonor: 2500000,
      status: 'Belum Dibayar',
    ),
    HonorDosenModel(
      id: '2',
      nama: 'Dr. Ahmad Fauzi, M.Kom.',
      nidn: '197002022000022001',
      jumlahSidangPenguji: 4,
      jumlahSidangPembimbing: 2,
      totalHonor: 2000000,
      status: 'Sudah Dibayar',
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text('Dokumen & Rekap Honor'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'SK Penguji'),
            Tab(text: 'Rekap Honor'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSKTab(),
          _buildHonorTab(),
        ],
      ),
    );
  }

  Widget _buildSKTab() {
    final generated =
        _skCards.where((s) => s.status != DokumenStatus.belumGenerate).length;
    final belum =
        _skCards.where((s) => s.status == DokumenStatus.belumGenerate).length;

    return Column(
      children: [
        _buildFilterRow(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Text(
                'Total: ${_skCards.length} SK',
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '($generated sudah, $belum belum)',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              _buildGenerateAllButton(),
            ],
          ),
        ),
        Expanded(
          child: _skCards.isEmpty
              ? _buildEmptyState('Belum ada data SK', Icons.description_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _skCards.length,
                  itemBuilder: (context, index) {
                    return _SKCardWidget(sk: _skCards[index]);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildGenerateAllButton() {
    final hasBelum =
        _skCards.any((s) => s.status == DokumenStatus.belumGenerate);
    if (!hasBelum) return const SizedBox.shrink();
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membuat semua SK...')),
        );
      },
      icon: const Icon(Icons.auto_awesome_rounded, size: 16),
      label: const Text('Generate Semua'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(0, 36),
      ),
    );
  }

  Widget _buildHonorTab() {
    final totalHonor = _honorDosenList.fold<int>(
      0,
      (sum, d) => sum + d.totalHonor,
    );
    final belumBayar = _honorDosenList
        .where((d) => d.status == 'Belum Dibayar')
        .fold<int>(0, (sum, d) => sum + d.totalHonor);

    return Column(
      children: [
        // Summary card
        Container(
          margin: const EdgeInsets.all(AppTheme.spacing16),
          padding: const EdgeInsets.all(AppTheme.spacing20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: AppTheme.borderRadiusLarge,
            boxShadow: AppTheme.shadowMedium,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Honor Periode $_selectedBulan $_selectedTahun',
                      style: AppTheme.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _currencyFormat.format(totalHonor),
                      style: AppTheme.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Belum dibayar: ${_currencyFormat.format(belumBayar)}',
                      style: AppTheme.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: _honorDosenList.isEmpty
              ? _buildEmptyState(
                  'Belum ada data honor', Icons.payments_outlined)
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _honorDosenList.length,
                  itemBuilder: (context, index) {
                    return _HonorDosenCard(honor: _honorDosenList[index]);
                  },
                ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildFilterRow() {
    const bulanList = ['Juni', 'Mei', 'April', 'Maret'];
    const tahunList = ['2024', '2023', '2022'];

    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacing16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedBulan,
              decoration: const InputDecoration(
                labelText: 'Bulan',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: bulanList
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedBulan = val);
              },
            ),
          ),
          const SizedBox(width: AppTheme.spacing12),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedTahun,
              decoration: const InputDecoration(
                labelText: 'Tahun',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              items: tahunList
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedTahun = val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: AppColors.textTertiary),
          const SizedBox(height: 12),
          Text(
            message,
            style: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.fromLTRB(AppTheme.spacing16, AppTheme.spacing12, AppTheme.spacing16, AppTheme.spacing16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mengekspor Excel...')),
                  );
                },
                icon: const Icon(Icons.table_chart_rounded, size: 18),
                label: const Text('Ekspor Excel'),
              ),
            ),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mencetak PDF...')),
                  );
                },
                icon: const Icon(Icons.picture_as_pdf_rounded, size: 18),
                label: const Text('Cetak PDF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SKCardWidget extends StatelessWidget {
  final SKCard sk;

  const _SKCardWidget({required this.sk});

  @override
  Widget build(BuildContext context) {
    String statusLabel;
    StatusChipType statusType;

    switch (sk.status) {
      case DokumenStatus.belumGenerate:
        statusLabel = 'Belum Generate';
        statusType = StatusChipType.pending;
        break;
      case DokumenStatus.draft:
        statusLabel = 'Draft';
        statusType = StatusChipType.revision;
        break;
      case DokumenStatus.final_:
        statusLabel = 'Final';
        statusType = StatusChipType.done;
        break;
      case DokumenStatus.cetak:
        statusLabel = 'Dicetak';
        statusType = StatusChipType.approved;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.borderRadiusMedium,
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.description_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sk.mahasiswaNama,
                    style: AppTheme.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sk.tanggalSidang,
                    style: AppTheme.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  StatusChip(label: statusLabel, type: statusType),
                ],
              ),
            ),
            if (sk.status == DokumenStatus.belumGenerate)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Generate SK', style: TextStyle(fontSize: 12)),
              )
            else
              IconButton(
                icon: const Icon(
                  Icons.download_rounded,
                  color: AppColors.primary,
                ),
                tooltip: 'Unduh SK',
                onPressed: () {},
              ),
          ],
        ),
      ),
    );
  }
}

class _HonorDosenCard extends StatelessWidget {
  final HonorDosenModel honor;

  const _HonorDosenCard({required this.honor});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    final isBelumBayar = honor.status == 'Belum Dibayar';

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppTheme.borderRadiusMedium,
        boxShadow: AppTheme.shadowSmall,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AvatarInitials(name: honor.nama),
            const SizedBox(width: AppTheme.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    honor.nama,
                    style: AppTheme.bodyMedium
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'NIDN: ${honor.nidn}',
                    style:
                        AppTheme.caption.copyWith(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Row(
                    children: [
                      _infoChip(
                          '${honor.jumlahSidangPenguji}x Penguji',
                          Icons.person_search_rounded),
                      const SizedBox(width: AppTheme.spacing8),
                      _infoChip(
                          '${honor.jumlahSidangPembimbing}x Pembimbing',
                          Icons.supervisor_account_rounded),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  currencyFormat.format(honor.totalHonor),
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                StatusChip(
                  label: honor.status,
                  type: isBelumBayar
                      ? StatusChipType.pending
                      : StatusChipType.approved,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(
            label,
            style: AppTheme.caption.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
