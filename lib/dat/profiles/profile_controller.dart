import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../../core/theme/key_art.dart';

class Profile {
  final String id;
  final String name;
  final LinearGradient avatar;

  const Profile({required this.id, required this.name, required this.avatar});
}

/// Profiles shown on the "Who's watching?" screen. Kept in memory for now.
class ProfileController extends ChangeNotifier {
  ProfileController._();

  static final ProfileController instance = ProfileController._();

  static const maxProfiles = 5;

  final List<Profile> _profiles = [
    Profile(id: 'gui', name: 'Gui', avatar: KeyArt.byIndex(3)),
    Profile(id: 'ana', name: 'Ana', avatar: KeyArt.byIndex(4)),
    Profile(id: 'kids', name: 'Kids', avatar: KeyArt.byIndex(5)),
    Profile(id: 'guest', name: 'Guest', avatar: KeyArt.byIndex(6)),
  ];
  int _created = 0;
  Profile? _current;

  List<Profile> get profiles => List.unmodifiable(_profiles);

  /// The profile picked on "Who's watching?"; null until one is chosen.
  Profile? get current => _current;

  bool get canAdd => _profiles.length < maxProfiles;

  void select(Profile profile) {
    _current = profile;
    notifyListeners();
  }

  void add(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || !canAdd) return;
    _created++;
    _profiles.add(
      Profile(
        id: 'profile-$_created',
        name: trimmed,
        avatar: KeyArt.byIndex(6 + _created),
      ),
    );
    notifyListeners();
  }

  void remove(Profile profile) {
    if (_profiles.length <= 1) return;
    _profiles.removeWhere((p) => p.id == profile.id);
    if (_current?.id == profile.id) _current = null;
    notifyListeners();
  }
}
