import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netraya/constants/firestore_model_naming.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/models/position.dart';
import 'package:netraya/services/firebase_storage_service.dart';
import 'package:path/path.dart' as p;

class UserService {
  final String? _uid;
  UserService() : _uid = FirebaseAuth.instance.currentUser == null ? null : FirebaseAuth.instance.currentUser!.uid;

  final _userDataReference = FirebaseFirestore.instance.collection('users');
  final _positionsReference = FirebaseFirestore.instance.collection('positions');
  final _userTempDataReference = FirebaseFirestore.instance.collection('temp_users');
  final FirebaseStorageService firebaseStorageService = FirebaseStorageService();

  Stream<AppUser?> get userData {
    return _userDataReference.doc(_uid).snapshots().map(AppUser.fromDocSnapshot);
  }

  Stream<AppUser?> getUserData() {
    return _userDataReference.doc(_uid).snapshots().map(AppUser.fromDocSnapshot);
  }

  Future<AppUser?> getUser() {
    return _userDataReference.doc(_uid).get().then(AppUser.fromDocSnapshot);
  }

  Future<AppUserTemp?> getTempUserData() {
    return _userTempDataReference.doc(_uid).get().then(AppUserTemp.fromDocSnapshot);
  }

  Future<JobPosition> getPositionLevel() async {
    AppUser? appUser = await getUser();
    return _positionsReference.doc(appUser == null ? '' : appUser.positionId).get().then(JobPosition.fromDocSnapshot);
  }

  Future<JobPosition> getPositionLevelFromPositionId({String? positionId}) async {
    return _positionsReference.doc(positionId).get().then(JobPosition.fromDocSnapshot);
  }

  Future<AppUser?> getOtherUser(String uid) async {
    final userDataReference = FirebaseFirestore.instance.collection('users');
    AppUser? appUser = await userDataReference.doc(uid).get().then(AppUser.fromDocSnapshot);
    if (appUser != null) {
      JobPosition jobPosition = await getPositionLevelFromPositionId(positionId: appUser.positionId);
      appUser.positionName = jobPosition.name;
    }
    return appUser;
  }

  Future<dynamic> addNewUser(AppUserTemp appUser) {
    return _userTempDataReference.doc(appUser.uid).set(appUser.toMapNew());
  }

  Future<dynamic> updateUser(AppUser appUser) {
    return _userDataReference.doc(appUser.uid).update(appUser.toMapUpdate());
  }

  Future<dynamic> updateProfileImage(XFile xFile) async {
    String url = await firebaseStorageService.uploadFile(xFile.path, 'users/$_uid${p.extension(xFile.name)}');

    return _userDataReference.doc(_uid).update({
      AppUserFieldNaming.photoUrl: url,
    });
  }

  Future<dynamic> updateProfile({XFile? xFile, required String name}) async {
    if (xFile != null) {
      String url = await firebaseStorageService.uploadFile(xFile.path, 'users/$_uid${p.extension(xFile.name)}');
      return _userDataReference.doc(_uid).update({
        AppUserFieldNaming.name: name,
        AppUserFieldNaming.photoUrl: url,
      });
    }
    return _userDataReference.doc(_uid).update({
      AppUserFieldNaming.name: name,
    });
  }

  static String greeting() {
    DateTime now = DateTime.now();
    if (now.hour > 0 && now.hour < 11) {
      return 'Selamat Pagi,';
    }
    if (now.hour > 11 && now.hour < 15) {
      return 'Selamat Siang,';
    }
    if (now.hour > 15 && now.hour < 18) {
      return 'Selamat Sore,';
    }
    return 'Selamat Malam,';
  }
}
