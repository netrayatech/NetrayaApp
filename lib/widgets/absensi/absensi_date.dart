import 'package:flutter/material.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/settings.dart';
import 'package:netraya/providers/app_user_provider.dart';
import 'package:netraya/services/settings_service.dart';
import 'package:provider/provider.dart';

class AbsensiDate extends StatelessWidget {
  const AbsensiDate({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Column(
      children: [
        Text(
          AppSettings.appDateFormatWithDayName.format(now),
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        FutureBuilder(
          future: SettingsService().getGeneralData(),
          builder: (context, AsyncSnapshot<General?> snapshot) {
            String officeHours = '';
            final userProvider = Provider.of<AppUserProvider>(context, listen: false);
            if (snapshot.connectionState != ConnectionState.waiting) {
              if (snapshot.hasData) {
                switch (userProvider.appUser.shift) {
                  case 1:
                    officeHours = '${snapshot.data!.shift1['start']} - ${snapshot.data!.shift1['end']}';
                    break;
                  case 2:
                    officeHours = '${snapshot.data!.shift2['start']} - ${snapshot.data!.shift2['end']}';
                    break;
                  default:
                    officeHours = '${snapshot.data!.normalShift['start']} - ${snapshot.data!.normalShift['end']}';
                }
              }
            }
            return Text(
              officeHours,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            );
          },
        ),
      ],
    );
  }
}
