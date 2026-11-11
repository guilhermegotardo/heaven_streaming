import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';

enum AppButtonVariant { primary, secondary, outline }

/// "Button / Primary", "Button / Secondary" and "Button / Outline" from the
/// design: 48 high, radius 8, label followed by an optional icon.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.expand = false,
    this.height = AppSizes.buttonHeight,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;

  /// Fills the available width (mobile layouts).
  final bool expand;
  final double height;

  @override
  Widget build(BuildContext context) {
    final (background, foreground, side) = switch (variant) {
      AppButtonVariant.primary => (
        AppColors.primary,
        AppColors.onPrimary,
        BorderSide.none,
      ),
      AppButtonVariant.secondary => (
        AppColors.onPrimary.withValues(alpha: 0.16),
        AppColors.textPrimary,
        BorderSide.none,
      ),
      AppButtonVariant.outline => (
        Colors.transparent,
        AppColors.textSecondary,
        const BorderSide(color: AppColors.textSecondary, width: 1.5),
      ),
    };

    return Opacity(
      opacity: onPressed == null ? AppOpacity.disabled : 1,
      child: SizedBox(
        height: height,
        width: expand ? double.infinity : null,
        child: Material(
          color: background,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
            side: side,
          ),
          child: InkWell(
            onTap: onPressed,
            hoverColor: AppColors.onPrimary.withValues(alpha: AppOpacity.hover),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyStrong.copyWith(
                        color: foreground,
                      ),
                    ),
                  ),
                  if (icon != null) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Icon(icon, size: AppSizes.iconMd, color: foreground),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// "Button / Icon": 48 circle with a 1.5 outline.
class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.textSecondary, width: 1.5),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox.square(
            dimension: AppSizes.buttonHeight,
            child: Icon(
              icon,
              size: AppSizes.iconMd,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
