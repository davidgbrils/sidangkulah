import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

/// Tema Material 3 untuk aplikasi SidangKu
class AppTheme {
  AppTheme._();

  // ── Spacing System ────────────────────────────────────────────────────
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;

  // ── Border Radius ─────────────────────────────────────────────────────
  static const double radiusSmall = 8;
  static const double radiusMedium = 12;
  static const double radiusLarge = 16;
  static const double radiusPill = 100;

  static BorderRadius borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static BorderRadius borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static BorderRadius borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static BorderRadius borderRadiusPill = BorderRadius.circular(radiusPill);

  // ── Shadows ───────────────────────────────────────────────────────────
  static List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
  ];

  // ── Typography ────────────────────────────────────────────────────────
  static TextStyle get _baseTextStyle => GoogleFonts.plusJakartaSans();

  static TextStyle headingLarge = _baseTextStyle.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingMedium = _baseTextStyle.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headingSmall = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle bodyLarge = _baseTextStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle caption = _baseTextStyle.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  static TextStyle labelMedium = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle button = _baseTextStyle.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ── Light Theme ───────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface,
      error: AppColors.error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,
      brightness: Brightness.light,

      // Typography
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: _baseTextStyle.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
        displayMedium: _baseTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
        displaySmall: _baseTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.w600),
        headlineLarge: headingLarge,
        headlineMedium: headingMedium,
        headlineSmall: headingSmall,
        titleLarge: _baseTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
        titleMedium: _baseTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        titleSmall: _baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: button,
        labelMedium: labelMedium,
        labelSmall: caption,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _baseTextStyle.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnPrimary),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          minimumSize: const Size(88, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusMedium,
          ),
          textStyle: button,
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          minimumSize: const Size(88, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusMedium,
          ),
          textStyle: button.copyWith(color: AppColors.primary),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: button.copyWith(color: AppColors.primary),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        constraints: const BoxConstraints(minHeight: 56, maxHeight: 56),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadiusMedium,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        hintStyle: bodyMedium.copyWith(color: AppColors.textTertiary),
        labelStyle: labelMedium,
        errorStyle: caption.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.textSecondary,
        suffixIconColor: AppColors.textSecondary,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariant,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusPill,
        ),
        side: BorderSide.none,
        labelStyle: _baseTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: _baseTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _baseTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w400),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
        ),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadiusLarge,
        ),
        titleTextStyle: headingMedium,
        contentTextStyle: bodyMedium,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        showDragHandle: true,
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: bodyMedium.copyWith(color: AppColors.textOnDark),
        shape: RoundedRectangleBorder(borderRadius: borderRadiusSmall),
        behavior: SnackBarBehavior.floating,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // Tab Bar
      tabBarTheme: TabBarThemeData(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiary,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: _baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: _baseTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w400),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return AppColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary.withValues(alpha: 0.3);
          return AppColors.border;
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return AppColors.primary;
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(AppColors.textOnPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: const BorderSide(color: AppColors.border, width: 1.5),
      ),
    );
  }
}
