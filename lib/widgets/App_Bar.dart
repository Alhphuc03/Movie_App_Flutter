import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isDarkMode = false; // Biến trạng thái để theo dõi chế độ sáng/tối

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      foregroundColor: isDarkMode ? Colors.white : Colors.black,
      title: Image.asset(
        'assets/logo.png',
        height: 50,
        width: 120,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              isDarkMode = !isDarkMode; // Đảo ngược trạng thái chế độ sáng/tối
            });
          },
          icon: Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
        ),
      ],
    );
  }
}
