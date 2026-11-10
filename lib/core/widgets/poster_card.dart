import 'package:flutter/material.dart';

import '../../dat/catalog/catalog.dart';
import '../theme/app_tokens.g.dart';
import 'video_art.dart';

/// Penpot "Card/Poster": 2:3 poster that grows and gets an outline on hover or
/// keyboard/remote focus.
class PosterCard extends StatefulWidget {
  const PosterCard({super.key, required this.video, required this.width, this.onTap});

  final Video video;
  final double width;
  final VoidCallback? onTap;

  @override
  State<PosterCard> createState() => _PosterCardState();
}

class _PosterCardState extends State<PosterCard> {
  bool _hovered = false;
  bool _focused = false;

  static const _radius = BorderRadius.all(Radius.circular(AppRadius.md));

  @override
  Widget build(BuildContext context) {
    final highlighted = _hovered || _focused;
    return Semantics(
      button: true,
      label: widget.video.title,
      child: SizedBox(
        width: widget.width,
        height: widget.width * 1.5,
        child: AnimatedScale(
          scale: highlighted ? 1.05 : 1,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: Material(
            color: AppColors.surface,
            borderRadius: _radius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: widget.onTap,
              onHover: (v) => setState(() => _hovered = v),
              onFocusChange: (v) => setState(() => _focused = v),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  VideoArt(video: widget.video),
                  IgnorePointer(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        borderRadius: _radius,
                        border: Border.all(
                          color: highlighted ? AppColors.textPrimary : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
