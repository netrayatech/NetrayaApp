import 'package:flutter/material.dart';
import 'package:netraya/screens/monitor_staff_screen.dart';
import 'package:netraya/screens/pengajuan_cuti.dart';
import 'package:netraya/screens/pic_controlling/pic_scan_qr_screen.dart';
import 'package:netraya/screens/smt_management_screen.dart';
import 'package:netraya/widgets/bs_container.dart';
import 'package:netraya/widgets/home/card_menu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CardMenu(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SMTManagementScreen(),
                )),
                assetPath: 'assets/svg/smt_management.svg',
                text: appLocalizations.smtManagement,
              ),
              const SizedBox(
                width: 16,
              ),
              CardMenu(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const PICScanQrScreen(),
                )),
                assetPath: 'assets/svg/pic_controlling.svg',
                text: appLocalizations.picControlling,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          // Row(
          //   children: [
          //     CardMenu(
          //       onTap: () {
          //         showModalBottomSheet(
          //           context: context,
          //           shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          //           builder: (context) => BSContainer(
          //             title: appLocalizations.attendance,
          //             child: Row(
          //               children: [
          //                 CardMenu(
          //                   onTap: () => Navigator.of(context).pushNamed(PengajuanCutiScreen.routeName),
          //                   assetPath: 'assets/svg/skip_calender.svg',
          //                   text: appLocalizations.leaveApplication,
          //                 ),
          //                 const SizedBox(
          //                   width: 16,
          //                 ),
          //                 CardMenu(
          //                   onTap: () => Navigator.of(context).pushNamed(MonitorStaff.routeName),
          //                   assetPath: 'assets/svg/people.svg',
          //                   text: appLocalizations.attendance,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //       assetPath: 'assets/svg/attendance.svg',
          //       text: appLocalizations.attendance,
          //     ),
          //     const SizedBox(
          //       width: 16,
          //     ),
          //     CardMenu(
          //       onTap: () {},
          //       assetPath: 'assets/svg/task_management.svg',
          //       text: appLocalizations.taskManagement,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
