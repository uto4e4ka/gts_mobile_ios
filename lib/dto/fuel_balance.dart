class FuelResponse {
  final double count;

  FuelResponse({required this.count});

  factory FuelResponse.fromJson(Map<String, dynamic> json) {
    return FuelResponse(count: (json['balance'] as num).toDouble());
  }
}
