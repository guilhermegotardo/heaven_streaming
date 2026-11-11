import 'package:flutter/material.dart';

import '../../../../app/navigation.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/backdrop.dart';
import '../../../../core/widgets/key_art_image.dart';
import '../../../../core/widgets/title_meta.dart';
import '../../../../dat/catalog/catalog.dart';

/// Desktop hero: full-bleed backdrop with the featured title, synopsis,
/// Play / More info and the page dots.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.video,
    required this.height,
    required this.pageCount,
    required this.pageIndex,
    required this.onPageSelected,
  });

  final Video video;
  final double height;
  final int pageCount;
  final int pageIndex;
  final ValueChanged<int> onPageSelected;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final padding = Responsive.pagePadding(context);
    final titleSize = (width * 0.046).clamp(44.0, AppFontSize.hero);

    return SizedBox(
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Backdrop(video: video),
          Positioned(
            left: padding,
            right: padding,
            bottom: height * 0.26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  video.isSeries ? 'SERIES' : 'FILM',
                  style: AppTextStyles.overline,
                ),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Text(
                    video.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: AppFontWeight.extrabold,
                      height: AppLineHeight.hero,
                      letterSpacing: -1,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                TitleMeta(video: video),
                const SizedBox(height: AppSpacing.lg),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    video.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyLg,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      label: 'Play',
                      icon: Icons.play_arrow_rounded,
                      onPressed: AppNavigation.canPlay(video)
                          ? () => AppNavigation.play(context, video)
                          : null,
                    ),
                    const SizedBox(width: AppSpacing.lg),
                    AppButton(
                      label: 'More info',
                      icon: Icons.info_outline,
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          AppNavigation.openDetails(context, video),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxxl),
                _PageDots(
                  count: pageCount,
                  index: pageIndex,
                  onSelected: onPageSelected,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({
    required this.count,
    required this.index,
    required this.onSelected,
  });

  final int count;
  final int index;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.lg,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (count > 1)
            for (var i = 0; i < count; i++)
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onSelected(i),
                  child: Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: i == index ? 20 : 8,
                        height: 4,
                        decoration: BoxDecoration(
                          color: i == index
                              ? AppColors.textPrimary
                              : AppColors.textDisabled,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

/// Mobile hero: rounded art card with centered title, genres and the
/// Play / More info buttons.
class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 342 / 470,
      child: Container(
        clipBehavior: Clip.antiAlias,
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: AppColors.onPrimary.withValues(alpha: 0.12),
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            KeyArtImage(video: video),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xD9000000)],
                  stops: [0.4, 1],
                ),
              ),
            ),
            Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: () => AppNavigation.openDetails(context, video),
              ),
            ),
            Positioned(
              left: AppSpacing.lg,
              right: AppSpacing.lg,
              bottom: AppSpacing.lg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    video.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.headline.copyWith(
                      fontWeight: AppFontWeight.extrabold,
                    ),
                  ),
                  if (video.genres.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      video.genres.join(' · '),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Play',
                          icon: Icons.play_arrow_rounded,
                          expand: true,
                          height: AppSizes.buttonHeightSm,
                          onPressed: AppNavigation.canPlay(video)
                              ? () => AppNavigation.play(context, video)
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: AppButton(
                          label: 'More info',
                          variant: AppButtonVariant.secondary,
                          expand: true,
                          height: AppSizes.buttonHeightSm,
                          onPressed: () =>
                              AppNavigation.openDetails(context, video),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
