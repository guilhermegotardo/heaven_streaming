import 'package:flutter/material.dart';

import '../../../app/navigation.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/backdrop.dart';
import '../../../core/widgets/dropdown_select.dart';
import '../../../core/widgets/episode_row.dart';
import '../../../core/widgets/key_art_image.dart';
import '../../../core/widgets/landscape_card.dart';
import '../../../core/widgets/poster_card.dart';
import '../../../core/widgets/title_meta.dart';
import '../../../core/widgets/top_nav.dart';
import '../../../dat/catalog/catalog.dart';
import '../../../dat/catalog/catalog_controller.dart';
import '../../../dat/my_list/my_list_controller.dart';
import '../../../dat/progress/watch_progress_controller.dart';

enum _Tab {
  episodes('Episodes'),
  moreLikeThis('More Like This');

  const _Tab(this.label);

  final String label;
}

/// "04 Details – Movie" and "05 Details – Series": backdrop, title block and
/// actions, then "More Like This" (movies) or the Episodes / More Like This
/// tabs (series).
class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.video});

  final Video video;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  _Tab _tab = _Tab.episodes;
  late int _season;

  Video get _video => widget.video;

  List<int> get _seasons =>
      _video.episodes.map((e) => e.season).toSet().toList()..sort();

  @override
  void initState() {
    super.initState();
    _season = _video.isSeries
        ? _video.episodes[AppNavigation.resumeEpisodeIndex(_video)].season
        : 1;
  }

  /// Titles sharing a genre with this one; any other title as a fallback.
  List<Video> get _similar {
    final Catalog catalog;
    try {
      catalog = CatalogController.instance.catalog;
    } catch (_) {
      return const [];
    }
    final others = catalog.videos.where((v) => v.id != _video.id).toList();
    final sameGenre = others
        .where((v) => v.genres.any(_video.genres.contains))
        .toList();
    return sameGenre.isEmpty ? others : sameGenre;
  }

  /// "Play", "Resume" or "Resume S1:E3".
  String get _playLabel {
    final latest = WatchProgressController.instance.latestFor(_video.id);
    if (latest == null) return 'Play';
    if (!_video.isSeries) return latest.finished ? 'Play' : 'Resume';
    final episode = _video.episodes[AppNavigation.resumeEpisodeIndex(_video)];
    return 'Resume ${Formatters.episodeCode(episode)}';
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([
          MyListController.instance,
          WatchProgressController.instance,
        ]),
        builder: (context, _) =>
            isMobile ? _buildMobile(context) : _buildDesktop(context),
      ),
    );
  }

  // ---- Desktop ----

  Widget _buildDesktop(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final padding = Responsive.pagePadding(context);
    final backdropHeight = _video.isSeries
        ? (size.height * 0.67).clamp(480.0, 720.0)
        : (size.height * 0.8).clamp(520.0, 860.0);
    final titleSize = (size.width * 0.042).clamp(40.0, AppFontSize.heroSm);

    Widget padded(Widget child) => Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: child,
    );

    return Stack(
      children: [
        Positioned.fill(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: backdropHeight,
                  child: Backdrop(video: _video),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSizes.navHeight + AppSpacing.xxl),
                    Padding(
                      padding: EdgeInsets.only(left: padding - AppSpacing.sm),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          tooltip: 'Back',
                          iconSize: AppSizes.iconLg,
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    padded(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _video.isSeries ? 'SERIES' : 'FILM',
                            style: AppTextStyles.overline,
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 900),
                            child: Text(
                              _video.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: titleSize,
                                fontWeight: AppFontWeight.extrabold,
                                height: AppLineHeight.hero,
                                letterSpacing: -1,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TitleMeta(video: _video, showGenres: false),
                          const SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 720),
                            child: Text(
                              _video.description,
                              style: AppTextStyles.bodyLg,
                            ),
                          ),
                          const SizedBox(height: 36),
                          _buildActions(context, expand: false),
                          if (_video.genres.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xxl),
                            Text(
                              'Genres: ${_video.genres.join(', ')}',
                              style: AppTextStyles.bodySm,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    if (_video.isSeries) ...[
                      padded(_buildTabs()),
                      const SizedBox(height: 40),
                      if (_tab == _Tab.episodes)
                        padded(_buildEpisodes(context, compact: false))
                      else
                        _buildSimilar(context),
                    ] else ...[
                      padded(
                        const Text(
                          'More Like This',
                          style: AppTextStyles.titleSm,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _buildSimilar(context),
                    ],
                    const SizedBox(height: AppSpacing.xxxl),
                  ],
                ),
              ],
            ),
          ),
        ),
        const Positioned(top: 0, left: 0, right: 0, child: TopNav()),
      ],
    );
  }

  // ---- Mobile ----

  Widget _buildMobile(BuildContext context) {
    final canPlay = AppNavigation.canPlay(_video);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 264,
            child: Stack(
              fit: StackFit.expand,
              children: [
                KeyArtImage(video: _video, alignment: const Alignment(0, -0.5)),
                const ColoredBox(color: Color(0x40000000)),
                Center(
                  child: GestureDetector(
                    onTap: canPlay
                        ? () => AppNavigation.play(context, _video)
                        : null,
                    child: const PlayBadge(size: 56),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: AppSpacing.sm,
                  child: SafeArea(
                    child: IconButton(
                      tooltip: 'Close',
                      onPressed: () => Navigator.maybePop(context),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0x80000000),
                      ),
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _video.title,
                  style: AppTextStyles.title.copyWith(
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TitleMeta(video: _video, showGenres: false),
                const SizedBox(height: AppSpacing.lg),
                _buildActions(context, expand: true),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  _video.description,
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                if (_video.genres.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Genres: ${_video.genres.join(', ')}',
                    style: AppTextStyles.caption,
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),
                if (_video.isSeries) ...[
                  _buildTabs(),
                  const SizedBox(height: AppSpacing.lg),
                  if (_tab == _Tab.episodes)
                    _buildEpisodes(context, compact: true),
                ] else
                  const Text('More Like This', style: AppTextStyles.titleSm),
              ],
            ),
          ),
          if (!_video.isSeries || _tab == _Tab.moreLikeThis)
            _buildSimilar(context),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  // ---- Shared sections ----

  Widget _buildActions(BuildContext context, {required bool expand}) {
    final inList = MyListController.instance.contains(_video.id);
    final height = expand ? AppSizes.buttonHeightSm : AppSizes.buttonHeight;

    final play = AppButton(
      label: _playLabel,
      icon: Icons.play_arrow_rounded,
      expand: expand,
      height: height,
      onPressed: AppNavigation.canPlay(_video)
          ? () => AppNavigation.play(context, _video)
          : null,
    );
    final myList = AppButton(
      label: 'My List',
      icon: inList ? Icons.check : Icons.add,
      variant: AppButtonVariant.secondary,
      expand: expand,
      height: height,
      onPressed: () => MyListController.instance.toggle(_video.id),
    );

    if (expand) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          play,
          const SizedBox(height: AppSpacing.sm),
          myList,
        ],
      );
    }
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.md,
      children: [play, myList],
    );
  }

  Widget _buildTabs() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final tab in _Tab.values)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xxxl),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _tab = tab),
                      child: Container(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              width: 3,
                              color: tab == _tab
                                  ? AppColors.primary
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        child: Text(
                          tab.label,
                          style: AppTextStyles.bodyLg.copyWith(
                            fontWeight: tab == _tab
                                ? AppFontWeight.semibold
                                : AppFontWeight.regular,
                            color: tab == _tab
                                ? AppColors.textPrimary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEpisodes(BuildContext context, {required bool compact}) {
    final progress = WatchProgressController.instance;
    final current = progress.latestFor(_video.id)?.episodeIndex;
    final episodes = [
      for (final (index, episode) in _video.episodes.indexed)
        if (episode.season == _season) (index, episode),
    ];

    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.contentMaxWidth),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                DropdownSelect<int>(
                  value: _season,
                  options: _seasons,
                  labelOf: (season) => 'Season $season',
                  width: compact ? 160 : 200,
                  onChanged: (season) => setState(() => _season = season),
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Text(
                    '${episodes.length} ${episodes.length == 1 ? 'episode' : 'episodes'}'
                    ' · ${_video.year}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySm,
                  ),
                ),
              ],
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.xxl),
            for (final (index, episode) in episodes)
              Builder(
                builder: (context) {
                  final entry = progress.entryFor(_video.id, index);
                  return EpisodeRow(
                    seriesId: _video.id,
                    episode: episode,
                    compact: compact,
                    highlighted: index == current,
                    progress: entry?.fraction,
                    trailing: entry == null
                        ? null
                        : entry.finished
                        ? 'Watched'
                        : '${Formatters.runtime(entry.remaining.inSeconds)} left',
                    onTap: () => AppNavigation.play(
                      context,
                      _video,
                      episodeIndex: index,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  /// Horizontal rail of similar titles (it adds its own page margin).
  Widget _buildSimilar(BuildContext context) {
    final padding = Responsive.pagePadding(context);
    final similar = _similar;
    if (similar.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: const Text('No similar titles yet.', style: AppTextStyles.body),
      );
    }

    final posterWidth = Responsive.isMobile(context) ? 110.0 : 180.0;
    return SizedBox(
      height: posterWidth * 1.5,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.symmetric(horizontal: padding),
        itemCount: similar.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.lg),
        itemBuilder: (context, index) {
          final video = similar[index];
          return PosterCard(
            video: video,
            width: posterWidth,
            height: posterWidth * 1.5,
            onTap: () => AppNavigation.openDetails(context, video),
          );
        },
      ),
    );
  }
}
