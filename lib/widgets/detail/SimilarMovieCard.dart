import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';

class SimilarMovieCard extends StatelessWidget {
  final Movie similarMovie;

  const SimilarMovieCard({required this.similarMovie});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: similarMovie.id),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 300,
        margin: const EdgeInsets.only(right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              "https://image.tmdb.org/t/p/original/${similarMovie.posterPath}",
              width: 150,
              height: 225,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, color: Colors.grey);
              },
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                similarMovie.title,
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
