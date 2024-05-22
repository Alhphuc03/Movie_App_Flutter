import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/screens/GenreMoviesScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:xemphim/widgets/App_Bar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetail> _movieDetails;

  @override
  void initState() {
    super.initState();
    _movieDetails = Api().getMovieDetails(widget.movieId);
  }

  // Hàm mở URL của trailer
  Future<void> _playTrailer(BuildContext context, int movieId) async {
    final api = Api();
    final trailerUrl = await api.getMovieTrailerUrl(movieId);
    if (trailerUrl != null) {
      // Kiểm tra xem URL có hợp lệ không trước khi mở
      if (await canLaunch(trailerUrl)) {
        await launch(trailerUrl);
      } else {
        // Xử lý trường hợp không thể mở URL
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open the trailer.'),
          ),
        );
      }
    } else {
      // Xử lý trường hợp không có trailer
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No trailer available for this movie.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const CustomAppBar(),
      body: FutureBuilder<MovieDetail>(
        future: _movieDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No movie details found.'));
          } else {
            final movie = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Image.network(
                        "https://image.tmdb.org/t/p/original/${movie.backdropPath}",
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: Row(
                          children: [
                            Container(
                              width: 390,
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    movie.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '(${movie.releasedate.substring(0, 4)})',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    movie.voteaverage.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              'User Score',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            _playTrailer(context, movie.id);
                          },
                          icon: Icon(Icons.play_arrow),
                          label: Text('Play Trailer'),
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
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500/${movie.posterPath}",
                                height: 150,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                movie.overview,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Details',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
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
                          children: [
                            const Text(
                              'Genres:',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: movie.genres
                                    .map(
                                      (genre) => GenreTag(
                                        genreName: genre.name,
                                        genreId: genre.id,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

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
