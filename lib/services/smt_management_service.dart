import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netraya/models/point.dart';

class SmtManagementService {
  Future<List<Point>> getAllPoints() async {
    final uri = Uri.parse("https://netrayasmt-default-rtdb.asia-southeast1.firebasedatabase.app/vlookup/Points.json");
    print(uri);

    final headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.get(uri, headers: headers);
    print('response.statusCode : ${response.statusCode}');
    List<Point> listPoints = [];
    if (response.statusCode == 200) {
      final results = json.decode(response.body) as Map<String, dynamic>;
      for (var element in results.entries) {
        listPoints.add(Point(name: element.value['Name'], id: element.key));
      }
    }

    return listPoints;
  }
}
