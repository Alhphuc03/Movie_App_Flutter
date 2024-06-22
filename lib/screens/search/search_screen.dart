import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/widgets/App_Bar.dart';
import 'package:xemphim/widgets/navigation_drawer.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List _results = [];
  bool _isLoading = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
      });
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final apiKey = "5744c461b4e9a5730311b1bacdc9a337";

    final url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _results = data['results'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      throw Exception('Failed to load movies');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      _searchMovies(_controller.text);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : Color.fromARGB(255, 255, 255, 255),
      appBar: const CustomAppBar(),
      drawer: const DrawerNavi(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nhập tên phim ....',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: isDarkMode
                    ? const Color.fromARGB(255, 255, 255, 255)
                    : Color.fromARGB(255, 218, 218, 218),
                suffixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.black : Colors.black,
                  fontSize: 16,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              ),
              style: const TextStyle(fontSize: 20, color: Colors.black),
              onChanged: (query) {
                _searchMovies(query);
              },
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, index) {
                        final movie = _results[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailsScreen(movieId: movie['id']),
                              ),
                            );
                          },
                          child: Container(
                            height: 170,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            child: Card(
                              elevation: 5,
                              color:
                                  isDarkMode ? Colors.grey[900] : Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    movie['poster_path'] != null
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
                                            ),
                                            child: Image.network(
                                              'https://image.tmdb.org/t/p/w200${movie['poster_path']}',
                                              width: 100,
                                              // height: 180,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8.0),
                                              bottomLeft: Radius.circular(8.0),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 180,
                                              color: Colors.grey[300],
                                              child: const Icon(Icons.image),
                                            ),
                                          ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              movie['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            _formatReleaseDate(
                                                movie['release_date']),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          movie['vote_average'] != null
                                              ? Row(
                                                  children: [
                                                    const Icon(Icons.star,
                                                        color: Colors.yellow,
                                                        size: 24),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      movie['vote_average']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: isDarkMode
                                                            ? Colors.white
                                                            : Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String _formatReleaseDate(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) {
      return 'No release date';
    }

    try {
      DateTime parsedDate = DateTime.parse(releaseDate);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      print('Error parsing release date: $e');
      return 'Invalid date format';
    }
  }
}
