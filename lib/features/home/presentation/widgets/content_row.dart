import 'package:flutter/material.dart';

import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/utils/responsive.dart';

/// A titled horizontal rail: "Trending Now  ……  See all >".
class ContentRow extends StatelessWidget {
  const ContentRow({
    super.key,
    required this.title,
    required this.height,
    required this.itemCount,
    required this.itemBuilder,
    this.spacing = AppSpacing.lg,
    this.onSeeAll,
  });

  final String title;
  final double height;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double spacing;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.pagePadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isMobile
                      ? AppTextStyles.titleSm.copyWith(
                          fontSize: AppFontSize.bodyLg,
                        )
                      : AppTextStyles.titleSm,
                ),
              ),
              if (onSeeAll != null)
                InkWell(
                  onTap: onSeeAll,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xs),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See all',
                          style: AppTextStyles.label.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        const Icon(
                          Icons.chevron_right,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: isMobile ? AppSpacing.md : AppSpacing.lg),
        SizedBox(
          height: height,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: EdgeInsets.symmetric(horizontal: padding),
            itemCount: itemCount,
            separatorBuilder: (_, _) => SizedBox(width: spacing),
            itemBuilder: itemBuilder,
          ),
        ),
        SizedBox(height: isMobile ? AppSpacing.xl : 44),
      ],
    );
  }
}
