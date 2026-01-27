class OverModel {
  final String? comment;
  final double over;
  final int k;

  OverModel({this.comment, required this.over, required this.k});

  factory OverModel.fromJson(Map<String, dynamic> json) {
    return OverModel(
      comment: json['comment'],
      over: (json['over'] as num).toDouble(),
      k: json['k'] as int,
    );
  }
}
