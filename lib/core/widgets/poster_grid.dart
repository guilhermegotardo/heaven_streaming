import 'package:flutter/material.dart';

import '../../app/navigation.dart';
import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import '../utils/responsive.dart';
import 'poster_card.dart';

/// Sliver grid of posters: 8 columns on the 1920 frame, 3 on mobile.
class SliverPosterGrid extends StatelessWidget {
  const SliverPosterGrid({super.key, required this.videos});

  final List<Video> videos;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final spacing = isMobile ? 14.0 : AppSpacing.xl;
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: isMobile ? 130 : 227,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 2 / 3,
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final video = videos[index];
        return PosterCard(
          video: video,
          onTap: () => AppNavigation.openDetails(context, video),
        );
      }, childCount: videos.length),
    );
  }
}
