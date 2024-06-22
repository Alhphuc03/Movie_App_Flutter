import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/model/movie_review.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/widgets/app_bar.dart';
import 'package:xemphim/widgets/detail/MovieBackdrop.dart';
import 'package:xemphim/widgets/detail/MovieDetails.dart';
import 'package:xemphim/widgets/detail/MovieInfo.dart';
import 'package:xemphim/widgets/detail/ReviewsSection.dart';
import 'package:xemphim/widgets/detail/SimilarMoviesSection.dart';
import 'package:xemphim/widgets/detail/watch_movie_button.dart'; // Import WatchMovieButton

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({Key? key, required this.movieId}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Future<MovieDetail> _movieDetails;
  late Future<List<Reviews>> _movieReviews;
  late Future<MovieSimilar> _movieSimilar;

  bool _seeAllReviews = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _movieDetails = Api().getMovieDetails(widget.movieId);
    _movieReviews = Api().getMovieReviews(widget.movieId);
    _movieSimilar = Api().getMovieSimilar(widget.movieId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: CustomAppBar(),
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
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MovieBackdrop(movie: movie),
                      Container(
                        child: TabBar(
                          controller: _tabController,
                          labelColor: isDarkMode ? Colors.white : Colors.black,
                          unselectedLabelColor:
                              isDarkMode ? Colors.grey : Colors.black87,
                          indicatorColor:
                              isDarkMode ? Colors.white : Colors.black,
                          indicatorWeight: 3,
                          dividerColor:
                              isDarkMode ? Colors.white : Colors.black,
                          labelStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          tabs: const [
                            Tab(text: 'Detail'),
                            Tab(text: 'Reviews'),
                            Tab(text: 'Similar'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 500, // Fixed height for the TabBarView
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildMovieDescription(movie),
                            _buildMovieReviews(),
                            _buildSimilarMovies(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Align the button at the bottom
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: WatchMovieButton(
                      movieId: movie.id,
                      movieTitle: movie.original_title,
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildMovieDescription(MovieDetail movie) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MovieDetails(movie: movie),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieReviews() {
    return FutureBuilder<List<Reviews>>(
      future: _movieReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No reviews available.'));
        } else {
          return ReviewsSection(
            movieReviews: _movieReviews,
            seeAllReviews: _seeAllReviews,
            onSeeAllReviewsPressed: () {
              setState(() {
                _seeAllReviews = !_seeAllReviews;
              });
            },
          );
        }
      },
    );
  }

  Widget _buildSimilarMovies() {
    return FutureBuilder<MovieSimilar>(
      future: _movieSimilar,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No similar movies found.'));
        } else {
          final similarMovies = snapshot.data!;
          return SimilarMoviesSection(movieSimilar: _movieSimilar);
        }
      },
    );
  }
}
