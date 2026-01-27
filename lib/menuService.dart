import 'dart:convert';
import 'package:gts_mobile/authService.dart';
import 'package:gts_mobile/dto/over_get.dart';
import 'package:http/http.dart' as http;
import 'dto/fuel_balance.dart';
import 'dto/work_response.dart';
import 'dto/statistic.dart';

class MenuService {
  static const String baseUrl = "http://147.45.157.246:8080";

  /// UNIVERSAL GET WITH AUTO REFRESH
  Future<http.Response> _get(String path) async {
    String? token = await AuthService.getAccessToken();

    if (token == null) {
      throw Exception("Не авторизован");
    }

    http.Response response = await http.get(
      Uri.parse("$baseUrl$path"),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 401) {
      token = await AuthService.refreshToken();
      if (token == null) {
        throw Exception("Сессия истекла");
      }

      response = await http.get(
        Uri.parse("$baseUrl$path"),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    }

    return response;
  }

  /// FUEL
  Future<FuelResponse> fuelResponse() async {
    final response = await _get('/fuel/balance');

    if (response.statusCode == 200) {
      return FuelResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  /// WORK
  Future<WorkResponse> workResponse() async {
    final response = await _get('/work/objects/appointed/count');

    if (response.statusCode == 200) {
      return WorkResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  /// STATISTIC
  Future<StatisticResponse> fetchStatistics() async {
    final response = await _get('/work/statistic');

    if (response.statusCode == 200) {
      return StatisticResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }
}
