import 'package:gts_mobile/dto/category_work.dart';
import 'package:gts_mobile/dto/gts_object.dart';
import 'package:gts_mobile/dto/price_work.dart';
import 'package:gts_mobile/dto/user.dart';

class Work {
  final int id;
  final User user;
  final PriceWork priceWork;
  final DateTime date;
  final double nums;
  final GtsObject obj;
  final CategoryWork categoryWork;
  final int k;
  final double hover;
  final double rover;

  Work({
    required this.id,
    required this.user,
    required this.priceWork,
    required this.date,
    required this.nums,
    required this.obj,
    required this.categoryWork,
    required this.k,
    required this.hover,
    required this.rover,
  });

  factory Work.fromJson(Map<String, dynamic> json) {
    return Work(
      id: json['id'],
      user: User.fromJson(json['user']),
      priceWork: PriceWork.fromJson(json['priceWork']),
      date: DateTime.parse(json['date']),
      nums: (json['num'] as num).toDouble(),
      obj: GtsObject.fromJson(json['obj']),
      categoryWork: CategoryWork.fromJson(json['categoryWork']),
      k: json['k'],
      hover: (json['hover'] as num).toDouble(),
      rover: (json['rover'] as num).toDouble(),
    );
  }
}
