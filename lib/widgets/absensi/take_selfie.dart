import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/services/absensi_service.dart';
import 'package:netraya/widgets/absensi/camera_screen.dart';
import 'package:netraya/widgets/absensi/circle_button.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TakeSelfie extends StatelessWidget {
  const TakeSelfie({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final absenProvider = Provider.of<AbsenProvider>(context, listen: false);
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context, listen: false);
    final absensiService = AbsensiService();

    return CircleButton(
      onPressed: () async {
        loadingDialog(context);
        List<CameraDescription> cameras = await availableCameras();
        Navigator.of(context).pop();

        final result = await Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CameraScreen(cameras: cameras),
        ));
        if (result == null) {
          return;
        }
        loadingDialog(context);

        Absen? absenResult;
        if (absensiScreenConfigProvider.isClockIn) {
          absenResult = await absensiService.clockIn(absenProvider.absen.copyWith(localPath: result.path));
        } else {
          absenResult = await absensiService.clockOut(absenProvider.absen.copyWith(localPath: result.path));
        }

        Navigator.of(context).pop();
        if (absenResult != null) {
          absenResult = absenResult.copyWith(localPath: result.path);
          absenProvider.setAbsen(absenResult);
          absensiScreenConfigProvider.setStep(4);
          return;
        }
        infoDialog(context, 'Opps, Terjadi Kesalahan.');
        absensiScreenConfigProvider.setStep(3);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined),
          const SizedBox(
            height: 12,
          ),
          Text(
            appLocalizations.takeSelfie,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
