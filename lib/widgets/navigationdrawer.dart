import 'package:flutter/material.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/screens/GenreMoviesScreen.dart';
import 'package:xemphim/screens/GenreTvsScreen%20.dart';
import 'package:xemphim/screens/home.dart';

class DrawerNavi extends StatefulWidget {
  const DrawerNavi({Key? key}) : super(key: key);

  @override
  _DrawerNaviState createState() => _DrawerNaviState();
}

class _DrawerNaviState extends State<DrawerNavi> {
  late Future<List<MovieList>> movieList;
  late Future<List<MovieList>> tvList;

  @override
  void initState() {
    movieList = Api().getListOfMovies();
    tvList = Api().getListTV();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.black,
        child: ListView(
          children: [
            SizedBox(
              height: 120,
              child: UserAccountsDrawerHeader(
                accountName: const Text('PACK APP',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                accountEmail: null,
                currentAccountPicture:
                    null, // Set to null to remove the menu icon
                currentAccountPictureSize:
                    const Size.square(30), // Size of the close button
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 255, 0, 0),
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
            ListTile(
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
            ExpansionTile(
              title: const Text('Movies',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              children: [
                FutureBuilder<List<MovieList>>(
                  future: movieList,
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
                        children: snapshot.data!.map((movieGenre) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: ListTile(
                              title: Text(
                                movieGenre.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 190, 190, 190)),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenreMoviesScreen(
                                      genreId: movieGenre.id,
                                      genreName: movieGenre.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text('TV',
                  style: TextStyle(fontSize: 20, color: Colors.white)),
              children: [
                FutureBuilder<List<MovieList>>(
                  future: tvList,
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
                        children: snapshot.data!.map((movieGenre) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 25.0),
                            child: ListTile(
                              title: Text(
                                movieGenre.name,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 190, 190, 190)),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GenreTvsScreen(
                                      genreId: movieGenre.id,
                                      genreName: movieGenre.name,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
