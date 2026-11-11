import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/widgets/poster_card.dart';
import '../../../../dat/catalog/catalog.dart';

/// "Top 10" item: a huge rank number tucked behind the poster.
class RankedPoster extends StatelessWidget {
  const RankedPoster({
    super.key,
    required this.rank,
    required this.video,
    required this.posterWidth,
    required this.onTap,
  });

  final int rank;
  final Video video;
  final double posterWidth;
  final VoidCallback onTap;

  /// Space reserved for the number, as a fraction of the poster width.
  static const _numberFactor = 0.75;

  static double widthFor(double posterWidth) =>
      posterWidth * (1 + _numberFactor);

  @override
  Widget build(BuildContext context) {
    final height = posterWidth * 1.5;
    return SizedBox(
      width: widthFor(posterWidth),
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: height * 0.04,
            child: Text(
              '$rank',
              maxLines: 1,
              softWrap: false,
              style: TextStyle(
                fontSize: posterWidth * 1.3,
                fontWeight: AppFontWeight.extrabold,
                height: 1,
                letterSpacing: -0.5,
                color: AppColors.surfaceRaised,
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: posterWidth,
            child: PosterCard(video: video, onTap: onTap),
          ),
        ],
      ),
    );
  }
}
