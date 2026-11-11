import '../../dat/catalog/catalog.dart';

abstract final class Formatters {
  /// 8040 -> "2h 14m", 3120 -> "52m", 5 -> "5s".
  static String runtime(int seconds) {
    if (seconds < 60) return '${seconds}s';
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours == 0) return '${minutes}m';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  /// Player clock: "18:42" or "1:02:03".
  static String clock(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  /// The catalog rating is 0–10; the design shows it as "98% match".
  static String? match(Video video) {
    if (video.rating <= 0) return null;
    return '${(video.rating * 10).round().clamp(0, 100)}% match';
  }

  static int seasonCount(Video video) =>
      video.episodes.map((e) => e.season).toSet().length;

  /// "3 Seasons" for series, "2h 14m" for movies.
  static String length(Video video) {
    if (!video.isSeries) return runtime(video.durationSeconds);
    final seasons = seasonCount(video);
    return seasons == 1 ? '1 Season' : '$seasons Seasons';
  }

  static String episodeCode(Episode episode) =>
      'S${episode.season}:E${episode.number}';
}
