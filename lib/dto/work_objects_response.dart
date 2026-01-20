import 'package:gts_mobile/dto/work_object.dart';

class WorkObjResponse {
  final List<WorkObj> objects;

  WorkObjResponse({required this.objects});

  factory WorkObjResponse.fromJson(Map<String, dynamic> json) {
    return WorkObjResponse(
      objects: (json['objects'] as List)
          .map((e) => WorkObj.fromJson(e))
          .toList(),
    );
  }
}
