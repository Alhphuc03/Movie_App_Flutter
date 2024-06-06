import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';

class UpcomingSection extends StatelessWidget {
  const UpcomingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Future<List<Movie>> upcomingMovies = Api().getUpcomingMovies();

    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 320, // Set your desired height here
          child: Image.asset(
            'assets/banner-carousel.png', // Replace with your asset path
            fit: BoxFit.cover,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 70),
                          Stack(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Image.network(
                                    "https://image.tmdb.org/t/p/original/${movie.backdropPath}",
                                    height: 170,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                left: 15,
                                right: 15,
                                child: Container(
                                  width: MediaQuery.of(context).size.width -
                                      10 -
                                      10 -
                                      5 -
                                      5,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(137, 77, 76, 76),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '(${movie.releasedate.substring(0, 4)})',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                  options: CarouselOptions(
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 1.4,
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
