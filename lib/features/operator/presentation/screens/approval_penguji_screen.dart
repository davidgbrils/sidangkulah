import 'package:flutter/material.dart';
import 'package:sidangkufix/core/constants/app_colors.dart';
import 'package:sidangkufix/core/theme/app_theme.dart';
import 'package:sidangkufix/core/widgets/avatar_initials.dart';

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
}

class ApprovalPengujiScreen extends StatefulWidget {
  const ApprovalPengujiScreen({super.key});

  @override
  State<ApprovalPengujiScreen> createState() => _ApprovalPengujiScreenState();
}

class _ApprovalPengujiScreenState extends State<ApprovalPengujiScreen> {
  int _selectedFilter = 0;
  bool _isLoading = false;

  final _requests = const [
    RequestGantiPengujiModel(
      id: '1',
      mahasiswaNama: 'Budi Setiawan',
      nim: '1202184001',
      jadwalSidang: 'Senin, 3 Juni 2024',
      waktuSidang: '10:00 - 12:00',
      oldPenguji: 'Dr. Siti Aminah',
      newPenguji: 'Dr. Ahmad Fauzi',
      alasan: 'Dr. Siti Aminah berhalangan hadir karena mewakili kampus dalam conference internasional',
      diajukanOleh: 'Dr. Heru Setiawan',
      timestamp: '2 jam lalu',
      status: RequestStatus.pending,
      isUrgent: true,
    ),
    RequestGantiPengujiModel(
      id: '2',
      mahasiswaNama: 'Anisa Maharani',
      nim: '1202184002',
      jadwalSidang: 'Selasa, 4 Juni 2024',
      waktuSidang: '09:00 - 11:00',
      oldPenguji: 'Dr. Ahmad',
      newPenguji: 'Dr. Siti Aminah',
      alasan: 'Usai conference, jadwal bisa disesuaikan',
      diajukanOleh: 'Dr. Heru Setiawan',
      timestamp: '5 jam lalu',
      status: RequestStatus.pending,
      isUrgent: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pendingCount = _requests
        .where((r) => r.status == RequestStatus.pending)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Approval Ganti Penguji'),
            if (pendingCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
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
          _buildFilterChips(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                return ApprovalRequestCard(
                  request: _requests[index],
                  onSetuju: () => _handleSetuju(_requests[index]),
                  onTolak: () => _handleTolak(_requests[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['Menunggu', 'Disetujui', 'Ditolak', 'Semua'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: filters.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = _selectedFilter == index;

          int count = 0;
          if (index == 0) {
            count = _requests.where((r) => r.status == RequestStatus.pending).length;
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: isSelected,
              label: Text(
                count > 0 ? '$label ($count)' : label,
              ),
              onSelected: (selected) {
                setState(() => _selectedFilter = index);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Future<void> _handleSetuju(RequestGantiPengujiModel request) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Setuju Perubahan?'),
        content: Text(
          'Apakah Anda menyetujui pergantian penguji untuk ${request.mahasiswaNama}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Setuju'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permintaan disetujui'),
          backgroundColor: AppColors.success,
        ),
      );
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
          children: [
            Text(
              'Apakah Anda menolak pergantian penguji untuk ${request.mahasiswaNama}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Alasan penolakan (opsional)',
                hintText: 'Masukkan alasan...',
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
              backgroundColor: AppColors.error,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Tolak'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1));
      setState(() => _isLoading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Permintaan ditolak'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

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
            const SizedBox(height: 16),
            _buildExaminerChange(),
            const SizedBox(height: 12),
            _buildAlasan(),
            const SizedBox(height: 12),
            _buildFooter(),
            if (widget.request.status == RequestStatus.pending) ...[
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUrgentBadge() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'MENDESAK',
        style: AppTheme.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
                style: AppTheme.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${widget.request.jadwalSidang}\n${widget.request.waktuSidang}',
            style: AppTheme.caption.copyWith(
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.request.oldPenguji,
                  style: AppTheme.bodySmall.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _expanded
              ? widget.request.alasan
              : widget.request.alasan.length > 100
                  ? '${widget.request.alasan.substring(0, 100)}...'
                  : widget.request.alasan,
          style: AppTheme.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        if (widget.request.alasan.length > 100)
          TextButton(
            onPressed: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Tutup' : 'Selengkapnya',
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Text(
          'Diajukan oleh ${widget.request.diajukanOleh}',
          style: AppTheme.caption.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.textTertiary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.request.timestamp,
          style: AppTheme.caption.copyWith(
            color: AppColors.textTertiary,
          ),
        ),
        const Spacer(),
        if (widget.request.status != RequestStatus.pending) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: widget.request.status == RequestStatus.disetujui
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
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
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: widget.onTolak,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
            ),
            child: const Text('Tolak'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: widget.onSetuju,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
            ),
            child: const Text('Setuju'),
          ),
        ),
      ],
    );
  }
}