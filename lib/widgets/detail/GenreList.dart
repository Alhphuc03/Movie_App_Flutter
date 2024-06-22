import 'package:flutter/material.dart';
import 'package:xemphim/widgets/detail/GenreTag.dart';

import 'package:xemphim/model/movie_detail.dart';

class GenreList extends StatelessWidget {
  final List<Genre> genres;

  const GenreList({Key? key, required this.genres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres
          .map((genre) => GenreTag(genreName: genre.name, genreId: genre.id))
          .toList(),
    );
  }
}
