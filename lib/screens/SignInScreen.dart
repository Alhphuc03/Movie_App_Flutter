import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xemphim/common/session_manager.dart';
import 'package:xemphim/screens/AccoutScreen.dart';

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
    final String apiKey =
        '5744c461b4e9a5730311b1bacdc9a337'; // Replace with your actual API key from TMDB

    // 1. Generate Request Token
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/authentication/token/new?api_key=$apiKey&username=$username&password=$password'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String requestToken = data['request_token'];

      // 2. Validate Request Token (using POST for security)
      final validateRequestTokenResponse = await http.post(
        Uri.parse(
            'https://api.themoviedb.org/3/authentication/token/validate_with_login?api_key=$apiKey&request_token=$requestToken&username=$username&password=$password'),
      );

      if (validateRequestTokenResponse.statusCode == 200) {
        final validateData = jsonDecode(validateRequestTokenResponse.body);
        final bool success = validateData['success'];

        if (success) {
          // 3. Create Session
          final createSessionResponse = await http.post(
            Uri.parse(
                'https://api.themoviedb.org/3/authentication/session/new?api_key=$apiKey&request_token=$requestToken'),
          );

          if (createSessionResponse.statusCode == 200) {
            final sessionData = jsonDecode(createSessionResponse.body);
            final String sessionId =
                sessionData['session_id']; // Get session ID

            // Save session ID to SessionManager
            SessionManager.saveSessionId(sessionId);

            // Navigate to AccountScreen and remove LoginScreen from the stack
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AccountScreen()),
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
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText:
                  true, // This line hides the entered password characters
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
