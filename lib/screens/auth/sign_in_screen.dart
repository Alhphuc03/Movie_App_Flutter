import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/screens/account/account_screen.dart';

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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
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
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person, color: Colors.black),
                      labelText: 'Username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.lock, color: Colors.black),
                      labelText: 'Password',
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
                  child: const Text(
                    'Login',
                    style: TextStyle(
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
