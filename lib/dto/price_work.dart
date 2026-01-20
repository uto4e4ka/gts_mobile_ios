import 'package:gts_mobile/dto/category_work.dart';
import 'package:gts_mobile/dto/unit.dart';

class PriceWork {
  final int id;
  final String name;
  final double price;
  final int nums;
  final Unit unit;
  final CategoryWork categoryWork;

  PriceWork({
    required this.id,
    required this.name,
    required this.price,
    required this.nums,
    required this.unit,
    required this.categoryWork,
  });

  factory PriceWork.fromJson(Map<String, dynamic> json) {
    return PriceWork(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      nums: json['num'],
      unit: Unit.fromJson(json['unit']),
      categoryWork: CategoryWork.fromJson(json['categoryWork']),
    );
  }
}
