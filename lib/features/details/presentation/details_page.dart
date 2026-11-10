import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/video_display.dart';
import '../../../core/widgets/app_buttons.dart';
import '../../../core/widgets/episode_tile.dart';
import '../../../core/widgets/video_art.dart';
import '../../../core/widgets/video_meta.dart';
import '../../../dat/catalog/catalog.dart';
import '../../player/play_video.dart';

const _compactBreakpoint = 700.0;

/// Opens the details screen for [video].
void openDetails(BuildContext context, Video video) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => DetailsPage(video: video)),
  );
}

/// Title details (Penpot "Details – Movie" / "Details – Series"):
/// backdrop header with info and Play, plus the episode list for series.
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.video});

  final Video video;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late int _season = widget.video.seasons.isEmpty
      ? 0
      : widget.video.seasons.first;

  @override
  Widget build(BuildContext context) {
    final video = widget.video;
    final allEpisodes = video.sortedEpisodes;
    final seasonEpisodes = allEpisodes
        .where((e) => e.season == _season)
        .toList();

    final topInset = MediaQuery.paddingOf(context).top;
    return Scaffold(
      body: Stack(
        children: [
          _buildContent(video, allEpisodes, seasonEpisodes),
          // Fade behind the back button so it stays readable over scrolled content.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topInset + kToolbarHeight + AppSpacing.lg,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.background,
                      AppColors.background.withValues(alpha: 0.8),
                      AppColors.background.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.55, 1],
                  ),
                ),
              ),
            ),
          ),
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: BackButton(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    Video video,
    List<Episode> allEpisodes,
    List<Episode> seasonEpisodes,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        final hp = compact ? AppSpacing.lg : AppSpacing.huge;

        final info = _TitleInfo(
          video: video,
          compact: compact,
          firstEpisode: allEpisodes.isEmpty ? null : allEpisodes.first,
        );

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: compact
                  ? _CompactHeader(
                      video: video,
                      horizontalPadding: hp,
                      info: info,
                    )
                  : _WideHeader(
                      video: video,
                      height: (constraints.maxHeight * 0.72).clamp(
                        420.0,
                        720.0,
                      ),
                      horizontalPadding: hp,
                      info: info,
                    ),
            ),
            if (video.isSeries) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    hp,
                    AppSpacing.xxl,
                    hp,
                    AppSpacing.sm,
                  ),
                  child: _EpisodesHeader(
                    seasons: video.seasons,
                    selected: _season,
                    episodeCount: seasonEpisodes.length,
                    onChanged: (s) => setState(() => _season = s),
                  ),
                ),
              ),
              SliverPadding(
                // Tiles have their own inner padding; keep their content aligned with the header.
                padding: EdgeInsets.symmetric(horizontal: hp - AppSpacing.md),
                sliver: SliverConstrainedCrossAxis(
                  maxExtent: 1200,
                  sliver: SliverList.builder(
                    itemCount: seasonEpisodes.length,
                    itemBuilder: (context, i) => EpisodeTile(
                      series: video,
                      episode: seasonEpisodes[i],
                      compact: compact,
                      onTap: () =>
                          playVideo(context, video, episode: seasonEpisodes[i]),
                    ),
                  ),
                ),
              ),
            ],
            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xxxl)),
          ],
        );
      },
    );
  }
}

class _WideHeader extends StatelessWidget {
  const _WideHeader({
    required this.video,
    required this.height,
    required this.horizontalPadding,
    required this.info,
  });

  final Video video;
  final double height;
  final double horizontalPadding;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SizedBox(
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            VideoBackdrop(video: video),
            if (constraints.maxWidth >= 1000)
              Positioned(
                right: horizontalPadding,
                bottom: AppSpacing.xxl,
                height: height * 0.68,
                child: _Poster(video: video),
              ),
            Positioned(
              left: horizontalPadding,
              bottom: AppSpacing.xxl,
              width: math.min(
                720,
                constraints.maxWidth - horizontalPadding * 2,
              ),
              child: info,
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactHeader extends StatelessWidget {
  const _CompactHeader({
    required this.video,
    required this.horizontalPadding,
    required this.info,
  });

  final Video video;
  final double horizontalPadding;
  final Widget info;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top + kToolbarHeight;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: top + 240,
          child: Stack(
            fit: StackFit.expand,
            children: [
              VideoBackdrop(video: video, leftScrim: false),
              Padding(
                padding: EdgeInsets.only(top: top, bottom: AppSpacing.lg),
                child: Center(child: _Poster(video: video)),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: info,
        ),
      ],
    );
  }
}

class _TitleInfo extends StatelessWidget {
  const _TitleInfo({
    required this.video,
    required this.compact,
    required this.firstEpisode,
  });

  final Video video;
  final bool compact;
  final Episode? firstEpisode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    final synopsis = video.synopsis;
    final episode = firstEpisode;
    final playLabel = episode != null
        ? 'Play S${episode.season}:E${episode.number}'
        : 'Play';

    final play = PrimaryButton(
      label: playLabel,
      height: compact ? 44 : 48,
      onPressed: canPlay(video)
          ? () => playVideo(context, video, episode: episode)
          : null,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Overline(video.kindLabel),
        const SizedBox(height: AppSpacing.sm),
        Text(
          video.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: compact
              ? theme.headlineMedium
              : theme.displayLarge?.copyWith(
                  fontSize: 64,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
        ),
        const SizedBox(height: AppSpacing.md),
        VideoMetaLine(video: video),
        const SizedBox(height: AppSpacing.lg),
        compact ? SizedBox(width: double.infinity, child: play) : play,
        if (synopsis != null) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            synopsis,
            style: compact
                ? theme.bodyMedium?.copyWith(color: AppColors.textPrimary)
                : theme.bodyLarge?.copyWith(fontSize: 18),
          ),
        ],
      ],
    );
  }
}

class _EpisodesHeader extends StatelessWidget {
  const _EpisodesHeader({
    required this.seasons,
    required this.selected,
    required this.episodeCount,
    required this.onChanged,
  });

  final List<int> seasons;
  final int selected;
  final int episodeCount;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text('Episodes', style: theme.titleLarge),
        if (seasons.length > 1)
          PopupMenuButton<int>(
            initialValue: selected,
            onSelected: onChanged,
            tooltip: 'Choose season',
            itemBuilder: (_) => [
              for (final s in seasons)
                PopupMenuItem(value: s, child: Text('Season $s')),
            ],
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Season $selected',
                    style: theme.bodyLarge?.copyWith(
                      fontWeight: AppFontWeight.semibold,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        Text(
          seasons.length > 1
              ? '$episodeCount episodes'
              : 'Season $selected · $episodeCount episodes',
          style: theme.bodyMedium,
        ),
      ],
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.all(Radius.circular(AppRadius.lg));
    return AspectRatio(
      aspectRatio: 2 / 3,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: Color(0x99000000),
              blurRadius: 48,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: VideoArt(video: video),
        ),
      ),
    );
  }
}
