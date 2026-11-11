import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/utils/responsive.dart';

/// "09 Loading": placeholder blocks in the shape of the home page.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.pagePadding(context);
    // Never shorter than the placeholder column inside it.
    final heroHeight = math.max(size.height * 0.65, 440.0);
    final cardWidth = isMobile ? 160.0 : 288.0;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: heroHeight,
            color: AppColors.surface,
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.fromLTRB(
              padding,
              0,
              padding,
              heroHeight * 0.16,
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Bone(width: 160, height: 16),
                SizedBox(height: AppSpacing.xl),
                _Bone(width: 720, height: 72, radius: AppRadius.md),
                SizedBox(height: 28),
                _Bone(width: 520, height: 18),
                SizedBox(height: 14),
                _Bone(width: 640, height: 18),
                SizedBox(height: 14),
                _Bone(width: 460, height: 18),
                SizedBox(height: 58),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Bone(
                      width: 140,
                      height: AppSizes.buttonHeight,
                      radius: AppRadius.md,
                    ),
                    SizedBox(width: AppSpacing.lg),
                    _Bone(
                      width: 170,
                      height: AppSizes.buttonHeight,
                      radius: AppRadius.md,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: _Bone(width: 280, height: 24, color: AppColors.surface),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            height: cardWidth * 9 / 16,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: padding),
              itemCount: 8,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
              itemBuilder: (_, _) => _Bone(
                width: cardWidth,
                height: cardWidth * 9 / 16,
                radius: AppRadius.md,
                color: AppColors.surface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bone extends StatelessWidget {
  const _Bone({
    required this.width,
    required this.height,
    this.radius = AppRadius.sm,
    this.color = AppColors.surfaceRaised,
  });

  final double width;
  final double height;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: width),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
