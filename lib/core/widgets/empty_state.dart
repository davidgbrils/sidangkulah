import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// Widget untuk menampilkan state kosong/empty
/// Digunakan ketika data belum ada atau tidak ditemukan
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double? iconSize;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.iconSize,
  });

  /// Factory: belum ada data
  factory EmptyState.noData({
    String? title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inbox_rounded,
      title: title ?? 'Belum Ada Data',
      subtitle: subtitle ?? 'Data akan muncul di sini',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Factory: data tidak ditemukan
  factory EmptyState.notFound({
    String? title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.search_off_rounded,
      title: title ?? 'Data Tidak Ditemukan',
      subtitle: subtitle ?? 'Coba ubah kata kunci pencarian Anda',
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Factory: error
  factory EmptyState.error({
    String? title,
    String? subtitle,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.error_outline_rounded,
      title: title ?? 'Terjadi Kesalahan',
      subtitle: subtitle ?? 'Silakan coba lagi nanti',
      actionLabel: actionLabel ?? 'Coba Lagi',
      onAction: onAction,
    );
  }

  /// Factory: tidak ada koneksi
  factory EmptyState.noConnection({
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.wifi_off_rounded,
      title: 'Tidak Ada Koneksi',
      subtitle: 'Periksa koneksi internet Anda dan coba lagi',
      actionLabel: actionLabel ?? 'Coba Lagi',
      onAction: onAction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: (iconSize ?? 64) + 32,
              height: (iconSize ?? 64) + 32,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: iconSize ?? 64,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: AppTheme.spacing24),

            // Title
            Text(
              title,
              style: AppTheme.headingMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),

            // Subtitle
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacing8),
              Text(
                subtitle!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Action Button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppTheme.spacing24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing24,
                    vertical: AppTheme.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppTheme.borderRadiusMedium,
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
