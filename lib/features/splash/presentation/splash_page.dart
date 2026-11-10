import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../core/theme/app_tokens.g.dart';
import 'splash_controller.dart';

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

    if (!mounted){
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/gotflix_splash.png',
              width: 220,
            ),
            const SizedBox(height: AppSpacing.xl),
            const SizedBox.square(
              dimension: 36,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.border,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}