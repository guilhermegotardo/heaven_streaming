import 'package:flutter/painting.dart';

import 'app_tokens.g.dart';

/// The typography library of the Penpot file ("heaven / ...").
abstract final class AppTextStyles {
  static const display = TextStyle(
    fontSize: AppFontSize.display,
    fontWeight: AppFontWeight.bold,
    height: AppLineHeight.tight,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );
  static const headline = TextStyle(
    fontSize: AppFontSize.headline,
    fontWeight: AppFontWeight.bold,
    height: AppLineHeight.tight,
    color: AppColors.textPrimary,
  );
  static const title = TextStyle(
    fontSize: AppFontSize.title,
    fontWeight: AppFontWeight.semibold,
    height: AppLineHeight.tight,
    color: AppColors.textPrimary,
  );
  static const titleSm = TextStyle(
    fontSize: AppFontSize.titleSm,
    fontWeight: AppFontWeight.semibold,
    height: AppLineHeight.tight,
    color: AppColors.textPrimary,
  );
  static const bodyLg = TextStyle(
    fontSize: AppFontSize.bodyLg,
    fontWeight: AppFontWeight.regular,
    height: AppLineHeight.normal,
    color: AppColors.textPrimary,
  );
  static const body = TextStyle(
    fontSize: AppFontSize.body,
    fontWeight: AppFontWeight.regular,
    height: AppLineHeight.normal,
    color: AppColors.textSecondary,
  );
  static const bodyStrong = TextStyle(
    fontSize: AppFontSize.body,
    fontWeight: AppFontWeight.semibold,
    height: AppLineHeight.normal,
    color: AppColors.textPrimary,
  );
  static const bodySm = TextStyle(
    fontSize: AppFontSize.bodySm,
    fontWeight: AppFontWeight.regular,
    height: AppLineHeight.normal,
    color: AppColors.textSecondary,
  );
  static const label = TextStyle(
    fontSize: AppFontSize.bodySm,
    fontWeight: AppFontWeight.semibold,
    height: AppLineHeight.tight,
    color: AppColors.textPrimary,
  );
  static const caption = TextStyle(
    fontSize: AppFontSize.caption,
    fontWeight: AppFontWeight.medium,
    height: AppLineHeight.normal,
    color: AppColors.textSecondary,
  );
  static const overline = TextStyle(
    fontSize: AppFontSize.caption,
    fontWeight: AppFontWeight.bold,
    height: AppLineHeight.tight,
    letterSpacing: 2,
    color: AppColors.primary,
  );
}
