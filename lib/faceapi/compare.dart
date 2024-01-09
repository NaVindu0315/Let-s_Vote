import 'dart:convert';

import 'package:http/http.dart' as http;
import "face-response.dart";

Future<FaceComparisonResponse> compareFaces(
    String faceurl1, String faceurl2) async {
  final response = await http.post(
    Uri.parse('http://localhost:3000/compareFaces'),
    body: jsonEncode({
      'faceurl1': faceurl1,
      'faceurl2': faceurl2,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return FaceComparisonResponse.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to compare faces');
  }
}
