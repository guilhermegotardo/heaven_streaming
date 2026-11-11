import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import 'hover_scale.dart';
import 'key_art_image.dart';

/// "Card / Poster": 2:3 art with the title over a bottom scrim.
/// Fills its parent unless [width] / [height] are given.
class PosterCard extends StatelessWidget {
  const PosterCard({
    super.key,
    required this.video,
    required this.onTap,
    this.width,
    this.height,
  });

  final Video video;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: HoverScale(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Stack(
            fit: StackFit.expand,
            children: [
              KeyArtImage(video: video),
              const Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.36,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xD9000000)],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: AppSpacing.md,
                right: AppSpacing.md,
                bottom: AppSpacing.md,
                child: Text(
                  video.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.label,
                ),
              ),
              Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: onTap,
                  hoverColor: AppColors.onPrimary.withValues(
                    alpha: AppOpacity.hover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
