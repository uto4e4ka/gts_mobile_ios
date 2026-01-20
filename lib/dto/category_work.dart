class CategoryWork {
  final int id;
  final String name;
  final String defObj;
  final int defCat;

  CategoryWork({
    required this.id,
    required this.name,
    required this.defObj,
    required this.defCat,
  });

  factory CategoryWork.fromJson(Map<String, dynamic> json) {
    return CategoryWork(
      id: json['id'],
      name: json['name'],
      defObj: json['defObj'],
      defCat: json['defCat'],
    );
  }
}
