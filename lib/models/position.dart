import 'package:cloud_firestore/cloud_firestore.dart';

class JobPosition {
  final String name;
  final int level;

  JobPosition({required this.name, required this.level});

  static JobPosition fromDocSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return JobPosition(name: data['name'], level: data['level']);
  }
}
