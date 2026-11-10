import 'package:flutter/material.dart';

import '../../core/utils/video_display.dart';
import '../../dat/catalog/catalog.dart';
import '../../dat/catalog/catalog_controller.dart';
import 'media_player.dart';

/// Opens the player for a movie, or for a series starting at [episode]
/// (the first one by default) with every episode queued after it.
void playVideo(BuildContext context, Video video, {Episode? episode}) {
  final library = CatalogController.instance.library;

  final List<PlayerItem> playlist;
  var initialIndex = 0;
  if (video.isSeries) {
    final episodes = video.sortedEpisodes;
    playlist = [
      for (final e in episodes)
        PlayerItem(
          videoUri: library.resolve(e.videoPath),
          title: '${video.title} - S${e.season}E${e.number} - ${e.title}',
        ),
    ];
    if (episode != null) initialIndex = episodes.indexOf(episode).clamp(0, episodes.length - 1);
  } else {
    final path = video.videoPath;
    if (path == null) return;
    playlist = [PlayerItem(videoUri: library.resolve(path), title: video.title)];
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlayerPage(playlist: playlist, initialIndex: initialIndex),
    ),
  );
}

/// Whether [playVideo] has something to play for [video].
bool canPlay(Video video) => video.isSeries || video.videoPath != null;
