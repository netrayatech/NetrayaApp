import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netraya/constants/firestore_model_naming.dart';

class NotificationModel {
  final String id;
  final String uid;
  final String title;
  final String targetId;
  final String condition;
  final bool isRead;
  final bool isAction;
  final String description;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.uid,
    this.isRead = false,
    this.isAction = false,
    this.targetId = '',
    this.title = '',
    this.condition = '',
    this.description = '',
    required this.createdAt,
  });

  static List<NotificationModel> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      return fromDocSnapshot(doc);
    }).toList();
  }

  static NotificationModel fromDocSnapshot(DocumentSnapshot docSnapshot) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
    return NotificationModel(
      id: docSnapshot.id,
      uid: data[NotificationFieldNaming.uid] ?? '',
      title: data[NotificationFieldNaming.title] ?? '',
      condition: data[NotificationFieldNaming.condition] ?? '',
      targetId: data[NotificationFieldNaming.targetId] ?? '',
      isRead: data[NotificationFieldNaming.isRead] ?? false,
      isAction: data[NotificationFieldNaming.isAction],
      description: data[NotificationFieldNaming.description],
      createdAt: data[NotificationFieldNaming.createdAt] == null ? DateTime.now() : DateTime.parse(data[NotificationFieldNaming.createdAt].toDate().toString()),
    );
  }
}
