import 'package:flutter/material.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/screens/TrailerScreen%20.dart';
import 'package:xemphim/screens/WatchMovie.dart'; // Add this import
import 'package:xemphim/widgets/GenreTag.dart';

class MovieDetails extends StatelessWidget {
  final MovieDetail movie;

  const MovieDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (movie.runtime != null)
            Text(
              'Runtime: ${movie.runtime} minutes',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 8),
          if (movie.budget != null && movie.budget != 0)
            Text(
              'Budget: \$${movie.budget}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 8),
          if (movie.revenue != null && movie.revenue != 0)
            Text(
              'Revenue: \$${movie.revenue}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            YoutubePlayerTrailer(movieId: movie.id)),
                  );
                },
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play Trailer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
              const SizedBox(width: 60),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WatchMovieScreen(
                          movieId: movie.id,
                          movieTitle: movie.original_title,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.movie),
                  label: const Text('Watch Movie'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Overview',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.overview,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
