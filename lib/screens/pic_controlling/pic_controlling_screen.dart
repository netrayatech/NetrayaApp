import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/exceptions/app_general_exception.dart';
import 'package:netraya/models/line_condition.dart';
import 'package:netraya/screens/main_screen.dart';
import 'package:netraya/services/pic_controlling_service.dart';
import 'package:netraya/widgets/widget_functions.dart';

class PICControlling extends StatefulWidget {
  const PICControlling({Key? key, required this.lineCondition}) : super(key: key);
  final LineCondition lineCondition;

  @override
  State<PICControlling> createState() => _PICControllingState();
}

class _PICControllingState extends State<PICControlling> {
  TextEditingController textarea = TextEditingController();
  List<String> conditions = [
    "Aman",
    "Hardware Issue",
    "Program Issue",
    "Human Error",
    "Standby",
  ];
  String selectedCondition = '';
  String catatan = '';
  late LineCondition lineCondition;
  final picControllingService = PicControllingService();

  @override
  void initState() {
    lineCondition = widget.lineCondition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Kondisi LINE',
        ),
      ),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Center(
                  child: Text(
                    lineCondition.lineName,
                    style: const TextStyle(fontSize: 24, color: AppColors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Card(
                      margin: const EdgeInsets.only(top: 24),
                      child: SizedBox(
                        width: 328,
                        height: 450,
                        child: Container(
                          margin: const EdgeInsets.only(left: 16, right: 16, top: 32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Text(
                                "Pilih Kondisi",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const Divider(
                                height: 10,
                                thickness: 1,
                              ),
                              ListView.builder(
                                itemCount: conditions.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedCondition = conditions[index];
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Radio<String>(
                                        value: conditions[index],
                                        groupValue: selectedCondition,
                                        onChanged: (String? value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedCondition = value;
                                            });
                                          }
                                        },
                                      ),
                                      Text(conditions[index]),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 4),
                                child: const Text(
                                  "Catatan",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              TextField(
                                controller: textarea,
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromRGBO(222, 226, 230, 1)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(222, 226, 230, 1),
                                    ),
                                  ),
                                ),
                                onChanged: (value) => catatan = value,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (selectedCondition.isEmpty || catatan.isEmpty) {
                          showFormError(context);
                          return;
                        }
                        lineCondition = LineCondition(
                            lineId: lineCondition.lineId,
                            lineName: lineCondition.lineName,
                            condition: selectedCondition,
                            notes: catatan,
                            createdAt: lineCondition.createdAt);

                        try {
                          loadingDialog(context);
                          bool result = await picControllingService.execute(lineCondition);
                          Navigator.of(context).pop();
                          if (result) {
                            customSuccessDialog(
                                context: context,
                                title: 'Berhasil Memasukan Data',
                                body: 'Data kontrol ${lineCondition.lineName} telah berhasil dimasukkan ke database',
                                btnText: 'Kembali ke Beranda',
                                btnOnPresss: () {
                                  Navigator.of(context).popUntil((route) => route.isFirst);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const MainScreen(),
                                  ));
                                });
                          }
                        } on AppGeneralException catch (e) {
                          Navigator.of(context).pop();
                          await showValidationError(context, e.cause);
                        } catch (e) {
                          Navigator.of(context).pop();
                          log(e.toString());
                          await showValidationError(context, ErrorMessage.general);
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(AppColors.red),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0), side: const BorderSide(color: Colors.red)))),
                      child: const Text("Simpan")),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
