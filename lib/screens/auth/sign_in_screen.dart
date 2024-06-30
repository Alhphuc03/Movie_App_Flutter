import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xemphim/common/languageManager.dart';
import 'dart:convert';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/screens/account/account_screen.dart';
import 'package:xemphim/widgets/bottom_nav_bar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;
    final String apiKey = '5744c461b4e9a5730311b1bacdc9a337';

    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey&username=$username&password=$password'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String requestToken = data['request_token'];

      final validateRequestTokenResponse = await http.post(
        Uri.parse(
            'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey&request_token=$requestToken&username=$username&password=$password'),
      );

      if (validateRequestTokenResponse.statusCode == 200) {
        final validateData = jsonDecode(validateRequestTokenResponse.body);
        final bool success = validateData['success'];

        if (success) {
          final createSessionResponse = await http.post(
            Uri.parse(
                'https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey&request_token=$requestToken'),
          );

          if (createSessionResponse.statusCode == 200) {
            final sessionData = jsonDecode(createSessionResponse.body);
            final String sessionId = sessionData['session_id'];
            await SessionManager.saveSessionId(sessionId);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const BottomNavBar(initialIndex: 3)),
              (Route<dynamic> route) => false,
            );
          } else {
            _showErrorDialog('Failed to create session.');
          }
        } else {
          _showErrorDialog('Invalid username or password.');
        }
      } else {
        _showErrorDialog('Failed to validate request token.');
      }
    } else {
      _showErrorDialog('Failed to generate request token.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
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

  @override
  Widget build(BuildContext context) {
    var languageManager = Provider.of<LanguageManager>(context);
    bool isVietnameseMode = languageManager.isVietnamese();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/banner.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isVietnameseMode
                      ? "Chào mừng quay trở lại !"
                      : 'Welcome Back!',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      icon: Icon(Icons.person, color: Colors.white),
                      labelText:
                          isVietnameseMode ? "Tên đăng nhập" : 'Username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock, color: Colors.white),
                      labelText: isVietnameseMode ? "Mật khẩu" : 'Password',
                      border: InputBorder.none,
                    ),
                    obscureText: true,
                  ),
                ),
                const SizedBox(height: 40.0),
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEA4335),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    isVietnameseMode ? "Đăng nhập" : 'Login',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
