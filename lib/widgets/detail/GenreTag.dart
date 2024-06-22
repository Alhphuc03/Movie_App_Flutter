import 'package:flutter/material.dart';

import 'package:xemphim/screens/genre/genre_movies_screen.dart';

class GenreTag extends StatelessWidget {
  final String genreName;
  final int genreId;

  const GenreTag({required this.genreName, required this.genreId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Chuyển qua trang xem phim theo thể loại
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreMoviesScreen(
              genreId: genreId, // Pass genreId to GenreMoviesScreen
              genreName: genreName, // Pass genreName to GenreMoviesScreen
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.indigo],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          genreName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
