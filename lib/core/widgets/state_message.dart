import 'package:flutter/material.dart';

import '../theme/app_tokens.g.dart';
import 'app_buttons.dart';

/// Centered icon + title + message + optional action — the error and empty
/// states from the Penpot template.
class StateMessage extends StatelessWidget {
  const StateMessage({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.iconColor = AppColors.textDisabled,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String? message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: iconColor),
            const SizedBox(height: AppSpacing.xl),
            Text(title, style: theme.headlineMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message!, style: theme.bodyLarge?.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              PrimaryButton(label: actionLabel!, icon: actionIcon, onPressed: onAction),
            ],
          ],
        ),
      ),
    );
  }
}
