import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';
import 'package:placementapp/backend/models/user_model.dart';

import '../backend/token/token_storage.dart';

class UserRequest {
  static Future<User> getUserDataById(String id) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    String url = "${Urls.userUrl}/${id}";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var obj = jsonDecode(response.body);
      User theUser = User.fromJson(obj);
      return theUser;
    } else {
      throw Exception('Cannot get user');
    }
  }

  static Future<bool> updateFcmToken(String userId, String? fcmToken) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }


    if (fcmToken == null) {
      throw Exception('FCM Token is null');
    }

    String url = "${Urls.userUrl}/update-fcm-token/${userId}";

    final response = await http.put(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({"fcmToken": fcmToken}));

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
