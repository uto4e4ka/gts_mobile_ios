class GtsObject {
  final int id;
  final String name;
  final int unvis;
  final String code1;

  GtsObject({
    required this.id,
    required this.name,
    required this.unvis,
    required this.code1,
  });

  factory GtsObject.fromJson(Map<String, dynamic> json) {
    return GtsObject(
      id: json['id'],
      name: json['name'],
      unvis: json['unvis'],
      code1: json['code1'],
    );
  }
}
