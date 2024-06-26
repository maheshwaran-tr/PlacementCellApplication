import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';
import 'package:placementapp/backend/models/admin_model.dart';
import '../backend/token/token_storage.dart';
// import '../backend/models/admin_model.dart';

class AdminRequests {


static Future<Uint8List> fetchImageByAdminId(String adminId) async {

    String theUrl = "${Urls.adminUrl}/profile/$adminId";

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

  static Future<Admin> getAdminById(String adminId) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.adminUrl}/${adminId}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Admin.fromJson(jsonData);
    } else {
      throw Exception('Cannot get student by this id');
    }
  }

}
