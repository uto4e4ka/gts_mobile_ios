class WorkCategory {
  final int id;
  final String name;

  WorkCategory({required this.id, required this.name});

  factory WorkCategory.fromJson(Map<String, dynamic> json) {
    return WorkCategory(id: json['id'], name: json['name']);
  }
}
