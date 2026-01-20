import 'package:gts_mobile/dto/work_object.dart';

class WorkObjCalendar {
  final int id;
  final WorkObj workObj;
  final DateTime date;

  WorkObjCalendar({
    required this.id,
    required this.workObj,
    required this.date,
  });

  factory WorkObjCalendar.fromJson(Map<String, dynamic> json) {
    return WorkObjCalendar(
      id: json['id'],
      workObj: WorkObj.fromJson(json['workObj']),
      date: DateTime.parse(json['date']),
    );
  }
}
