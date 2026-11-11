import 'package:heaven_streaming/dat/catalog/catalog.dart';

/// A catalog big enough to fill every rail and grid of the design.
Catalog buildCatalog() {
  const titles = [
    'The Last Signal',
    'Iron Valley',
    'Neon Drift',
    'Wildlands',
    'Paper Moons',
    'The Quiet Year',
    'Glass City',
    'Afterglow',
    'Low Tide',
    'Orbit 9',
    'Sunday Ghosts',
    'A Very Long Title That Should Be Truncated Somewhere Along The Way',
  ];
  const genres = ['Sci-Fi', 'Drama', 'Thriller', 'Comedy'];

  return Catalog(
    videos: [
      for (final (index, title) in titles.indexed)
        Video(
          id: 'v$index',
          title: title,
          year: 2015 + index,
          durationSeconds: 3000 + index * 600,
          genres: [
            genres[index % genres.length],
            genres[(index + 1) % genres.length],
          ],
          rating: 9.8 - index * 0.4,
          description:
              'When a forgotten radio telescope picks up a message addressed to her '
              'by name, an astronomer must decide whether to answer — and what it '
              'will cost the world if she does.',
          // Even titles are series with two seasons, odd ones are movies.
          videoPath: index.isEven ? null : 'v$index/video.mp4',
          episodes: [
            if (index.isEven)
              for (var episode = 0; episode < 8; episode++)
                Episode(
                  season: episode < 5 ? 1 : 2,
                  number: episode < 5 ? episode + 1 : episode - 4,
                  title: 'Episode title $episode',
                  videoPath: 'v$index/e$episode.mp4',
                ),
          ],
        ),
    ],
  );
}
