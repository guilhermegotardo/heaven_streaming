import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import '../utils/video_display.dart';

/// "1995 · ★ 7.4 · 39 episodes · Cartoon, Kids" — the meta line under titles.
class VideoMetaLine extends StatelessWidget {
  const VideoMetaLine({super.key, required this.video, this.showGenres = true});

  final Video video;
  final bool showGenres;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary);
    final rating = video.ratingLabel;
    final genres = video.visibleGenres;

    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('${video.year}', style: style),
        if (rating != null) AppBadge(label: '★ $rating'),
        Text(video.lengthLabel, style: style),
        if (showGenres && genres.isNotEmpty) Text(genres.join(' · '), style: style),
      ],
    );
  }
}

/// Penpot "Badge": small outlined label (ratings, age, quality).
class AppBadge extends StatelessWidget {
  const AppBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.textSecondary),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: AppFontSize.caption,
          fontWeight: AppFontWeight.semibold,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// Small uppercase red label above titles ("SERIES", "MOVIE").
class Overline extends StatelessWidget {
  const Overline(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: AppFontSize.caption,
        fontWeight: AppFontWeight.bold,
        letterSpacing: 2,
        color: AppColors.primary,
      ),
    );
  }
}
