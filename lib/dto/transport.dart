class Transport {
  final int id;
  final String name;
  final double cons;
  final double amort;
  final int? ownerId;
  final double balance;

  Transport({
    required this.id,
    required this.name,
    required this.cons,
    required this.amort,
    this.ownerId,
    required this.balance,
  });

  factory Transport.fromJson(Map<String, dynamic> json) {
    return Transport(
      id: json['id'],
      name: json['name'],
      cons: (json['cons'] as num).toDouble(),
      amort: (json['amort'] as num).toDouble(),
      ownerId: json['owner'] != null ? json['owner']['id'] : null,
      balance: (json['balance'] as num).toDouble(),
    );
  }
}
