import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:netraya/constants/app_settings.dart';
import 'package:netraya/exceptions/app_general_exception.dart';
import 'package:netraya/models/chat.dart';
import 'package:netraya/models/custom_response.dart';
import 'package:netraya/models/line_condition.dart';

class PicControllingService {
  final User? _user;
  PicControllingService() : _user = FirebaseAuth.instance.currentUser;

  Future inquiry(String qrContent) async {
    final uri = Uri.parse(AppEndpoint.picControllingInquiry);
    print(uri);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _user!.getIdToken()}',
    };
    qrContent = qrContent.replaceAll('\n', '');

    final body = json.encode({
      'qrContent': qrContent,
    });

    print(body);

    final response = await http.post(uri, headers: headers, body: body);
    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      final results = CustomResponse.fromMap(json.decode(response.body));
      if (results.errorCode == ApiErrorCode.SUCCESS) {
        return LineCondition(lineId: qrContent, lineName: results.message['Name'], condition: '', notes: '', createdAt: DateTime.now());
      }
      if (results.errorCode == ApiErrorCode.DATA_NOT_FOUND) {
        throw AppGeneralException('Qr code tidak valid');
      }
    }
    throw AppGeneralException(ErrorMessage.general);
  }

  Future execute(LineCondition lineCondition) async {
    final uri = Uri.parse(AppEndpoint.picControllingExecute);
    print(uri);

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${await _user!.getIdToken()}',
    };

    print(lineCondition.toMapRequest());

    final body = json.encode(lineCondition.toMapRequest());

    final response = await http.post(uri, headers: headers, body: body);
    print('response.statusCode : ${response.statusCode}');
    if (response.statusCode == 200) {
      final results = CustomResponse.fromMap(json.decode(response.body));
      if (results.errorCode == ApiErrorCode.SUCCESS) {
        return true;
      }
    }
    throw AppGeneralException(ErrorMessage.general);
  }
}

class ChatsService {
  final User? _user;
  ChatsService() : _user = FirebaseAuth.instance.currentUser;
  final _picControllingReff = FirebaseFirestore.instance.collection('picControlling');

  Stream<List<Chat>> getMessages(String picControllingId) {
    return _picControllingReff.doc(picControllingId).collection('chats').orderBy('createdAt').snapshots().map(Chat.fromQuerySnapshot);
  }

  Future<Chat> postMessage(String picControllingId, String senderName, String message) async {
    print('post message');
    Chat chat = Chat(senderId: _user!.uid, senderName: senderName, message: message, createdAt: DateTime.now());
    await _picControllingReff.doc(picControllingId).collection('chats').add(chat.toMapRequest());
    print('complete');
    return chat;
  }
}
