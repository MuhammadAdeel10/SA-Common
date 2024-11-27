import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';

class TripFiles {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String branchId = 'branchId';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String applicationUserId = 'applicationUserId';
  static final String startTime = 'startTime';
  static final String endTime = 'endTime';
  static final String tripType = 'tripType';
}

class TripModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? branchId;
  String? applicationUserId;
  DateTime? startTime;
  DateTime? endTime;
  bool isSync;
  DateTime? syncDate;
  TripType? tripType;

  TripModel({
    this.id,
    this.companySlug,
    this.branchId,
    this.applicationUserId,
    this.isSync = false,
    this.syncDate,
    this.endTime,
    this.startTime,
    this.tripType,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companySlug': companySlug,
      'branchId': branchId,
      'applicationUserId': applicationUserId,
      'syncDate': syncDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'tripType': tripType?.value,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return TripModel(
      id: map['id'] != null ? map['id'] as int : null,
      companySlug: slug ?? map['companySlug'],
      branchId: map['branchId'] != null ? map['branchId'] as int : null,
      applicationUserId: map['applicationUserId'] != null ? map['applicationUserId'] as String : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      tripType: map['tripType'] == null ? null : intoTripType(map['tripType']),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return TripModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<TripModel> FromJson(String str, String slug) => List<TripModel>.from(json.decode(str).map((x) => TripModel().fromJson(x, slug: slug)));

  String ToJson({required List<TripModel> data}) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
