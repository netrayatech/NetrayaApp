import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:netraya/models/app_user.dart';
import 'package:netraya/services/user_service.dart';

class GoogleSignInService {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        if (userCredential.additionalUserInfo!.isNewUser) {
          AppUserTemp appUserTemp = AppUserTemp(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? '',
            photoUrl: userCredential.user!.photoURL ?? '',
            status: 0,
            token: fcmToken ?? '',
            role: 'Staff',
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          await UserService().addNewUser(appUserTemp);
          return appUserTemp;
        } else {
          AppUser appUser = AppUser(
            uid: userCredential.user!.uid,
            name: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? '',
            photoUrl: userCredential.user!.photoURL ?? '',
            positionId: '',
            token: fcmToken ?? '',
            role: 'Staff',
            updatedAt: DateTime.now(),
            createdAt: DateTime.now(),
          );
          await UserService().updateUser(appUser);
          return appUser;
        }
      }
    } catch (e) {
      googleSignIn.signOut();
      return Future.error(e.toString());
    }
  }

  Future logout() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {
      return Future.error(e);
    }
  }
}
