import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/screens/detail/watch_movie_screen.dart';

class WatchMovieButton extends StatelessWidget {
  final int movieId;
  final String movieTitle;

  const WatchMovieButton({
    required this.movieId,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WatchMovieScreen(
                movieId: movieId,
                movieTitle: movieTitle,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF0000),
          foregroundColor: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_creation_outlined),
            SizedBox(width: 8),
            Text(isVietnameseMode ? "Xem phim" : 'Watch Movie',
                style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
