import 'package:flutter/material.dart';

class BottomNavi extends StatefulWidget {
  const BottomNavi({super.key});

  @override
  State<BottomNavi> createState() => _BottomNaviState();
}

class _BottomNaviState extends State<BottomNavi> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


// import 'package:flutter/material.dart';
// import 'package:xemphim/screens/account/account_screen.dart';

// import 'package:xemphim/screens/search/search_screen.dart';
// import 'package:xemphim/screens/home/home_screen.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;

//   final List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];

//   final List<Widget> _screens = [
//     const Home(),
//     const SearchScreen(),
//     const AccountScreen(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens.asMap().entries.map((entry) {
//           int index = entry.key;
//           Widget screen = entry.value;
//           return Navigator(
//             key: _navigatorKeys[index],
//             onGenerateRoute: (routeSettings) {
//               return MaterialPageRoute(
//                 builder: (context) => screen,
//               );
//             },
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: _onTabTapped,
//         backgroundColor: Colors.black,
//         unselectedItemColor: const Color(0xFF999999),
//         selectedItemColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.search),
//             label: 'Search',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.account_box),
//             label: 'Account',
//           ),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:provider/provider.dart';
// import 'package:xemphim/main.dart';
// import 'package:xemphim/screens/account/account_screen.dart';
// import 'package:xemphim/screens/search/search_screen.dart';
// import 'package:xemphim/screens/home/home_screen.dart';

// class BottomNavBar extends StatefulWidget {
//   const BottomNavBar({Key? key}) : super(key: key);

//   @override
//   State<BottomNavBar> createState() => _BottomNavBarState();
// }

// class _BottomNavBarState extends State<BottomNavBar> {
//   int _currentIndex = 0;

//   final List<GlobalKey<NavigatorState>> _navigatorKeys = [
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//     GlobalKey<NavigatorState>(),
//   ];

//   final List<Widget> _screens = [
//     const Home(),
//     const SearchScreen(),
//     const AccountScreen(),
//   ];

//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var themeNotifier = Provider.of<ThemeNotifier>(context);
//     bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;
//     return Scaffold(
//       body: IndexedStack(
//         index: _currentIndex,
//         children: _screens.asMap().entries.map((entry) {
//           int index = entry.key;
//           Widget screen = entry.value;
//           return Navigator(
//             key: _navigatorKeys[index],
//             onGenerateRoute: (routeSettings) {
//               return MaterialPageRoute(
//                 builder: (context) => screen,
//               );
//             },
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: CurvedNavigationBar(
//         index: _currentIndex,
//         height: 60.0,
//         items: const <Widget>[
//           Icon(Icons.home, size: 30),
//           Icon(Icons.search, size: 30),
//           Icon(Icons.account_box, size: 30),
//         ],
//         color: Colors.white,
//         buttonBackgroundColor: Colors.white,
//         backgroundColor: Color.fromARGB(255, 0, 0, 0),
//         animationCurve: Curves.easeInOut,
//         animationDuration: const Duration(milliseconds: 600),
//         onTap: _onTabTapped,
//       ),
//     );
//   }
// }
