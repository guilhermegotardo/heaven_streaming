import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../../dat/catalog/catalogo_controller.dart';
class SplashController {
  Future<void> initializeApp() async {
    await CatalogController.instance.loadCatalog();
    try {
      final catalogo = CatalogController.instance.catalogo;
      if (kDebugMode) {
        print(catalogo.videos.first.titulo);
      }
    }
    catch(e) {
      if (kDebugMode) {
      print('Erro ao carregar catálogo: $e');
      }
    }
    await Future.delayed(const Duration(seconds: 2));
  }
}