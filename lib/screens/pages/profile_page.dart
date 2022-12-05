import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/position.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:netraya/screens/profiles/edit_password_screen.dart';
import 'package:netraya/screens/profiles/edit_profile_screen.dart';
import 'package:netraya/screens/monitor_staff_screen.dart';
import 'package:netraya/services/google_sign_in_service.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/user_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appUserProvider = Provider.of<AppUserProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppSettings.appMainPadding),
        width: double.infinity,
        child: Column(
          children: [
            CustomAppBar(
              title: appLocalizations.profile,
            ),
            const UserProfilePicture(width: 120, radius: 60),
            const SizedBox(
              height: 16,
            ),
            Text(
              appUserProvider.appUser.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              appUserProvider.appUser.role,
              style: const TextStyle(
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 32,
            ),
            const ProfilePageMenu(),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                JobPosition jobPosition = await UserService().getPositionLevel();
                GoogleSignInService().logout();
                FirebaseAuth.instance.signOut();
                FirebaseMessaging.instance.unsubscribeFromTopic('all');
                FirebaseMessaging.instance.unsubscribeFromTopic('level${jobPosition.level}');
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                primary: Colors.white,
                shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.darkRed), borderRadius: BorderRadius.circular(8)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/svg/logout.svg'),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    appLocalizations.signOut,
                    style: const TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePageMenu extends StatelessWidget {
  const ProfilePageMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: SimpleButton(
            onTap: () => Navigator.of(context).pushNamed(EditProfileScreen.routeName),
            padding: const EdgeInsets.all(16),
            bgColor: const Color.fromARGB(31, 157, 157, 157),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/setting.svg'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  appLocalizations.editProfile,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: SimpleButton(
            onTap: () => Navigator.of(context).pushNamed(EditPasswordScreen.routeName),
            padding: const EdgeInsets.all(16),
            bgColor: const Color.fromARGB(31, 157, 157, 157),
            child: Row(
              children: [
                SvgPicture.asset('assets/svg/password.svg'),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  appLocalizations.changePassword,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: SimpleButton(
            onTap: () {
              showModalBottomSheet(
                context: context,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                builder: (context) => const SelectLanguage(),
              );
            },
            padding: const EdgeInsets.all(16),
            bgColor: const Color.fromARGB(31, 157, 157, 157),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/svg/language.svg',
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  appLocalizations.changeLanguage,
                ),
                const Spacer(),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          width: double.infinity,
          child: SimpleButton(
            onTap: () {},
            padding: const EdgeInsets.all(16),
            bgColor: const Color.fromARGB(31, 157, 157, 157),
            child: Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  '${appLocalizations.appVersion} 1.0.0',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }
}

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  List<String> languages = ['Bahasa Indonesia', 'English'];
  int selectedLanguage = -1;
  bool isInitState = true;
  late LocaleProvider localeProvider;

  @override
  void didChangeDependencies() {
    localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    if (isInitState) {
      isInitState = false;
      if (localeProvider.locale.languageCode == "id") {
        selectedLanguage = 0;
      }
      if (localeProvider.locale.languageCode == "en") {
        selectedLanguage = 1;
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(AppSettings.appMainPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                appLocalizations.changeLanguage,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const Divider(),
          ListView.builder(
            itemCount: languages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  selectedLanguage = index;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Radio<int>(
                    value: index,
                    groupValue: selectedLanguage,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          selectedLanguage = value;
                        });
                      }
                    },
                  ),
                  Text(languages[index]),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (selectedLanguage == 0) {
                  localeProvider.setLocale(const Locale('in'));
                } else {
                  localeProvider.setLocale(const Locale('en'));
                }

                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: AppColors.darkRed,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.darkRed), borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                appLocalizations.save,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: 12,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 18,
        ),
      ],
    );
  }
}
