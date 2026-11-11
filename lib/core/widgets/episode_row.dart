import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import '../theme/key_art.dart';
import 'thin_progress_bar.dart';

/// "Row / Episode": number, 16:9 thumb with play icon and progress, title and
/// a secondary line. The episode being watched gets the raised background.
class EpisodeRow extends StatelessWidget {
  const EpisodeRow({
    super.key,
    required this.seriesId,
    required this.episode,
    required this.onTap,
    this.progress,
    this.trailing,
    this.highlighted = false,
    this.compact = false,
  });

  final String seriesId;
  final Episode episode;
  final VoidCallback onTap;

  /// 0–1; hides the progress line when null.
  final double? progress;

  /// Right-aligned text (e.g. the time left).
  final String? trailing;
  final bool highlighted;

  /// Mobile layout: smaller thumb, no number column.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final thumbWidth = compact ? 128.0 : 240.0;
    final secondary = 'Season ${episode.season} · Episode ${episode.number}';

    final thumb = ClipRRect(
      borderRadius: BorderRadius.circular(compact ? 6 : AppRadius.md),
      child: SizedBox(
        width: thumbWidth,
        height: thumbWidth * 9 / 16,
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: KeyArt.gradientFor(
                  '$seriesId-${episode.season}-${episode.number}',
                ),
              ),
            ),
            Center(
              child: Icon(
                Icons.play_arrow_rounded,
                size: compact ? AppSizes.iconMd : AppSizes.iconLg,
                color: AppColors.onPrimary,
              ),
            ),
            if (progress != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: ThinProgressBar(value: progress!),
              ),
          ],
        ),
      ),
    );

    return Material(
      color: highlighted ? AppColors.surfaceRaised : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.lg),
          child: Row(
            children: [
              if (!compact)
                SizedBox(
                  width: 56,
                  child: Text(
                    '${episode.number}',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    style: AppTextStyles.title.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              thumb,
              SizedBox(width: compact ? AppSpacing.md : AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      compact
                          ? '${episode.number}. ${episode.title}'
                          : episode.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: compact
                          ? AppTextStyles.label
                          : AppTextStyles.bodyStrong,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      compact && trailing != null
                          ? '$secondary · $trailing'
                          : secondary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: compact
                          ? AppTextStyles.caption
                          : AppTextStyles.bodySm,
                    ),
                  ],
                ),
              ),
              if (!compact && trailing != null) ...[
                const SizedBox(width: AppSpacing.lg),
                Text(trailing!, style: AppTextStyles.bodySm),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
