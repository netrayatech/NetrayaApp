import 'package:flutter/material.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/esp32.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/services/absensi_service.dart';
import 'package:netraya/services/esp32_service.dart';
import 'package:netraya/widgets/absensi/absensi_center_content.dart';
import 'package:netraya/widgets/absensi/absensi_date.dart';
import 'package:netraya/widgets/absensi/detail_and_login_activity_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AbsensiScreen extends StatelessWidget {
  const AbsensiScreen({Key? key}) : super(key: key);
  static const routeName = '/absensiScreen';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final absensiService = AbsensiService();
    final esp32Service = ESP32Service();
    final now = DateTime.now();
    Future<List<dynamic>> initData() async {
      List<ESP32> listEsp32 = await esp32Service.getListEsp32();
      List<Absen> listAbsen = await absensiService.getAbsensiByDate(now);
      return [listAbsen, listEsp32];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.attendance,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initData(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError && !snapshot.hasData) {
            Navigator.of(context).pop();
          }

          if (snapshot.data![0].isEmpty) {
            snapshot.data![0].add(Absen(
                id: '',
                uid: '',
                status: '',
                clockInLocation: '',
                clockOutLocation: '',
                date: DateTime.now(),
                clockInSelfieImagePath: '',
                clockOutSelfieImagePath: ''));
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => AbsensiScreenConfigProvider(snapshot.data![0].first.clockIn == null)),
              ChangeNotifierProvider(create: (context) => AbsenProvider(snapshot.data![0].first)),
              ChangeNotifierProvider(create: (context) => ESP32Provider(snapshot.data![1])),
            ],
            child: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  AbsensiDate(),
                  AbsensiCenterContent(),
                  DetailAndLogActivityButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
