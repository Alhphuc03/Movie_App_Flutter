import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/model/movie_provider';
import 'package:xemphim/model/movie_review.dart';
import 'package:xemphim/model/movie_similar.dart';
import 'package:xemphim/screens/GenreMoviesScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xemphim/screens/TrailerScreen%20.dart';

import 'package:xemphim/widgets/App_Bar.dart';

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
  late Future<List<Provider>> _provider;
  bool _seeAllReviews =
      false; // Thêm biến này để quản lý chế độ hiển thị review

  @override
  void initState() {
    super.initState();
    _movieDetails = Api().getMovieDetails(widget.movieId);
    _movieReviews = Api().getMovieReviews(widget.movieId);
    _movieSimilar = Api().getMovieSimilar(widget.movieId);
    _provider = Api().getProvider(widget.movieId);
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
          const SnackBar(
            content: Text('Could not open the trailer.'),
          ),
        );
      }
    } else {
      // Xử lý trường hợp không có trailer
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
                              width: 372,
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
                                      fontSize: 20,
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
                        Text(
                          movie.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'Released at: ${movie.releasedate.substring(0, 4)}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.star,
                                color: Colors.amber, size: 24),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                border:
                                    Border.all(color: Colors.amber, width: 2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Text(
                                '${movie.voteaverage}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
                        const SizedBox(height: 16),
                        // ElevatedButton.icon(
                        //   onPressed: () {
                        //     _playTrailer(context, movie.id);
                        //   },
                        //   icon: const Icon(Icons.play_arrow),
                        //   label: const Text('Play Trailer'),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.amber,
                        //     foregroundColor: Colors.black,
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //     ),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 24, vertical: 12),
                        //   ),
                        // ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      // TrailerScreen(movieId: movie.id),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),

                        const SizedBox(height: 16),
                        const Text(
                          'Reviews',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<List<Reviews>>(
                          future: _movieReviews,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(
                                  child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData ||
                                snapshot.data!.isEmpty) {
                              return const Center(
                                  child: Text('No reviews found.'));
                            } else {
                              final reviews = snapshot.data!;
                              final displayReviews = _seeAllReviews
                                  ? reviews
                                  : reviews.take(3).toList();
                              return Column(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: displayReviews.map((review) {
                                        return Container(
                                          width: 300,
                                          child: Card(
                                            color: Colors.black87,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          "https://image.tmdb.org/t/p/w500${review.avatarPath}",
                                                        ),
                                                      ),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        review.author,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    review.content,
                                                    style: const TextStyle(
                                                        color: Colors.white70),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Icon(Icons.star,
                                                          color: Colors.amber,
                                                          size: 16),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        review.rating
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  if (reviews.length > 3)
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _seeAllReviews = !_seeAllReviews;
                                        });
                                      },
                                      child: Text(
                                        _seeAllReviews ? 'See Less' : 'See All',
                                        style: const TextStyle(
                                            color: Colors.amber),
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      'Similar Movies',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  FutureBuilder<MovieSimilar>(
                                    future: _movieSimilar,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.movies.isEmpty) {
                                        return const Center(
                                            child: Text(
                                                'No similar movies found.'));
                                      } else {
                                        final similarMovies =
                                            snapshot.data!.movies;
                                        return SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children:
                                                similarMovies.map((movie) {
                                              return GestureDetector(
                                                onTap: () {
                                                  // Handle tapping on a similar movie
                                                },
                                                child: Container(
                                                  width: 150,
                                                  margin: const EdgeInsets.only(
                                                      right: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        child: Image.network(
                                                          "https://image.tmdb.org/t/p/w200/${movie.posterPath}",
                                                          height: 200,
                                                          width: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        movie.title,
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Providers',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height:
                                        50, // Đảm bảo chiều cao của container đủ để hiển thị hình ảnh
                                    child: FutureBuilder<List<Provider>>(
                                      future: _provider,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else if (snapshot.hasError) {
                                          return Center(
                                              child: Text(
                                                  'Error: ${snapshot.error}'));
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return SizedBox
                                              .shrink(); // Trả về một widget trống nếu không có dữ liệu
                                        } else {
                                          final List<Provider> providers = snapshot
                                              .data!; // Chuyển đổi sang danh sách các nhà cung cấp
                                          final Set<int> addedProviderIds =
                                              {}; // Set để lưu trữ các provider_id đã được thêm vào
                                          final List<Widget> uniqueProviders =
                                              []; // Danh sách các nhà cung cấp duy nhất
                                          providers.forEach((provider) {
                                            if (!addedProviderIds.contains(
                                                provider.providerId)) {
                                              // Kiểm tra xem provider_id đã tồn tại trong Set chưa
                                              addedProviderIds.add(provider
                                                  .providerId); // Thêm provider_id vào Set
                                              uniqueProviders.add(
                                                GestureDetector(
                                                  onTap: () {
                                                    // Xử lý khi nhấn vào một nhà cung cấp
                                                  },
                                                  child: Container(
                                                    margin: EdgeInsets.only(
                                                        right: 8),
                                                    child: Image.network(
                                                      "https://image.tmdb.org/t/p/w200/${provider.logoPath}",
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }
                                          });
                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: uniqueProviders,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
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
