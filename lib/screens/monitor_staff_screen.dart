import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/absen.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/settings.dart';
import 'package:netraya/providers/montor_staff_provider.dart';
import 'package:netraya/screens/google_map_screen.dart';
import 'package:netraya/services/monitor_staff_service.dart';
import 'package:netraya/services/settings_service.dart';
import 'package:netraya/widgets/home_screen_app_bar.dart';
import 'package:netraya/widgets/user_profile_picture.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonitorStaff extends StatelessWidget {
  const MonitorStaff({Key? key}) : super(key: key);
  static const routeName = '/monitor_staff';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MonitorStaffProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MonitorStaffStatusProvider(),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appLocalizations.staffMonitor,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
          backgroundColor: AppColors.red,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        body: const MonitorStaffBody(),
      ),
    );
  }
}

class MonitorStaffBody extends StatefulWidget {
  const MonitorStaffBody({
    Key? key,
  }) : super(key: key);

  @override
  State<MonitorStaffBody> createState() => _MonitorStaffBodyState();
}

class _MonitorStaffBodyState extends State<MonitorStaffBody> {
  final monitorStaffService = MonitorStaffService();

  late MonitorStaffProvider monitorStaffProvider;
  int selectedStatus = 0;
  final now = DateTime.now();

  Map<String, Color> statusColor = {
    'cuti': AppColors.yellow,
    'alpha': AppColors.red,
    'belum_absen': Colors.black12,
  };
  List<Map<String, dynamic>> usersAbsen = [];
  List<Absen> absensiList = [];
  List<AppUserTemp> appUsers = [];
  Set<String> usersId = {}; // for validation distinct value

  void initData() async {
    int totalMasuk = 0;
    int totalCuti = 0;
    int totalKaryawan = 0;
    absensiList = await monitorStaffService.getAbsensi(date: now);
    appUsers = await monitorStaffService.getUsers();
    totalKaryawan = appUsers.length;

    for (int i = 0; i < absensiList.length; i++) {
      if (!usersId.add(absensiList[i].uid)) {
        absensiList.removeAt(i);
        continue;
      }
      if (absensiList[i].status == 'present') {
        totalMasuk++;
      }
      if (absensiList[i].status == 'cuti') {
        totalCuti++;
      }
    }

    // for (Absen absen in absensiList) {
    //   if (!usersId.add(absen.uid)) {
    //     int userIndex = absensiList.indexWhere((element) => element.id == absen.id);
    //     absensiList.removeAt(userIndex);
    //     continue;
    //   }
    //   if (absen.status == 'present') {
    //     totalMasuk++;
    //   }
    //   if (absen.status == 'cuti') {
    //     totalCuti++;
    //   }
    // }
    monitorStaffProvider.set(totalKaryawan, totalMasuk, totalCuti);
    setState(() {});
  }

  @override
  void initState() {
    monitorStaffProvider = Provider.of<MonitorStaffProvider>(context, listen: false);
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const OverallInfo(),
        const SizedBox(
          height: 16,
        ),
        const AbsensiStatusList(),
        Consumer<MonitorStaffStatusProvider>(
          builder: (context, value, child) {
            List<AppUserTemp> tempAppUsers = [...appUsers];
            usersAbsen = [];
            for (Absen absen in absensiList) {
              int userIndex = tempAppUsers.indexWhere((user) => user.uid == absen.uid);
              if (userIndex < 0) {
                continue;
              }
              if (value.selectedStatus == 0) {
                usersAbsen.add({"absen": absen, "user": tempAppUsers.removeAt(userIndex)});
              }
              if (value.selectedStatus == 1 && absen.status == 'present') {
                usersAbsen.add({"absen": absen, "user": tempAppUsers.removeAt(userIndex)});
              }
              if (value.selectedStatus == 2 || value.selectedStatus == 4) {
                tempAppUsers.removeAt(userIndex);
              }
              if (value.selectedStatus == 3 && absen.status == 'cuti') {
                usersAbsen.add({"absen": absen, "user": tempAppUsers.removeAt(userIndex)});
              }
            }

            if (value.selectedStatus == 0 || (value.selectedStatus == 2 && now.hour < 17) || (value.selectedStatus == 4 && now.hour >= 17)) {
              for (AppUserTemp appUser in tempAppUsers) {
                usersAbsen.add({"user": appUser});
              }
            }

            return ListView.builder(
              itemCount: usersAbsen.length,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => MonitorStaffTile(
                absen: usersAbsen[index]['absen'],
                appUser: usersAbsen[index]['user'],
                now: now,
                statusColor: statusColor,
                drawBorder: index < usersAbsen.length - 1,
              ),
            );
          },
        ),
      ],
    );
  }
}

class MonitorStaffTile extends StatelessWidget {
  const MonitorStaffTile({
    Key? key,
    required this.absen,
    required this.appUser,
    required this.now,
    required this.statusColor,
    required this.drawBorder,
  }) : super(key: key);

  final AppUserTemp appUser;
  final Absen? absen;
  final DateTime now;
  final Map<String, Color> statusColor;
  final bool drawBorder;

  Widget absensiStatus(BuildContext context, AppLocalizations appLocalizations) {
    if (absen != null) {
      if (absen!.status == 'present') {
        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(GoogleMapScreen.routeName, arguments: [absen, appUser]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    color: AppColors.darkRed,
                    size: 16,
                  ),
                  Text(
                    appLocalizations.location,
                    style: const TextStyle(color: AppColors.red, fontSize: 12),
                  )
                ],
              ),
              Text(
                "${absen!.clockIn!.hour}:${absen!.clockIn!.minute}:${absen!.clockIn!.second}",
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
        );
      }
      if (absen!.status.startsWith('cuti')) {
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: statusColor['cuti'],
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            appLocalizations.leave,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: now.hour >= 17 ? statusColor['alpha'] : statusColor['belum_absen'],
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        now.hour >= 17 ? appLocalizations.alpha : appLocalizations.notAbsent,
        style: TextStyle(fontSize: 12, color: now.hour >= 17 ? Colors.white : Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: drawBorder ? const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black26, width: 0.5))) : null,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
              child: OtherUserProfilePicture(
            width: 20,
            radius: 20,
            url: appUser.photoUrl,
          )),
          const SizedBox(
            width: 8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(appUser.name),
              FutureBuilder(
                future: SettingsService().getGeneralData(),
                builder: (context, AsyncSnapshot<General?> snapshot) {
                  String officeHours = '';
                  if (snapshot.connectionState != ConnectionState.waiting) {
                    if (snapshot.hasData) {
                      switch (appUser.shift) {
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
                    '${appLocalizations.officeHours} (${snapshot.connectionState == ConnectionState.waiting ? '' : officeHours})',
                    style: const TextStyle(color: Colors.black38),
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          absensiStatus(context, appLocalizations)
        ],
      ),
    );
  }
}

class AbsensiStatusList extends StatelessWidget {
  const AbsensiStatusList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final monitorStaffStatusProvider = Provider.of<MonitorStaffStatusProvider>(context);
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: monitorStaffStatusProvider.statusList.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Row(
                  children: [
                    const SizedBox(
                      width: AppSettings.appMainPadding,
                    ),
                    SimpleButton(
                      onTap: () {
                        monitorStaffStatusProvider.setSelectedStatus(index);
                      },
                      padding: const EdgeInsets.all(10),
                      bgColor: monitorStaffStatusProvider.isSelected(monitorStaffStatusProvider.statusList[index]) ? AppColors.softRed : Colors.black12,
                      child: Text(
                        monitorStaffStatusProvider.statusList[index],
                        style:
                            TextStyle(color: monitorStaffStatusProvider.isSelected(monitorStaffStatusProvider.statusList[index]) ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                );
              }
              return SimpleButton(
                onTap: () {
                  monitorStaffStatusProvider.setSelectedStatus(index);
                },
                padding: const EdgeInsets.all(10),
                bgColor: monitorStaffStatusProvider.isSelected(monitorStaffStatusProvider.statusList[index]) ? AppColors.softRed : Colors.black12,
                child: Text(
                  monitorStaffStatusProvider.statusList[index],
                  style: TextStyle(color: monitorStaffStatusProvider.isSelected(monitorStaffStatusProvider.statusList[index]) ? Colors.white : Colors.black),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class SimpleButton extends StatelessWidget {
  const SimpleButton({
    Key? key,
    required this.child,
    required this.bgColor,
    required this.padding,
    this.border,
    this.onTap,
  }) : super(key: key);

  final Widget child;
  final Color bgColor;
  final EdgeInsetsGeometry padding;
  final BoxBorder? border;

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: border),
            child: child,
          ),
        ),
      ),
    );
  }
}

class OverallInfo extends StatelessWidget {
  const OverallInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    final appLocalizations = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      height: 120,
      child: Stack(
        children: [
          Container(
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.red,
            ),
            width: double.infinity,
            child: Text(
              AppSettings.appDateFormatWithDayName.format(now),
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
              ),
              height: 80,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Consumer<MonitorStaffProvider>(
                      builder: (context, value, child) => SmallInfoCard(
                        title: '${value.totalMasuk}',
                        subtitle: '${appLocalizations.employee} ${appLocalizations.present}',
                        titleColor: AppColors.blue,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(border: Border.symmetric(vertical: BorderSide(width: 0.3, color: Colors.grey))),
                      child: Consumer<MonitorStaffProvider>(
                        builder: (context, value, child) => SmallInfoCard(
                          title: '${value.totalCuti}',
                          subtitle: '${appLocalizations.employee} ${appLocalizations.leave}',
                          titleColor: const Color.fromRGBO(225, 169, 61, 1),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Consumer<MonitorStaffProvider>(
                      builder: (context, value, child) => SmallInfoCard(
                        title: '${value.totalKaryawan - value.totalCuti - value.totalMasuk}',
                        subtitle: '${appLocalizations.employee} ${appLocalizations.alpha}',
                        titleColor: const Color.fromRGBO(225, 61, 61, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
