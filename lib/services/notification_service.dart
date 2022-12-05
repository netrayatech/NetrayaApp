import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netraya/constants/firestore_model_naming.dart';
import 'package:netraya/models/notification.dart';
import 'package:netraya/models/position.dart';
import 'package:netraya/services/user_service.dart';

class NotificationService {
  final String _uid;
  NotificationService() : _uid = FirebaseAuth.instance.currentUser!.uid;
  final _notificationsReff = FirebaseFirestore.instance.collection('notifications');
  final _notificationsCounterReff = FirebaseFirestore.instance.collection('notifications_counter');

  Future<List<NotificationModel>> getLastNotification() {
    return _notificationsReff
        .where(NotificationFieldNaming.uid, isEqualTo: _uid)
        .orderBy(NotificationFieldNaming.createdAt, descending: true)
        .limit(1)
        .get()
        .then(NotificationModel.fromQuerySnapshot);
  }

  Future<List<NotificationModel>> getMyNotifications() async {
    JobPosition jobPosition = await UserService().getPositionLevel();
    print('level${jobPosition.level.toString()}');
    List<NotificationModel> notifications =
        await _notificationsReff.where(NotificationFieldNaming.uid, isEqualTo: _uid).get().then((value) => NotificationModel.fromQuerySnapshot(value));
    notifications.addAll(await _notificationsReff
        .where('levels', arrayContains: 'level${jobPosition.level.toString()}')
        .get()
        .then((value) => NotificationModel.fromQuerySnapshot(value)));
    return notifications;
  }

  Future tandaiSudahDibaca(String docId) {
    return _notificationsReff.doc(docId).update({NotificationFieldNaming.isRead: true});
  }

  Future<Map<String, dynamic>> getNotificationsCounter() async {
    final snapshotDocument = await _notificationsCounterReff.doc(_uid).get();
    if (snapshotDocument.data() == null) return {};
    return snapshotDocument.data() as Map<String, dynamic>;
  }

  Future resetNotificationsCounter() {
    return _notificationsCounterReff.doc(_uid).set({'unread': 0});
  }
}
