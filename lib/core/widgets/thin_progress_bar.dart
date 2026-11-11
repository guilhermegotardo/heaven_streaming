import 'package:flutter/widgets.dart';

import '../theme/app_tokens.g.dart';

/// The 4px watched-progress line at the bottom of thumbnails.
class ThinProgressBar extends StatelessWidget {
  const ThinProgressBar({super.key, required this.value, this.height = 4});

  /// 0–1.
  final double value;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ColoredBox(
        color: AppColors.onPrimary.withValues(alpha: 0.3),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: value.clamp(0.0, 1.0),
          child: const ColoredBox(color: AppColors.primary),
        ),
      ),
    );
  }
}
