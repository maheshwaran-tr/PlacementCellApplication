import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:placementapp/api_requests/urls.dart';

import '../backend/token/token_storage.dart';

class AuthRequests {
  static Future<Map<String, dynamic>?> loginUser(
      String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        // Handle empty username or password
        return null;
      }

      var regBody = {"username": username, "password": password};

      String url = "${Urls.authUrl}/login";
      var response = await http.post(Uri.parse(url),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regBody));

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('access_token') &&
            jsonResponse.containsKey('refresh_token') &&
            (jsonResponse.containsKey('user_data'))) {
          var myAccessToken = jsonResponse['access_token'];
          var refreshToken = jsonResponse['refresh_token'];

          var userData = jsonResponse['user_data'];

          await TokenStorage.saveTokens(myAccessToken, refreshToken);

          // Return both user data and access_token
          return {
            'user_id':jsonResponse["user_id"],
            'access_token': myAccessToken,
            'role': jsonResponse['role'],
            'user_data': userData
          };
        } else {
          // Handle missing fields in the response
          return null;
        }
      } else {
        // Handle non-200 status codes
        print("Login failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (error) {
      // Handle unexpected errors
      print("Error during login: $error");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> refreshTheToken() async {
    final token = await TokenStorage.getRefreshToken();
    if (token == null) {
      // Handle missing refresh token
      return null;
    }

    String url = "${Urls.authUrl}/refresh-token";

    var regBody = {"refreshToken": token};

    final response = await http.post(Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(regBody));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('access_token') &&
          jsonResponse.containsKey('refresh_token') &&
          (jsonResponse.containsKey('user_data'))) {
        var myAccessToken = jsonResponse['access_token'];
        var refreshToken = jsonResponse['refresh_token'];

        var userData = jsonResponse['user_data'];

        await TokenStorage.saveTokens(myAccessToken, refreshToken);

        // Return both user data and access_token
        return {
          'access_token': myAccessToken,
          'role': jsonResponse['role'],
          'user_data': userData
        };
      } else {
        // Handle missing fields in the response
        return null;
      }
    } else {
      // Handle non-200 status codes
      print("Login failed with status code: ${response.statusCode}");
      return null;
    }
  }
}
