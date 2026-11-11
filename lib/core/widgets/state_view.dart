import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import '../utils/responsive.dart';
import 'app_button.dart';

/// Centered icon + title + message + action, used by the Error and Empty
/// screens of the design.
class StateView extends StatelessWidget {
  const StateView({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.actionIcon,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(Responsive.pagePadding(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isMobile ? AppSpacing.huge : AppSizes.iconXl,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              title,
              textAlign: TextAlign.center,
              style: isMobile ? AppTextStyles.title : AppTextStyles.headline,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.body,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: AppSpacing.xxxl),
              AppButton(
                label: actionLabel!,
                icon: actionIcon,
                onPressed: onAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
