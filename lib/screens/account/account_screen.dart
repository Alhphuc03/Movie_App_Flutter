import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:xemphim/common/AvatarManager.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/screens/auth/auth_screen.dart';
import 'package:xemphim/widgets/App_Bar.dart';

const kBackgroundColor = Color.fromARGB(255, 0, 0, 0);
const kPrimaryColorRed = Color(0xFFEA4335);

const Color kDarkModeBackgroundColor = Colors.black;
const Color kLightModeBackgroundColor = Color.fromARGB(255, 255, 255, 255);

const Color kDarkModeCardColor = Color(0xFF3C4043);
const Color kLightModeCardColor = Color(0xDADADA);

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _accountName = '';

  Future<void> _fetchAccountDetails(String sessionId) async {
    if (sessionId == null) {
      return;
    }
    final String apiKey = '5744c461b4e9a5730311b1bacdc9a337';
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/account?api_key=$apiKey&session_id=$sessionId'),
      headers: {
        'Authorization': 'Bearer $sessionId',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String username = data['username'];
      final String? avatarPath = data['avatar']['tmdb']['avatar_path'];
      final int accountID = data['id'];

      if (mounted) {
        setState(() {
          _accountName = username ?? '';
          AvtManager.avatarUrl = avatarPath != null
              ? 'https://image.tmdb.org/t/p/w200$avatarPath'
              : '';
        });
      }

      // Lưu accountID vào SharedPreferences
      await SessionManager.saveAccountId(accountID.toString());
    } else {
      _showErrorDialog(message: 'Không thể lấy thông tin tài khoản.');
    }
  }

  void _showErrorDialog({required String message}) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Lỗi'),
            content: Text(message),
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
  }

  void _navigateToAuthScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
    );
  }

  void _logout() {
    SessionManager.clearSession();
    AvtManager.clearAvatarUrl();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AccountScreen()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  void initState() {
    super.initState();
    SessionManager.init();

    final sessionId = SessionManager.sessionId;
    print('Session ID: $sessionId');
    if (sessionId.isNotEmpty) {
      _fetchAccountDetails(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = SessionManager.sessionId;
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      backgroundColor:
          isDarkMode ? kDarkModeBackgroundColor : kLightModeBackgroundColor,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40.0,
                        backgroundImage: AvtManager.avatarUrl.isNotEmpty
                            ? NetworkImage(AvtManager.avatarUrl)
                            : const AssetImage('assets/avt_df.png')
                                as ImageProvider,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        _accountName.isNotEmpty ? _accountName : 'Account Name',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        'Welcome back!',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.only(top: 16.0),
                  children: [
                    if (sessionId.isNotEmpty) ...[
                      _buildListTile(
                        icon: Icons.list,
                        title: 'Watchlist',
                        subtitle: 'Your watchlist',
                        onTap: () {
                          // Handle tap event
                        },
                        isDarkMode: isDarkMode, // Pass isDarkMode here
                      ),
                      _buildListTile(
                        icon: Icons.favorite,
                        title: 'Favorite TV',
                        subtitle: 'Your favorite TV shows',
                        onTap: () {
                          // Handle tap event
                        },
                        isDarkMode: isDarkMode,
                      ),
                      _buildListTile(
                        icon: Icons.favorite,
                        title: 'Favorite Movie',
                        subtitle: 'Your favorite movies',
                        onTap: () {},
                        isDarkMode: isDarkMode,
                      ),
                      _buildListTile(
                        icon: Icons.star,
                        title: 'Rating',
                        subtitle: 'Your ratings',
                        onTap: () {},
                        isDarkMode: isDarkMode,
                      ),
                      _buildListTile(
                        icon: Icons.logout_outlined,
                        title: 'Logout',
                        subtitle: 'Logout from your account',
                        onTap: _logout,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                    if (sessionId.isEmpty) ...[
                      _buildListTile(
                        icon: Icons.login_outlined,
                        title: 'Login',
                        subtitle: 'Login to your account',
                        onTap: _navigateToAuthScreen,
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required bool isDarkMode, // Make sure isDarkMode is required
  }) {
    return Card(
      color: isDarkMode ? kDarkModeCardColor : kLightModeCardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: isDarkMode
                  ? Color.fromARGB(255, 0, 0, 0).withOpacity(0.5)
                  : kLightModeCardColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          leading: Icon(icon, color: kPrimaryColorRed),
          title: Text(
            title,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 18,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: onTap,
        ),
      ),
    );
  }
}
