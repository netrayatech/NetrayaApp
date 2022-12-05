import 'package:flutter/material.dart';
import 'package:netraya/models/app_user.dart';

class AppUserProvider with ChangeNotifier {
  AppUser _appUser = AppUser(uid: '', name: '', email: '', positionId: '', role: '', updatedAt: DateTime(0), createdAt: DateTime(0));

  AppUser get appUser => _appUser;

  void setWithoutNotif(AppUser appUser) {
    _appUser = appUser;
  }

  void set(AppUser appUser) {
    _appUser = appUser;
    notifyListeners();
  }
}
