import 'package:flutter/material.dart';

/// Cinematic Noir color palette from DESIGN.md.
abstract final class AppColors {
  // Surfaces
  static const Color surface = Color(0xFF121317);
  static const Color surfaceDim = Color(0xFF121317);
  static const Color surfaceBright = Color(0xFF38393D);
  static const Color surfaceContainerLowest = Color(0xFF0D0E12);
  static const Color surfaceContainerLow = Color(0xFF1A1B1F);
  static const Color surfaceContainer = Color(0xFF1E1F23);
  static const Color surfaceContainerHigh = Color(0xFF292A2E);
  static const Color surfaceContainerHighest = Color(0xFF343539);
  static const Color surfaceVariant = Color(0xFF343539);

  // On-surface content
  static const Color onSurface = Color(0xFFE3E2E7);
  static const Color onSurfaceVariant = Color(0xFFC4C7C7);
  static const Color inverseSurface = Color(0xFFE3E2E7);
  static const Color inverseOnSurface = Color(0xFF2F3034);

  // Outlines
  static const Color outline = Color(0xFF8E9192);
  static const Color outlineVariant = Color(0xFF444748);

  // Primary – silver/off-white
  static const Color primary = Color(0xFFC9C6C5);
  static const Color onPrimary = Color(0xFF313030);
  static const Color primaryContainer = Color(0xFF0A0A0A);
  static const Color onPrimaryContainer = Color(0xFF7B7979);

  // Secondary – warm grey
  static const Color secondary = Color(0xFFC8C6C5);
  static const Color onSecondary = Color(0xFF303030);
  static const Color secondaryContainer = Color(0xFF474746);
  static const Color onSecondaryContainer = Color(0xFFB7B5B4);

  // Tertiary – Luxurious Gold (branding accent)
  static const Color tertiary = Color(0xFFE9C176);
  static const Color gold = Color(0xFFC5A059);
  static const Color onTertiary = Color(0xFF412D00);
  static const Color tertiaryContainer = Color(0xFF100900);
  static const Color onTertiaryContainer = Color(0xFF957432);

  // CTA – Metallic Blue (primary button gradient)
  static const Color metallicBlueLight = Color(0xFF38BDF8);
  static const Color metallicBlueDark = Color(0xFF0284C7);

  // Error
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);

  // Graphite (for card backgrounds per spec Level 1)
  static const Color graphite = Color(0xFF1C1C1C);

  // Glass overlay colours
  static const Color glassPanel = Color(0x991C1C1C); // 60% opacity graphite
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white
}
