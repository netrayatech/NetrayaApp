import 'package:cloud_firestore/cloud_firestore.dart';

class LineCondition {
  final String lineId;
  final String lineName;
  final String condition;
  final String notes;
  final DateTime createdAt;

  LineCondition({required this.lineId, required this.lineName, required this.condition, required this.notes, required this.createdAt});

  static List<LineCondition> fromQuerySnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) => fromDocSnapshot(doc)).toList();
  }

  static LineCondition fromDocSnapshot(DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    return LineCondition(
      lineId: data['lineId'],
      lineName: data['lineName'],
      condition: data['condition'],
      notes: data['notes'],
      createdAt: DateTime.parse(data['createdAt'].toDate().toString()),
    );
  }

  Map<String, dynamic> toMapRequest() {
    return {'lineId': lineId, 'lineName': lineName, 'condition': condition, 'notes': notes};
  }
}
