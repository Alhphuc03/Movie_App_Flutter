import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(70);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool isDarkMode = true;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: widget.preferredSize,
      child: Padding(
        padding:
            const EdgeInsets.only(top: 10.0), // Thêm padding 10 pixels từ top
        child: AppBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          title: Container(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/logo_movie.png',
              height: 50,
              width: 120,
            ),
          ),
          centerTitle: true,
          actions: [
            Container(
              alignment: Alignment.center,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isDarkMode =
                        !isDarkMode; // Đảo ngược trạng thái chế độ sáng/tối
                  });
                },
                icon:
                    Icon(isDarkMode ? Icons.wb_sunny : Icons.nightlight_round),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
