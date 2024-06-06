import 'package:flutter/material.dart';
import 'package:xemphim/common/untils.dart';
import 'package:xemphim/widgets/App_Bar.dart';
import 'package:xemphim/widgets/bottom_nav_bar.dart';

import 'package:xemphim/widgets/navigation_drawer.dart';
import 'package:xemphim/widgets/home/popular_movies.dart';
import 'package:xemphim/widgets/home/toprated.dart';
import 'package:xemphim/widgets/home/upcoming.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kBackgoundColor,
      appBar: CustomAppBar(),
      drawer: DrawerNavi(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            UpcomingSection(),
            PopularSection(),
            TopRatedSection(),
          ],
        ),
      ),
    );
  }
}
