import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/screens/detail/detail_screen.dart';
import 'package:xemphim/widgets/App_Bar.dart';

class WatchHistoryScreen extends StatefulWidget {
  @override
  _WatchHistoryScreenState createState() => _WatchHistoryScreenState();
}

class _WatchHistoryScreenState extends State<WatchHistoryScreen> {
  List<dynamic> watchHistoryDetails = [];
  final String apiKey = '5744c461b4e9a5730311b1bacdc9a337';

  @override
  void initState() {
    super.initState();
    _loadWatchHistory();
  }

  Future<void> _loadWatchHistory() async {
    List<int> watchHistory = SessionManager.getWatchHistory();
    List<dynamic> details = [];
    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();
    String languageCode = isVietnameseMode ? 'vi-VN' : 'en-US';

    for (int movieId in watchHistory) {
      final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=$languageCode'),
      );

      if (response.statusCode == 200) {
        details.add(jsonDecode(response.body));
      }
    }

    setState(() {
      watchHistoryDetails = details;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      appBar: CustomAppBar(),
      body: Column(
        children: [
          Text(
            isVietnameseMode ? 'Lịch sử phim đã xem' : 'Watch History',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: watchHistoryDetails.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: watchHistoryDetails.length,
                    itemBuilder: (context, index) {
                      var movie = watchHistoryDetails[index];
                      return WatchlistItem(
                        title: movie['title'],
                        release_date: movie['release_date'],
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  MovieDetailsScreen(movieId: movie['id']),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class WatchlistItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String release_date;
  final VoidCallback onTap;

  const WatchlistItem({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.release_date,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: 120,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    release_date,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  CustomIconButton(
                    icon: Icons.remove_red_eye,
                    text: isVietnameseMode ? "Xem chi tiết" : 'View details',
                    iconBackgroundColor: Colors.white,
                    iconColor: Colors.red,
                    textColor: isDarkMode ? Colors.white : Colors.black,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconBackgroundColor;
  final Color iconColor;
  final Color textColor;
  final VoidCallback onTap;

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
