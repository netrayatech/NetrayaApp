import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/services/absensi_service.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/user_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreenAppBar extends StatelessWidget {
  const HomeScreenAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.white;
    final absensiService = AbsensiService();
    final now = DateTime.now();
    final appLocalizations = AppLocalizations.of(context)!;
    return SizedBox(
      height: 280,
      child: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(176, 108, 28, 1),
                Color.fromRGBO(225, 61, 75, 1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          height: 240,
          width: double.infinity,
          padding: const EdgeInsets.all(AppSettings.appMainPadding),
          child: SafeArea(
            child: Consumer<AppUserProvider>(
              builder: (context, appUserProvider, child) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/png/logo.png',
                    scale: 1.8,
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  Row(
                    children: [
                      const UserProfilePicture(width: 80, radius: 40),
                      const SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              UserService.greeting(),
                              style: TextStyle(color: textColor, fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              appUserProvider.appUser.name,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              appUserProvider.appUser.role,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 16,
          right: 16,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: StreamBuilder(
              stream: absensiService.absensiCounter,
              builder:
                  (context, AsyncSnapshot<Map<String, dynamic>> snapshot) =>
                      Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: SmallInfoCard(
                      title: snapshot.connectionState == ConnectionState.waiting
                          ? '0'
                          : snapshot.data![now.year.toString()]['masuk']
                              .toString(),
                      subtitle: 'Active Line',
                      titleColor: AppColors.blue,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border.symmetric(
                              vertical:
                                  BorderSide(width: 0.3, color: Colors.grey))),
                      child: SmallInfoCard(
                        title:
                            snapshot.connectionState == ConnectionState.waiting
                                ? '0'
                                : snapshot.data![now.year.toString()]['cuti']
                                    .toString(),
                        subtitle: 'Change Model',
                        titleColor: const Color.fromRGBO(225, 169, 61, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SmallInfoCard(
                      title: snapshot.connectionState == ConnectionState.waiting
                          ? '0'
                          : snapshot.data![now.year.toString()]['alpha']
                              .toString(),
                      subtitle: 'Machine Issue',
                      titleColor: const Color.fromRGBO(225, 61, 61, 1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class SmallInfoCard extends StatelessWidget {
  const SmallInfoCard(
      {Key? key,
      required this.title,
      required this.subtitle,
      this.titleColor = Colors.black})
      : super(key: key);
  final String title;
  final String subtitle;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
