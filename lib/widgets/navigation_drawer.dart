import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/screens/genre/genre_movies_screen.dart';
import 'package:xemphim/screens/genre/genre_tvs_screen.dart';
import 'package:xemphim/screens/home/home_screen.dart';

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

  // Hàm tạo ExpansionTile
  Widget buildExpansionTile(String title, IconData icon,
      Future<List<MovieList>> list, bool showLess, bool isMovie) {
    return ExpansionTile(
      title: Row(
        children: [
          Icon(icon, color: Colors.white), // Thêm icon vào tiêu đề
          const SizedBox(width: 10), // Khoảng cách giữa icon và tiêu đề
          Text(
            title,
            style: const TextStyle(fontSize: 20, color: Colors.white),
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
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 190, 190, 190),
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
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            Container(
              // color: Color(0xFF8A8A8A), // Màu nền cho phần header
              child: SizedBox(
                height: 120,
                child: UserAccountsDrawerHeader(
                  accountName: const Text('Movie+',
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 255, 0, 0))),
                  accountEmail: null,
                  currentAccountPicture:
                      null, // Set to null to remove the menu icon
                  currentAccountPictureSize:
                      const Size.square(30), // Size of the close button
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/banner-carousel.png'),
                      fit: BoxFit.cover,
                      // Đường dẫn đến tệp tin ảnh trong assets
                    ),
                  ),
                  otherAccountsPictures: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.white),
              title: const Text('Home',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
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
                'Movies', Icons.movie, movieList, showLessMovie, true),
            buildExpansionTile('TV', Icons.tv, tvList, showLessTV, false),
          ],
        ),
      ),
    );
  }
}
