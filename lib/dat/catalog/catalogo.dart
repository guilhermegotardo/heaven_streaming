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
  /// Séries não têm [videoPath]; cada item de [episodios] tem o seu.
  final String? videoPath;
  final String? posterPath;

  @JsonKey(defaultValue: [])
  final List<Episodio> episodios;

  Video(
    {
    required this.id,
    required this.titulo,
    required this.ano,
    required this.duracaoSegundos,
    required this.generos,
    required this.nota,
    required this.descricao,
    this.videoPath,
    this.posterPath,
    this.episodios = const [],
  }
  );

  bool get isSerie => episodios.isNotEmpty;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Episodio {
  final int temporada;
  final int numero;
  final String titulo;

  /// Caminho relativo à raiz da biblioteca.
  final String videoPath;

  Episodio({
    required this.temporada,
    required this.numero,
    required this.titulo,
    required this.videoPath,
  });

  factory Episodio.fromJson(Map<String, dynamic> json) => _$EpisodioFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodioToJson(this);
}