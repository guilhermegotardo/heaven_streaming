import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../dat/catalog/catalog_controller.dart';

class SplashController {
  Future<void> initializeApp() async {
    try {
      await CatalogController.instance.loadCatalog();
      final catalog = CatalogController.instance.catalog;
      if (kDebugMode) {
        print(catalog.videos.first.title);
      }
    }
    catch(e) {
      if (kDebugMode) {
      print('Failed to load catalog: $e');
      }
    }
    await Future.delayed(const Duration(seconds: 2));
  }
}