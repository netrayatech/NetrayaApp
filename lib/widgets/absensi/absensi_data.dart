import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/providers/absensi_screen_provider.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/screens/google_map_screen.dart';
import 'package:netraya/screens/view_image_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AbsensiData extends StatelessWidget {
  const AbsensiData({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final absenProvider = Provider.of<AbsenProvider>(context);
    final appUserProvider = Provider.of<AppUserProvider>(context, listen: false);
    final absensiScreenConfigProvider = Provider.of<AbsensiScreenConfigProvider>(context);
    final appLocalizations = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        absensiScreenConfigProvider.step > 0 && absensiScreenConfigProvider.paired
            ? Expanded(
                child: Column(
                  children: [
                    Text(appLocalizations.location),
                    InkWell(
                      onTap: () => Navigator.of(context).pushNamed(GoogleMapScreen.routeName, arguments: [absenProvider.absen, appUserProvider.appUser]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.darkRed,
                          ),
                          Text(
                            absensiScreenConfigProvider.isClockIn ? absenProvider.absen.clockInLocation : absenProvider.absen.clockOutLocation,
                            style: const TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(),
        absensiScreenConfigProvider.step > 3
            ? Expanded(
                child: Column(
                  children: [
                    Text(appLocalizations.selfie),
                    InkWell(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ViewImageScreen(localPath: absenProvider.absen.localPath),
                      )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            color: AppColors.darkRed,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Text(
                            appLocalizations.showImage,
                            style: const TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}
