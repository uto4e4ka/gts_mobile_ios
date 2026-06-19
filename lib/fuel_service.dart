import 'dart:convert';
import 'package:gts_mobile/authService.dart';
import 'package:gts_mobile/dto/transport.dart';
import 'package:gts_mobile/dto/transport_trip.dart';
import 'package:gts_mobile/dto/work_object.dart';
import 'package:http/http.dart' as http;

// 🔑 Импортируем глобальный навигатор из вашего файла main.dart
import 'package:gts_mobile/main.dart';

import 'dto/appointed_object.dart';
import 'dto/price_work_response.dart';
import 'dto/today_work_response.dart';
import 'dto/work_add_response.dart';
import 'dto/work_category_response.dart';

class FuelService {
  static const String baseUrl = "http://147.45.157.246:8080";

  /// ===============================
  /// UNIVERSAL REQUEST WITH REFRESH
  /// ===============================
  Future<http.Response> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    String? token = await AuthService.getAccessToken();

    if (token == null) {
      // Если токена нет изначально — сразу отправляем на авторизацию
      _redirectToLogin();
      throw Exception("User not authorized");
    }

    final uri = Uri.parse("$baseUrl$path");

    http.Response response;

    Future<http.Response> send(String token) {
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      if (method == 'GET') {
        return http.get(uri, headers: headers);
      } else {
        return http.post(
          uri,
          headers: headers,
          body: body != null ? jsonEncode(body) : null,
        );
      }
    }

    response = await send(token);

    // 🔁 access token expired
    if (response.statusCode == 401) {
      token = await AuthService.refreshToken();

      // ❌ Сбой рефреша токена — выкидываем на логин
      if (token == null) {
        _redirectToLogin();
        throw Exception("Session expired");
      }

      response = await send(token);
    }

    return response;
  }

  /// Вспомогательный метод для очистки данных и редиректа
  void _redirectToLogin() {
    // 1. Очищаем сохраненную сессию, чтобы предотвратить бесконечные циклы запросов
    AuthService.logout();

    // 2. Сбрасываем стек навигации и открываем экран '/login' без возможности вернуться назад
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }

  /// ===============================
  /// API METHODS
  /// ===============================

  Future<List<WorkObj>> fetchObjects() async {
    final response = await _request('GET', '/work/history/today/objects');

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final List list = jsonMap['objects'];
      return list.map((e) => WorkObj.fromJson(e)).toList();
    }
    throw Exception(response.body);
  }

  Future<List<Transport>> fetchTransport() async {
    final response = await _request('GET', '/fuel/transport');
    print(response);
    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final List list = jsonMap['transports'];
      print("Транспорт: ");
      print(list);
      return list.map((e) => Transport.fromJson(e)).toList();
    }
    throw Exception(response.body);
  }

  Future<TransportTrip> getInserted(int ts, int objId) async {
    final response = await _request(
      'GET',
      '/fuel/insert/get?ts=$ts&objId=$objId',
    );
    print('/fuel/insert/get?ts=$ts&objId=$objId');
    if (response.statusCode == 200) {
      return TransportTrip.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<bool> insertFuel(
    double refuel,
    double distance,
    int ts_id,
    int obj_id,
    String route,
  ) async {
    final response = await _request(
      'POST',
      '/fuel/insert',
      body: {
        "refuel": refuel,
        "distance": distance,
        "ts_id": ts_id,
        "obj_id": obj_id,
        "route": route,
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      return true;
    }
    throw Exception(response.body);
  }
}
