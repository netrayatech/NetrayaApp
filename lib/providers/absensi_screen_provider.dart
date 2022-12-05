import 'package:flutter/cupertino.dart';

class AbsensiScreenConfigProvider with ChangeNotifier {
  int _step = 0;
  bool _paired = false;
  bool _isClockIn = true;

  AbsensiScreenConfigProvider(this._isClockIn);

  int get step => _step;
  bool get paired => _paired;
  bool get isClockIn => _isClockIn;

  void setStep(int val) {
    _step = val;
    notifyListeners();
  }

  void setPaired(bool val) {
    _paired = val;
    notifyListeners();
  }
}
