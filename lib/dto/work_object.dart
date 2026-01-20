import 'package:gts_mobile/dto/gts_object.dart';

class WorkObj {
  final int id;
  final GtsObject object;
  final int typeW;
  final int status;
  final DateTime? dat1;
  final String? comment;
  final DateTime? dat5;

  WorkObj({
    required this.id,
    required this.object,
    required this.typeW,
    required this.status,
    this.dat1,
    this.comment,
    this.dat5,
  });

  factory WorkObj.fromJson(Map<String, dynamic> json) {
    return WorkObj(
      id: json['id'],
      object: GtsObject.fromJson(json['object']),
      typeW: json['typeW'],
      status: json['status'],
      dat1: json['dat1'] != null ? DateTime.parse(json['dat1']) : null,
      comment: json['comment'],
      dat5: json['dat5'] != null ? DateTime.parse(json['dat5']) : null,
    );
  }
}
