import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/screens/genre/genre_movies_screen.dart';
import 'package:xemphim/screens/genre/genre_tvs_screen.dart';
import 'package:xemphim/screens/home/home_screen.dart';
import 'package:xemphim/main.dart';

class DrawerNavi extends StatefulWidget {
  const DrawerNavi({Key? key}) : super(key: key);

  @override
  _DrawerNaviState createState() => _DrawerNaviState();
}

class _DrawerNaviState extends State<DrawerNavi> {
  late Future<List<MovieList>> movieList;
  late Future<List<MovieList>> tvList;
  int visibleMovieCount = 5;
  bool showLessMovie = false;
  bool showLessTV = false;

  @override
  void initState() {
    movieList = Api().getListOfMovies();
    tvList = Api().getListTV();
    super.initState();
  }

  // Function to build ExpansionTile
  Widget buildExpansionTile(
      String title,
      IconData icon,
      Future<List<MovieList>> list,
      bool showLess,
      bool isMovie,
      ThemeData theme) {
    Color titleColor = theme.textTheme.bodyLarge!.color!;
    Color iconColor = theme.iconTheme.color!;

    return ExpansionTile(
      title: Row(
        children: [
          Icon(icon, color: iconColor), // Adding icon to title
          const SizedBox(width: 10), // Space between icon and title
          Text(
            title,
            style: TextStyle(fontSize: 20, color: titleColor),
          ),
        ],
      ),
      children: [
        FutureBuilder<List<MovieList>>(
          future: list,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No data available.'),
              );
            } else {
              // Render list of movie genres
              return Column(
                children: [
                  ...snapshot.data!
                      .take(
                          showLess ? snapshot.data!.length : visibleMovieCount)
                      .map((movieGenre) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 25.0),
                      child: ListTile(
                        title: Text(
                          movieGenre.name,
                          style: TextStyle(
                            fontSize: 16,
                            color: titleColor,
                          ),
                        ),
                        onTap: () {
                          if (isMovie) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenreMoviesScreen(
                                  genreId: movieGenre.id,
                                  genreName: movieGenre.name,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GenreTvsScreen(
                                  genreId: movieGenre.id,
                                  genreName: movieGenre.name,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  }).toList(),
                  if (visibleMovieCount < snapshot.data!.length && !showLess)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (isMovie) {
                            showLessMovie = true;
                          } else {
                            showLessTV = true;
                          }
                        });
                      },
                      child: const Text(
                        'See more',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  if (showLess)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          if (isMovie) {
                            showLessMovie = false;
                          } else {
                            showLessTV = false;
                          }
                        });
                      },
                      child: const Text(
                        'See less',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    ThemeData theme = Theme.of(context);

    return Drawer(
      child: Container(
        color: isDarkMode ? Colors.black : Colors.white,
        child: ListView(
          children: [
            Container(
              child: SizedBox(
                height: 120,
                child: UserAccountsDrawerHeader(
                  accountName: const Text(
                    'Movie+',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 255, 0, 0),
                    ),
                  ),
                  accountEmail: null,
                  currentAccountPicture: null,
                  currentAccountPictureSize: const Size.square(30),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/banner-carousel.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  otherAccountsPictures: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.home,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                'Home',
                style: TextStyle(
                  fontSize: 20,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
            buildExpansionTile(
                'Movies', Icons.movie, movieList, showLessMovie, true, theme),
            buildExpansionTile(
                'TV', Icons.tv, tvList, showLessTV, false, theme),
          ],
        ),
      ),
    );
  }
}
