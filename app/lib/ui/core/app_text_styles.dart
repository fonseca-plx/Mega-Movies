import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_movies/ui/core/app_colors.dart';

/// Centralised typography scale from DESIGN.md.
///
/// Editorial / titles → Noto Serif
/// Functional / UI → Be Vietnam Pro
abstract final class AppTextStyles {
  // --- Display (Noto Serif) ---

  /// 48px • 700 weight • −0.02em tracking
  static TextStyle get displayLg => GoogleFonts.notoSerif(
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.02 * 48,
    color: AppColors.onSurface,
  );

  /// 36px • 600 weight • −0.01em tracking
  static TextStyle get displayMd => GoogleFonts.notoSerif(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.01 * 36,
    color: AppColors.onSurface,
  );

  // --- Headlines ---

  /// 28px Noto Serif • 600 weight
  static TextStyle get headlineLg => GoogleFonts.notoSerif(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: AppColors.onSurface,
  );

  /// 20px Be Vietnam Pro • 600 weight
  static TextStyle get headlineMd => GoogleFonts.beVietnamPro(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.onSurface,
  );

  // --- Body (Be Vietnam Pro) ---

  /// 18px • 400 weight
  static TextStyle get bodyLg => GoogleFonts.beVietnamPro(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.onSurface,
  );

  /// 16px • 400 weight
  static TextStyle get bodyMd => GoogleFonts.beVietnamPro(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.onSurface,
  );

  // --- Labels (Be Vietnam Pro) ---

  /// 14px • 600 weight • +0.05em tracking
  static TextStyle get labelLg => GoogleFonts.beVietnamPro(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.05 * 14,
    color: AppColors.onSurface,
  );

  /// 12px • 500 weight
  static TextStyle get labelSm => GoogleFonts.beVietnamPro(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.2,
    color: AppColors.onSurface,
  );
}
