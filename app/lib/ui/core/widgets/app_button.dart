import 'package:flutter/material.dart';
import 'package:mega_movies/ui/core/app_colors.dart';
import 'package:mega_movies/ui/core/app_text_styles.dart';

enum _ButtonVariant { primary, secondary, ghost }

/// Metallic Blue primary button per DESIGN.md.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) => _AppButton(
    variant: _ButtonVariant.primary,
    label: label,
    onPressed: onPressed,
    icon: icon,
    isFullWidth: isFullWidth,
  );
}

/// Gold-bordered secondary button.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;

  @override
  Widget build(BuildContext context) => _AppButton(
    variant: _ButtonVariant.secondary,
    label: label,
    onPressed: onPressed,
    icon: icon,
    isFullWidth: isFullWidth,
  );
}

/// Muted ghost button.
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => _AppButton(
    variant: _ButtonVariant.ghost,
    label: label,
    onPressed: onPressed,
    icon: icon,
  );
}

class _AppButton extends StatefulWidget {
  const _AppButton({
    required this.variant,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isFullWidth = false,
  });

  final _ButtonVariant variant;
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isFullWidth;

  @override
  State<_AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<_AppButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    Widget content = Row(
      mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, size: 20, color: _iconColor),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: AppTextStyles.labelLg.copyWith(color: _textColor),
        ),
      ],
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: _decoration,
          child: content,
        ),
      ),
    );
  }

  Color get _textColor => switch (widget.variant) {
    _ButtonVariant.primary => Colors.white,
    _ButtonVariant.secondary => AppColors.gold,
    _ButtonVariant.ghost => AppColors.onSurfaceVariant,
  };

  Color get _iconColor => _textColor;

  BoxDecoration get _decoration => switch (widget.variant) {
    _ButtonVariant.primary => BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.metallicBlueLight, AppColors.metallicBlueDark],
      ),
      boxShadow: _hovered
          ? [
              BoxShadow(
                color: AppColors.metallicBlueDark.withAlpha(77),
                blurRadius: 15,
              ),
            ]
          : null,
    ),
    _ButtonVariant.secondary => BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      border: Border.all(color: AppColors.gold),
      color: _hovered ? AppColors.gold.withAlpha(26) : Colors.transparent,
    ),
    _ButtonVariant.ghost => BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: _hovered ? AppColors.surfaceContainerHigh : Colors.transparent,
    ),
  };
}
