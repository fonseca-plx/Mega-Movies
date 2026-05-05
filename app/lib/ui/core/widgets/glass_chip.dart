import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';

/// A pill-shaped glass-morphism chip used for genre tags and badges.
class GlassChip extends StatelessWidget {
  const GlassChip({super.key, required this.label, this.isFeatured = false});

  final String label;
  final bool isFeatured;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(26),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Text(
            label,
            style: AppTextStyles.labelSm.copyWith(
              color: isFeatured ? AppColors.tertiary : AppColors.onSurface,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
