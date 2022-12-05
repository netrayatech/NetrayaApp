import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:netraya/screens/absensi_screen.dart';
import 'package:netraya/screens/pages/history_page.dart';
import 'package:netraya/screens/pages/home_page.dart';
import 'package:netraya/screens/pages/notifikasi_page.dart';
import 'package:netraya/screens/pages/profile_page.dart';
import 'package:netraya/widgets/custom_bottom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const routeName = '/home_screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? currentBackPressTime;
  List<Widget> pages = const [HomePage(), HistoryPage(), NotifikasiPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () => onWillPop(appLocalizations),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Consumer<MainScreenProvider>(builder: (context, value, child) {
          return pages[value.selectedPage];
        }),
        floatingActionButton: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            elevation: 3,
            onPressed: () => Navigator.of(context).pushNamed(AbsensiScreen.routeName),
            backgroundColor: AppColors.darkRed,
            child: SvgPicture.asset(
              'assets/svg/qr-code-scan.svg',
              width: 40,
              color: Colors.white,
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: const CustomBottomAppBar(),
      ),
    );
  }

  Future<bool> onWillPop(AppLocalizations appLocalizations) {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null || now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(appLocalizations.pressAgainToExit)));
      return Future.value(false);
    }
    exit(0);
  }
}
