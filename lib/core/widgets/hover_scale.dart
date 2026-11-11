import 'package:flutter/widgets.dart';

/// Slightly enlarges [child] while the mouse is over it.
class HoverScale extends StatefulWidget {
  const HoverScale({super.key, required this.child, this.scale = 1.04});

  final Widget child;
  final double scale;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? widget.scale : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
