import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/chat.dart';
import 'package:netraya/models/notification.dart';
import 'package:netraya/services/pic_controlling_service.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/pic_controlling/card_detail_notification.dart';

class DetailNotificationScreen extends StatefulWidget {
  const DetailNotificationScreen({Key? key, required this.notificationModel}) : super(key: key);
  final NotificationModel notificationModel;

  @override
  State<DetailNotificationScreen> createState() => _DetailNotificationScreenState();
}

class _DetailNotificationScreenState extends State<DetailNotificationScreen> {
  TextEditingController nameController = TextEditingController();
  String fullName = '';
  final userService = UserService();
  final messageTEC = TextEditingController();
  final chatsService = ChatsService();
  FocusNode nameFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Detail Notifikasi',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 12,
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: PICNotificationTile(
                  notificationModel: widget.notificationModel,
                ),
              ),
              const Divider(
                height: 10,
                thickness: 1,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: StreamBuilder(
                  stream: ChatsService().getMessages(widget.notificationModel.targetId),
                  builder: (context, AsyncSnapshot<List<Chat>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text(ErrorMessage.general),
                      );
                    }

                    List<Chat> messages = snapshot.data as List<Chat>;

                    return ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Align(
                        alignment: Alignment.centerRight,
                        child: CardDetailNotification(
                          chat: messages[index],
                          userService: userService,
                          textFieldFn: nameFN,
                        ),
                      ),
                    );
                  }),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Container(
              margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageTEC,
                      focusNode: nameFN,
                      decoration: InputDecoration(
                          filled: true,
                          hintText: "Masukkan komentar anda",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16)),
                    ),
                  ),
                  FutureBuilder(
                      future: userService.getUser(),
                      builder: (context, AsyncSnapshot<AppUser?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            margin: const EdgeInsets.only(left: 12),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                              onPressed: null,
                              child: const SizedBox(height: 20, width: 20, child: CircularProgressIndicator()),
                            ),
                          );
                        }
                        return Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: AppColors.darkRed),
                            onPressed: () {
                              if (messageTEC.text.isEmpty) {
                                return;
                              }
                              chatsService.postMessage(widget.notificationModel.targetId, snapshot.data!.name, messageTEC.text);
                              messageTEC.clear();
                              FocusScope.of(context).unfocus();
                            },
                            child: const Text("Posting"),
                          ),
                        );
                      })
                ],
              )),
        ],
      ),
    );
  }
}

class PICNotificationTile extends StatelessWidget {
  const PICNotificationTile({
    Key? key,
    required this.notificationModel,
  }) : super(key: key);
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'assets/svg/program.svg',
            height: 10,
            width: 10,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 9, right: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 19,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.center,
                        decoration:
                            BoxDecoration(color: notificationModel.condition == 'Aman' ? Colors.green : AppColors.red, borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          notificationModel.condition,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.white),
                        ),
                      ),
                      Text(
                        AppSettings.appDateTimeFormat.format(notificationModel.createdAt),
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(notificationModel.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(notificationModel.description, style: const TextStyle(fontSize: 12, height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
