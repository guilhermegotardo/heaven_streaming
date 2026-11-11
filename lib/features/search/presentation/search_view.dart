import 'package:flutter/material.dart';

import '../../../app/navigation.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/key_art_image.dart';
import '../../../core/widgets/poster_grid.dart';
import '../../../core/widgets/state_view.dart';
import '../../../dat/catalog/catalog.dart';

/// "06 Search": search field, filter chips and the results (poster grid on
/// desktop, rows on mobile).
class SearchView extends StatefulWidget {
  const SearchView({super.key, required this.videos});

  final List<Video> videos;

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static const _all = 'All';
  static const _series = 'Series';
  static const _movies = 'Movies';

  final TextEditingController _query = TextEditingController();
  String _filter = _all;

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  /// "All", "Series", "Movies", then every genre in the catalog.
  List<String> get _filters {
    final genres = <String>{
      for (final video in widget.videos) ...video.genres,
    }.toList()..sort();
    return [_all, _series, _movies, ...genres];
  }

  List<Video> _results() {
    final query = _query.text.trim().toLowerCase();
    final results = widget.videos.where((video) {
      final matchesFilter = switch (_filter) {
        _all => true,
        _series => video.isSeries,
        _movies => !video.isSeries,
        _ => video.genres.contains(_filter),
      };
      if (!matchesFilter) return false;
      if (query.isEmpty) return true;
      return video.title.toLowerCase().contains(query) ||
          video.genres.any((genre) => genre.toLowerCase().contains(query));
    }).toList();
    if (query.isEmpty) results.sort((a, b) => b.rating.compareTo(a.rating));
    return results;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final padding = Responsive.pagePadding(context);
    final query = _query.text.trim();
    final results = _results();
    final radius = BorderRadius.circular(AppRadius.lg);

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              padding,
              isMobile ? AppSpacing.md : AppSizes.navHeight + AppSpacing.xl,
              padding,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _query,
                autofocus: !isMobile,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                cursorColor: AppColors.primary,
                style: AppTextStyles.body.copyWith(
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Search titles and genres',
                  hintStyle: AppTextStyles.body,
                  filled: true,
                  fillColor: AppColors.surfaceRaised,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: isMobile ? 10 : 20,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.textSecondary,
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 52),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          tooltip: 'Clear',
                          onPressed: () => setState(_query.clear),
                          icon: const Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                          ),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: radius,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: radius,
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: radius,
                    borderSide: const BorderSide(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.fromLTRB(padding, AppSpacing.xl, padding, 0),
              child: Row(
                children: [
                  for (final filter in _filters)
                    Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.md),
                      child: AppChip(
                        label: filter,
                        selected: filter == _filter,
                        onTap: () => setState(() => _filter = filter),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (results.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: StateView(
                icon: Icons.search_off,
                title: 'No results',
                message: query.isEmpty
                    ? 'There are no titles in "$_filter".'
                    : 'Nothing matches "$query". Try another title or genre.',
              ),
            )
          else ...[
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                padding,
                isMobile ? AppSpacing.xl : AppSpacing.xxl,
                padding,
                isMobile ? AppSpacing.lg : AppSpacing.xl,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  query.isEmpty ? 'Top Searches' : 'Top results for "$query"',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isMobile
                      ? AppTextStyles.titleSm.copyWith(
                          fontSize: AppFontSize.bodyLg,
                        )
                      : AppTextStyles.titleSm,
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.fromLTRB(
                padding,
                0,
                padding,
                AppSpacing.xxxl,
              ),
              sliver: isMobile
                  ? SliverList.separated(
                      itemCount: results.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) =>
                          _ResultRow(video: results[index]),
                    )
                  : SliverPosterGrid(videos: results),
            ),
          ],
        ],
      ),
    );
  }
}

/// Mobile result: 16:9 thumb, title and a ringed play button.
class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final canPlay = AppNavigation.canPlay(video);
    return InkWell(
      onTap: () => AppNavigation.openDetails(context, video),
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: SizedBox(
              width: 136,
              height: 76,
              child: KeyArtImage(
                video: video,
                alignment: const Alignment(0, -0.5),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              video.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.label,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          IconButton(
            tooltip: 'Play',
            onPressed: canPlay
                ? () => AppNavigation.play(context, video)
                : null,
            style: IconButton.styleFrom(
              side: const BorderSide(color: AppColors.textPrimary, width: 1.5),
              fixedSize: const Size.square(36),
              minimumSize: const Size.square(36),
              padding: EdgeInsets.zero,
            ),
            iconSize: 20,
            icon: const Icon(Icons.play_arrow_rounded),
          ),
        ],
      ),
    );
  }
}
