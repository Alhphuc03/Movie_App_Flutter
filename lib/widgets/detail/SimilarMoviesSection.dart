import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/widgets/detail/SimilarMovieCard.dart';

class SimilarMoviesSection extends StatelessWidget {
  final Future<MovieSimilar> movieSimilar;

  const SimilarMoviesSection({required this.movieSimilar});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Similar Movies',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<MovieSimilar>(
            future: movieSimilar,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No similar movies found.'));
              } else {
                final similarMovies = snapshot.data!.movies;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: similarMovies
                        .map((similarMovie) =>
                            SimilarMovieCard(similarMovie: similarMovie))
                        .toList(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
