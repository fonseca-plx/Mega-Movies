import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_movies/ui/core/app_colors.dart';

/// Centralised [ThemeData] for the Cinematic Noir design system.
final class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.inverseOnSurface,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainerHighest: AppColors.surfaceContainerHighest,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.surface,
      textTheme: GoogleFonts.beVietnamProTextTheme(ThemeData.dark().textTheme),
      // Shapes: 4px for buttons/inputs, 8px for cards (per DESIGN.md)
      cardTheme: CardThemeData(
        color: AppColors.graphite,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColors.glassBorder),
        ),
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.graphite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: AppColors.metallicBlueDark),
        ),
        hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.metallicBlueDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Color.fromARGB(230, 0, 0, 0),
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 10,
            letterSpacing: 0.8,
            fontWeight: FontWeight.w500,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.metallicBlueLight,
              size: 24,
            );
          }
          return const IconThemeData(
            color: AppColors.onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      navigationRailTheme: const NavigationRailThemeData(
        backgroundColor: AppColors.surfaceContainerHighest,
        indicatorColor: Colors.transparent,
        selectedIconTheme: IconThemeData(
          color: AppColors.metallicBlueLight,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.onSurfaceVariant,
          size: 24,
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.glassBorder),
      iconTheme: const IconThemeData(color: AppColors.onSurfaceVariant),
    );
  }
}
