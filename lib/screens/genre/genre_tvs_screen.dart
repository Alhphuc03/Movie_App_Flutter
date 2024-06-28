import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/api/api.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/common/untils.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/model/list_model.dart';
import 'package:xemphim/model/tv_model.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';
import 'package:xemphim/widgets/App_Bar.dart';
import 'package:xemphim/widgets/navigation_drawer.dart';

class GenreTvsScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  const GenreTvsScreen({
    Key? key,
    required this.genreId,
    required this.genreName,
  }) : super(key: key);

  @override
  _GenreTvsScreenState createState() => _GenreTvsScreenState();
}

class _GenreTvsScreenState extends State<GenreTvsScreen> {
  late Future<List<MovieList>> tvList;
  late Future<List<TVShow>> _tvShows;
  late int selectedGenreId;
  int visibleTvCount = 5;
  bool showLessTv = false;

  @override
  void initState() {
    super.initState();
    selectedGenreId = widget.genreId;
    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();
    String languageCode = isVietnameseMode ? 'vi-VN' : 'en-US';
    tvList = Api().getListTV(languageCode);
    _tvShows = Api().getTVsByGenre(selectedGenreId, languageCode);
  }

  void _onGenreSelected(int genreId, String languageCode) {
    setState(() {
      selectedGenreId = genreId;
      languageCode = languageCode;
      _tvShows = Api().getTVsByGenre(selectedGenreId, languageCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();
    String languageCode = isVietnameseMode ? 'vi-VN' : 'en-US';

    return Scaffold(
      backgroundColor: isDarkMode ? kBackgoundColor : Colors.white,
      appBar: CustomAppBar(),
      drawer: DrawerNavi(),
      body: Column(
        children: [
          // Genre tags
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
                return Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final genre = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: GestureDetector(
                          onTap: () => _onGenreSelected(genre.id, languageCode),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            decoration: BoxDecoration(
                              color: selectedGenreId == genre.id
                                  ? Colors.red
                                  : Colors.grey[800],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              genre.name,
                              style: TextStyle(
                                color: selectedGenreId == genre.id
                                    ? Colors.white
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
          Expanded(
            child: FutureBuilder<List<TVShow>>(
              future: _tvShows,
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
                    child: Text('No TV shows available for this genre.'),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 0.55,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final tvShow = snapshot.data![index];
                        return _buildTVShowCard(context, tvShow);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTVShowCard(BuildContext context, TVShow tvShow) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(movieId: tvShow.id),
          ),
        );
      },
      child: Container(
        child: Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  'https://image.tmdb.org/t/p/original/${tvShow.posterPath}',
                  fit: BoxFit.cover,
                  height: 280,
                  width: double.infinity,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tvShow.name,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
