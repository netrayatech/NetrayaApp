import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/position.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/providers/auth_screen_provider.dart';
import 'package:netraya/screens/main_screen.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/login.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double logoOpacity = 0;
  bool nextScreen = false;
  final userService = UserService();

  @override
  void initState() {
    showLogo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appUserProvider = Provider.of<AppUserProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppSettings.appLinearGradient,
          ),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, AsyncSnapshot<User?> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting || !nextScreen) {
                return loading();
              }
              if (snapshot.hasData) {
                return StreamBuilder(
                  stream: UserService().getUserData(),
                  builder: (context, AsyncSnapshot<AppUser?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting || !nextScreen) {
                      return loading();
                    }
                    if (snapshot.hasData) {
                      FirebaseMessaging.instance.subscribeToTopic('all');
                      appUserProvider.setWithoutNotif(snapshot.data!);
                    } else {
                      return FutureBuilder(
                        future: UserService().getTempUserData(),
                        builder: (context, AsyncSnapshot<AppUserTemp?> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                            return loading();
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Hai, ${snapshot.data!.name}',
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Pendaftaran kamu sedang menunggu\n persetujuan dari admin',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return FutureBuilder(
                        future: userService.getPositionLevel(),
                        builder: (context, AsyncSnapshot<JobPosition> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return loading();
                          }
                          if (snapshot.hasError) {
                            log(snapshot.error.toString());
                          } else {
                            print('level${snapshot.data!.level}');
                            FirebaseMessaging.instance
                                .unsubscribeFromTopic('level${snapshot.data!.level}')
                                .then((value) => FirebaseMessaging.instance.subscribeToTopic('level${snapshot.data!.level}'));
                          }

                          return Consumer<AppUserProvider>(
                            builder: (context, value, child) {
                              if (nextScreen) {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  return ChangeNotifierProvider(
                                    create: (context) => AuthScreenProvider(),
                                    child: const Login(),
                                  );
                                }
                                Future.delayed(const Duration(milliseconds: 500)).then((value) => Navigator.of(context).pushNamed(MainScreen.routeName));
                              }

                              return loading();
                            },
                          );
                        });
                  },
                );
              }
              if (nextScreen) {
                return ChangeNotifierProvider(
                  create: (context) => AuthScreenProvider(),
                  child: const Login(),
                );
              }

              return loading();
            },
          ),
        ),
      ),
    );
  }

  void showLogo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      logoOpacity = 1;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      nextScreen = true;
    });
  }

  Center loading() {
    return Center(
      child: AnimatedOpacity(
        opacity: logoOpacity,
        duration: const Duration(milliseconds: 1000),
        child: Image.asset('assets/png/logo.png'),
      ),
    );
  }
}
