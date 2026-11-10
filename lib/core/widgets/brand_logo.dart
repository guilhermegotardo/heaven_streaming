import 'package:flutter/material.dart';

import '../theme/app_tokens.g.dart';

/// Wordmark used in the top bar.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.size = 28});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(
      'HEAVEN',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
        color: AppColors.primary,
        height: 1,
      ),
    );
  }
}
