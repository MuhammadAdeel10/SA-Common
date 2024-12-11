import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';

class TripFiles {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String branchId = 'branchId';
  static final String tripId = 'tripId';
  static final String isSync = 'isSync';
  static final String isNew = 'isNew';
  static final String isEdit = 'isEdit';
  static final String syncDate = 'syncDate';
  static final String applicationUserId = 'applicationUserId';
  static final String startDate = 'startDate';
  static final String endDate = 'endDate';
  static final String travelStatus = 'travelStatus';
  static final String updatedOn = 'updatedOn';
}

class TripModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? branchId;
  int? tripId;
  String? applicationUserId;
  DateTime? startDate;
  DateTime? endDate;
  bool isSync;
  bool isNew;
  bool isEdit;
  DateTime? syncDate;
  TravelStatus? travelStatus;
  String? updatedOn;

  TripModel({
    this.id,
    this.companySlug,
    this.branchId,
    this.tripId,
    this.applicationUserId,
    this.isSync = false,
    this.isNew = false,
    this.isEdit = false,
    this.syncDate,
    this.endDate,
    this.startDate,
    this.travelStatus,
    this.updatedOn,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'companySlug': companySlug,
      'branchId': branchId,
      'applicationUserId': applicationUserId,
      'tripId': tripId,
      'syncDate': syncDate?.toIso8601String(),
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'travelStatus': travelStatus?.value,
      'isSync': isSync == false ? 0 : 1,
      'isNew': isNew == false ? 0 : 1,
      'isEdit': isEdit == false ? 0 : 1,
      'updatedOn': updatedOn,
    };
  }

  factory TripModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return TripModel(
      id: map['id'] != null ? map['id'] as int : null,
      companySlug: slug ?? map['companySlug'],
      branchId: map['branchId'] != null ? map['branchId'] as int : null,
      tripId: map['tripId'] != null ? map['tripId'] as int : null,
      applicationUserId: map['applicationUserId'] != null ? map['applicationUserId'] as String : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      isNew: (map['isNew'] == 0 || map['isNew'] == false || map['isNew'] == null) ? false : true,
      isEdit: (map['isEdit'] == 0 || map['isEdit'] == false || map['isEdit'] == null) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      travelStatus: map['travelStatus'] == null ? null : intoTravelStatus(map['travelStatus']),
      updatedOn: map['updatedOn'] != null ? map['updatedOn'] as String : null,
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
