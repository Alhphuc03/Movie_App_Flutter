class MovieDetail {
  final String title;
  final String original_title;
  final String backdropPath;
  final String overview;
  final String posterpath;
  final double voteaverage;
  final String releasedate;
  final double popularity;
  final String posterPath;
  final int id;
  final int runtime;
  final int budget;
  final int revenue;
  final List<Genre> genres;

  MovieDetail({
    required this.title,
    required this.original_title,
    required this.backdropPath,
    required this.overview,
    required this.posterpath,
    required this.voteaverage,
    required this.releasedate,
    required this.popularity,
    required this.posterPath,
    required this.id,
    required this.runtime,
    required this.budget,
    required this.revenue,
    required this.genres,
  });

  factory MovieDetail.fromMap(Map<String, dynamic> map) {
    return MovieDetail(
      title: map['title'],
      original_title: map['original_title'],
      backdropPath: map['backdrop_path'],
      overview: map['overview'],
      posterpath: map['poster_path'],
      voteaverage: map['vote_average'].toDouble(),
      releasedate: map['release_date'],
      popularity: map['popularity'].toDouble(),
      posterPath: map['poster_path'] ??
          '', // Kiểm tra null ở đây và gán giá trị mặc định nếu là null
      id: map['id'],
      runtime: map['runtime'] ?? 0,
      budget: map['budget'] ?? 0,
      revenue: map['revenue'] ?? 0,
      genres: (map['genres'] as List<dynamic>)
          .map((genre) => Genre.fromMap(genre))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'original_title': original_title,
      'backdropPath': backdropPath,
      'overview': overview,
      'posterpath': posterpath,
      'voteaverage': voteaverage,
      'releasedate': releasedate,
      'popularity': popularity,
      'posterPath': posterPath,
      'id': id,
      'runtime': runtime,
      'budget': budget,
      'revenue': revenue,
      'genres': genres.map((genre) => genre.toMap()).toList(),
    };
  }
}

class Genre {
  final int id;
  final String name;

  Genre({required this.id, required this.name});

  factory Genre.fromMap(Map<String, dynamic> map) {
    return Genre(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}
