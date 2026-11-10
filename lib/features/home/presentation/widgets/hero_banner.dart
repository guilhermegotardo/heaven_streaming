import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_tokens.g.dart';
import '../../../../core/utils/video_display.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/video_art.dart';
import '../../../../core/widgets/video_meta.dart';
import '../../../../dat/catalog/catalog.dart';
import '../../../player/play_video.dart';

/// Featured title at the top of the home.
///
/// Wide: full-bleed blurred backdrop, info on the left, poster on the right.
/// Compact (phones): rounded poster card with the title and two buttons.
class HeroBanner extends StatelessWidget {
  const HeroBanner({
    super.key,
    required this.video,
    required this.compact,
    required this.horizontalPadding,
    required this.onPlay,
    required this.onMoreInfo,
    this.height = AppSizes.heroHeight,
  });

  final Video video;
  final bool compact;
  final double horizontalPadding;
  final double height;
  final VoidCallback onPlay;
  final VoidCallback onMoreInfo;

  @override
  Widget build(BuildContext context) => compact ? _buildCompact(context) : _buildWide(context);

  Widget _buildWide(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final synopsis = video.synopsis;

    return LayoutBuilder(
      builder: (context, constraints) {
        final showPoster = constraints.maxWidth >= 1000;
        return SizedBox(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoBackdrop(video: video),
              if (showPoster)
                Positioned(
                  right: horizontalPadding,
                  bottom: height * 0.14,
                  height: height * 0.62,
                  child: _FloatingPoster(video: video),
                ),
              Positioned(
                left: horizontalPadding,
                bottom: height * 0.12,
                width: math.min(640, constraints.maxWidth - horizontalPadding * 2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Overline(video.kindLabel),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.displayLarge?.copyWith(
                        fontSize: 64,
                        fontWeight: FontWeight.w800,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    VideoMetaLine(video: video),
                    if (synopsis != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        synopsis,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyLarge?.copyWith(fontSize: 18),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    Wrap(
                      spacing: AppSpacing.md,
                      runSpacing: AppSpacing.md,
                      children: [
                        PrimaryButton(label: 'Play', onPressed: canPlay(video) ? onPlay : null),
                        SecondaryButton(label: 'More info', onPressed: onMoreInfo),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompact(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final genres = video.visibleGenres;
    const radius = BorderRadius.all(Radius.circular(AppRadius.xl));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding + AppSpacing.sm),
      child: AspectRatio(
        aspectRatio: 358 / 470,
        child: DecoratedBox(
          position: DecorationPosition.foreground,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: AppColors.onPrimary.withValues(alpha: 0.12)),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                GestureDetector(
                  onTap: onMoreInfo,
                  child: VideoArt(video: video, showTitleFallback: false),
                ),
                const IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0x00000000), Color(0xE6000000)],
                        stops: [0.45, 1],
                      ),
                    ),
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
                        style: theme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      if (genres.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          genres.join(' · '),
                          textAlign: TextAlign.center,
                          style: theme.bodySmall?.copyWith(color: AppColors.textPrimary),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.md),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Play',
                              height: 44,
                              onPressed: canPlay(video) ? onPlay : null,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: SecondaryButton(label: 'Info', height: 44, onPressed: onMoreInfo),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingPoster extends StatelessWidget {
  const _FloatingPoster({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.lg));
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: radius,
          boxShadow: [BoxShadow(color: Color(0x99000000), blurRadius: 48, offset: Offset(0, 24))],
        ),
        child: ClipRRect(borderRadius: radius, child: VideoArt(video: video)),
      ),
    );
  }
}
