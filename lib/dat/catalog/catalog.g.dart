// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) => Catalog(
  videos: (json['videos'] as List<dynamic>)
      .map((e) => Video.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
  'videos': instance.videos,
};

Video _$VideoFromJson(Map<String, dynamic> json) => Video(
  id: json['id'] as String,
  title: json['title'] as String,
  year: (json['year'] as num).toInt(),
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
  rating: (json['rating'] as num).toDouble(),
  description: json['description'] as String,
  videoPath: json['videoPath'] as String?,
  posterPath: json['posterPath'] as String?,
  episodes:
      (json['episodes'] as List<dynamic>?)
          ?.map((e) => Episode.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'year': instance.year,
  'durationSeconds': instance.durationSeconds,
  'genres': instance.genres,
  'rating': instance.rating,
  'description': instance.description,
  'videoPath': instance.videoPath,
  'posterPath': instance.posterPath,
  'episodes': instance.episodes,
};

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  season: (json['season'] as num).toInt(),
  number: (json['number'] as num).toInt(),
  title: json['title'] as String,
  videoPath: json['videoPath'] as String,
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'season': instance.season,
  'number': instance.number,
  'title': instance.title,
  'videoPath': instance.videoPath,
};
