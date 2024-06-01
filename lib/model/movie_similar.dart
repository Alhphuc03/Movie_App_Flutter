import 'package:xemphim/model/movie_model.dart';

class MovieSimilar {
  final List<Movie> movies;

  MovieSimilar({required this.movies});

  factory MovieSimilar.fromMap(Map<String, dynamic> map) {
    var list = map['results'] as List;
    List<Movie> movieList = list.map((i) => Movie.fromMap(i)).toList();

    return MovieSimilar(movies: movieList);
  }
}