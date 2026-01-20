class WorkResponse {
  final int count;

  WorkResponse({required this.count});

  factory WorkResponse.fromJson(Map<String, dynamic> json) {
    return WorkResponse(count: (json['count'] as num).toInt());
  }
}
