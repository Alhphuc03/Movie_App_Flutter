import 'package:flutter/material.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/widgets/SimilarMovieCard.dart';


class SimilarMoviesSection extends StatelessWidget {
  final Future<MovieSimilar> movieSimilar;

  const SimilarMoviesSection({required this.movieSimilar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Similar Movies',
            style: TextStyle(
              color: Colors.white,
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
                        .map((similarMovie) => SimilarMovieCard(similarMovie: similarMovie))
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
