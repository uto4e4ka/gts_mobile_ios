import 'package:gts_mobile/dto/work_obj_calendar.dart';

class AppointedObject {
  final WorkObjCalendar object;
  final int daysRemaining;
  final bool alreadyInsert;

  AppointedObject({
    required this.object,
    required this.daysRemaining,
    required this.alreadyInsert,
  });

  factory AppointedObject.fromJson(Map<String, dynamic> json) {
    return AppointedObject(
      object: WorkObjCalendar.fromJson(json['object']),
      daysRemaining: json['daysRemaining'],
      alreadyInsert: json['alreadyInsert'],
    );
  }
}
