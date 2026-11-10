import 'package:flutter/material.dart';

import '../theme/app_tokens.g.dart';

/// Penpot "Button/Primary": red, icon + label, 48px tall.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.play_arrow_rounded,
    this.height = 48,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(minimumSize: Size(0, height));
    final text = Text(label, overflow: TextOverflow.ellipsis);
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: AppSizes.iconMd),
            label: text,
          );
  }
}

/// Penpot "Button/Secondary": translucent white, icon + label, 48px tall.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon = Icons.info_outline_rounded,
    this.height = 48,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final double height;

  @override
  Widget build(BuildContext context) {
    final style = FilledButton.styleFrom(
      minimumSize: Size(0, height),
      backgroundColor: AppColors.onPrimary.withValues(alpha: 0.16),
      foregroundColor: AppColors.textPrimary,
    );
    final text = Text(label, overflow: TextOverflow.ellipsis);
    return icon == null
        ? FilledButton(onPressed: onPressed, style: style, child: text)
        : FilledButton.icon(
            onPressed: onPressed,
            style: style,
            icon: Icon(icon, size: AppSizes.iconMd),
            label: text,
          );
  }
}
