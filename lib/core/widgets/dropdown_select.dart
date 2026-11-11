import 'package:flutter/material.dart';

import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';

/// "Select / Season" and "Select / Sort": 44 high raised box with a chevron
/// that opens a menu.
class DropdownSelect<T> extends StatelessWidget {
  const DropdownSelect({
    super.key,
    required this.value,
    required this.options,
    required this.labelOf,
    required this.onChanged,
    this.width = 200,
  });

  final T value;
  final List<T> options;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final double width;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      tooltip: '',
      initialValue: value,
      position: PopupMenuPosition.under,
      color: AppColors.surfaceRaised,
      constraints: BoxConstraints(minWidth: width),
      onSelected: onChanged,
      itemBuilder: (_) => [
        for (final option in options)
          PopupMenuItem(value: option, child: Text(labelOf(option))),
      ],
      child: Container(
        width: width,
        height: AppSizes.buttonHeightSm,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                labelOf(value),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyStrong,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
