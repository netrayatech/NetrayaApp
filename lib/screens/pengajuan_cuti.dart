import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/cuti.dart';
import 'package:netraya/models/settings.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:netraya/screens/main_screen.dart';
import 'package:netraya/screens/monitor_staff_screen.dart';
import 'package:netraya/services/absensi_service.dart';
import 'package:netraya/services/cuti_service.dart';
import 'package:netraya/widgets/bs_container.dart';
import 'package:netraya/widgets/widget_functions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class PengajuanCutiScreen extends StatelessWidget {
  const PengajuanCutiScreen({Key? key}) : super(key: key);
  static const routeName = '/pengajuan_cuti';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLocalizations.leaveApplication,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: ChangeNotifierProvider(
        create: (context) => SettingsCutiProvider(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                InfoCuti(),
                SizedBox(
                  height: 32,
                ),
                FormPengajuanCuti(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormPengajuanCuti extends StatefulWidget {
  const FormPengajuanCuti({Key? key}) : super(key: key);

  @override
  State<FormPengajuanCuti> createState() => _FormPengajuanCutiState();
}

class _FormPengajuanCutiState extends State<FormPengajuanCuti> {
  final now = DateTime.now();
  String jenisCuti = '';
  DateTime? tanggalMulai;
  DateTime? tanggalBerakhir;
  String catatan = '';
  final cutiService = CutiService();
  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    void submitCuti() {
      if (jenisCuti.isEmpty) {
        showValidationError(context, 'Jenis Cuti harus dipilih');
        return;
      }
      if (tanggalMulai == null) {
        showValidationError(context, 'Tanggal mulai harus dipilih');
        return;
      }
      if (tanggalBerakhir == null) {
        showValidationError(context, 'Tanggal berakhir harus dipilih');
        return;
      }

      if (tanggalBerakhir!.difference(tanggalMulai!).isNegative) {
        showValidationError(context, 'Tanggal berakhir harus lebih besar dari tanggal mulai');
        return;
      }

      if (catatan.isEmpty) {
        showValidationError(context, 'Catatan harus diisi');
        return;
      }

      loadingDialog(context);
      cutiService
          .cutiRequest(Cuti(uid: '', jenisCuti: jenisCuti, tanggalMulai: tanggalMulai, tanggalBerakhir: tanggalBerakhir, catatan: catatan))
          .catchError((error, stackTrace) {
        Navigator.of(context).pop();
        infoDialog(context, error.toString());
        return;
      }).then((value) async {
        if (value != null) {
          Navigator.of(context).pop();
          await customAlertDialog(
              context: context,
              child: Column(
                children: [
                  SvgPicture.asset('assets/svg/check_2.svg'),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    appLocalizations.successfulLeaveApplication,
                    style: const TextStyle(color: Colors.lightGreen, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    appLocalizations.successfulLeaveApplicationDetail,
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  )
                ],
              )).then(
            (value) {
              Navigator.of(context).pushNamedAndRemoveUntil(PengajuanCutiScreen.routeName, ModalRoute.withName(MainScreen.routeName));
            },
          );
        }
      });
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSettings.appMainPadding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.white, boxShadow: const [
        BoxShadow(blurRadius: 10, spreadRadius: 1, color: AppColors.lightGrey),
      ]),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                '${appLocalizations.leaveApplicationForm}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              appLocalizations.leaveType,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            Consumer<SettingsCutiProvider>(
              builder: (context, value, child) => SimpleButton(
                onTap: () async {
                  String? selectedJenisCuti = await showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                    builder: (context) => ChangeNotifierProvider.value(value: value, child: const SelectCutiType()),
                  );
                  if (selectedJenisCuti != null) {
                    setState(() {
                      jenisCuti = selectedJenisCuti;
                    });
                  }
                },
                bgColor: Colors.white,
                padding: const EdgeInsets.all(12),
                border: Border.all(color: Colors.black12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(jenisCuti.isEmpty ? appLocalizations.chosseLeaveType : jenisCuti), const Icon(Icons.arrow_forward_ios, size: 14)],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.startDate,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      SimpleButton(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: DateTime(2020, 1, 1),
                            lastDate: DateTime(now.year + 10, 1, 1),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(primary: AppColors.darkRed),
                              ),
                              child: child!,
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              tanggalMulai = selectedDate;
                            });
                          }
                        },
                        bgColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        border: Border.all(color: Colors.black12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/svg/calendar.svg'),
                            Text(
                              tanggalMulai == null ? 'DD-MM-YYYY' : AppSettings.simpleDateFormat.format(tanggalMulai!),
                              style: tanggalMulai == null ? const TextStyle(color: Colors.black38) : const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.endDate,
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 6),
                      SimpleButton(
                        onTap: () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: now,
                            firstDate: DateTime(2020, 1, 1),
                            lastDate: DateTime(now.year + 10, 1, 1),
                            builder: (context, child) => Theme(
                              data: ThemeData.light().copyWith(
                                colorScheme: const ColorScheme.light(primary: AppColors.darkRed),
                              ),
                              child: child!,
                            ),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              tanggalBerakhir = selectedDate;
                            });
                          }
                        },
                        bgColor: Colors.white,
                        padding: const EdgeInsets.all(12),
                        border: Border.all(color: Colors.black12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset('assets/svg/calendar.svg'),
                            Text(
                              tanggalBerakhir == null ? 'DD-MM-YYYY' : AppSettings.simpleDateFormat.format(tanggalBerakhir!),
                              style: tanggalBerakhir == null ? const TextStyle(color: Colors.black38) : const TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            Text(
              appLocalizations.note,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 6),
            TextField(
              minLines: 3,
              maxLines: 6,
              onChanged: ((value) => catatan = value),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black12),
                  ),
                  hintText: '${appLocalizations.add} ${appLocalizations.note}',
                  hintStyle: const TextStyle(fontSize: 14)),
            ),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submitCuti,
                style: ElevatedButton.styleFrom(
                  primary: AppColors.darkRed,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.darkRed), borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectCutiType extends StatefulWidget {
  const SelectCutiType({Key? key}) : super(key: key);

  @override
  State<SelectCutiType> createState() => _SelectCutiTypeState();
}

class _SelectCutiTypeState extends State<SelectCutiType> {
  String selectedCuti = '';

  @override
  Widget build(BuildContext context) {
    final settingsCutiProvider = Provider.of<SettingsCutiProvider>(context);

    return BSContainer(
      title: 'Pilih Jenis Cuti',
      child: Column(
        children: [
          ListView.builder(
            itemCount: settingsCutiProvider.cuti == null ? 0 : settingsCutiProvider.cuti!.types.length,
            shrinkWrap: true,
            itemBuilder: (context, index) => Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Radio<String>(
                  value: settingsCutiProvider.cuti!.types[index],
                  groupValue: selectedCuti,
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        selectedCuti = value;
                      });
                    }
                  },
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCuti = settingsCutiProvider.cuti!.types[index];
                      });
                    },
                    child: Text(settingsCutiProvider.cuti!.types[index])),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(selectedCuti),
              style: ElevatedButton.styleFrom(
                primary: AppColors.darkRed,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(side: const BorderSide(color: AppColors.darkRed), borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Pilih Cuti',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCuti extends StatelessWidget {
  const InfoCuti({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int cutiTerpakai = 0;
    int kuotaCuti = 12;
    final now = DateTime.now();
    final absensiService = AbsensiService();
    final settingsCutiProvider = Provider.of<SettingsCutiProvider>(context, listen: false);

    Future<List<dynamic>> getAbsensiData() async {
      List<dynamic> data = [];
      data.add(await absensiService.getAbsensiCounter());
      data.add(await absensiService.getCuti());
      settingsCutiProvider.setCuti(data[1]);
      return data;
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      height: 170,
      child: FutureBuilder(
        future: getAbsensiData(),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              cutiTerpakai = snapshot.data![0][now.year.toString()]['cuti_tahunan'];
              kuotaCuti = snapshot.data![1] != null ? snapshot.data![1].jatahCuti : 12;
            }
          }
          return Column(children: [
            Expanded(
              child: Row(
                children: [
                  CircularPercentIndicator(
                    radius: 45.0,
                    lineWidth: 10.0,
                    percent: cutiTerpakai / kuotaCuti,
                    center: Text(
                      "${(cutiTerpakai / kuotaCuti * 100).ceil()} %",
                      style: const TextStyle(color: AppColors.darkRed),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: AppColors.darkRed,
                  ),
                  const Spacer(),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            color: AppColors.darkRed,
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '$cutiTerpakai Cuti Terpakai',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color.fromARGB(255, 193, 199, 206),
                            size: 16,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${kuotaCuti - cutiTerpakai} Cuti Tersisa',
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            InkWell(
              onTap: () {
                final mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
                mainScreenProvider.setSelectedPage(1);
                Navigator.of(context).pop();
              },
              child: SizedBox(
                height: 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Riwayat Pengajuan Cuti ',
                      style: TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.w500, fontSize: 12),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: AppColors.darkRed,
                      size: 14,
                    ),
                  ],
                ),
              ),
            )
          ]);
        },
      ),
    );
  }
}
