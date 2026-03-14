// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalogo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalogo _$CatalogoFromJson(Map<String, dynamic> json) => Catalogo(
  videos: (json['videos'] as List<dynamic>)
      .map((e) => Video.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CatalogoToJson(Catalogo instance) => <String, dynamic>{
  'videos': instance.videos,
};

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  id: json['id'] as String,
  titulo: json['titulo'] as String,
  ano: (json['ano'] as num).toInt(),
  duracaoSegundos: (json['duracaoSegundos'] as num).toInt(),
  generos: (json['generos'] as List<dynamic>).map((e) => e as String).toList(),
  nota: (json['nota'] as num).toDouble(),
  descricao: json['descricao'] as String,
  thumbnailUrl: json['thumbnailUrl'] as String,
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'id': instance.id,
  'titulo': instance.titulo,
  'ano': instance.ano,
  'duracaoSegundos': instance.duracaoSegundos,
  'generos': instance.generos,
  'nota': instance.nota,
  'descricao': instance.descricao,
  'thumbnailUrl': instance.thumbnailUrl,
};
