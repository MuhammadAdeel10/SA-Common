import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class VisitsModelField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String branchId = 'branchId';
  static final String customerId = 'customerId';
  static final String salesPersonId  = 'salesPersonId';
  static final String visitDateTime = 'visitDateTime';
  static final String latitude = 'latitude';
  static final String longitude = 'longitude';
  static final String visitOutcome = 'visitOutcome';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
}

class VisitsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? branchId;
  int? customerId;
  int? salesPersonId;
  DateTime? visitDateTime;
  int? visitOutcome;
  double? latitude;
  double? longitude;
  bool isSync;
  DateTime? syncDate;
  int? tempId;

  VisitsModel({this.id, this.companySlug = "", this.customerId, this.visitDateTime, this.salesPersonId,this.latitude, this.longitude, this.visitOutcome, this.isSync = false, this.syncDate,  this.branchId, this.tempId});
  Map<String, dynamic> toMap({bool isTempId = false}) {
    return <String, dynamic>{
      'id': id,
      'companySlug': companySlug,
      'customerId': customerId,
      'visitDateTime': visitDateTime?.toIso8601String(),
      'visitOutcome': visitOutcome,
      'salesPersonId': salesPersonId,
      'latitude': latitude,
      'longitude': longitude,
      'isSync': isSync == false ? 0 : 1,
      'syncDate': syncDate?.toIso8601String(),
      'branchId': branchId,
      if(isTempId)
      'tempId': tempId,
    };
  }

  factory VisitsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return VisitsModel(
      id: map['id'] != null ? map['id'] as int : null,
      companySlug: map['companySlug'] ?? slug,
      latitude: double.parse(map['latitude'].toString()),
      longitude: double.parse(map['longitude'].toString()),
      customerId: map['customerId'] != null ? map['customerId'] as int : null,
      salesPersonId: map['salesPersonId'] != null ? map['salesPersonId'] as int : null,
      visitDateTime: map['visitDateTime'] != null ? DateTime.parse(map['visitDateTime']) : null,
      branchId: map['branchId']?.toInt(),
      visitOutcome: map['visitOutcome'] ?? null ,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      tempId: map['tempId'] != null ? map['tempId'] as int : null,
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return VisitsModel.fromMap(json, slug: slug);
  }
factory VisitsModel.fromJson(String source) => VisitsModel.fromMap(json.decode(source));

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

}
