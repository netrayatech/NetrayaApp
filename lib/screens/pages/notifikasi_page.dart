import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/notification.dart';
import 'package:netraya/screens/pages/profile_page.dart';
import 'package:netraya/screens/pic_controlling/detail_notification_screen.dart';
import 'package:netraya/services/notification_service.dart';
import 'package:netraya/widgets/notification_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NotifikasiPage extends StatelessWidget {
  const NotifikasiPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: AppSettings.appMainPadding),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomAppBar(title: appLocalizations.notification),
            FutureBuilder(
              future: notificationService.getMyNotifications(),
              builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(
                    child: Text('Oops, Terjadi kesalahan'),
                  );
                }

                if (!snapshot.hasData) {
                  return Center(
                    child: Text('${appLocalizations.youDontHave} ${appLocalizations.notification}'),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${snapshot.data!.length} ${appLocalizations.notification}',
                              style: const TextStyle(fontSize: 12, color: Colors.black87),
                            ),
                            InkWell(
                              onTap: () {
                                for (var notification in snapshot.data!) {
                                  if (!notification.isRead) {
                                    notificationService.tandaiSudahDibaca(notification.id);
                                  }
                                  notificationService.resetNotificationsCounter();
                                }
                              },
                              child: Row(
                                children: [
                                  SvgPicture.asset('assets/svg/check.svg'),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    appLocalizations.markAsRead,
                                    style: const TextStyle(color: AppColors.red, fontSize: 12),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(children: [
                            ListView.builder(
                              itemCount: snapshot.data!.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                NotificationModel notificationModel = snapshot.data![index];
                                if (notificationModel.isAction) {
                                  return InkWell(
                                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => DetailNotificationScreen(
                                        notificationModel: notificationModel,
                                      ),
                                    )),
                                    child: Container(
                                      padding: const EdgeInsets.all(AppSettings.appMainPadding),
                                      margin: index == 13 ? const EdgeInsets.only(bottom: 16) : null,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: PICNotificationTile(
                                              notificationModel: notificationModel,
                                            ),
                                          ),
                                          // snapshot.data![index].isRead
                                          const SizedBox(
                                            width: 8,
                                          )
                                          // : const Icon(
                                          //     Icons.circle,
                                          //     size: 8,
                                          //     color: AppColors.red,
                                          //   ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: const EdgeInsets.all(AppSettings.appMainPadding),
                                    margin: index == 13 ? const EdgeInsets.only(bottom: 16) : null,
                                    decoration: BoxDecoration(
                                      color: index < 2 ? Colors.black12 : Colors.transparent,
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: NotificationTile(
                                            notificationModel: snapshot.data![index],
                                            titleColor: snapshot.data![index].isRead ? Colors.black : AppColors.red,
                                            textColor: snapshot.data![index].isRead ? Colors.black : AppColors.red,
                                          ),
                                        ),
                                        snapshot.data![index].isRead
                                            ? const SizedBox(
                                                width: 8,
                                              )
                                            : const Icon(
                                                Icons.circle,
                                                size: 8,
                                                color: AppColors.red,
                                              ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          ]),
                        ),
                      ),
                    ],
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
