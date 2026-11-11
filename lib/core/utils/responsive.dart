import 'package:flutter/widgets.dart';

import '../theme/app_tokens.g.dart';

/// Breakpoints between the "Mobile" and "Desktop / TV" pages of the design.
abstract final class Responsive {
  static const mobileBreakpoint = 900.0;
  static const wideBreakpoint = 1200.0;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < mobileBreakpoint;

  /// Horizontal page margin: 16 on mobile, 64 on the 1920 desktop frame.
  static double pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileBreakpoint) return AppSpacing.lg;
    if (width < wideBreakpoint) return AppSpacing.xxl;
    return AppSpacing.huge;
  }
}
