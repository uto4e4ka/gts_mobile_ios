import 'package:gts_mobile/dto/category_work.dart';
import 'package:gts_mobile/dto/unit.dart';
import 'package:gts_mobile/dto/user.dart';

class PriceWorksResponse {
  final List<PriceWork> priceWorks;

  PriceWorksResponse({required this.priceWorks});

  factory PriceWorksResponse.fromJson(Map<String, dynamic> json) {
    return PriceWorksResponse(
      priceWorks: (json['priceWorks'] as List)
          .map((e) => PriceWork.fromJson(e))
          .toList(),
    );
  }
}

class PriceWork {
  final int id;
  final String name;
  final double price;
  final User user;
  final int nums;
  final Unit unit;
  final CategoryWork? categoryWork;
  final CategoryPriceWork categoryPriceWork;
  final int unvis;

  PriceWork({
    required this.id,
    required this.name,
    required this.price,
    required this.user,
    required this.nums,
    required this.unit,
    this.categoryWork,
    required this.categoryPriceWork,
    required this.unvis,
  });

  factory PriceWork.fromJson(Map<String, dynamic> json) {
    return PriceWork(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      user: User.fromJson(json['user']),
      nums: json['num'],
      unit: Unit.fromJson(json['unit']),
      categoryWork: json['categoryWork'] != null
          ? CategoryWork.fromJson(json['categoryWork'])
          : null,
      categoryPriceWork: CategoryPriceWork.fromJson(json['categoryPriceWork']),
      unvis: json['unvis'],
    );
  }
}

class CategoryPriceWork {
  final int id;
  final String name;

  CategoryPriceWork({required this.id, required this.name});

  factory CategoryPriceWork.fromJson(Map<String, dynamic> json) {
    return CategoryPriceWork(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
