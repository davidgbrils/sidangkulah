import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Widget avatar dengan inisial nama
/// Digunakan untuk menampilkan avatar user tanpa foto
class AvatarInitials extends StatelessWidget {
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final String? imageUrl;

  const AvatarInitials({
    super.key,
    required this.name,
    this.size = 40,
    this.backgroundColor,
    this.textColor,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final initials = Formatters.getInitials(name);
    final bgColor = backgroundColor ?? _getColorFromName(name);
    final fgColor = textColor ?? AppColors.textOnPrimary;

    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: size / 2,
        backgroundImage: NetworkImage(imageUrl!),
        backgroundColor: bgColor,
        child: null,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTheme.headingMedium.copyWith(
            fontSize: size * 0.36,
            fontWeight: FontWeight.w600,
            color: fgColor,
            height: 1,
          ),
        ),
      ),
    );
  }

  /// Warna otomatis berdasarkan hash nama
  Color _getColorFromName(String name) {
    final colors = [
      AppColors.primary,
      const Color(0xFF00897B), // Teal
      const Color(0xFF5E35B1), // Deep Purple
      const Color(0xFFE53935), // Red
      const Color(0xFF43A047), // Green
      const Color(0xFFFB8C00), // Orange
      const Color(0xFF3949AB), // Indigo
      const Color(0xFF00ACC1), // Cyan
      const Color(0xFF8E24AA), // Purple
      const Color(0xFFD81B60), // Pink
    ];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}
