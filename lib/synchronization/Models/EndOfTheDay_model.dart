import 'dart:convert';

import '../../Controller/BaseRepository.dart';
import '../../utils/Helper.dart';

class EndOfTheDayFields {
  static final String id = 'id';
  static final String branchId = 'branchId';
  static final String companySlug = 'companySlug';
  static final String endOfDayDate = 'endOfDayDate';
}

class EndOfTheDayModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  DateTime? endOfDayDate;
  int? branchId;
  EndOfTheDayModel({
    this.id,
    this.companySlug,
    this.endOfDayDate,
    this.branchId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'endOfDayDate': endOfDayDate?.toIso8601String(),
      'branchId': branchId,
    };
  }

  factory EndOfTheDayModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return EndOfTheDayModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      endOfDayDate: map['endOfDayDate'] != null ? DateTime.parse(map['endOfDayDate']) : Helper.OnlyDateToday(),
      branchId: map['branchId']?.toInt(),
    );
  }

  factory EndOfTheDayModel.fromJson(String source) => EndOfTheDayModel.fromMap(json.decode(source));

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return EndOfTheDayModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<EndOfTheDayModel> FromJson(String str, String slug) => List<EndOfTheDayModel>.from(json.decode(str).map((x) => EndOfTheDayModel().fromJson(x, slug: slug)));

  String ToJson(List<EndOfTheDayModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
