import 'package:flutter/material.dart';
import 'routes.dart';
import '../core/theme/app_theme.dart';
import '../features/splash/presentation/splash_page.dart';
import '../features/home/presentation/home_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GOTFLIX',
      theme: AppTheme.dark,
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.home: (_) => const HomePage(),
      },
    );
  }
}