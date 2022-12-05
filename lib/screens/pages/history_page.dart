import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/cuti.dart';
import 'package:netraya/screens/pages/profile_page.dart';
import 'package:netraya/services/cuti_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cutiService = CutiService();
    final appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(AppSettings.appMainPadding, AppSettings.appMainPadding, AppSettings.appMainPadding, 0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomAppBar(title: appLocalizations.history),
            FutureBuilder(
              future: cutiService.getMyCuti(),
              builder: (context, AsyncSnapshot<List<Cuti>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Oops, Terjadi kesalahan'),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text('${appLocalizations.youDontHave} ${appLocalizations.history}'),
                  );
                }

                List<Cuti> listCuti = snapshot.data!;

                return Expanded(
                  child: ListView.builder(
                    itemCount: listCuti.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 10),
                            blurRadius: 10,
                            spreadRadius: 2,
                            color: Colors.grey[200]!,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: getStatusColor(listCuti[index].status),
                            ),
                            child: Text(
                              getStatusText(listCuti[index].status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            listCuti[index].jenisCuti,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            getRangeDate(listCuti[index].tanggalMulai, listCuti[index].tanggalBerakhir),
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            appLocalizations.submittedOn,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            listCuti[index].requestedAt == null ? '' : AppSettings.appDateFormat.format(listCuti[index].requestedAt!),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Color getStatusColor(int status) {
  switch (status) {
    case AppCode.approved:
      return Colors.lightGreen;
    case AppCode.rejected:
      return AppColors.red;
    case AppCode.submitted:
      return AppColors.yellow;
  }
  return Colors.white;
}

String getStatusText(int status) {
  switch (status) {
    case AppCode.approved:
      return 'Approved';
    case AppCode.rejected:
      return 'Rejected';
    case AppCode.submitted:
      return 'Submitted';
  }
  return '';
}

String getRangeDate(DateTime? first, DateTime? last) {
  if (first == null || last == null) return '';
  int totalDay = first.difference(last).inDays.abs() + 1;
  for (int i = 0; i < totalDay; i++) {
    if (first.add(Duration(days: i)).weekday == DateTime.sunday) {
      totalDay--;
    }
  }
  return '${AppSettings.appDateFormat.format(first)} - ${AppSettings.appDateFormat.format(last)} ($totalDay Hari)';
}
