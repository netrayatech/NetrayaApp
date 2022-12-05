import 'package:flutter/material.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/models/notification.dart';
import 'package:netraya/providers/main_screen_provider.dart';
import 'package:netraya/services/notification_service.dart';
import 'package:netraya/widgets/notification_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Announcement extends StatelessWidget {
  const Announcement({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationService = NotificationService();
    final mainScreenProvider = Provider.of<MainScreenProvider>(context, listen: false);
    final appLocalizations = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.grey),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.red,
                    maxRadius: 12,
                    child: FutureBuilder(
                      future: notificationService.getNotificationsCounter(),
                      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) => Text(
                        snapshot.data != null ? '${snapshot.data!['unread']}' : '0',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    'Pengumuman',
                    style: TextStyle(),
                  )
                ],
              ),
              TextButton(
                onPressed: () {
                  mainScreenProvider.setSelectedPage(2);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(color: Colors.red),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: Colors.red,
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            height: 0.5,
            color: Colors.grey,
          ),
          const SizedBox(
            height: 12,
          ),
          FutureBuilder(
            future: notificationService.getLastNotification(),
            builder: (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Tidak ada pengumuman'),
                );
              }

              return NotificationTile(
                notificationModel: snapshot.data!.first,
                titleColor: AppColors.yellow,
                textColor: Colors.black,
              );
            },
          ),
        ],
      ),
    );
  }
}
