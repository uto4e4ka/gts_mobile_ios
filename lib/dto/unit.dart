class Unit {
  final int id;
  final String name;
  final String meas;

  Unit({required this.id, required this.name, required this.meas});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(id: json['id'], name: json['name'], meas: json['meas']);
  }
}
