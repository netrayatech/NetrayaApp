import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/constants/app_colors.dart';
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/chat.dart';
import 'package:netraya/services/user_service.dart';
import 'package:netraya/widgets/user_profile_picture.dart';

class CardDetailNotification extends StatelessWidget {
  const CardDetailNotification({
    Key? key,
    required this.chat,
    required this.userService,
    required this.textFieldFn,
  }) : super(key: key);
  final Chat chat;
  final UserService userService;
  final FocusNode textFieldFn;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 200),
                child: Stack(
                  children: [
                    FutureBuilder(
                      future: userService.getOtherUser(chat.senderId),
                      builder: (context, AsyncSnapshot<AppUser?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }
                        String name = chat.senderName;
                        String position = '';
                        String url = '';

                        if (snapshot.hasError) {
                          return const Text(ErrorMessage.general);
                        }

                        if (snapshot.hasData) {
                          name = snapshot.data!.name.isEmpty ? chat.senderName : snapshot.data!.name;
                          position = snapshot.data!.positionName;
                          url = snapshot.data!.photoUrl;
                        }

                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            OtherUserProfilePicture(width: 40, radius: 20, url: url),
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    position,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 140,
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  chat.message,
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
          Positioned(
            right: 0,
            top: 10,
            child: Text(
              textAlign: TextAlign.start,
              AppSettings.appDateTimeFormat.format(chat.createdAt),
              style: const TextStyle(fontSize: 10),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(textFieldFn);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/svg/message-square.svg'),
                  const SizedBox(
                    width: 4,
                  ),
                  const Text(
                    "Balas",
                    style: TextStyle(color: AppColors.darkRed, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
