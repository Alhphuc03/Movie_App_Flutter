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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreMoviesScreen(genreId: genreId , genreName: genreName,),
          ),
        );
      },
      child: Chip(
        label: Text(genreName),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
