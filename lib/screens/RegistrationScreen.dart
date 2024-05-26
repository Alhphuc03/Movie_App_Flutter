import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final String _tmdbRegistrationUrl = 'https://www.themoviedb.org/signup';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Đăng ký TMDb'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (await canLaunch(_tmdbRegistrationUrl)) {
              await launch(_tmdbRegistrationUrl);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Không thể mở liên kết đăng ký TMDb.'),
                ),
              );
            }
          },
          child: Text('Đăng ký'),
        ),
      ),
    );
  }
}