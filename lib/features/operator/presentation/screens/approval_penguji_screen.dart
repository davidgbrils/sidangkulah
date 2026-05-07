import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';

enum RequestStatus { pending, disetujui, ditolak }

class RequestGantiPengujiModel {
  final String id;
  final String mahasiswaNama;
  final String nim;
  final String jadwalSidang;
  final String waktuSidang;
  final String oldPenguji;
  final String newPenguji;
  final String alasan;
  final String diajukanOleh;
  final String timestamp;
  final RequestStatus status;
  final bool isUrgent;

  const RequestGantiPengujiModel({
    required this.id,
    required this.mahasiswaNama,
    required this.nim,
    required this.jadwalSidang,
    required this.waktuSidang,
    required this.oldPenguji,
    required this.newPenguji,
    required this.alasan,
    required this.diajukanOleh,
    required this.timestamp,
    required this.status,
    this.isUrgent = false,
  });

  RequestGantiPengujiModel copyWith({RequestStatus? status}) {
    return RequestGantiPengujiModel(
      id: id,
      mahasiswaNama: mahasiswaNama,
      nim: nim,
      jadwalSidang: jadwalSidang,
      waktuSidang: waktuSidang,
      oldPenguji: oldPenguji,
      newPenguji: newPenguji,
      alasan: alasan,
      diajukanOleh: diajukanOleh,
      timestamp: timestamp,
      status: status ?? this.status,
      isUrgent: isUrgent,
    );
  }
}

class ApprovalPengujiScreen extends StatefulWidget {
  const ApprovalPengujiScreen({super.key});

  @override
  State<ApprovalPengujiScreen> createState() => _ApprovalPengujiScreenState();
}

class _ApprovalPengujiScreenState extends State<ApprovalPengujiScreen> {
  int _selectedFilter = 0; // 0 = Menunggu, 1 = Disetujui, 2 = Ditolak, 3 = Semua

  List<RequestGantiPengujiModel> _requests = [
    const RequestGantiPengujiModel(
      id: '1',
      mahasiswaNama: 'Budi Setiawan',
      nim: '1202184001',
      jadwalSidang: 'Senin, 3 Juni 2024',
      waktuSidang: '10:00 - 12:00',
      oldPenguji: 'Dr. Siti Aminah',
      newPenguji: 'Dr. Ahmad Fauzi',
      alasan:
          'Dr. Siti Aminah berhalangan hadir karena mewakili kampus dalam conference internasional di Singapura.',
      diajukanOleh: 'Dr. Heru Setiawan',
      timestamp: '2 jam lalu',
      status: RequestStatus.pending,
      isUrgent: true,
    ),
    const RequestGantiPengujiModel(
      id: '2',
      mahasiswaNama: 'Anisa Maharani',
      nim: '1202184002',
      jadwalSidang: 'Selasa, 4 Juni 2024',
      waktuSidang: '09:00 - 11:00',
      oldPenguji: 'Dr. Ahmad',
      newPenguji: 'Dr. Siti Aminah',
      alasan:
          'Usai conference, jadwal sudah bisa disesuaikan kembali dengan Dr. Siti Aminah.',
      diajukanOleh: 'Dr. Heru Setiawan',
      timestamp: '5 jam lalu',
      status: RequestStatus.pending,
      isUrgent: false,
    ),
    const RequestGantiPengujiModel(
      id: '3',
      mahasiswaNama: 'Dian Permana',
      nim: '1202184003',
      jadwalSidang: 'Rabu, 5 Juni 2024',
      waktuSidang: '13:00 - 15:00',
      oldPenguji: 'Dr. Budi Santoso',
      newPenguji: 'Dr. Heru Setiawan',
      alasan: 'Dr. Budi Santoso sakit dan tidak bisa hadir.',
      diajukanOleh: 'Operator FTEN',
      timestamp: '1 hari lalu',
      status: RequestStatus.disetujui,
      isUrgent: false,
    ),
  ];

  List<RequestGantiPengujiModel> get _filteredRequests {
    switch (_selectedFilter) {
      case 0:
        return _requests
            .where((r) => r.status == RequestStatus.pending)
            .toList();
      case 1:
        return _requests
            .where((r) => r.status == RequestStatus.disetujui)
            .toList();
      case 2:
        return _requests
            .where((r) => r.status == RequestStatus.ditolak)
            .toList();
      default:
        return _requests;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        _requests.where((r) => r.status == RequestStatus.pending).length;
    final filtered = _filteredRequests;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Approval Ganti Penguji'),
            if (pendingCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterChips(pendingCount),
          if (filtered.isEmpty)
            Expanded(child: _buildEmptyState())
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return ApprovalRequestCard(
                    request: filtered[index],
                    onSetuju: () => _handleSetuju(filtered[index]),
                    onTolak: () => _handleTolak(filtered[index]),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(int pendingCount) {
    final filters = [
      ('Menunggu', pendingCount),
      ('Disetujui', 0),
      ('Ditolak', 0),
      ('Semua', _requests.length),
    ];

    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Row(
          children: filters.asMap().entries.map((entry) {
            final index = entry.key;
            final label = entry.value.$1;
            final count = entry.value.$2;
            final isSelected = _selectedFilter == index;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(
                  count > 0 ? '$label ($count)' : label,
                ),
                onSelected: (_) {
                  setState(() => _selectedFilter = index);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final labels = ['Menunggu', 'Disetujui', 'Ditolak', 'Semua'];
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _selectedFilter == 0
                ? Icons.check_circle_outline_rounded
                : Icons.inbox_outlined,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada request ${labels[_selectedFilter].toLowerCase()}',
            style:
                AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          if (_selectedFilter == 0) ...[
            const SizedBox(height: 8),
            Text(
              'Semua request sudah diproses',
              style: AppTheme.caption,
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleSetuju(RequestGantiPengujiModel request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setuju Perubahan?'),
        content: Text(
          'Setujui pergantian penguji untuk ${request.mahasiswaNama}?\n\n'
          '${request.oldPenguji} → ${request.newPenguji}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Setuju'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() {
        final idx = _requests.indexWhere((r) => r.id == request.id);
        if (idx != -1) {
          _requests[idx] = _requests[idx].copyWith(
            status: RequestStatus.disetujui,
          );
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Request berhasil disetujui'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  Future<void> _handleTolak(RequestGantiPengujiModel request) async {
    final reasonController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tolak Perubahan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tolak pergantian penguji untuk ${request.mahasiswaNama}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: InputDecoration(
                labelText: 'Alasan penolakan (opsional)',
                hintText: 'Masukkan alasan...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    reasonController.dispose();

    if (confirmed == true && mounted) {
      setState(() {
        final idx = _requests.indexWhere((r) => r.id == request.id);
        if (idx != -1) {
          _requests[idx] =
              _requests[idx].copyWith(status: RequestStatus.ditolak);
        }
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Request ditolak'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }
}

// ── Request Card ──────────────────────────────────────────────────────────
class ApprovalRequestCard extends StatefulWidget {
  final RequestGantiPengujiModel request;
  final VoidCallback? onSetuju;
  final VoidCallback? onTolak;

  const ApprovalRequestCard({
    super.key,
    required this.request,
    this.onSetuju,
    this.onTolak,
  });

  @override
  State<ApprovalRequestCard> createState() => _ApprovalRequestCardState();
}

class _ApprovalRequestCardState extends State<ApprovalRequestCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.request.isUrgent) _buildUrgentBadge(),
            _buildHeader(),
            const SizedBox(height: 14),
            _buildExaminerChange(),
            const SizedBox(height: 12),
            _buildAlasan(),
            const SizedBox(height: 10),
            _buildFooter(),
            if (widget.request.status == RequestStatus.pending) ...[
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 10),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentBadge() {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.priority_high_rounded,
              size: 12, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            'MENDESAK',
            style: AppTheme.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.request.mahasiswaNama,
                style: AppTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.request.nim,
                style: AppTheme.bodySmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                widget.request.jadwalSidang,
                style: AppTheme.caption.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                widget.request.waktuSidang,
                style: AppTheme.caption
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExaminerChange() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penguji Lama',
                    style: AppTheme.caption
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 2),
                Text(
                  widget.request.oldPenguji,
                  style: AppTheme.bodySmall.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              color: AppColors.textSecondary,
              size: 16,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Penguji Baru',
                    style: AppTheme.caption
                        .copyWith(color: AppColors.textTertiary)),
                const SizedBox(height: 2),
                Text(
                  widget.request.newPenguji,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlasan() {
    final isLong = widget.request.alasan.length > 100;
    final displayText = _expanded || !isLong
        ? widget.request.alasan
        : '${widget.request.alasan.substring(0, 100)}...';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Alasan',
          style: AppTheme.caption
              .copyWith(color: AppColors.textTertiary, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          displayText,
          style: AppTheme.bodySmall.copyWith(color: AppColors.textSecondary),
        ),
        if (isLong)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Tutup' : 'Selengkapnya',
              style: AppTheme.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        const Icon(Icons.person_outline_rounded,
            size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            'Oleh ${widget.request.diajukanOleh} • ${widget.request.timestamp}',
            style: AppTheme.caption.copyWith(color: AppColors.textTertiary),
          ),
        ),
        if (widget.request.status != RequestStatus.pending)
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: widget.request.status == RequestStatus.disetujui
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.request.status == RequestStatus.disetujui
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 12,
                  color: widget.request.status == RequestStatus.disetujui
                      ? AppColors.success
                      : AppColors.error,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.request.status == RequestStatus.disetujui
                      ? 'Disetujui'
                      : 'Ditolak',
                  style: AppTheme.caption.copyWith(
                    color: widget.request.status == RequestStatus.disetujui
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onTolak,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('Tolak'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: widget.onSetuju,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            icon: const Icon(Icons.check_rounded, size: 16),
            label: const Text('Setujui'),
          ),
        ),
      ],
    );
  }
}