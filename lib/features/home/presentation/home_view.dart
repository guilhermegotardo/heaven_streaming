import 'dart:async';

import 'package:flutter/material.dart';

import '../../../app/navigation.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/landscape_card.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../dat/catalog/catalog.dart';
import '../../../dat/profiles/profile_controller.dart';
import '../../../dat/progress/watch_progress_controller.dart';
import '../../browse/presentation/browse_view.dart';
import 'widgets/content_row.dart';
import 'widgets/hero_banner.dart';
import 'widgets/ranked_poster.dart';

/// "03 Home": hero, then the Continue Watching / Trending Now / Top 10 /
/// New Releases rails.
class HomeView extends StatefulWidget {
  const HomeView({super.key, required this.videos});

  final List<Video> videos;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  static const _featuredCount = 5;
  static const _rotation = Duration(seconds: 10);

  late List<Video> _featured;
  late List<Video> _topRated;
  late List<Video> _newReleases;
  int _heroIndex = 0;
  Timer? _rotationTimer;

  @override
  void initState() {
    super.initState();
    _prepare();
  }

  @override
  void didUpdateWidget(HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videos != widget.videos) _prepare();
  }

  void _prepare() {
    _topRated = [...widget.videos]
      ..sort((a, b) => b.rating.compareTo(a.rating));
    _newReleases = [...widget.videos]..sort((a, b) => b.year.compareTo(a.year));
    _featured = _topRated.take(_featuredCount).toList();
    _heroIndex = 0;
    _restartRotation();
  }

  void _restartRotation() {
    _rotationTimer?.cancel();
    if (_featured.length < 2) return;
    _rotationTimer = Timer.periodic(_rotation, (_) {
      if (!mounted) return;
      setState(() => _heroIndex = (_heroIndex + 1) % _featured.length);
    });
  }

  void _selectHero(int index) {
    setState(() => _heroIndex = index);
    _restartRotation();
  }

  @override
  void dispose() {
    _rotationTimer?.cancel();
    super.dispose();
  }

  void _seeAll(String title, List<Video> videos) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BrowsePage(title: title, videos: videos),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hero = _featured[_heroIndex];

    final rails = ListenableBuilder(
      listenable: Listenable.merge([
        WatchProgressController.instance,
        ProfileController.instance,
      ]),
      builder: (context, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildRails(context, isMobile),
      ),
    );

    if (isMobile) return _buildMobile(context, hero, rails);

    final size = MediaQuery.sizeOf(context);
    final heroHeight = (size.height * 0.83).clamp(640.0, 900.0);

    return SingleChildScrollView(
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: heroHeight,
            child: HeroBanner(
              video: hero,
              height: heroHeight,
              pageCount: _featured.length,
              pageIndex: _heroIndex,
              onPageSelected: _selectHero,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // The rails start over the bottom scrim of the hero.
              SizedBox(height: heroHeight * 0.845),
              rails,
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobile(BuildContext context, Video hero, Widget rails) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 520,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF2A1050), AppColors.background],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    AppSpacing.sm,
                    AppSpacing.xs,
                    0,
                  ),
                  child: Row(
                    children: [
                      const BrandLogo(fontSize: AppFontSize.title),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Search',
                        onPressed: () =>
                            AppNavigation.goToTab(context, ShellTab.search),
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Row(
                    children: [
                      AppChip(
                        label: 'Series',
                        onTap: () =>
                            AppNavigation.goToTab(context, ShellTab.series),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppChip(
                        label: 'Movies',
                        onTap: () =>
                            AppNavigation.goToTab(context, ShellTab.movies),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      AppChip(
                        label: 'New & Popular',
                        onTap: () => AppNavigation.goToTab(
                          context,
                          ShellTab.newAndPopular,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: HeroCard(video: hero),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                rails,
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRails(BuildContext context, bool isMobile) {
    final posterWidth = isMobile ? 110.0 : 200.0;
    final posterHeight = posterWidth * 1.5;
    final continueWidth = isMobile ? 220.0 : 320.0;
    final releaseWidth = isMobile ? 200.0 : 288.0;

    final byId = {for (final video in widget.videos) video.id: video};
    final continueWatching = [
      for (final entry in WatchProgressController.instance.continueWatching)
        if (byId[entry.videoId] case final video?) (video, entry),
    ];
    final profile = ProfileController.instance.current;
    final top10 = _topRated.take(10).toList();

    return [
      if (continueWatching.isNotEmpty)
        ContentRow(
          title: profile == null
              ? 'Continue Watching'
              : 'Continue Watching for ${profile.name}',
          height: LandscapeCard.heightFor(continueWidth),
          spacing: isMobile ? AppSpacing.md : 40,
          itemCount: continueWatching.length,
          itemBuilder: (context, index) {
            final (video, entry) = continueWatching[index];
            return LandscapeCard(
              video: video,
              width: continueWidth,
              progress: entry.fraction,
              meta: _continueMeta(video, entry),
              onTap: () => AppNavigation.play(
                context,
                video,
                episodeIndex: entry.episodeIndex,
              ),
            );
          },
        ),
      ContentRow(
        title: 'Trending Now',
        height: posterHeight,
        spacing: isMobile ? AppSpacing.sm : AppSpacing.lg,
        onSeeAll: () => _seeAll('Trending Now', widget.videos),
        itemCount: widget.videos.length,
        itemBuilder: (context, index) {
          final video = widget.videos[index];
          return PosterCard(
            video: video,
            width: posterWidth,
            height: posterHeight,
            onTap: () => AppNavigation.openDetails(context, video),
          );
        },
      ),
      ContentRow(
        title: 'Top 10 Today',
        height: posterHeight,
        spacing: isMobile ? AppSpacing.sm : AppSpacing.md,
        onSeeAll: () => _seeAll('Top 10 Today', top10),
        itemCount: top10.length,
        itemBuilder: (context, index) {
          final video = top10[index];
          return RankedPoster(
            rank: index + 1,
            video: video,
            posterWidth: posterWidth,
            onTap: () => AppNavigation.openDetails(context, video),
          );
        },
      ),
      ContentRow(
        title: 'New Releases',
        height: LandscapeCard.heightFor(releaseWidth),
        spacing: isMobile ? AppSpacing.md : AppSpacing.lg,
        onSeeAll: () => _seeAll('New Releases', _newReleases),
        itemCount: _newReleases.length,
        itemBuilder: (context, index) {
          final video = _newReleases[index];
          return LandscapeCard(
            video: video,
            width: releaseWidth,
            meta: [
              '${video.year}',
              if (video.genres.isNotEmpty) video.genres.first,
            ].join(' · '),
            onTap: () => AppNavigation.openDetails(context, video),
          );
        },
      ),
    ];
  }

  /// "S1:E4 · 22m left" for series, "1h 05m left" for movies.
  String _continueMeta(Video video, WatchEntry entry) {
    final left = '${Formatters.runtime(entry.remaining.inSeconds)} left';
    final index = entry.episodeIndex;
    if (index == null || index >= video.episodes.length) return left;
    return '${Formatters.episodeCode(video.episodes[index])} · $left';
  }
}
