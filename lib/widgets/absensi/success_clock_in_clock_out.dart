import 'package:flutter/material.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SuccessClockInClockOut extends StatelessWidget {
  const SuccessClockInClockOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context, listen: false);
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromRGBO(228, 255, 248, 1),
        border: Border.all(color: const Color.fromRGBO(228, 255, 248, 0.8)),
      ),
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 134,
              height: 134,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromRGBO(144, 246, 222, 0.5),
              ),
              child: Container(),
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
                const Icon(
                  Icons.check,
                  color: Colors.green,
                  size: 40,
                ),
                Text(
                  absensiScreenConfigProvider.isClockIn
                      ? '${appLocalizations.clockIn}\n${appLocalizations.successfull}'
                      : '${appLocalizations.clockOut}\n${appLocalizations.successfull}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
