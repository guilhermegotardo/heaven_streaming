import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../../dat/catalog/catalog_controller.dart';
import '../theme/key_art.dart';

/// The poster of [video] filling its parent, over a gradient that stays
/// visible when there is no poster or it cannot be loaded.
///
/// The parent must give it a bounded size.
class KeyArtImage extends StatelessWidget {
  const KeyArtImage({
    super.key,
    required this.video,
    this.alignment = Alignment.center,
  });

  final Video video;
  final Alignment alignment;

  static String? posterUrl(Video video) {
    final path = video.posterPath;
    if (path == null || path.isEmpty) return null;
    return CatalogController.instance.library.resolve(path).toString();
  }

  @override
  Widget build(BuildContext context) {
    final url = posterUrl(video);
    return DecoratedBox(
      decoration: BoxDecoration(gradient: KeyArt.gradientFor(video.id)),
      child: url == null
          ? const SizedBox.expand()
          : Image.network(
              url,
              fit: BoxFit.cover,
              alignment: alignment,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (_, _, _) => const SizedBox.expand(),
            ),
    );
  }
}
