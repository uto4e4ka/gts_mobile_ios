import 'package:gts_mobile/dto/work.dart';

class TodayWorksResponse {
  final List<Work> works;

  TodayWorksResponse({required this.works});

  factory TodayWorksResponse.fromJson(Map<String, dynamic> json) {
    return TodayWorksResponse(
      works: (json['works'] as List).map((e) => Work.fromJson(e)).toList(),
    );
  }
}
