import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_tokens.g.dart';
import '../utils/formatters.dart';
import 'app_badge.dart';

/// The line under a hero title: "98% match  2026  [HD]  3 Seasons  Sci-Fi · Thriller".
class TitleMeta extends StatelessWidget {
  const TitleMeta({super.key, required this.video, this.showGenres = true});

  final Video video;
  final bool showGenres;

  @override
  Widget build(BuildContext context) {
    final match = Formatters.match(video);
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        if (match != null)
          Text(
            match,
            style: AppTextStyles.bodyStrong.copyWith(color: AppColors.success),
          ),
        Text('${video.year}', style: AppTextStyles.body),
        AppBadge(video.isSeries ? 'SERIES' : 'FILM'),
        Text(Formatters.length(video), style: AppTextStyles.body),
        if (showGenres && video.genres.isNotEmpty)
          Text(video.genres.join(' · '), style: AppTextStyles.body),
      ],
    );
  }
}
