import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static final _secureStorage = FlutterSecureStorage();

  static Future<void> saveFCMToken(String? fcmToken) async {
    if (fcmToken != null) {
      await _secureStorage.write(key: 'fcm_token', value: fcmToken);
    }
  }

  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await _secureStorage.write(key: 'access_token', value: accessToken);
    await _secureStorage.write(key: 'refresh_token', value: refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await _secureStorage.read(key: 'access_token');
  }

  static Future<String?> getFCMToken() async {
    return await _secureStorage.read(key: 'fcm_token');
  }

  static Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: 'refresh_token');
  }

  static Future<void> deleteTokens() async {
    await _secureStorage.delete(key: 'access_token');
    await _secureStorage.delete(key: 'refresh_token');
  }
}
