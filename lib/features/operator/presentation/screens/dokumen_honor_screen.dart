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
    final generated = _skCards.where((s) => s.status != DokumenStatus.belumGenerate).length;
    final belum = _skCards.where((s) => s.status == DokumenStatus.belumGenerate).length;

    return Column(
      children: [
        _buildFilterRow(),
        Padding(
          padding: const EdgeInsets.all(16),
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
                '($generated sudah generate, $belum belum)',
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _skCards.length,
            itemBuilder: (context, index) {
              final sk = _skCards[index];
              return _SKCardWidget(sk: sk);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHonorTab() {
    final totalHonor = _honorDosenList.fold<int>(
      0,
      (sum, d) => sum + d.totalHonor,
    );

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.account_balance_wallet,
                color: Colors.white,
                size: 32,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Honor',
                    style: AppTheme.bodySmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    _currencyFormat.format(totalHonor),
                    style: AppTheme.headingMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _honorDosenList.length,
            itemBuilder: (context, index) {
              final honor = _honorDosenList[index];
              return _HonorDosenCard(honor: honor);
            },
          ),
        ),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildFilterRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Bulan',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              value: 'Juni',
              items: const ['Juni', 'Mei', 'April']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
              onChanged: (_) {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Tahun',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              value: '2024',
              items: const ['2024', '2023', '2022']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (_) {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.table_chart),
              label: const Text('Ekspor Excel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text('Cetak PDF'),
            ),
          ),
        ],
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
    Color statusColor;
    IconData statusIcon;

    switch (sk.status) {
      case DokumenStatus.belumGenerate:
        statusLabel = 'Belum Generate';
        statusColor = AppColors.textTertiary;
        statusIcon = Icons.hourglass_empty;
        break;
      case DokumenStatus.draft:
        statusLabel = 'Draft';
        statusColor = AppColors.warning;
        statusIcon = Icons.edit;
        break;
      case DokumenStatus.final_:
        statusLabel = 'Final';
        statusColor = AppColors.success;
        statusIcon = Icons.check_circle;
        break;
      case DokumenStatus.cetak:
        statusLabel = 'Dicetak';
        statusColor = AppColors.primary;
        statusIcon = Icons.print;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(
          sk.mahasiswaNama,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(sk.tanggalSidang),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatusChip(
              label: statusLabel,
              color: statusColor,
            ),
            const SizedBox(width: 8),
            if (sk.status == DokumenStatus.belumGenerate)
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                ),
                child: Text(
                  'Generate SK',
                  style: AppTheme.caption,
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.download),
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

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: AvatarInitials(nama: honor.nama),
        title: Text(
          honor.nama,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${honor.jumlahSidangPenguji} sidang sebagai penguji, ${honor.jumlahSidangPembimbing} sebagai pembimbing',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(honor.totalHonor),
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            StatusChip(
              label: honor.status,
              color: honor.status == 'Sudah Dibayar'
                  ? AppColors.success
                  : AppColors.error,
            ),
          ],
        ),
      ),
    );
  }
}