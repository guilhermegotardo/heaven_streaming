import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import 'poster_card.dart';

/// A titled, horizontally scrolling row of posters ("Trending Now", "Series"…).
class ContentRow extends StatelessWidget {
  const ContentRow({
    super.key,
    required this.title,
    required this.videos,
    required this.posterWidth,
    required this.horizontalPadding,
    required this.onSelect,
  });

  final String title;
  final List<Video> videos;
  final double posterWidth;
  final double horizontalPadding;
  final ValueChanged<Video> onSelect;

  // Room for the hover scale so the enlarged card is not clipped.
  static const _hoverRoom = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: posterWidth * 1.5 + _hoverRoom * 2,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: _hoverRoom),
            itemCount: videos.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
            itemBuilder: (_, i) => PosterCard(
              video: videos[i],
              width: posterWidth,
              onTap: () => onSelect(videos[i]),
            ),
          ),
        ),
      ],
    );
  }
}
