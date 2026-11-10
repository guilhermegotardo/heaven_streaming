import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import 'video_art.dart';

/// Penpot "Row/Episode": number, 16:9 thumbnail with play icon, title.
/// The catalog has no per-episode art, so the thumbnail crops the series poster.
class EpisodeTile extends StatelessWidget {
  const EpisodeTile({
    super.key,
    required this.series,
    required this.episode,
    required this.compact,
    required this.onTap,
  });

  final Video series;
  final Episode episode;
  final bool compact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    const radius = BorderRadius.all(Radius.circular(AppRadius.lg));

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        hoverColor: AppColors.surfaceRaised,
        focusColor: AppColors.surfaceRaised,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              if (!compact) ...[
                SizedBox(
                  width: 40,
                  child: Text(
                    '${episode.number}',
                    textAlign: TextAlign.center,
                    style: theme.titleLarge?.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
              ],
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: SizedBox(
                  width: compact ? 128 : 200,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        VideoArt(
                          video: series,
                          alignment: const Alignment(0, -0.4),
                          showTitleFallback: false,
                        ),
                        const ColoredBox(color: Color(0x4D000000)),
                        Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: compact ? 28 : 36,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compact ? '${episode.number}. ${episode.title}' : episode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodyLarge?.copyWith(fontWeight: AppFontWeight.semibold),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text('S${episode.season} · E${episode.number}', style: theme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
