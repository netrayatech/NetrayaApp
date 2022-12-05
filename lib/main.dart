import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:netraya/screens/absensi_screen.dart';
import 'package:netraya/screens/activity_log_screen.dart';
import 'package:netraya/screens/google_map_screen.dart';
import 'package:netraya/screens/main_screen.dart';
import 'package:netraya/screens/monitor_staff_screen.dart';
import 'package:netraya/screens/pengajuan_cuti.dart';
import 'package:netraya/screens/pic_controlling/detail_notification_screen.dart';
import 'package:netraya/screens/pic_controlling/pic_controlling_screen.dart';
import 'package:netraya/screens/profiles/edit_password_screen.dart';
import 'package:netraya/screens/profiles/edit_profile_screen.dart';
import 'package:netraya/screens/smt_management_screen.dart';
import 'package:netraya/widgets/login.dart';
import 'package:netraya/screens/otp_screen.dart';
import 'package:netraya/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late List<CameraDescription> _cameras;
late AndroidNotificationChannel channel;
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future requestMessagePermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true, cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description: 'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  requestMessagePermission();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseMessaging.instance.getToken().then((value) => print(value));
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        print('inital message');
      }
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('===========');
      print(message);
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_stat_launcher_icon',
              ),
            ));
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppUserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MainScreenProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
        )
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, value, child) => MaterialApp(
          locale: value.locale,
          title: 'Netraya Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: AppBarTheme.of(context).copyWith(
                elevation: 0,
                color: Colors.white10,
                foregroundColor: Colors.black,
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
                centerTitle: true),
            toggleableActiveColor: AppColors.darkRed,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.red),
                textStyle: MaterialStateProperty.all<TextStyle>(const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(16)),
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('in', ''),
          ],
          routes: {
            Login.routeName: (context) => const Login(),
            OtpScreen.routeName: (context) => const OtpScreen(),
            MainScreen.routeName: (context) => const MainScreen(),
            AbsensiScreen.routeName: (context) => const AbsensiScreen(),
            ActivityLogScreen.routeName: (context) => const ActivityLogScreen(),
            MonitorStaff.routeName: (context) => const MonitorStaff(),
            PengajuanCutiScreen.routeName: (context) => const PengajuanCutiScreen(),
            EditProfileScreen.routeName: (context) => const EditProfileScreen(),
            EditPasswordScreen.routeName: (context) => const EditPasswordScreen(),
            GoogleMapScreen.routeName: (context) => const GoogleMapScreen(),
          },
        ),
      ),
    );
  }
}
