import 'package:json_annotation/json_annotation.dart';

part 'catalog.g.dart';

@JsonSerializable()
class Catalog {
  final List<Video> videos;

  Catalog({required this.videos});

  factory Catalog.fromJson(Map<String, dynamic> json) => _$CatalogFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogToJson(this);
}

@JsonSerializable()
class Video {
  final String id;
  final String title;
  final int year;

  final int durationSeconds;
  final List<String> genres;

  final double rating;
  final String description;

  /// Paths relative to the library root (e.g. "m001/video.mp4").
  /// Series have no [videoPath]; each item in [episodes] has its own.
  final String? videoPath;
  final String? posterPath;

  @JsonKey(defaultValue: [])
  final List<Episode> episodes;

  Video(
    {
    required this.id,
    required this.title,
    required this.year,
    required this.durationSeconds,
    required this.genres,
    required this.rating,
    required this.description,
    this.videoPath,
    this.posterPath,
    this.episodes = const [],
  }
  );

  bool get isSeries => episodes.isNotEmpty;

  factory Video.fromJson(Map<String, dynamic> json) => _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}

@JsonSerializable()
class Episode {
  final int season;
  final int number;
  final String title;

  /// Path relative to the library root.
  final String videoPath;

  Episode({
    required this.season,
    required this.number,
    required this.title,
    required this.videoPath,
  });

  factory Episode.fromJson(Map<String, dynamic> json) => _$EpisodeFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
