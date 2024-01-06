import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

const String apiKey = 'YOUR_API_KEY';
const String azureFaceApiUrl =
    'https://YOUR_AZURE_REGION.api.cognitive.microsoft.com/face/v1.0/detect';

class faceapi extends StatelessWidget {
  const faceapi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: facecompare(),
    );
  }
}

class facecompare extends StatefulWidget {
  ///begin

  ///end

  @override
  State<facecompare> createState() => _facecompareState();
}

class _facecompareState extends State<facecompare> {
  MediaType(String type, String subtype) {
    return '$type/$subtype';
  }

  ///begin

  Future<bool> compareFaces() async {
    String imgurl1 =
        'https://firebasestorage.googleapis.com/v0/b/cam-test-2-78bd3.appspot.com/o/images%2F2023-12-01%2012%3A39%3A43.963704.jpg?alt=media&token=f9258809-b452-4c64-a4ce-d88718e6f55e';
    String imgurl2 = '';
    // Request parameters
    final params = {
      'returnFaceId': 'true',
      'returnFaceLandmarks': 'false',
    };

    // Construct the URL
    final uri = Uri.parse(azureFaceApiUrl).replace(queryParameters: params);

    // Create the HTTP POST request
    final request = http.MultipartRequest('POST', uri);
    request.headers['Ocp-Apim-Subscription-Key'] = apiKey;
    request.headers['Content-Type'] = 'application/octet-stream';

    // Add the image URLs to the request body
    final imgUrl1Bytes = utf8.encode(imgurl1);
    final imgUrl2Bytes = utf8.encode(imgurl2);

    request.files.add(await http.MultipartFile.fromPath(
      'image1',
      imgurl1,
      contentType: MediaType('image', 'jpeg'),
    ));

    request.files.add(await http.MultipartFile.fromPath(
      'image2',
      imgurl2,
      contentType: MediaType('image', 'jpeg'),
    ));

    // Send the request and parse the response
    final response = await request.send();
    final body = await response.stream.bytesToString();
    final data = jsonDecode(body);

    // Check if there are faces detected and if their IDs match
    if (data is List && data.length == 2) {
      final faceId1 = data[0]['faceId'];
      final faceId2 = data[1]['faceId'];
      return faceId1 == faceId2;
    }

    return false;
  }

  ///end
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
