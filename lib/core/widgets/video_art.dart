import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../../dat/catalog/catalog_controller.dart';
import '../theme/app_tokens.g.dart';

/// Placeholder key-art gradients, same palette as the Penpot template.
const _artPalette = <List<Color>>[
  [Color(0xFF1B2A6B), Color(0xFF7B2FF7)],
  [Color(0xFF3A0CA3), Color(0xFFF72585)],
  [Color(0xFF0B3D2E), Color(0xFF2EC4B6)],
  [Color(0xFF5A189A), Color(0xFFFF6D00)],
  [Color(0xFF03045E), Color(0xFF00B4D8)],
  [Color(0xFF6A040F), Color(0xFFFFBA08)],
  [Color(0xFF1D3557), Color(0xFFE63946)],
  [Color(0xFF3C096C), Color(0xFFE0AAFF)],
];

List<Color> _gradientFor(String seed) {
  final sum = seed.codeUnits.fold<int>(0, (a, b) => a + b);
  return _artPalette[sum % _artPalette.length];
}

/// The poster of a [Video], or a gradient placeholder when it has none
/// (or while it loads / when it fails).
class VideoArt extends StatelessWidget {
  const VideoArt({
    super.key,
    required this.video,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.showTitleFallback = true,
  });

  final Video video;
  final BoxFit fit;
  final Alignment alignment;

  /// Writes the title over the placeholder, so cards without art stay readable.
  final bool showTitleFallback;

  @override
  Widget build(BuildContext context) {
    final placeholder = _ArtPlaceholder(video: video, showTitle: showTitleFallback);
    final path = video.posterPath;
    if (path == null || path.isEmpty) return placeholder;

    return Image.network(
      CatalogController.instance.library.resolve(path).toString(),
      fit: fit,
      alignment: alignment,
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) =>
          frame == null && !wasSynchronouslyLoaded
              ? _ArtPlaceholder(video: video, showTitle: false)
              : child,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}

class _ArtPlaceholder extends StatelessWidget {
  const _ArtPlaceholder({required this.video, required this.showTitle});

  final Video video;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _gradientFor(video.id),
        ),
      ),
      child: showTitle
          ? Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Text(
                  video.title,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            )
          : const SizedBox.expand(),
    );
  }
}

/// Blurred art filling its parent, faded into the background on the left and
/// bottom — the backdrop behind the home hero and the details header.
class VideoBackdrop extends StatelessWidget {
  const VideoBackdrop({super.key, required this.video, this.leftScrim = true});

  final Video video;
  final bool leftScrim;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRect(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Transform.scale(
              scale: 1.15,
              child: VideoArt(video: video, showTitleFallback: false),
            ),
          ),
        ),
        const ColoredBox(color: Color(0x33000000)),
        if (leftScrim)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.background.withValues(alpha: 0.95),
                  AppColors.background.withValues(alpha: 0),
                ],
                stops: const [0, 0.7],
              ),
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.background.withValues(alpha: 0), AppColors.background],
              stops: const [0.5, 1],
            ),
          ),
        ),
      ],
    );
  }
}
