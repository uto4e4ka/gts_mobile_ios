import 'package:gts_mobile/dto/work.dart';

class HistoryDetails {
  final double rover;
  final double hover;
  final double total;
  final int compare;
  final int k;
  final double kValue;
  final List<Work> works;

  HistoryDetails({
    required this.rover,
    required this.hover,
    required this.total,
    required this.compare,
    required this.k,
    required this.kValue,
    required this.works,
  });

  factory HistoryDetails.fromJson(Map<String, dynamic> json) {
    return HistoryDetails(
      rover: (json['rover'] ?? 0).toDouble(),
      hover: (json['hover'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      compare: json['compare'],
      k: json['k'],
      kValue: (json['k_value'] ?? 0).toDouble(),
      works: (json['works'] as List).map((e) => Work.fromJson(e)).toList(),
    );
  }
}
