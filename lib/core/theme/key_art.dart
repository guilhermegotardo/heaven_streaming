import 'package:flutter/painting.dart';

/// Gradient key art from the Penpot design, used for profile avatars and as a
/// placeholder whenever a title has no poster (or the poster fails to load).
abstract final class KeyArt {
  static const _pairs = <(int, int)>[
    (0xFF1B2A6B, 0xFF7B2FF7),
    (0xFF3A0CA3, 0xFFF72585),
    (0xFF0B3D2E, 0xFF2EC4B6),
    (0xFF5A189A, 0xFFFF6D00),
    (0xFF03045E, 0xFF00B4D8),
    (0xFF6A040F, 0xFFFFBA08),
    (0xFF1D3557, 0xFFE63946),
    (0xFF2B2D42, 0xFF8D99AE),
    (0xFF004B23, 0xFF9EF01A),
    (0xFF3C096C, 0xFFE0AAFF),
    (0xFF370617, 0xFFE85D04),
    (0xFF0D1B2A, 0xFF778DA9),
  ];

  static int get count => _pairs.length;

  static LinearGradient byIndex(int index) {
    final (start, end) = _pairs[index % _pairs.length];
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(start), Color(end)],
    );
  }

  /// Always returns the same gradient for the same [seed] (e.g. a video id).
  static LinearGradient gradientFor(String seed) {
    var hash = 0;
    for (final unit in seed.codeUnits) {
      hash = (hash * 31 + unit) & 0x7fffffff;
    }
    return byIndex(hash);
  }
}
