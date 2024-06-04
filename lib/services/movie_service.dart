// movie_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> searchMovie(String movieTitle, bool disposed, Function showError) async {
  final String searchUrl =
      'https://phimapi.com/v1/api/tim-kiem?keyword=$movieTitle&limit=100';

  try {
    final response = await http.get(Uri.parse(searchUrl));

    if (disposed) return {}; // Check disposed state

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        final List<dynamic>? movies = jsonData['data']['items'];

        if (movies != null) {
          for (var movie in movies) {
            if (movie['origin_name'] == movieTitle) {
              final String slug = movie['slug'];
              return fetchMovieDetails(slug, disposed, showError);
            }
          }
        }
      }
    }
  } catch (e) {
    showError(e);
  }

  return {};
}

Future<Map<String, dynamic>> fetchMovieDetails(String slug, bool disposed, Function showError) async {
  final String movieUrl = 'https://phimapi.com/phim/$slug';

  try {
    final response = await http.get(Uri.parse(movieUrl));

    if (disposed) return {}; // Check disposed state

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      showError('An error occurred while loading movie information: ${response.statusCode}');
    }
  } catch (e) {
    showError(e);
  }

  return {};
}
