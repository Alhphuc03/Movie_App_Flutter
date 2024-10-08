import 'package:http/http.dart' as http;
import 'package:xemphim/api/constants.dart';
import 'dart:convert';
import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/model/movie_review.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/model/tv_model.dart';

class Api {
  final upComingApiurl =
      "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey";
  final popularApiurl =
      "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey";
  final topRatedApiurl =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey";

  Future<List<Movie>> getUpcomingMovies(String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=$languageCode";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<List<Movie>> getPopularMovies(String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=$languageCode";

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies(String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=$languageCode";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<List<MovieList>> getListOfMovies(String languageCode) async {
    final getMovieList =
        "https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=$languageCode";
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

  Future<List<MovieList>> getListTV(String languageCode) async {
    final getTVList =
        "https://api.themoviedb.org/3/genre/tv/list?api_key=$apiKey&language=$languageCode";

    final response = await http.get(Uri.parse(getTVList));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['genres'];

      List<MovieList> movies =
          data.map((genre) => MovieList.fromMap(genre)).toList();
      return movies;
    } else {
      throw Exception('Failed to load tv genres');
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=$genreId&language=$languageCode";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to load movies by genre');
    }
  }

  Future<List<TVShow>> getTVsByGenre(int genreId, String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/discover/tv?api_key=$apiKey&with_genres=$genreId&language=$languageCode";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];

      List<TVShow> tvShows = data.map((tv) => TVShow.fromMap(tv)).toList();
      return tvShows;
    } else {
      throw Exception('Failed to load TV shows by genre');
    }
  }

  Future<MovieDetail> getMovieDetails(int movieId, String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=$languageCode";
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

  Future<List<Reviews>> getMovieReviews(
      int movieId, String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/reviews?api_key=$apiKey&language=$languageCode";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((review) => Reviews.fromMap(review)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<MovieSimilar> getMovieSimilar(int movieId, String languageCode) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=$apiKey&language=$languageCode";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      MovieSimilar moviesimilar = MovieSimilar.fromMap(data); // Change here
      return moviesimilar; // Change here
    } else {
      throw Exception('Failed to load movie similar');
    }
  }

  Future<String> getDirectorName(int movieId) async {
    final url =
        "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=$apiKey";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> crew = data['crew'];
      final director = crew.firstWhere((member) => member['job'] == 'Director',
          orElse: () => null);
      if (director != null) {
        return director['name'];
      } else {
        throw Exception('Director not found');
      }
    } else {
      throw Exception('Failed to load director');
    }
  }

  Future<void> _getAccountDetails(String sessionId) async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/account?api_key=$apiKey&session_id=$sessionId'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final int accountId = data['id'];
      print('Account ID: $accountId');
      // Bạn có thể lưu hoặc sử dụng accountId ở đây
    } else {
      throw Exception('Failed to load movie similar');
    }
  }

  Future<int> getAccountId(String sessionId) async {
    final url =
        "https://api.themoviedb.org/3/account?api_key=$apiKey&session_id=$sessionId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final int accountId = data['id'];
      return accountId;
    } else {
      throw Exception('Failed to load account ID');
    }
  }

  Future<void> markAsFavorite(
      int accountId, String sessionId, int movieId, bool favorite) async {
    final url =
        'https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'favorite': favorite,
      }),
    );

    if (response.statusCode == 200) {
      throw Exception('Failed to mark as favorite: ${response.statusCode}');
    } else {
      print('Marked as favorite successfully');
    }
  }

  Future<void> addToWatchlist(
      int accountId, String sessionId, int movieId, bool watchlist) async {
    final url =
        'https://api.themoviedb.org/3/account/$accountId/watchlist?api_key=$apiKey&session_id=$sessionId';
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json;charset=utf-8'},
      body: jsonEncode({
        'media_type': 'movie',
        'media_id': movieId,
        'watchlist': watchlist,
      }),
    );

    if (response.statusCode == 200) {
      throw Exception('Failed to mark as favorite: ${response.statusCode}');
    } else {
      print('Marked as favorite successfully');
    }
  }
}
