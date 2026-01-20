class StatisticResponse {
  final double monthTip;
  final double dayTip;
  final double avgTip;
  final double maxDay;

  StatisticResponse({
    required this.monthTip,
    required this.dayTip,
    required this.avgTip,
    required this.maxDay,
  });

  factory StatisticResponse.fromJson(Map<String, dynamic> json) {
    return StatisticResponse(
      monthTip: (json['month_tip'] as num).toDouble(),
      dayTip: (json['day_tip'] as num).toDouble(),
      avgTip: (json['avg_tip'] as num).toDouble(),
      maxDay: (json['max_day'] as num).toDouble(),
    );
  }
}
