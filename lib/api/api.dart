import 'package:http/http.dart' as http;
import 'package:xemphim/api/constants.dart';

import 'dart:convert';

import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/model/movie_review.dart';

class Api {
  final upComingApiurl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiurl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiurl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";
  final getMovieList =
      "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey";
  final getTVList =
      "https://api.themoviedb.org/3/genre/tv/list?api_key=$apiKey";

  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(Uri.parse(upComingApiurl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(Uri.parse(popularApiurl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(Uri.parse(topRatedApiurl));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<MovieList>> getListOfMovies() async {
    final response = await http.get(Uri.parse(getMovieList));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];

      List<MovieList> movies =
          data.map((genre) => MovieList.fromMap(genre)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movie genres');
    }
  }

  Future<List<MovieList>> getListTV() async {
    final response = await http.get(Uri.parse(getTVList));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];

      List<MovieList> movies =
          data.map((genre) => MovieList.fromMap(genre)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movie genres');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId) async {
    final url =
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<List<Movie>> getTVByGenre(int genreId) async {
    final url =
        "https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&with_genres=$genreId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load TV shows by genre');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId) async {
    final url = "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      MovieDetail movieDetail = MovieDetail.fromMap(data); // Change here
      return movieDetail; // Change here
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<String?> getMovieTrailerUrl(int movieId) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (data.isNotEmpty) {
        final String key = data[0]['key'];
        return 'https://www.youtube.com/watch?v=$key';
      }
    }
    return null;
  }

  Future<List<Reviews>> getMovieReviews(int movieId) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((review) => Reviews.fromMap(review)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}
