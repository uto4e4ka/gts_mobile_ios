class WorkAddResponse {
  final double nums;

  WorkAddResponse({required this.nums});

  factory WorkAddResponse.fromJson(Map<String, dynamic> json) {
    return WorkAddResponse(nums: (json['num'] as num).toDouble());
  }
}
