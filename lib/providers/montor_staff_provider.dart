import 'package:flutter/cupertino.dart';

class MonitorStaffProvider with ChangeNotifier {
  int _totalKaryawan = 0;
  int _totalMasuk = 0;
  int _totalCuti = 0;

  int get totalKaryawan => _totalKaryawan;
  int get totalMasuk => _totalMasuk;
  int get totalCuti => _totalCuti;

  void set(int totalKaryawan, int totalMasuk, int totalCuti) {
    _totalKaryawan = totalKaryawan;
    _totalMasuk = totalMasuk;
    _totalCuti = totalCuti;
    notifyListeners();
  }
}

class MonitorStaffStatusProvider with ChangeNotifier {
  int _selectedStatus = 0;
  List<String> _statusList = ['Semua', 'Sudah Absen', 'Belum Absen', 'Cuti', 'Alpha'];

  int get selectedStatus => _selectedStatus;
  List<String> get statusList => _statusList;

  bool isSelected(String value) {
    return value == _statusList[_selectedStatus];
  }

  void setSelectedStatus(int value) {
    _selectedStatus = value;
    notifyListeners();
  }
}
