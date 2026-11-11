import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/profiles/presentation/profiles_page.dart';
import '../features/shell/presentation/shell_page.dart';
import '../features/splash/presentation/splash_page.dart';
import 'routes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Heaven Streaming',
      theme: AppTheme.dark,
      scrollBehavior: const _AppScrollBehavior(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashPage(),
        AppRoutes.profiles: (_) => const ProfilesPage(),
        AppRoutes.home: (_) => const ShellPage(),
      },
    );
  }
}

/// Lets the horizontal rails be dragged with a mouse or trackpad on desktop.
class _AppScrollBehavior extends MaterialScrollBehavior {
  const _AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
