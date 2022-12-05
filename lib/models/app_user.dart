import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:netraya/constants/firestore_model_naming.dart';

class AppUser {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String role;
  final String positionId;
  String positionName;
  final int shift;
  final String token;
  final DateTime updatedAt;
  final DateTime createdAt;

  AppUser(
      {required this.uid,
      required this.name,
      required this.email,
      this.photoUrl = '',
      required this.role,
      required this.positionId,
      this.positionName = '',
      this.token = '',
      this.shift = 0,
      required this.updatedAt,
      required this.createdAt});

  static List<AppUser> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AppUser(
        uid: doc.id,
        name: data[AppUserFieldNaming.name] ?? '',
        email: data[AppUserFieldNaming.email] ?? '',
        photoUrl: data[AppUserFieldNaming.photoUrl] ?? '',
        positionId: data[AppUserFieldNaming.positionId] ?? '',
        shift: data[AppUserFieldNaming.shift] ?? 0,
        role: data[AppUserFieldNaming.role],
        updatedAt: data[AppUserFieldNaming.updatedAt] == null ? DateTime.parse(data[AppUserFieldNaming.updatedAt].toDate().toString()) : DateTime(0),
        createdAt: data[AppUserFieldNaming.createdAt] == null ? DateTime.parse(data[AppUserFieldNaming.createdAt].toDate().toString()) : DateTime(0),
      );
    }).toList();
  }

  static AppUser? fromDocSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AppUser(
      uid: snapshot.id,
      name: data[AppUserFieldNaming.name] ?? 'Unknown',
      email: data[AppUserFieldNaming.email] ?? '',
      photoUrl: data[AppUserFieldNaming.photoUrl] ?? '',
      positionId: data[AppUserFieldNaming.positionId] ?? '',
      shift: data[AppUserFieldNaming.shift] ?? 0,
      role: data[AppUserFieldNaming.role],
      updatedAt: data[AppUserFieldNaming.updatedAt] == null ? DateTime.parse(data[AppUserFieldNaming.updatedAt].toDate().toString()) : DateTime(0),
      createdAt: data[AppUserFieldNaming.createdAt] == null ? DateTime.parse(data[AppUserFieldNaming.createdAt].toDate().toString()) : DateTime(0),
    );
  }

  Map<String, dynamic> toMapUpdate() {
    return {
      AppUserFieldNaming.name: name,
      AppUserFieldNaming.email: email,
      AppUserFieldNaming.fcmToken: token,
      AppUserFieldNaming.updatedAt: FieldValue.serverTimestamp()
    };
  }
}

class AppUserTemp {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String role;
  final String token;
  final int status;
  final int shift;
  final DateTime updatedAt;
  final DateTime createdAt;

  AppUserTemp(
      {required this.uid,
      required this.name,
      required this.email,
      this.photoUrl = '',
      required this.role,
      this.token = '',
      this.status = 0,
      this.shift = 0,
      required this.updatedAt,
      required this.createdAt});

  static List<AppUserTemp> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AppUserTemp(
        uid: doc.id,
        name: data[AppUserFieldNaming.name] ?? '',
        email: data[AppUserFieldNaming.email] ?? '',
        photoUrl: data[AppUserFieldNaming.photoUrl] ?? '',
        role: data[AppUserFieldNaming.role],
        status: data[AppUserFieldNaming.status] ?? 0,
        shift: data[AppUserFieldNaming.shift] ?? 0,
        updatedAt: data[AppUserFieldNaming.updatedAt] == null ? DateTime.parse(data[AppUserFieldNaming.updatedAt].toDate().toString()) : DateTime(0),
        createdAt: data[AppUserFieldNaming.createdAt] == null ? DateTime.parse(data[AppUserFieldNaming.createdAt].toDate().toString()) : DateTime(0),
      );
    }).toList();
  }

  static AppUserTemp? fromDocSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return AppUserTemp(
      uid: snapshot.id,
      name: data[AppUserFieldNaming.name] ?? 'Unknown',
      email: data[AppUserFieldNaming.email] ?? '',
      photoUrl: data[AppUserFieldNaming.photoUrl] ?? '',
      role: data[AppUserFieldNaming.role],
      status: data[AppUserFieldNaming.status] ?? 0,
      shift: data[AppUserFieldNaming.shift] ?? 0,
      updatedAt: data[AppUserFieldNaming.updatedAt] == null ? DateTime.parse(data[AppUserFieldNaming.updatedAt].toDate().toString()) : DateTime(0),
      createdAt: data[AppUserFieldNaming.createdAt] == null ? DateTime.parse(data[AppUserFieldNaming.createdAt].toDate().toString()) : DateTime(0),
    );
  }

  Map<String, dynamic> toMapNew() {
    return {
      AppUserFieldNaming.name: name,
      AppUserFieldNaming.email: email,
      AppUserFieldNaming.photoUrl: photoUrl,
      AppUserFieldNaming.role: role,
      AppUserFieldNaming.status: status,
      AppUserFieldNaming.shift: shift,
      AppUserFieldNaming.fcmToken: token,
      AppUserFieldNaming.updatedAt: FieldValue.serverTimestamp(),
      AppUserFieldNaming.createdAt: FieldValue.serverTimestamp(),
    };
  }
}
