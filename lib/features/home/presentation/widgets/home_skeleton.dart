import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.g.dart';

/// Placeholder layout shown while the catalog loads (Penpot "Loading" screen).
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 700;
        final hp = compact ? AppSpacing.lg : AppSpacing.huge;
        final posterWidth = compact ? 110.0 : AppSizes.posterWidth;
        final heroHeight = compact ? 440.0 : (constraints.maxHeight * 0.7).clamp(360.0, 760.0);

        Widget block(double w, double h, {double radius = AppRadius.sm}) => Container(
              width: w,
              height: h,
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(radius),
              ),
            );

        return ClipRect(
          child: OverflowBox(
            alignment: Alignment.topLeft,
            maxHeight: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: heroHeight,
                  color: AppColors.surface,
                  padding: EdgeInsets.fromLTRB(hp, 0, hp, heroHeight * 0.12),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      block(120, 14),
                      const SizedBox(height: AppSpacing.md),
                      block(compact ? 240 : 560, compact ? 36 : 64, radius: AppRadius.md),
                      const SizedBox(height: AppSpacing.lg),
                      block(compact ? 200 : 420, 16),
                      const SizedBox(height: AppSpacing.sm),
                      block(compact ? 160 : 360, 16),
                      const SizedBox(height: AppSpacing.xl),
                      block(compact ? 260 : 300, 48, radius: AppRadius.md),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                for (var row = 0; row < 2; row++) ...[
                  Padding(padding: EdgeInsets.only(left: hp), child: block(180, 20)),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: posterWidth * 1.5,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: hp),
                      itemCount: 12,
                      separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
                      itemBuilder: (_, _) => Container(
                        width: posterWidth,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
