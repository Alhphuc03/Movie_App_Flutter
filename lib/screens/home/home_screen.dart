import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xemphim/common/untils.dart';
import 'package:xemphim/main.dart';
import 'package:xemphim/widgets/app_bar.dart';
import 'package:xemphim/widgets/bottom_nav_bar.dart';
import 'package:xemphim/widgets/home/toprated.dart';
import 'package:xemphim/widgets/navigation_drawer.dart';
import 'package:xemphim/widgets/home/popular_movies.dart';
import 'package:xemphim/widgets/home/upcoming.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    var themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor:
          isDarkMode ? Colors.black : Color.fromARGB(255, 255, 255, 255),
      appBar: const CustomAppBar(),
      drawer: const DrawerNavi(),
      // bottomNavigationBar: BottomNavBar(),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingSection(),
            PopularSection(),
            TopRatedSection(),
          ],
        ),
      ),
    );
  }
}
