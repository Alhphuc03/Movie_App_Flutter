import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xemphim/common/AvatarManager.dart';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/screens/auth/auth_screen.dart';
import 'package:xemphim/widgets/App_Bar.dart';

const kBackgroundColor = Color.fromARGB(255, 9, 9, 24);
const kPrimaryColorRed = Color(0xFFEA4335);
const kQuaternaryColorDarkGray = Color(0xFF3C4043);

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
      if (mounted) {
        setState(() {
          _accountName = username ?? '';
          GlobalManager.avatarUrl = avatarPath != null
              ? 'https://image.tmdb.org/t/p/w200$avatarPath'
              : '';
        });
      }
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
    GlobalManager.clearAvatarUrl();

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
    if (sessionId.isNotEmpty) {
      _fetchAccountDetails(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionId = SessionManager.sessionId;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [kBackgroundColor, kBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100.0),
              Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: GlobalManager.avatarUrl.isNotEmpty
                        ? NetworkImage(GlobalManager.avatarUrl)
                        : const AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _accountName.isNotEmpty
                              ? _accountName
                              : 'Account Name',
                          style: const TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: ListView(
                  children: [
                    if (sessionId.isNotEmpty) ...[
                      _buildListTile(
                        icon: Icons.movie,
                        title: 'Favorite Movie',
                        onTap: () {
                          // Xử lý sự kiện khi nhấn vào Phim yêu thích
                        },
                      ),
                      _buildListTile(
                        icon: Icons.tv,
                        title: 'Favorite TV',
                        onTap: () {
                          // Xử lý sự kiện khi nhấn vào TV yêu thích
                        },
                      ),
                      _buildListTile(
                        icon: Icons.watch_later,
                        title: 'WatchList',
                        onTap: () {
                          // Xử lý sự kiện khi nhấn vào Danh sách xem sau
                        },
                      ),
                    ],
                    _buildListTile(
                      icon: sessionId.isNotEmpty
                          ? Icons.logout_outlined
                          : Icons.login_outlined,
                      title: sessionId.isNotEmpty ? 'Logout' : 'Login',
                      onTap: sessionId.isNotEmpty
                          ? _logout
                          : _navigateToAuthScreen,
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

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      color: kQuaternaryColorDarkGray,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Icon(icon, color: kPrimaryColorRed),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
        onTap: onTap,
      ),
    );
  }
}
