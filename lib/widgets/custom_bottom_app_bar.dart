import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mainScreenConfigProvider = Provider.of<MainScreenProvider>(context);

    void changePage(int index) {
      mainScreenConfigProvider.setSelectedPage(index);
    }

    final appLocalizations = AppLocalizations.of(context)!;

    return BottomAppBar(
      elevation: 10,
      notchMargin: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: BottomAppBarItem(
                      selected: mainScreenConfigProvider.selectedPage == 0,
                      onTap: () => changePage(0),
                      text: 'Home',
                      svgAsset: 'assets/svg/home.svg',
                    ),
                  ),
                  Flexible(
                    child: BottomAppBarItem(
                      selected: mainScreenConfigProvider.selectedPage == 1,
                      onTap: () => changePage(1),
                      text: appLocalizations.history,
                      svgAsset: 'assets/svg/history.svg',
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: BottomAppBarItem(
                selected: false,
                onTap: () => changePage(1),
                text: appLocalizations.scanning,
              ),
            ),
            Flexible(
              child: Row(
                children: [
                  Flexible(
                    child: BottomAppBarItem(
                      selected: mainScreenConfigProvider.selectedPage == 2,
                      onTap: () => changePage(2),
                      text: appLocalizations.notification,
                      svgAsset: 'assets/svg/bell.svg',
                    ),
                  ),
                  Flexible(
                    child: BottomAppBarItem(
                      selected: mainScreenConfigProvider.selectedPage == 3,
                      onTap: () => changePage(3),
                      text: appLocalizations.profile,
                      svgAsset: 'assets/svg/profile.svg',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomAppBarItem extends StatelessWidget {
  final String text;
  final String? svgAsset;
  final bool selected;
  final Function() onTap;
  const BottomAppBarItem({
    required this.text,
    this.svgAsset,
    required this.onTap,
    this.selected = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        minWidth: 40,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        onPressed: onTap,
        child: Opacity(
          opacity: selected ? 1 : 0.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              svgAsset == null
                  ? const SizedBox(
                      height: 30,
                    )
                  : SvgPicture.asset(
                      svgAsset!,
                      color: selected ? AppColors.red : Colors.grey,
                    ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style:
                      TextStyle(color: selected ? AppColors.red : Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
