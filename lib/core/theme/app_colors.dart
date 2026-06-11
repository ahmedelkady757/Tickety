import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF1E6FF1);
  static const Color primaryLight = Color(0xFF5B97FF);
  static const Color primaryDark = Color(0xFF1250B8);
  static const Color primarySurface = Color(0xFFE8F0FE);

  // Accent
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFD5F5E3);
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFDECEB);
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFEF9E7);

  // Neutral – Light Mode
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F6FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color border = Color(0xFFE0E0E0);
  static const Color shimmerBase = Color(0xFFEEEEEE);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textDisabled = Color(0xFFBDBDBD);

  // Category chip colors
  static const Color chipSelected = primary;
  static const Color chipUnselected = Color(0xFFF5F6FA);
  static const Color chipTextSelected = Colors.white;
  static const Color chipTextUnselected = textPrimary;

  // Bottom nav
  static const Color bottomNavBackground = Colors.white;
  static const Color bottomNavSelected = primary;
  static const Color bottomNavUnselected = Color(0xFFBDBDBD);

  // Misc
  static const Color priceTag = primary;
  static const Color heartFilled = Color(0xFFE74C3C);
  static const Color heartEmpty = Color(0xFFBDBDBD);
  static const Color starFilled = Color(0xFFF1C40F);
  static const Color overlay = Color(0x80000000);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E6FF1), Color(0xFF5B97FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0x001A1A2E), Color(0xCC1A1A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient bannerGradient = LinearGradient(
    colors: [Color(0xFF1E6FF1), Color(0xFF1250B8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
