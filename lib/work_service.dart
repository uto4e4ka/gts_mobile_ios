import 'dart:convert';
import 'package:gts_mobile/authService.dart';
import 'package:gts_mobile/dto/history_details.dart';
import 'package:gts_mobile/dto/history_model.dart';
import 'package:http/http.dart' as http;

import 'dto/appointed_object.dart';
import 'dto/price_work_response.dart';
import 'dto/today_work_response.dart';
import 'dto/work_add_response.dart';
import 'dto/work_category_response.dart';

class WorkService {
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
      if (token == null) {
        throw Exception("Session expired");
      }
      response = await send(token);
    }

    return response;
  }

  /// ===============================
  /// API METHODS
  /// ===============================

  Future<List<AppointedObject>> fetchAppointedObjects() async {
    final response = await _request(
      'GET',
      '/work/objects/appointed?category=1',
    );

    if (response.statusCode == 200) {
      final jsonMap = jsonDecode(response.body);
      final List list = jsonMap['objects'];
      return list.map((e) => AppointedObject.fromJson(e)).toList();
    }
    throw Exception(response.body);
  }

  Future<PriceWorksResponse> fetchPriceWork(int category) async {
    final response = await _request('GET', '/work/priceWork/get?id=$category');

    if (response.statusCode == 200) {
      return PriceWorksResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<TodayWorksResponse> fetchWork(int obj, int category) async {
    final response = await _request(
      'GET',
      '/work/get?obj=$obj&category=$category',
    );

    if (response.statusCode == 200) {
      return TodayWorksResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<WorkCategoryResponse> fetchCategoryWork(int category) async {
    final response = await _request(
      'GET',
      '/work/categories/priceWork?id=$category',
    );

    if (response.statusCode == 200) {
      return WorkCategoryResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<WorkAddResponse> addWork(
    int category,
    int obj,
    int number,
    int workId,
    int k,
  ) async {
    final response = await _request(
      'POST',
      '/work/add',
      body: {
        "categoryWork": category,
        "obj": obj,
        "num": number,
        "priceWork": workId,
        "k": k,
      },
    );

    if (response.statusCode == 200) {
      return WorkAddResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<WorkAddResponse> subWork(
    int category,
    int obj,
    int number,
    int workId,
    int k,
  ) async {
    final response = await _request(
      'POST',
      '/work/subtract',
      body: {
        "categoryWork": category,
        "obj": obj,
        "num": number,
        "priceWork": workId,
        "k": k,
      },
    );

    if (response.statusCode == 200) {
      return WorkAddResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<WorkAddResponse> setWork(
    int category,
    int obj,
    int number,
    int workId,
    int k,
  ) async {
    final response = await _request(
      'POST',
      '/work/set',
      body: {
        "categoryWork": category,
        "obj": obj,
        "num": number,
        "priceWork": workId,
        "k": k,
      },
    );

    if (response.statusCode == 200) {
      return WorkAddResponse.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<HistoryModel> fetchHistory(String period) async {
    final response = await _request('GET', '/work/history/$period');

    if (response.statusCode == 200) {
      return HistoryModel.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }

  Future<HistoryDetails> fetchHistoryDetils(String date, int obj) async {
    final response = await _request(
      'GET',
      '/work/history/get?date=$date&obj=$obj',
    );

    if (response.statusCode == 200) {
      return HistoryDetails.fromJson(jsonDecode(response.body));
    }
    throw Exception(response.body);
  }
}
