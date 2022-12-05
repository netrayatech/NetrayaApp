import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:netraya/constants/firestore_model_naming.dart';

class Absen {
  final String id;
  final String uid;
  final String clockInLocation;
  final String clockOutLocation;
  final String status;
  final String clockInSelfieImagePath;
  final String clockOutSelfieImagePath;
  final String localPath;
  final GeoPoint? clockOutGeoPoint;
  final GeoPoint? clockInGeoPoint;
  final DateTime date;
  final DateTime? clockIn;
  final DateTime? clockOut;

  Absen(
      {required this.id,
      required this.uid,
      required this.status,
      required this.date,
      required this.clockInSelfieImagePath,
      required this.clockOutSelfieImagePath,
      this.localPath = '',
      this.clockOutGeoPoint,
      this.clockInGeoPoint,
      required this.clockInLocation,
      required this.clockOutLocation,
      this.clockIn,
      this.clockOut});

  static List<Absen> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Absen(
        id: doc.id,
        uid: data[AbsenFieldNaming.uid] ?? '',
        clockInLocation: data[AbsenFieldNaming.clockInLocation] ?? '',
        clockOutLocation: data[AbsenFieldNaming.clockOutLocation] ?? '',
        status: data[AbsenFieldNaming.status] ?? '',
        clockInSelfieImagePath: '',
        clockOutSelfieImagePath: '',
        clockInGeoPoint: data[AbsenFieldNaming.clockInGeopoint],
        clockOutGeoPoint: data[AbsenFieldNaming.clockOutGeopoint],
        date: data[AbsenFieldNaming.date] != null ? DateTime.parse(data[AbsenFieldNaming.date].toDate().toString()) : DateTime.now(),
        clockIn: data[AbsenFieldNaming.clockIn] != null ? DateTime.parse(data[AbsenFieldNaming.clockIn].toDate().toString()) : null,
        clockOut: data[AbsenFieldNaming.clockOut] != null ? DateTime.parse(data[AbsenFieldNaming.clockOut].toDate().toString()) : null,
      );
    }).toList();
  }

  static Absen? fromDocSnapshot(DocumentSnapshot snapshot) {
    if (snapshot.data() == null) return null;
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Absen(
      id: snapshot.id,
      uid: data[AbsenFieldNaming.uid] ?? '',
      clockInLocation: data[AbsenFieldNaming.clockInLocation] ?? '',
      clockOutLocation: data[AbsenFieldNaming.clockOutLocation] ?? '',
      status: data[AbsenFieldNaming.status] ?? '',
      clockInSelfieImagePath: '',
      clockOutSelfieImagePath: '',
      clockInGeoPoint: data[AbsenFieldNaming.clockInGeopoint],
      clockOutGeoPoint: data[AbsenFieldNaming.clockOutGeopoint],
      date: data[AbsenFieldNaming.date] != null ? DateTime.parse(data[AbsenFieldNaming.date].toDate().toString()) : DateTime.now(),
      clockIn: data[AbsenFieldNaming.clockIn] != null ? DateTime.parse(data[AbsenFieldNaming.clockIn].toDate().toString()) : null,
      clockOut: data[AbsenFieldNaming.clockOut] != null ? DateTime.parse(data[AbsenFieldNaming.clockOut].toDate().toString()) : null,
    );
  }

  Map<String, dynamic> clockInToMap() {
    return {
      AbsenFieldNaming.uid: uid,
      AbsenFieldNaming.clockInLocation: clockInLocation,
      AbsenFieldNaming.clockInSelfieImagePath: clockInSelfieImagePath,
      AbsenFieldNaming.status: 'present',
      AbsenFieldNaming.clockInGeopoint: clockInGeoPoint,
      AbsenFieldNaming.date: FieldValue.serverTimestamp(),
      AbsenFieldNaming.clockIn: FieldValue.serverTimestamp()
    };
  }

  Map<String, dynamic> clockOutToMap() {
    return {
      AbsenFieldNaming.clockOutLocation: clockOutLocation,
      AbsenFieldNaming.clockOutSelfieImagePath: clockOutSelfieImagePath,
      AbsenFieldNaming.clockOutGeopoint: clockOutGeoPoint,
      AbsenFieldNaming.clockOut: FieldValue.serverTimestamp()
    };
  }

  Absen copyWith({
    String? id,
    String? uid,
    String? clockInLocation,
    String? clockOutLocation,
    String? status,
    String? clockInSelfieImagePath,
    String? localPath,
    String? clockOutSelfieImagePath,
    GeoPoint? clockInGeoPoint,
    GeoPoint? clockOutGeoPoint,
    DateTime? date,
    DateTime? clockIn,
    DateTime? clockOut,
  }) {
    return Absen(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      clockInLocation: clockInLocation ?? this.clockInLocation,
      clockOutLocation: clockOutLocation ?? this.clockOutLocation,
      status: status ?? this.status,
      date: date ?? this.date,
      clockInGeoPoint: clockInGeoPoint ?? this.clockInGeoPoint,
      clockOutGeoPoint: clockOutGeoPoint ?? this.clockOutGeoPoint,
      localPath: localPath ?? this.localPath,
      clockInSelfieImagePath: clockInSelfieImagePath ?? this.clockInSelfieImagePath,
      clockOutSelfieImagePath: clockOutSelfieImagePath ?? this.clockInSelfieImagePath,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
    );
  }
}

class AbsenProvider with ChangeNotifier {
  Absen _absen = Absen(
      id: '', uid: '', status: '', clockInLocation: '', clockOutLocation: '', date: DateTime.now(), clockInSelfieImagePath: '', clockOutSelfieImagePath: '');

  AbsenProvider(this._absen);

  Absen get absen => _absen;

  void setAbsen(Absen absen) {
    _absen = absen;
    notifyListeners();
  }
}
