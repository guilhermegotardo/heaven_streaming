import '../../dat/catalog/catalog.dart';

/// Presentation helpers for [Video] shared by the home, details and player.
extension VideoDisplay on Video {
  /// Episodes ordered by season, then by number.
  List<Episode> get sortedEpisodes => [...episodes]
    ..sort((a, b) => a.season != b.season
        ? a.season.compareTo(b.season)
        : a.number.compareTo(b.number));

  /// Season numbers in ascending order.
  List<int> get seasons => {for (final e in episodes) e.season}.toList()..sort();

  /// Genres worth showing (the catalog uses "NA" as "no genre").
  List<String> get visibleGenres =>
      genres.where((g) => g.trim().isNotEmpty && g.toUpperCase() != 'NA').toList();

  /// "1h 52m", "8m", "12 episodes" or "3 seasons".
  String get lengthLabel {
    if (isSeries) {
      final count = seasons.length;
      return count > 1 ? '$count seasons' : '${episodes.length} episodes';
    }
    final minutes = (durationSeconds / 60).round();
    if (minutes < 1) return '<1m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }

  /// Rating as shown in badges, or null when the catalog has no rating.
  String? get ratingLabel => rating > 0 ? rating.toStringAsFixed(1) : null;

  String get kindLabel => isSeries ? 'SERIES' : 'MOVIE';

  /// Description, or null when the catalog only has a placeholder like ".".
  String? get synopsis {
    final text = description.trim();
    return text.length > 1 ? text : null;
  }

  bool get hasPoster => posterPath?.isNotEmpty ?? false;
}
