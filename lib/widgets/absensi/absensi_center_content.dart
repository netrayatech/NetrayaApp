import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/services/geolocatoar_service.dart';
import 'package:netraya/widgets/absensi/absensi_data.dart';
import 'package:netraya/widgets/absensi/bluetooth_pairing.dart';
import 'package:netraya/widgets/absensi/circle_button.dart';
import 'package:netraya/widgets/absensi/success_clock_in_clock_out.dart';
import 'package:netraya/widgets/absensi/take_selfie.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AbsensiCenterContent extends StatelessWidget {
  const AbsensiCenterContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        AbsensiButton(),
        SizedBox(
          height: 16,
        ),
        AbsensiData()
      ],
    );
  }
}

class AbsensiButton extends StatelessWidget {
  const AbsensiButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    FlutterBluePlus flutterBlue = FlutterBluePlus.instance;

    void scan() async {
      await GeolocatorService().getPermission().then((value) async {
        if (!await flutterBlue.isOn) {
          customAlertDialog(
              context: context,
              child: Column(
                children: const [
                  Text('Turning on bluetooth'),
                  SizedBox(
                    height: 8,
                  ),
                  CircularProgressIndicator()
                ],
              ));
          await flutterBlue.turnOn();
          await Future.delayed(const Duration(milliseconds: 1500)).then((value) => Navigator.of(context).pop());
        }
        final isOn = await flutterBlue.isOn;
        if (isOn) {
          absensiScreenConfigProvider.setStep(1);
        }
      }, onError: (error, stackTrace) {
        simpleAlertDialogWithIcon(context, appLocalizations.turnOnGpsAndBluetooth, Icons.error);
      });
    }

    switch (absensiScreenConfigProvider.step) {
      case 0:
        return CircleButton(
          onPressed: scan,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/svg/enter.svg'),
              const SizedBox(
                height: 12,
              ),
              Text(
                absensiScreenConfigProvider.isClockIn ? appLocalizations.clockIn : appLocalizations.clockOut,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      case 1:
        return const BluetoothPairing();
      case 2:
        return const TakeSelfie();
      case 4:
        return const SuccessClockInClockOut();
    }
    return Container();
  }
}
