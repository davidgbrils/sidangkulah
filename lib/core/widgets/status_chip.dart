import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// Tipe status chip
enum StatusChipType {
  scheduled,
  done,
  revision,
  pending,
  approved,
  rejected,
}

/// Chip status untuk menampilkan status sidang/berkas
class StatusChip extends StatelessWidget {
  final String label;
  final StatusChipType type;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const StatusChip({
    super.key,
    required this.label,
    required this.type,
    this.fontSize,
    this.padding,
  });

  /// Factory constructor dari string status
  factory StatusChip.fromString(String status) {
    final statusLower = status.toLowerCase();
    StatusChipType chipType;
    String chipLabel;

    switch (statusLower) {
      case 'scheduled':
      case 'terjadwal':
        chipType = StatusChipType.scheduled;
        chipLabel = 'Terjadwal';
        break;
      case 'done':
      case 'selesai':
        chipType = StatusChipType.done;
        chipLabel = 'Selesai';
        break;
      case 'revision':
      case 'revisi':
        chipType = StatusChipType.revision;
        chipLabel = 'Revisi';
        break;
      case 'pending':
      case 'menunggu':
        chipType = StatusChipType.pending;
        chipLabel = 'Menunggu';
        break;
      case 'approved':
      case 'disetujui':
        chipType = StatusChipType.approved;
        chipLabel = 'Disetujui';
        break;
      case 'rejected':
      case 'ditolak':
        chipType = StatusChipType.rejected;
        chipLabel = 'Ditolak';
        break;
      default:
        chipType = StatusChipType.pending;
        chipLabel = status;
    }

    return StatusChip(label: chipLabel, type: chipType);
  }

  Color get _backgroundColor {
    switch (type) {
      case StatusChipType.scheduled:
        return AppColors.chipScheduledBg;
      case StatusChipType.done:
        return AppColors.chipDoneBg;
      case StatusChipType.revision:
        return AppColors.chipRevisionBg;
      case StatusChipType.pending:
        return AppColors.chipPendingBg;
      case StatusChipType.approved:
        return AppColors.chipApprovedBg;
      case StatusChipType.rejected:
        return AppColors.chipRejectedBg;
    }
  }

  Color get _foregroundColor {
    switch (type) {
      case StatusChipType.scheduled:
        return AppColors.chipScheduledFg;
      case StatusChipType.done:
        return AppColors.chipDoneFg;
      case StatusChipType.revision:
        return AppColors.chipRevisionFg;
      case StatusChipType.pending:
        return AppColors.chipPendingFg;
      case StatusChipType.approved:
        return AppColors.chipApprovedFg;
      case StatusChipType.rejected:
        return AppColors.chipRejectedFg;
    }
  }

  IconData get _icon {
    switch (type) {
      case StatusChipType.scheduled:
        return Icons.schedule_rounded;
      case StatusChipType.done:
        return Icons.check_circle_rounded;
      case StatusChipType.revision:
        return Icons.edit_note_rounded;
      case StatusChipType.pending:
        return Icons.hourglass_empty_rounded;
      case StatusChipType.approved:
        return Icons.verified_rounded;
      case StatusChipType.rejected:
        return Icons.cancel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppTheme.spacing12,
            vertical: AppTheme.spacing4 + 2,
          ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: AppTheme.borderRadiusPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_icon, size: 14, color: _foregroundColor),
          const SizedBox(width: AppTheme.spacing4),
          Text(
            label,
            style: AppTheme.caption.copyWith(
              color: _foregroundColor,
              fontWeight: FontWeight.w600,
              fontSize: fontSize ?? 12,
            ),
          ),
        ],
      ),
    );
  }
}
