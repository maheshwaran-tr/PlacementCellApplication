import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';
import 'package:placementapp/backend/models/staff_model.dart';
import '../backend/token/token_storage.dart';

class StaffRequests {
  static Future<List<Staff>?> getAllStaffs() async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.staffUrl}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)["data"];

      List<Staff> staffList = [];
      for (var obj in jsonData) {
        final pobj = Staff.fromJson(obj);
        staffList.add(pobj);
      }
      return staffList;
    } else {
      return null;
    }
  }

  static Future<bool> addStaff(Staff staff) async {

    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    final response = await http.post(Uri.parse(Urls.staffUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(staff.toJson()));
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> deleteStaff(String staffId) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }
    String deleteStaffUrl = "${Urls.staffUrl}/$staffId";

    final response = await http.delete(
      Uri.parse(deleteStaffUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateStaff(Staff staff) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.staffUrl}/${staff.id}";
    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(staff.toJson()));
        print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<Staff> getStaffById(String staffId) async {
    String? token = await TokenStorage.getAccessToken();
    if (token == null) {
      throw Exception('Token is null');
    }
    String url = "${Urls.staffUrl}/${staffId}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      return Staff.fromJson(jsonData);
    } else {
      throw Exception('Cannot get student by this id');
    }
  }

  static Future<Uint8List> fetchImageByStaffId(String staffId) async {

    String theUrl = "${Urls.staffUrl}/profile/$staffId";

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
}
