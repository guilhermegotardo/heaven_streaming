import 'package:flutter/material.dart';

import '../dat/catalog/catalog.dart';
import '../dat/catalog/catalog_controller.dart';
import '../dat/progress/watch_progress_controller.dart';
import '../core/utils/formatters.dart';
import '../features/details/presentation/details_page.dart';
import '../features/player/media_player.dart';
import 'routes.dart';

/// Sections reachable from the top nav (desktop) / bottom nav (mobile).
enum ShellTab {
  home('Home'),
  series('Series'),
  movies('Movies'),
  newAndPopular('New & Popular'),
  myList('My List'),
  search('Search');

  const ShellTab(this.label);

  final String label;
}

abstract final class AppNavigation {
  /// The section shown by the shell page.
  static final ValueNotifier<ShellTab> tab = ValueNotifier(ShellTab.home);

  /// Shows [target], closing any details page that is open above the shell.
  static void goToTab(BuildContext context, ShellTab target) {
    tab.value = target;
    Navigator.of(context).popUntil(
      (route) => route.settings.name == AppRoutes.home || route.isFirst,
    );
  }

  /// Back to "Who's watching?".
  static void switchProfile(BuildContext context) {
    tab.value = ShellTab.home;
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.profiles, (_) => false);
  }

  static void openDetails(BuildContext context, Video video) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => DetailsPage(video: video)));
  }

  static bool canPlay(Video video) => video.isSeries || video.videoPath != null;

  /// Index of the episode "Play" should start: the last one watched, or the
  /// following one when that was finished.
  static int resumeEpisodeIndex(Video video) {
    final latest = WatchProgressController.instance.latestFor(video.id);
    final index = latest?.episodeIndex;
    if (latest == null || index == null || index >= video.episodes.length) {
      return 0;
    }
    if (latest.finished && index < video.episodes.length - 1) return index + 1;
    return index;
  }

  /// Opens the player. Series play as a playlist of all episodes starting at
  /// [episodeIndex] (default: where the profile stopped).
  static void play(BuildContext context, Video video, {int? episodeIndex}) {
    if (!canPlay(video)) return;
    final library = CatalogController.instance.library;

    final List<PlayerItem> playlist;
    var initialIndex = 0;
    if (video.isSeries) {
      playlist = [
        for (final (index, episode) in video.episodes.indexed)
          PlayerItem(
            videoUri: library.resolve(episode.videoPath),
            title: video.title,
            subtitle: '${Formatters.episodeCode(episode)} · ${episode.title}',
            videoId: video.id,
            episodeIndex: index,
          ),
      ];
      initialIndex = episodeIndex ?? resumeEpisodeIndex(video);
    } else {
      playlist = [
        PlayerItem(
          videoUri: library.resolve(video.videoPath!),
          title: video.title,
          videoId: video.id,
        ),
      ];
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            PlayerPage(playlist: playlist, initialIndex: initialIndex),
      ),
    );
  }
}
