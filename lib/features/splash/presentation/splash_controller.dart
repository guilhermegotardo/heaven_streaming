import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../dat/catalog/catalog_controller.dart';

class SplashController {
  /// Minimum time the splash stays on screen (the "after delay" of the design).
  static const minimumDuration = Duration(seconds: 2);

  Future<void> initializeApp() async {
    final minimum = Future<void>.delayed(minimumDuration);
    try {
      await CatalogController.instance.loadCatalog();
    } catch (e) {
      // The home page shows the error state and lets the user retry.
      debugPrint('Failed to load catalog: $e');
    }
    await minimum;
  }
}
