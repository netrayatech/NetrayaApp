import 'package:flutter/material.dart';
import 'package:netraya/widgets/login_form.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static const routeName = '/auth_screen';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String noHp = "";
  Duration animatedDuration = const Duration(milliseconds: 250);
  double opacity = 0;
  double height = 0;
  bool finishAnimated = false;

  void startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() {
      opacity = 1;
      height = 400;
    });
    await Future.delayed(animatedDuration);

    setState(() {
      finishAnimated = true;
    });
  }

  @override
  void initState() {
    startAnimation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedOpacity(
            opacity: opacity,
            duration: animatedDuration,
            child: Image.asset('assets/png/otp.png'),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              finishAnimated
                  ? const Positioned(
                      top: 0,
                      bottom: 0,
                      child: LoginForm(),
                    )
                  : AnimatedPositioned(
                      bottom: -400 + height,
                      duration: animatedDuration,
                      child: const LoginForm(),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
