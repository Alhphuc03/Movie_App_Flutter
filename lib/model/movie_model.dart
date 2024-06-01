class Movie {
  final String title;
  final String backdropPath;
  final String overview;
  final String posterpath;
  final double voteaverage;
  final String releasedate;
  final double popularity;
  final String posterPath;
  final int id;

  Movie(
      {required this.title,
      required this.backdropPath,
      required this.overview,
      required this.posterpath,
      required this.voteaverage,
      required this.releasedate,
      required this.popularity,
      required this.posterPath,
      required this.id});

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      title: map['title'] ?? '',
      backdropPath: map['backdrop_path'] ?? '',
      overview: map['overview'] ?? '',
      posterpath: map['poster_path'] ?? '',
      voteaverage: (map['vote_average'] ?? 0.0).toDouble(),
      releasedate: map['release_date'] ?? '',
      popularity: (map['popularity'] ?? 0.0).toDouble(),
      posterPath: map['poster_path'] ?? '',
      id: map['id'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'backdropPath': backdropPath,
      'overview': overview,
      'posterpath': posterpath,
      'voteaverage': voteaverage,
      'releasedate': releasedate,
      'popularity': popularity,
      'posterPath': posterPath,
      'id': id,
    };
  }
}
