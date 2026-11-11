import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import '../theme/key_art.dart';
import 'key_art_image.dart';

/// Full-bleed hero art: the title's gradient with the moon and glow from the
/// design, the poster on the right when there is one, and the left / bottom
/// scrims that blend it into the page.
///
/// The parent must give it a bounded size.
class Backdrop extends StatelessWidget {
  const Backdrop({super.key, required this.video});

  final Video video;

  @override
  Widget build(BuildContext context) {
    final posterUrl = KeyArtImage.posterUrl(video);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final glow = width * 0.6;
        final moon = width * 0.18;

        return ClipRect(
          child: Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: KeyArt.gradientFor(video.id),
                ),
              ),
              Positioned(
                left: width * 0.85 - glow / 2,
                top: height * 0.44 - glow / 2,
                width: glow,
                height: glow,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x24FFFFFF), Color(0x00FFFFFF)],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: width * 0.79 - moon / 2,
                top: height * 0.34 - moon / 2,
                width: moon,
                height: moon,
                child: const DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x1FFFFFFF),
                  ),
                ),
              ),
              if (posterUrl != null)
                Align(
                  alignment: Alignment.centerRight,
                  child: FractionallySizedBox(
                    widthFactor: 0.6,
                    heightFactor: 1,
                    child: ShaderMask(
                      blendMode: BlendMode.dstIn,
                      shaderCallback: (rect) => const LinearGradient(
                        colors: [Color(0x00FFFFFF), Color(0xFFFFFFFF)],
                        stops: [0, 0.5],
                      ).createShader(rect),
                      child: Image.network(
                        posterUrl,
                        fit: BoxFit.cover,
                        alignment: const Alignment(0, -0.5),
                        errorBuilder: (_, _, _) => const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: 0.65,
                  heightFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.background.withValues(alpha: 0.95),
                          AppColors.background.withValues(alpha: 0),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  heightFactor: 0.45,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0),
                          AppColors.background,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
