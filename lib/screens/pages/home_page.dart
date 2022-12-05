import 'package:flutter/material.dart';
// import 'package:netraya/widgets/home/announcement.dart';
import 'package:netraya/widgets/home/home_menu.dart';
import 'package:netraya/widgets/home_screen_app_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        // children: const [HomeScreenAppBar(), Announcement(), HomeMenu()],
        children: const [HomeScreenAppBar(), HomeMenu()],
      ),
    );
  }
}
