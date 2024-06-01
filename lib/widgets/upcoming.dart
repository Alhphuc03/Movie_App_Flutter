import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/screens/detail.dart';

class UpcomingSection extends StatelessWidget {
  const UpcomingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<List<Movie>> upcomingMovies = Api().getUpcomingMovies();

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/banner-carousel.png',
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20.0, 0, 0),
              child: Text(
                'Upcoming',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<Movie>>(
              future: upcomingMovies,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movies = snapshot.data!;
                return CarouselSlider.builder(
                  itemCount: movies.length,
                  itemBuilder: (context, index, realIndex) {
                    final movie = movies[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetailsScreen(movieId: movie.id),
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          // Phía sau hình ảnh
                          Positioned.fill(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/original/${movie.backdropPath}",
                                height: 150,
                              ),
                            ),
                          ),
                          // Container chứa văn bản và màu nền mờ
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(top: 160, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Màu nền đỏ
                                Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(134, 92, 92, 92),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 4),
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
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
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 1.8,
                    autoPlayInterval: const Duration(seconds: 3),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
