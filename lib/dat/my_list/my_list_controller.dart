import 'package:flutter/foundation.dart';

import '../profiles/profile_controller.dart';

/// "My List" of the current profile: video ids in the order they were added.
/// Kept in memory for now.
class MyListController extends ChangeNotifier {
  MyListController._();

  static final MyListController instance = MyListController._();

  final Map<String, List<String>> _idsByProfile = {};

  String get _profileId => ProfileController.instance.current?.id ?? '';

  /// Oldest first.
  List<String> get ids =>
      List.unmodifiable(_idsByProfile[_profileId] ?? const []);

  bool contains(String videoId) =>
      _idsByProfile[_profileId]?.contains(videoId) ?? false;

  @visibleForTesting
  void clear() {
    _idsByProfile.clear();
    notifyListeners();
  }

  void toggle(String videoId) {
    final ids = _idsByProfile.putIfAbsent(_profileId, () => []);
    if (!ids.remove(videoId)) ids.add(videoId);
    notifyListeners();
  }
}
