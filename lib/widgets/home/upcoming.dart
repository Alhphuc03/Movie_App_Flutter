import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_model.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';

// Ví dụ cho UpcomingSection
class UpcomingSection extends StatelessWidget {
  const UpcomingSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();

    final Future<List<Movie>> upcomingMovies = Api().getUpcomingMovies(
      isVietnameseMode ? 'vi-VN' : 'en-US',
    );

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
            Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
              child: Text(
                isVietnameseMode ? "Sắp ra mắt" : 'Upcoming',
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
                  return Center(child: CircularProgressIndicator());
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
                          SizedBox(height: 70),
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
                                    color: isDarkMode
                                        ? Color.fromARGB(137, 77, 76, 76)
                                        : Color.fromARGB(137, 244, 244, 244),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '(${movie.releasedate.substring(0, 4)})',
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white70
                                              : Colors.black54,
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
                    autoPlayInterval: Duration(seconds: 3),
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
