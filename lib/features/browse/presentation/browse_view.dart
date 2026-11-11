import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/poster_grid.dart';
import '../../../core/widgets/state_view.dart';
import '../../../dat/catalog/catalog.dart';

/// A titled poster grid (Series, Movies, New & Popular and "See all").
class BrowseView extends StatelessWidget {
  const BrowseView({
    super.key,
    required this.title,
    required this.videos,
    this.topPadding,
    this.trailing,
    this.empty,
  });

  final String title;
  final List<Video> videos;

  /// Space above the title; defaults to clearing the top nav on desktop.
  final double? topPadding;

  /// Widget at the right of the title (e.g. the sort select).
  final Widget? trailing;

  /// Shown instead of the grid when [videos] is empty.
  final Widget? empty;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.pagePadding(context);
    final top =
        topPadding ??
        (isMobile ? AppSpacing.md : AppSizes.navHeight + AppSpacing.xxl);

    if (videos.isEmpty) {
      return empty ??
          StateView(
            icon: Icons.movie_outlined,
            title: 'Nothing here yet',
            message: 'There are no titles in "$title" right now.',
          );
    }

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding,
              top,
              padding,
              isMobile ? AppSpacing.xl : AppSpacing.xxxl,
            ),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: isMobile
                          ? AppTextStyles.display.copyWith(
                              fontSize: AppFontSize.logo,
                              letterSpacing: 0,
                            )
                          : AppTextStyles.display,
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: AppSpacing.lg),
                    trailing!,
                  ],
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(padding, 0, padding, AppSpacing.xxxl),
            sliver: SliverPosterGrid(videos: videos),
          ),
        ],
      ),
    );
  }
}

/// [BrowseView] as a standalone page with a back button ("See all").
class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key, required this.title, required this.videos});

  final String title;
  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    final padding = Responsive.pagePadding(context);
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: BrowseView(
              title: title,
              videos: videos,
              topPadding: AppSizes.navHeight,
            ),
          ),
          Positioned(
            top: 0,
            left: padding - AppSpacing.sm,
            child: SafeArea(
              child: SizedBox(
                height: AppSizes.navHeight,
                child: Center(
                  child: IconButton(
                    tooltip: 'Back',
                    iconSize: AppSizes.iconLg,
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back),
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
