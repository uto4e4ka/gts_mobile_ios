import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://147.45.157.246:8080/api/auth";

  /// LOGIN
  static Future<bool> login(String login, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/sign-in"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"login": login, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString("accessToken", data['accessToken']);
      await prefs.setString("refreshToken", data['refreshToken']);
      return true;
    }
    return false;
  }

  /// GET ACCESS TOKEN
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString("accessToken");

    if (access == null) return null;

    if (!_isTokenExpired(access)) {
      return access;
    }

    return await refreshToken();
  }

  /// REFRESH
  static Future<String?> refreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refresh = prefs.getString("refreshToken");
    if (refresh == null) return null;

    final res = await http.post(
      Uri.parse("$baseUrl/token-refresh"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"token": refresh}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      await prefs.setString("accessToken", data['token']);
      return data['accessToken'];
    }

    await logout();
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  /// JWT EXP CHECK
  static bool _isTokenExpired(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload = jsonDecode(
      utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
    );

    final exp = payload['exp'];
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }
}
