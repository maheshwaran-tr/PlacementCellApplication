import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:placementapp/api_requests/urls.dart';

import '../backend/token/token_storage.dart';

class ImageRequests {

  static Future<int> uploadProof(String applicationId, String proof) async {
    String theUrl = "${Urls.jobApplicationUrl}/proof";
    Uri uri = Uri.parse(theUrl);
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] =
          'Bearer $token' // Include the token in the headers
      ..fields['application'] = applicationId
      ..files.add(await http.MultipartFile.fromPath('proofImage', proof));
    var response = await request.send();

    return response.statusCode;
  }

  static Future<Uint8List> fetchProof(String applicationId) async {
    String theUrl = "${Urls.jobApplicationUrl}/proof/$applicationId";

    Uri uri = Uri.parse(theUrl);

    String? token = await TokenStorage
        .getAccessToken(); // Retrieve the token from TokenStorage
    if (token == null) {
      throw Exception('Token is null');
    }

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token', // Include the token in the headers
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      // Handle error
      print('Error fetching image by student ID');
      throw Exception('Failed to fetch image');
    }
  }

  static Future<Uint8List> fetchImageByStudentId(String studentId) async {

    String theUrl = "${Urls.studentUrl}/profile/$studentId";

    Uri uri = Uri.parse(theUrl);

    String? token = await TokenStorage
        .getAccessToken(); // Retrieve the token from TokenStorage
    if (token == null) {
      throw Exception('Token is null');
    }

    var response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token', // Include the token in the headers
    });

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      // Handle error
      print('Error fetching image by student ID');
      throw Exception('Failed to fetch image');
    }
  }

  static Future<void> pickAndUploadImage(String studentId) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      String url = "${Urls.studentUrl}/profile";
      Uri uri = Uri.parse(url);

      String? token = await TokenStorage
          .getAccessToken(); // Retrieve the token from TokenStorage
      if (token == null) {
        throw Exception('Token is null');
      }

      var request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] =
            'Bearer $token' // Include the token in the headers
        ..fields['student'] = studentId
        ..files
            .add(await http.MultipartFile.fromPath('image', pickedFile.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        // Image uploaded successfully
        print("Image Uploaded Successfully");
      } else {
        print(response.statusCode);
        // Handle error
        print('Error uploading image');
      }
    }
  }
}
