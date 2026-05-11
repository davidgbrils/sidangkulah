import 'package:flutter/material.dart';

/// Konstanta warna aplikasi SidangKu
/// Menggunakan design system yang konsisten - Deep Navy Theme
class AppColors {
  AppColors._();

  // ── Brand Colors (Deep Navy) ─────────────────────────────────────────────
  static const Color primary = Color(0xFF001E40);
  static const Color primaryLight = Color(0xFF003366);
  static const Color primaryDark = Color(0xFF001640);
  static const Color primaryContainer = Color(0xFF003366);
  static const Color onPrimaryContainer = Color(0xFF799DD6);

  // ── Secondary Colors ───────────────────────────────────────────────
  static const Color secondary = Color(0xFF575F65);
  static const Color secondaryContainer = Color(0xFFDBE3EA);

  // ── Surface & Background ─────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFD3E4FE);
  static const Color surfaceContainer = Color(0xFFE5EEFF);
  static const Color surfaceContainerLow = Color(0xFFEFF4FF);
  static const Color surfaceContainerHigh = Color(0xFFDCE9FF);
  static const Color surfaceContainerHighest = Color(0xFFD3E4FE);
  static const Color surfaceDim = Color(0xFFCBDBF5);
  static const Color surfaceBright = Color(0xFFF8F9FF);
  static const Color scaffoldBackground = Color(0xFFF8F9FF);

  // ── Status Colors ─────────────────────────────────────────────────────
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFF57C00);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF3A5F94);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ── Tertiary Colors (Untuk khusus dosen yang perlu teal) ──────────────
  static const Color tertiary = Color(0xFF00897B);
  static const Color tertiaryFixed = Color(0xFFFFDEA6);
  static const Color tertiaryContainer = Color(0xFF452F00);

  // ── Text Colors ───────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1C1E);
  static const Color textSecondary = Color(0xFF5F6368);
  static const Color textTertiary = Color(0xFF9AA0A6);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── Border & Divider ──────────────────────────────────────────────────
  static const Color border = Color(0xFFE0E3E8);
  static const Color borderLight = Color(0xFFF0F2F5);
  static const Color divider = Color(0xFFEEF1F6);

  // ── Status Chip Colors ────────────────────────────────────────────────
  static const Color chipScheduledBg = Color(0xFFE3F2FD);
  static const Color chipScheduledFg = Color(0xFF1565C0);

  static const Color chipDoneBg = Color(0xFFE8F5E9);
  static const Color chipDoneFg = Color(0xFF388E3C);

  static const Color chipRevisionBg = Color(0xFFFFF3E0);
  static const Color chipRevisionFg = Color(0xFFF57C00);

  static const Color chipPendingBg = Color(0xFFFFF8E1);
  static const Color chipPendingFg = Color(0xFFF9A825);

  static const Color chipApprovedBg = Color(0xFFE8F5E9);
  static const Color chipApprovedFg = Color(0xFF2E7D32);

  static const Color chipRejectedBg = Color(0xFFFFEBEE);
  static const Color chipRejectedFg = Color(0xFFD32F2F);

  // ── Shadow ────────────────────────────────────────────────────────────
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // ── Gradient ──────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryLight],
  );

  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryLight, primary],
  );
}
