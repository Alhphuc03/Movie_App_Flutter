import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:xemphim/common/AvatarManager.dart';
import 'package:xemphim/common/languageManager.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/screens/mylistmovie/userHeader.dart';
import 'package:xemphim/widgets/App_Bar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<dynamic> _favoriteMovies = [];
  String _userName = '';
  String _avatarUrl = '';

  Future<void> _fetchFavoriteMovies(String accountId, String sessionId) async {
    final String apiKey = '5744c461b4e9a5730311b1bacdc9a337';
    var languageManager = Provider.of<LanguageManager>(context, listen: false);
    bool isVietnameseMode = languageManager.isVietnamese();
    String languageCode = isVietnameseMode ? 'vi-VN' : 'en-US';

    // Fetch favorite movies
    final moviesResponse = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId&sort_by=created_at.desc&language=$languageCode'),
    );

    if (moviesResponse.statusCode == 200) {
      final moviesData = jsonDecode(moviesResponse.body);
      setState(() {
        _favoriteMovies = moviesData['results'];
      });
    } else {
      _showErrorDialog();
    }

    // Fetch user details
    final userResponse = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/account?api_key=$apiKey&session_id=$sessionId'),
    );

    if (userResponse.statusCode == 200) {
      final userData = jsonDecode(userResponse.body);
      setState(() {
        _userName = userData['username'];
        AvtManager.avatarUrl = userData['avatar']['tmdb']['avatar_path'] != null
            ? 'https://image.tmdb.org/t/p/w200${userData['avatar']['tmdb']['avatar_path']}'
            : '';
      });
    } else {
      _showErrorDialog();
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Lỗi'),
          content: const Text(
              'Không thể lấy danh sách phim yêu thích hoặc thông tin người dùng.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final sessionId = SessionManager.sessionId;
    final accountId = SessionManager.accountId;

    if (sessionId.isNotEmpty && accountId.isNotEmpty) {
      _fetchFavoriteMovies(accountId, sessionId);
    }
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
            isVietnameseMode ? 'Phim yêu thích' : 'Favorite Movies',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          // UserHeader(userName: _userName),
          Expanded(
            child: _favoriteMovies.isNotEmpty
                ? ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _favoriteMovies.length,
                    itemBuilder: (BuildContext context, int index) {
                      final movie = _favoriteMovies[index];
                      return WatchlistItem(
                        title: movie['title'],
                        imageUrl:
                            'https://image.tmdb.org/t/p/w500/${movie['poster_path']}',
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
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

  const WatchlistItem({Key? key, required this.title, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();
    return Card(
      // color: isDarkMode ? Colors.black : Colors.grey[400],
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Bo tròn các góc
              child: Image.network(
                imageUrl,
                width: 150,
                height: 230,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  CustomIconButton(
                    icon: Icons.add,
                    text: isVietnameseMode ? "Thêm danh sách" : 'Add to list',
                    iconBackgroundColor: Colors.white,
                    iconColor: Colors.red,
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  CustomIconButton(
                    icon: Icons.star,
                    text: isVietnameseMode ? "Đánh giá" : 'Rate it!',
                    iconBackgroundColor: Colors.white,
                    iconColor: Colors.red,
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  CustomIconButton(
                    icon: Icons.favorite,
                    text: isVietnameseMode ? "Yêu thích" : '  ',
                    iconBackgroundColor: Colors.red,
                    iconColor: Colors.white,
                    textColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                  CustomIconButton(
                    icon: Icons.remove,
                    text: isVietnameseMode ? "Xóa" : 'Remove',
                    iconBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                    iconColor: Colors.red,
                    textColor: isDarkMode ? Colors.white : Colors.black,
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

  const CustomIconButton({
    Key? key,
    required this.icon,
    required this.text,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
    );
  }
}
