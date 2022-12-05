import 'package:flutter/material.dart';

class MainScreenProvider with ChangeNotifier {
  int _selectedPage = 0;

  int get selectedPage => _selectedPage;

  void setSelectedPage(int value) {
    _selectedPage = value;
    notifyListeners();
  }

  void setSelectedPageWithoutNotify(int value) {
    _selectedPage = value;
  }
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = Locale('in');

  Locale get locale => _locale;

  void setLocale(Locale value) {
    _locale = value;
    notifyListeners();
  }
}
