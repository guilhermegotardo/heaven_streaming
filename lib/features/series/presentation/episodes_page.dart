import 'package:flutter/material.dart';

import '../../../dat/catalog/catalog.dart';
import '../../../dat/catalog/catalog_controller.dart';
import '../../player/media_player.dart';

class EpisodesPage extends StatelessWidget {
  final Video series;

  const EpisodesPage({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final episodes = [...series.episodes]
      ..sort((a, b) => a.season != b.season
          ? a.season.compareTo(b.season)
          : a.number.compareTo(b.number));

    // Every episode in order, so the player can move on to the next one by itself.
    final playlist = [
      for (final episode in episodes)
        PlayerItem(
          videoUri: CatalogController.instance.library.resolve(episode.videoPath),
          title: "${series.title} - S${episode.season}E${episode.number} - ${episode.title}",
        ),
    ];

    final bySeason = <int, List<Episode>>{};
    for (final episode in episodes) {
      bySeason.putIfAbsent(episode.season, () => []).add(episode);
    }

    return Scaffold(
      appBar: AppBar(title: Text(series.title)),
      body: ListView(
        children: [
          for (final MapEntry(key: season, value: seasonEpisodes) in bySeason.entries) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                "Season $season",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            for (final episode in seasonEpisodes)
              ListTile(
                leading: Text(
                  "${episode.number}",
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
                title: Text(episode.title),
                trailing: const Icon(Icons.play_arrow),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlayerPage(
                      playlist: playlist,
                      initialIndex: episodes.indexOf(episode),
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}
