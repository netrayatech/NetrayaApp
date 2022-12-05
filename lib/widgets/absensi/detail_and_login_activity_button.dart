import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/screens/activity_log_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DetailAndLogActivityButton extends StatelessWidget {
  const DetailAndLogActivityButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        absensiScreenConfigProvider.step == 0 ? const ClockInClockOutInfo() : const AbsensiProgress(),
        const SizedBox(
          height: 32,
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed(ActivityLogScreen.routeName),
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            elevation: 0,
            side: const BorderSide(color: AppColors.darkRed),
            minimumSize: const Size(100, 45),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                appLocalizations.activityLog,
                style: const TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AbsensiProgress extends StatelessWidget {
  const AbsensiProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Expanded(
          child: ProgressNumber(
            number: 1,
            text: 'Tracking Lokasi',
          ),
        ),
        const Expanded(
          child: ProgressNumber(
            number: 2,
            text: 'Selfie',
          ),
        ),
        Expanded(
          child: ProgressNumber(
            number: 3,
            text: absensiScreenConfigProvider.isClockIn ? 'Clocked in' : 'Clocked out',
          ),
        )
      ],
    );
  }
}

class ProgressNumber extends StatelessWidget {
  const ProgressNumber({
    Key? key,
    required this.number,
    required this.text,
  }) : super(key: key);
  final int number;
  final String text;

  @override
  Widget build(BuildContext context) {
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: absensiScreenConfigProvider.step > number ? Colors.green : null,
              shape: BoxShape.circle,
              border: Border.all(color: absensiScreenConfigProvider.step >= number ? Colors.green : Colors.grey, width: 2)),
          child: Text(
            '$number',
            style: TextStyle(
                color: absensiScreenConfigProvider.step >= number
                    ? absensiScreenConfigProvider.step > number
                        ? Colors.white
                        : Colors.green
                    : Colors.grey),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          text,
          style: TextStyle(color: absensiScreenConfigProvider.step >= number ? Colors.green : Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
        )
      ],
    );
  }
}

class ClockInClockOutInfo extends StatelessWidget {
  const ClockInClockOutInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text('${appLocalizations.clockIn}:'),
                Text(
                  absenProvider.absen.clockIn != null ? AppSettings.dateGetTime.format(absenProvider.absen.clockIn!) : '00:00',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
            Column(
              children: [
                Text('${appLocalizations.clockOut}:'),
                Text(
                  absenProvider.absen.clockOut != null ? AppSettings.dateGetTime.format(absenProvider.absen.clockOut!) : '00:00',
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                )
              ],
            ),
          ],
        ),
      ],
    );
  }
}
