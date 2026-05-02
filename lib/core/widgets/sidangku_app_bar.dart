import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../theme/app_theme.dart';

/// AppBar kustom SidangKu dengan gradient dan gaya konsisten
class SidangkuAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final List<Widget>? actions;
  final Widget? leading;
  final bool useGradient;
  final double elevation;

  const SidangkuAppBar({
    super.key,
    required this.title,
    this.showBack = true,
    this.actions,
    this.leading,
    this.useGradient = false,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        title,
        style: AppTheme.headingMedium.copyWith(
          color: AppColors.textOnPrimary,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      elevation: elevation,
      backgroundColor: useGradient ? Colors.transparent : AppColors.primary,
      leading: showBack
          ? (leading ??
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                onPressed: () => Navigator.of(context).maybePop(),
                color: AppColors.textOnPrimary,
              ))
          : leading,
      automaticallyImplyLeading: showBack,
      actions: actions,
    );

    if (useGradient) {
      return Container(
        decoration: const BoxDecoration(gradient: AppColors.headerGradient),
        child: appBar,
      );
    }

    return appBar;
  }
}
