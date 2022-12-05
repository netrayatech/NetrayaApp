import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/constants/helper.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/services/absensi_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ActivityLogScreen extends StatelessWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);
  static const routeName = '/activity_log';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final absensiService = AbsensiService();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.activityLog,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: absensiService.getAbsensi(),
        builder: (context, AsyncSnapshot<List<Absen>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError && !snapshot.hasData) {
            Navigator.of(context).pop();
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => ChangeNotifierProvider(
                create: (context) => AbsenProvider(snapshot.data![index]),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 10),
                        blurRadius: 10,
                        spreadRadius: 2,
                        color: Colors.grey[200]!,
                      ),
                    ],
                  ),
                  child: const ActivityLogTile(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ActivityLogTile extends StatelessWidget {
  const ActivityLogTile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final absenProvider = Provider.of<AbsenProvider>(context);
    int totalJamKerjaInSeconds = -1;
    if (absenProvider.absen.clockIn != null && absenProvider.absen.clockOut != null) {
      totalJamKerjaInSeconds = absenProvider.absen.clockOut!.difference(absenProvider.absen.clockIn!).inSeconds;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppSettings.appDateFormatWithDayName.format(absenProvider.absen.date),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appLocalizations.clockIn}:',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    absenProvider.absen.clockIn == null ? '--:--' : AppSettings.dateGetTime.format(absenProvider.absen.clockIn!),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appLocalizations.clockOut}:',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    absenProvider.absen.clockOut == null ? '--:--' : AppSettings.dateGetTime.format(absenProvider.absen.clockOut!),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${appLocalizations.totalWorkingHours}:',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    totalJamKerjaInSeconds < 0 ? '--:--:--' : Helper.formatTime(Duration(seconds: totalJamKerjaInSeconds), alwaysShowHours: true),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
