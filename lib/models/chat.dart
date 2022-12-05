import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String senderId;
  final String senderName;
  final String message;
  final DateTime createdAt;

  Chat({required this.senderId, required this.senderName, required this.message, required this.createdAt});

  static List<Chat> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Chat(
        senderId: data['senderId'] ?? '',
        senderName: data['senderName'] ?? '',
        message: data['message'] ?? '',
        createdAt: data['createdAt'] == null ? DateTime.now() : DateTime.parse(data['createdAt'].toDate().toString()),
      );
    }).toList();
  }

  Map<String, dynamic> toMapRequest() {
    return {
      "senderId": senderId,
      "senderName": senderName,
      "message": message,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }
}
