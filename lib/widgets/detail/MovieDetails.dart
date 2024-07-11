import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/movie_detail.dart';
import 'package:xemphim/screens/detail/watch_movie_screen.dart';
import 'package:xemphim/widgets/detail/GenreTag.dart';

class MovieDetails extends StatelessWidget {
  final MovieDetail movie;
  final int movieId;

  const MovieDetails({required this.movie, required this.movieId});

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 100, // set the width
                height: 80,
                child: Card(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${movie.voteaverage} ',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 146, // set the width
                height: 80,
                child: Card(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isVietnameseMode ? 'Thời lượng' : 'Time',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isVietnameseMode
                              ? '${movie.runtime} phút'
                              : '${movie.runtime} min',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 100, // set the width
                height: 80, // set the height
                child: Card(
                  color: isDarkMode
                      ? Colors.black.withOpacity(0.5)
                      : Colors.white.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(width: 1, color: Colors.grey),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          isVietnameseMode ? 'Tuổi' : 'Age',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isVietnameseMode
                              ? '${movie.adult ? '18+' : 'Không'}'
                              : '${movie.adult ? '18+' : 'No'}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            isVietnameseMode ? 'Mô tả' : 'Overview',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            color: isDarkMode
                ? Colors.black.withOpacity(0.5)
                : Colors.white.withOpacity(0.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(
                  width: 1, color: isDarkMode ? Colors.grey : Colors.white70),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                movie.overview,
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isVietnameseMode ? 'Thể loại' : 'Genres',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: movie.genres
                .map((genre) => GenreTag(
                      genreName: genre.name,
                      genreId: genre.id,
                    ))
                .toList(),
          ),
          const SizedBox(height: 45),
        ],
      ),
    );
  }
}
