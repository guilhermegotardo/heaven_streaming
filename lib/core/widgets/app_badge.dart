import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';

/// "Badge": small outlined label such as "16+" or "HD".
class AppBadge extends StatelessWidget {
  const AppBadge(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          fontWeight: AppFontWeight.semibold,
        ),
      ),
    );
  }
}
