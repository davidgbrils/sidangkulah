import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// Tipe tombol SidangKu
enum SidangkuButtonType { primary, secondary, outlined, danger }

/// Tombol kustom SidangKu dengan berbagai tipe dan animasi tekan
class SidangkuButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final SidangkuButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const SidangkuButton({
    super.key,
    required this.label,
    this.onTap,
    this.type = SidangkuButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height ?? 48,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    switch (type) {
      case SidangkuButtonType.primary:
        return _PrimaryButton(
          label: label,
          onTap: onTap,
          icon: icon,
          isLoading: isLoading,
          padding: padding,
        );
      case SidangkuButtonType.secondary:
        return _SecondaryButton(
          label: label,
          onTap: onTap,
          icon: icon,
          isLoading: isLoading,
          padding: padding,
        );
      case SidangkuButtonType.outlined:
        return _OutlinedBtn(
          label: label,
          onTap: onTap,
          icon: icon,
          isLoading: isLoading,
          padding: padding,
        );
      case SidangkuButtonType.danger:
        return _DangerButton(
          label: label,
          onTap: onTap,
          icon: icon,
          isLoading: isLoading,
          padding: padding,
        );
    }
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const _PrimaryButton({
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadiusMedium,
        ),
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const _SecondaryButton({
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.1),
        foregroundColor: AppColors.primary,
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadiusMedium,
        ),
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.primary,
      ),
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const _OutlinedBtn({
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadiusMedium,
        ),
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.primary,
      ),
    );
  }
}

class _DangerButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;

  const _DangerButton({
    required this.label,
    this.onTap,
    this.icon,
    this.isLoading = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.textOnPrimary,
        disabledBackgroundColor: AppColors.error.withValues(alpha: 0.5),
        elevation: 0,
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.borderRadiusMedium,
        ),
      ),
      child: _ButtonContent(
        label: label,
        icon: icon,
        isLoading: isLoading,
        color: AppColors.textOnPrimary,
      ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isLoading;
  final Color color;

  const _ButtonContent({
    required this.label,
    this.icon,
    this.isLoading = false,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppTheme.spacing8),
          Text(
            label,
            style: AppTheme.button.copyWith(color: color),
          ),
        ],
      );
    }

    return Text(
      label,
      style: AppTheme.button.copyWith(color: color),
    );
  }
}
