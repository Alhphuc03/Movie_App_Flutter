import 'package:flutter/material.dart';
import 'package:xemphim/screens/AccoutScreen.dart';

import 'package:xemphim/screens/SearchScreen.dart';
import 'package:xemphim/screens/home.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _currentIndex = 0; // Index của màn hình hiện tại được chọn

  // Danh sách các màn hình tương ứng với mỗi tab trong BottomNavigationBar
  final List<Widget> _screens = [
    const Home(), // Màn hình Home
    const SearchScreen(), // Màn hình Search
    const AccountScreen(), // Màn hình More
  ];

  // Phương thức được gọi khi một tab được chọn
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Cập nhật index của màn hình hiện tại
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hiển thị màn hình tương ứng với màn hình hiện tại được chọn
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Chỉ định tab hiện tại
        onTap: _onTabTapped, // Callback khi một tab được chọn
        backgroundColor: Colors.black,
        unselectedItemColor: const Color(0xFF999999),
        selectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
