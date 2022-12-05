import 'package:flutter/material.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/providers/auth_screen_provider.dart';
import 'package:netraya/services/google_sign_in_service.dart';
import 'package:provider/provider.dart';

class SocialLogin extends StatelessWidget {
  const SocialLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final googleSignInService = GoogleSignInService();
    final authScreenProvider = Provider.of<AuthScreenProvider>(context, listen: false);
    final appUserProvider = Provider.of<AppUserProvider>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            authScreenProvider.setIsLoading(true);
            AppUser? appUser = await googleSignInService.googleLogin().catchError((onError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(onError.toString())));
              return null;
            });
            if (appUser != null) {
              appUserProvider.setWithoutNotif(appUser);
            } else {
              authScreenProvider.setIsLoading(false);
            }
          },
          child: Image.asset(
            'assets/png/google.png',
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        InkWell(
          onTap: () {},
          child: Image.asset(
            'assets/png/facebook.png',
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        InkWell(
          onTap: () {},
          child: Image.asset(
            'assets/png/apple.png',
          ),
        ),
      ],
    );
  }
}
