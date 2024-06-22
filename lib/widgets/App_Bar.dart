import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/AvatarManager.dart';
import 'package:xemphim/main.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    // Determine which logo to display based on the current theme mode
    String logoAsset =
        isDarkMode ? 'assets/logo_dark.png' : 'assets/logo_light.png';

    return PreferredSize(
      preferredSize: preferredSize,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: AppBar(
          backgroundColor: isDarkMode ? Colors.black : Colors.white,
          foregroundColor: isDarkMode ? Colors.white : Colors.black,
          title: Container(
            child: Image.asset(
              logoAsset,
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
                    themeNotifier.toggleTheme();
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
