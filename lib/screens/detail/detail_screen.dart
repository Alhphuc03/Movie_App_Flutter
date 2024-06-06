import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_detail.dart';

import 'package:xemphim/model/movie_review.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/widgets/detail/MovieBackdrop.dart';
import 'package:xemphim/widgets/detail/MovieDetails.dart';
import 'package:xemphim/widgets/detail/MovieInfo.dart';
import 'package:xemphim/widgets/detail/ReviewsSection.dart';
import 'package:xemphim/widgets/detail/SimilarMoviesSection.dart';

import 'package:xemphim/widgets/app_bar.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<MovieDetail> _movieDetails;
  late Future<List<Reviews>> _movieReviews;
  late Future<MovieSimilar> _movieSimilar;

  bool _seeAllReviews = false;

  @override
  void initState() {
    super.initState();
    _movieDetails = Api().getMovieDetails(widget.movieId);
    _movieReviews = Api().getMovieReviews(widget.movieId);
    _movieSimilar = Api().getMovieSimilar(widget.movieId);
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
                  MovieBackdrop(movie: movie),
                  MovieInfo(movie: movie),
                  MovieDetails(movie: movie),
                  ReviewsSection(
                    movieReviews: _movieReviews,
                    seeAllReviews: _seeAllReviews,
                    onSeeAllReviewsPressed: () {
                      setState(() {
                        _seeAllReviews = !_seeAllReviews;
                      });
                    },
                  ),
                  SimilarMoviesSection(movieSimilar: _movieSimilar),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
