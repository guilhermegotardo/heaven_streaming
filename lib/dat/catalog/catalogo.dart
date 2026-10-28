import 'package:json_annotation/json_annotation.dart';

part 'catalogo.g.dart';

@JsonSerializable()
class Catalogo {
  final List<Video> videos;

  Catalogo({required this.videos});

  factory Catalogo.fromJson(Map<String, dynamic> json) => _$CatalogoFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogoToJson(this);
}

@JsonSerializable()
class Video {
  final String id;
  final String titulo;
  final int ano;

  final int duracaoSegundos;
  final List<String> generos;

  final double nota;
  final String descricao;

  /// Caminhos relativos à raiz da biblioteca (ex.: "m001/video.mp4").
  final String videoPath;
  final String? posterPath;

  Video(
    {
    required this.id,
    required this.titulo,
    required this.ano,
    required this.duracaoSegundos,
    required this.generos,
    required this.nota,
    required this.descricao,
    required this.videoPath,
    this.posterPath,
  }
  );

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}