import 'package:flutter/material.dart';
import 'package:xemphim/common/AvatarManager.dart';

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
        padding: const EdgeInsets.only(top: 10.0),
        child: AppBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          title: Container(
            child: Image.asset(
              'assets/logo_movie.png',
              height: 50,
              width: 120,
            ),
          ),
          centerTitle: true,
          actions: [
            Row(
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: AvtManager.avatarUrlNotifier,
                  builder: (context, avatarUrl, child) {
                    return IconButton(
                      onPressed: () {
                        // Add functionality for user icon here
                      },
                      icon: avatarUrl.isNotEmpty
                          ? CircleAvatar(
                              radius: 15.0,
                              backgroundImage: NetworkImage(avatarUrl),
                            )
                          : Icon(
                              Icons.account_circle_outlined,
                              size: 30,
                            ),
                    );
                  },
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      isDarkMode = !isDarkMode;
                    });
                  },
                  icon: Icon(
                    isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
