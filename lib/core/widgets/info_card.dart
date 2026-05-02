import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// Kartu informasi dengan ikon, judul, dan nilai
/// Digunakan untuk menampilkan statistik atau ringkasan
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final String? subtitle;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppTheme.borderRadiusMedium,
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon Container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: cardColor.withValues(alpha: 0.1),
                borderRadius: AppTheme.borderRadiusSmall,
              ),
              child: Icon(icon, color: cardColor, size: 22),
            ),
            const SizedBox(height: AppTheme.spacing12),

            // Value
            Text(
              value,
              style: AppTheme.headingLarge.copyWith(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppTheme.spacing4),

            // Title
            Text(
              title,
              style: AppTheme.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Subtitle (optional)
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacing4),
              Text(
                subtitle!,
                style: AppTheme.caption.copyWith(
                  color: cardColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
