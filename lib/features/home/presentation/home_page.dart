import 'package:flutter/material.dart';

import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/video_display.dart';
import '../../../core/widgets/content_row.dart';
import '../../../core/widgets/state_message.dart';
import '../../../dat/catalog/catalog.dart';
import '../../../dat/catalog/catalog_controller.dart';
import '../../details/presentation/details_page.dart';
import '../../player/play_video.dart';
import 'widgets/hero_banner.dart';
import 'widgets/home_skeleton.dart';
import 'widgets/home_top_bar.dart';

/// Below this width the home switches to the phone layout.
const _compactBreakpoint = 700.0;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Catalog> _catalogFuture;
  CatalogFilter _filter = CatalogFilter.all;

  @override
  void initState() {
    super.initState();
    _catalogFuture = CatalogController.instance.loadCatalog();
  }

  void _retry() {
    setState(() {
      _catalogFuture = CatalogController.instance.loadCatalog();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Catalog>(
        future: _catalogFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return StateMessage(
              icon: Icons.error_outline_rounded,
              iconColor: AppColors.error,
              title: 'Unable to load the catalog.',
              message: 'Check your connection or the catalog server and try again.',
              actionLabel: 'Try again',
              actionIcon: Icons.refresh_rounded,
              onAction: _retry,
            );
          }
          if (!snapshot.hasData) return const HomeSkeleton();
          return _HomeView(
            videos: snapshot.data!.videos,
            filter: _filter,
            onFilterChanged: (filter) => setState(() => _filter = filter),
          );
        },
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.videos, required this.filter, required this.onFilterChanged});

  final List<Video> videos;
  final CatalogFilter filter;
  final ValueChanged<CatalogFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < _compactBreakpoint;
        final hp = compact ? AppSpacing.lg : AppSpacing.huge;
        final posterWidth = compact
            ? 110.0
            : constraints.maxWidth >= 1600
                ? 200.0
                : AppSizes.posterWidth;

        final topBar = HomeTopBar(
          selected: filter,
          onSelect: onFilterChanged,
          compact: compact,
          horizontalPadding: hp,
        );

        final visible = _filtered(videos, filter);
        if (visible.isEmpty) {
          final empty = StateMessage(
            icon: Icons.movie_filter_outlined,
            title: videos.isEmpty ? 'No videos in the catalog.' : 'Nothing here yet',
            message: videos.isEmpty
                ? 'Add titles to catalog.json in your library.'
                : 'There are no ${filter.label.toLowerCase()} in the catalog.',
          );
          return compact
              ? SafeArea(child: Column(children: [topBar, Expanded(child: empty)]))
              : Stack(children: [empty, topBar]);
        }

        final featured = _featured(visible);
        final content = <Widget>[
          HeroBanner(
            video: featured,
            compact: compact,
            horizontalPadding: hp,
            height: (constraints.maxHeight * 0.8).clamp(440.0, 860.0),
            onPlay: () => playVideo(context, featured),
            onMoreInfo: () => openDetails(context, featured),
          ),
          for (final (title, rowVideos) in _rows(visible, filter))
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: ContentRow(
                title: title,
                videos: rowVideos,
                posterWidth: posterWidth,
                horizontalPadding: hp,
                onSelect: (video) => openDetails(context, video),
              ),
            ),
          const SizedBox(height: AppSpacing.xxxl),
        ];

        if (compact) {
          return SafeArea(
            bottom: false,
            child: ListView(
              children: [topBar, const SizedBox(height: AppSpacing.lg), ...content],
            ),
          );
        }
        return Stack(
          children: [
            ListView(padding: EdgeInsets.zero, children: content),
            Positioned(top: 0, left: 0, right: 0, child: topBar),
          ],
        );
      },
    );
  }

  static List<Video> _filtered(List<Video> videos, CatalogFilter filter) => switch (filter) {
        CatalogFilter.all => videos,
        CatalogFilter.series => videos.where((v) => v.isSeries).toList(),
        CatalogFilter.movies => videos.where((v) => !v.isSeries).toList(),
      };

  /// Best rated title, preferring ones that have a poster.
  static Video _featured(List<Video> videos) {
    final withArt = videos.where((v) => v.hasPoster).toList();
    final pool = withArt.isEmpty ? videos : withArt;
    return pool.reduce((best, v) => v.rating > best.rating ? v : best);
  }

  /// Rows shown under the hero: overview rows, then one per genre.
  static List<(String, List<Video>)> _rows(List<Video> videos, CatalogFilter filter) {
    final byRating = [...videos]..sort((a, b) => b.rating.compareTo(a.rating));
    final rows = <(String, List<Video>)>[];

    if (filter == CatalogFilter.all) {
      rows.add(('Top Rated', byRating));
      final series = byRating.where((v) => v.isSeries).toList();
      final movies = byRating.where((v) => !v.isSeries).toList();
      if (series.isNotEmpty) rows.add(('Series', series));
      if (movies.isNotEmpty) rows.add(('Movies', movies));
    } else {
      rows.add(('All ${filter.label}', byRating));
    }

    // Genre rows only when they add something beyond a single title.
    final byGenre = <String, List<Video>>{};
    for (final video in byRating) {
      for (final genre in video.visibleGenres) {
        byGenre.putIfAbsent(genre, () => []).add(video);
      }
    }
    final genres = byGenre.entries.where((e) => e.value.length >= 2).toList()
      ..sort((a, b) => b.value.length.compareTo(a.value.length));
    rows.addAll(genres.map((e) => (e.key, e.value)));

    return rows;
  }
}
