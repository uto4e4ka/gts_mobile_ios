import 'package:gts_mobile/dto/work_category.dart';

class WorkCategoryResponse {
  final List<WorkCategory> categories;

  WorkCategoryResponse({required this.categories});

  factory WorkCategoryResponse.fromJson(Map<String, dynamic> json) {
    return WorkCategoryResponse(
      categories: (json['categories'] as List)
          .map((e) => WorkCategory.fromJson(e))
          .toList(),
    );
  }
}
