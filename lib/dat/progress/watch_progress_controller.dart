import 'package:flutter/foundation.dart';

import '../profiles/profile_controller.dart';

class WatchEntry {
  final String videoId;

  /// Index into `Video.episodes`; null for movies.
  final int? episodeIndex;
  final Duration position;
  final Duration duration;
  final DateTime updatedAt;

  const WatchEntry({
    required this.videoId,
    required this.episodeIndex,
    required this.position,
    required this.duration,
    required this.updatedAt,
  });

  double get fraction {
    if (duration <= Duration.zero) return 0;
    return (position.inMilliseconds / duration.inMilliseconds).clamp(0.0, 1.0);
  }

  Duration get remaining =>
      position >= duration ? Duration.zero : duration - position;

  bool get finished => fraction >= 0.95;
}

/// How far the current profile got in each title, fed by the player.
/// Kept in memory for now.
class WatchProgressController extends ChangeNotifier {
  WatchProgressController._();

  static final WatchProgressController instance = WatchProgressController._();

  /// profile id -> entry key -> entry.
  final Map<String, Map<String, WatchEntry>> _entries = {};

  /// profile id -> video id -> last entry watched for that title.
  final Map<String, Map<String, WatchEntry>> _latest = {};

  String get _profileId => ProfileController.instance.current?.id ?? '';

  static String _key(String videoId, int? episodeIndex) =>
      episodeIndex == null ? videoId : '$videoId#$episodeIndex';

  void save({
    required String videoId,
    int? episodeIndex,
    required Duration position,
    required Duration duration,
  }) {
    if (duration <= Duration.zero) return;
    final entry = WatchEntry(
      videoId: videoId,
      episodeIndex: episodeIndex,
      position: position,
      duration: duration,
      updatedAt: DateTime.now(),
    );
    _entries.putIfAbsent(_profileId, () => {})[_key(videoId, episodeIndex)] =
        entry;
    _latest.putIfAbsent(_profileId, () => {})[videoId] = entry;
    notifyListeners();
  }

  @visibleForTesting
  void clear() {
    _entries.clear();
    _latest.clear();
    notifyListeners();
  }

  /// Progress of one movie ([episodeIndex] null) or one episode.
  WatchEntry? entryFor(String videoId, [int? episodeIndex]) =>
      _entries[_profileId]?[_key(videoId, episodeIndex)];

  /// The last thing watched of a title (for series, the last episode opened).
  WatchEntry? latestFor(String videoId) => _latest[_profileId]?[videoId];

  /// Unfinished titles, most recently watched first.
  List<WatchEntry> get continueWatching {
    final entries =
        (_latest[_profileId]?.values ?? const <WatchEntry>[])
            .where((e) => !e.finished)
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return entries;
  }
}
