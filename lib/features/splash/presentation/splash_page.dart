import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_tokens.g.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/brand_logo.dart';
import 'splash_controller.dart';

/// "01 Splash": logo over a red glow, then on to "Who's watching?".
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SplashController _controller = SplashController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _controller.initializeApp();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.profiles);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isMobile = Responsive.isMobile(context);
    final glow = math.min(size.width, size.height) * (isMobile ? 1.3 : 0.93);
    final spinner = isMobile ? 24.0 : 30.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: OverflowBox(
              maxWidth: glow,
              maxHeight: glow,
              child: Container(
                width: glow,
                height: glow,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.16),
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.primary.withValues(alpha: 0),
                    ],
                    stops: const [0, 0.6, 1],
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: BrandLogo(
                    fontSize: isMobile
                        ? AppFontSize.displayLg
                        : AppFontSize.splash,
                  ),
                ),
                SizedBox(height: isMobile ? AppSpacing.sm : AppSpacing.lg),
                Text(
                  'STREAMING',
                  style: AppTextStyles.overline.copyWith(
                    fontSize: isMobile
                        ? AppFontSize.caption
                        : AppFontSize.bodyLg,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.44),
            child: SizedBox.square(
              dimension: spinner,
              child: const CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
                backgroundColor: AppColors.border,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
