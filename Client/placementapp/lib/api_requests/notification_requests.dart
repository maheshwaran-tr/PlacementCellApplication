import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';
import '../backend/token/token_storage.dart';

class NotificationRequests {
  static Future<bool> sendNotificationsToDept(
      String title, String body, List<String> departments) async {
    String? token = await TokenStorage.getAccessToken();

    if (token == null) {
      throw Exception('Token is null');
    }

    var reqBody = {
      "title": title,
      "body": body,
      "allowedDepartments": departments
    };

    String url = "${Urls.notiUrl}/dept";

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(reqBody),
    );

    print(response.body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
