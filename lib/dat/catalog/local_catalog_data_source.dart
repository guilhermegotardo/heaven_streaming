import 'dart:convert';
import 'catalogo.dart';

import 'package:flutter/services.dart' show rootBundle;

class LocalCatalogDataSource 
{
  final String assetPath;
  LocalCatalogDataSource({this.assetPath = 'assets/movies.json'});

  Future<Catalogo> loadCatalog() async 
  {
    final text = await rootBundle.loadString(assetPath);
    final jsonMap = jsonDecode(text) as Map<String, dynamic>;
    return Catalogo.fromJson(jsonMap);
  }
}