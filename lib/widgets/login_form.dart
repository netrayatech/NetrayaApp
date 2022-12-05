import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/widgets/divider_text.dart';
import 'package:netraya/widgets/form_otp.dart';
import 'package:netraya/widgets/social_login.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(AppSettings.appMainPadding, AppSettings.appMainPadding * 1.5, AppSettings.appMainPadding, 0),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Login Akun',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 16,
            ),
            FormOtp(),
            SizedBox(
              height: 16,
            ),
            DividerText(
              text: 'Atau masuk dengan',
            ),
            SizedBox(
              height: 16,
            ),
            SocialLogin(),
            SizedBox(
              height: AppSettings.appMainPadding,
            ),
          ],
        ),
      ),
    );
  }
}
