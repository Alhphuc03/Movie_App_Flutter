import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/screens/account/account_screen.dart';
import 'package:xemphim/screens/outstanding/outstanding_screen.dart';
import 'package:xemphim/screens/search/search_screen.dart';
import 'package:xemphim/screens/home/home_screen.dart';
import 'package:xemphim/screens/setting/setting_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  final List<Widget> _icons = [
    Icon(Icons.home, size: 35),
    Icon(Icons.search, size: 35),
    Icon(Icons.bar_chart_rounded, size: 35),
    Icon(Icons.account_circle_outlined, size: 35),
    Icon(Icons.settings_sharp, size: 35),
  ];

  final List<Widget> _screens = [
    const Home(),
    const SearchScreen(),
    const OutstandingScreen(),
    const AccountScreen(),
    const SettingScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        height: 60.0,
        items: _icons,
        color: isDarkMode ? const Color.fromARGB(255, 0, 0, 0) : Colors.white,
        buttonBackgroundColor: isDarkMode
            ? const Color.fromARGB(255, 0, 0, 0)
            : const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 255, 255, 255)
            : const Color.fromARGB(255, 0, 0, 0),
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: _onTabTapped,
      ),
    );
  }
}
