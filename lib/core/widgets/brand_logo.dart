import 'package:flutter/material.dart';

import '../theme/app_tokens.g.dart';

class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.fontSize = AppFontSize.logo});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      'HEAVEN',
      maxLines: 1,
      softWrap: false,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: AppFontWeight.extrabold,
        height: AppLineHeight.tight,
        letterSpacing: fontSize >= AppFontSize.display ? -0.5 : 0,
        color: AppColors.primary,
      ),
    );
  }
}
