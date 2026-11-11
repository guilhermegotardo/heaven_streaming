import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import 'hover_scale.dart';
import 'key_art_image.dart';
import 'thin_progress_bar.dart';

/// "Card / Continue": 16:9 thumb with a play button and optional progress,
/// then title and a meta line.
class LandscapeCard extends StatelessWidget {
  const LandscapeCard({
    super.key,
    required this.video,
    required this.meta,
    required this.width,
    required this.onTap,
    this.progress,
  });

  final Video video;
  final String meta;
  final double width;
  final VoidCallback onTap;

  /// 0–1; hides the progress line when null.
  final double? progress;

  /// Height of the text block under the thumb.
  static const textHeight = 56.0;

  static double heightFor(double width) => width * 9 / 16 + textHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          HoverScale(
            scale: 1.03,
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    KeyArtImage(
                      video: video,
                      alignment: const Alignment(0, -0.5),
                    ),
                    const ColoredBox(color: Color(0x40000000)),
                    const Center(child: PlayBadge()),
                    if (progress != null)
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ThinProgressBar(value: progress!),
                      ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(onTap: onTap),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            video.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.label,
          ),
          const SizedBox(height: 2),
          Text(
            meta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }
}

/// White-ringed play button drawn over thumbnails.
class PlayBadge extends StatelessWidget {
  const PlayBadge({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0x80000000),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.onPrimary, width: 2),
      ),
      child: Icon(
        Icons.play_arrow_rounded,
        size: size / 2,
        color: AppColors.onPrimary,
      ),
    );
  }
}
