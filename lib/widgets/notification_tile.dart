import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:netraya/models/notification.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    Key? key,
    this.titleColor = Colors.black,
    this.textColor = Colors.black,
    required this.notificationModel,
  }) : super(key: key);
  final Color titleColor;
  final Color textColor;
  final NotificationModel notificationModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        notificationModel.title.isEmpty
            ? Container()
            : SvgPicture.asset(
                'assets/svg/info.svg',
                color: titleColor,
              ),
        const SizedBox(
          width: 8,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notificationModel.title,
                style: TextStyle(color: titleColor, fontSize: 12),
              ),
              Text(
                notificationModel.description,
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: 12),
              )
            ],
          ),
        )
      ],
    );
  }
}
