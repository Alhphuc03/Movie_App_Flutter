class TVShow {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final List<TVShowPart> parts;

  TVShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.parts,
  });

  factory TVShow.fromMap(Map<String, dynamic> map) {
    return TVShow(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      parts: (map['parts'] as List<dynamic>?)
              ?.map((part) => TVShowPart.fromMap(part))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'parts': parts.map((part) => part.toMap()).toList(),
    };
  }
}

class TVShowPart {
  final int id;
  final String title;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final String posterPath;
  final String backdropPath;
  final double popularity;
  final String releaseDate;
  final bool video;
  final double voteAverage;
  final int voteCount;
  final List<int> genreIds;
  final bool adult;
  final String mediaType;

  TVShowPart({
    required this.id,
    required this.title,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.popularity,
    required this.releaseDate,
    required this.video,
    required this.voteAverage,
    required this.voteCount,
    required this.genreIds,
    required this.adult,
    required this.mediaType,
  });

  factory TVShowPart.fromMap(Map<String, dynamic> map) {
    return TVShowPart(
      id: map['id'] ?? 0,
      title: map['title'] ?? '',
      originalLanguage: map['original_language'] ?? '',
      originalTitle: map['original_title'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      popularity: (map['popularity'] ?? 0.0).toDouble(),
      releaseDate: map['release_date'] ?? '',
      video: map['video'] ?? false,
      voteAverage: (map['vote_average'] ?? 0.0).toDouble(),
      voteCount: map['vote_count'] ?? 0,
      genreIds: List<int>.from(map['genre_ids'] ?? []),
      adult: map['adult'] ?? false,
      mediaType: map['media_type'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'originalLanguage': originalLanguage,
      'originalTitle': originalTitle,
      'overview': overview,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'popularity': popularity,
      'releaseDate': releaseDate,
      'video': video,
      'voteAverage': voteAverage,
      'voteCount': voteCount,
      'genreIds': genreIds,
      'adult': adult,
      'mediaType': mediaType,
    };
  }
}
