import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/esp32.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/services/geolocatoar_service.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BluetoothPairing extends StatefulWidget {
  const BluetoothPairing({
    Key? key,
  }) : super(key: key);

  @override
  State<BluetoothPairing> createState() => _BluetoothPairingState();
}

class _BluetoothPairingState extends State<BluetoothPairing> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  late AbsenProvider absenProvider;
  late Absen absen;
  late AbsensiScreenConfigProvider absensiScreenConfigProvider;
  late ESP32Provider esp32Provider;
  String userLocation = '';

  @override
  void didChangeDependencies() {
    absenProvider = Provider.of<AbsenProvider>(context, listen: false);
    absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);
    esp32Provider = Provider.of<ESP32Provider>(context);
    absen = absenProvider.absen;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    if (!absensiScreenConfigProvider.paired) {
      flutterBlue.startScan().timeout(
        const Duration(seconds: 16),
        onTimeout: () {
          flutterBlue.stopScan();
          simpleAlertDialogWithIcon(context, appLocalizations.notFoundTransmitter, Icons.error);
          absensiScreenConfigProvider.setStep(0);
        },
      ).onError((error, stackTrace) {
        flutterBlue.stopScan();
        simpleAlertDialogWithIcon(context, appLocalizations.turnOnGpsAndBluetooth, Icons.error);
        absensiScreenConfigProvider.setStep(0);
      });
    }

    void paired() async {
      Position userPosition = await GeolocatorService().getLocation().catchError((onError) {
        infoDialog(context, onError);
        Future.delayed(const Duration(milliseconds: 1500)).then((value) => absensiScreenConfigProvider.setStep(0));
      });
      absensiScreenConfigProvider.setPaired(true);
      if (absensiScreenConfigProvider.isClockIn) {
        absen = absen.copyWith(clockInGeoPoint: GeoPoint(userPosition.latitude, userPosition.longitude), clockInLocation: userLocation);
      } else {
        absen = absen.copyWith(clockOutGeoPoint: GeoPoint(userPosition.latitude, userPosition.longitude), clockOutLocation: userLocation);
      }

      absenProvider.setAbsen(absen);
      Future.delayed(const Duration(milliseconds: 1500)).then((value) => absensiScreenConfigProvider.setStep(2));
    }

    return StreamBuilder(
      stream: flutterBlue.scanResults,
      builder: (context, AsyncSnapshot<List<ScanResult>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        // if (true) {
        //   flutterBlue.stopScan();
        //   userLocation = 'bypass bluetooth';
        //   paired();
        // }
        for (ScanResult r in snapshot.data!) {
          for (ESP32 esp32 in esp32Provider.listEsp32) {
            if (r.advertisementData.serviceUuids.contains(esp32.uuid)) {
              flutterBlue.stopScan();
              userLocation = esp32.location;
              paired();
              break;
            }
          }
        }

        return Container(
          width: 170,
          height: 170,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: absensiScreenConfigProvider.paired ? const Color.fromRGBO(228, 255, 248, 1) : Colors.red[100],
            border: Border.all(color: absensiScreenConfigProvider.paired ? const Color.fromRGBO(228, 255, 248, 1) : Colors.red[100]!, width: 9),
            boxShadow: [
              BoxShadow(
                offset: absensiScreenConfigProvider.paired ? const Offset(0, 4) : const Offset(0, 2),
                blurRadius: 2,
                spreadRadius: 2,
                color: Colors.grey,
              ),
            ],
          ),
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: 134,
                  height: 134,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: absensiScreenConfigProvider.paired ? const Color.fromRGBO(144, 246, 222, 0.5) : Colors.white,
                  ),
                  child: Container(),
                ),
              ),
              absensiScreenConfigProvider.paired
                  ? Container()
                  : const SizedBox(
                      width: 170,
                      height: 170,
                      child: CircularProgressIndicator(
                        strokeWidth: 16,
                        color: AppColors.red,
                      ),
                    ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                top: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    absensiScreenConfigProvider.paired
                        ? const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 40,
                          )
                        : Container(),
                    Text(
                      absensiScreenConfigProvider.paired
                          ? '${appLocalizations.pairing}\n${appLocalizations.successfull}'
                          : '${appLocalizations.pairing}\nBluetooth',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: absensiScreenConfigProvider.paired ? Colors.green : AppColors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
