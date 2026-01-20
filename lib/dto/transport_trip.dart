import 'transport.dart';
import 'work_object.dart';

class TransportTrip {
  final int id;
  final Transport transport;
  final int userId;
  final String route;
  final double refuel;
  final double distance;
  final double balance;
  final DateTime insertAt;
  final WorkObj workObj;
  final double amort;

  TransportTrip({
    required this.id,
    required this.transport,
    required this.userId,
    required this.route,
    required this.refuel,
    required this.distance,
    required this.balance,
    required this.insertAt,
    required this.workObj,
    required this.amort,
  });

  factory TransportTrip.fromJson(Map<String, dynamic> json) {
    return TransportTrip(
      id: json['id'],
      transport: Transport.fromJson(json['transport']),
      userId: json['user']['id'],
      route: json['route'] ?? '',
      refuel: (json['refuel'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      balance: (json['balance'] as num).toDouble(),
      insertAt: DateTime.parse(json['insertAt']),
      workObj: WorkObj.fromJson(json['workObj']),
      amort: (json['amort'] as num).toDouble(),
    );
  }
}
