import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:xemphim/screens/SignInScreen.dart';
import 'package:xemphim/common/session_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String _avatarUrl = ''; // Biến để lưu đường dẫn avatar
  String _accountName = ''; // Biến để lưu tên tài khoản

  Future<void> _fetchAccountDetails(String sessionId) async {
    if (sessionId == null) {
      // Xử lý trường hợp khi sessionId là null
      return;
    }

    final String apiKey =
        '5744c461b4e9a5730311b1bacdc9a337'; // Thay YOUR_API_KEY bằng API key thực của bạn
    final String accountId =
        '17863072'; // Thay accountId bằng ID tài khoản thực của bạn

    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/account/$accountId?api_key=$apiKey&session_id=$sessionId'),
      headers: {
        'Authorization': 'Bearer $sessionId',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String username = data['username'];
      final String avatarPath = data['avatar']['tmdb']['avatar_path'];
      print('avatarPath: $avatarPath');
      setState(() {
        _accountName =
            username ?? ''; // Nếu username là null thì gán giá trị rỗng
        _avatarUrl = avatarPath != null
            ? 'https://image.tmdb.org/t/p/w200$avatarPath'
            : ''; // Kiểm tra avatarPath trước khi gán giá trị cho _avatarUrl
      });
    } else {
      _showErrorDialog(message: 'Failed to get account details.');
    }
  }

  void _showErrorDialog({required String message}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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

  void _navigateToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    final sessionId = SessionManager.sessionId;
    if (sessionId != null) {
      _fetchAccountDetails(sessionId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage: _avatarUrl.isNotEmpty
                      ? NetworkImage(_avatarUrl)
                      : const AssetImage('assets/default_avatar.png'),
                ),
                const SizedBox(width: 16.0),
                Text(
                  _accountName.isNotEmpty ? _accountName : 'Account Name',
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.movie),
                    title: const Text('Favorite Movie'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.tv),
                    title: const Text('Favorite TV'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.watch_later),
                    title: const Text('WatchList'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.login_outlined),
                    title: const Text('Login'),
                    onTap: _navigateToLoginScreen,
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
