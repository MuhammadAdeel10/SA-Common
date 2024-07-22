// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
class TravelLogFiles {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String branchId = 'branchId';
  static final String applicationUserId = 'applicationUserId';
  static final String serverDateTime = 'serverDateTime';
  static final String locationDateTime = 'locationDateTime';
  static final String altitude = 'altitude';
  static final String heading = 'heading';
  static final String speed = 'speed';
  static final String altitudeAccuracy = 'altitudeAccuracy';
  static final String longitude = 'longitude';
  static final String latitude = 'latitude';
  }
class TravelLogModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? branchId;
  String? applicationUserId;
  DateTime? serverDateTime;
  DateTime? locationDateTime;
  double altitude;
  double heading;
  double speed;
  double altitudeAccuracy;
  double longitude;
  double latitude;
  bool isSync;
  DateTime? syncDate;
  TravelLogModel({
    this.id,
    this.companySlug,
    this.branchId,
    this.applicationUserId,
    this.serverDateTime,
    this.locationDateTime,
    this.altitude = 0,
    this.heading = 0,
    this.speed = 0,
    this.altitudeAccuracy = 0,
    this.longitude = 0,
    this.latitude = 0,
     this.isSync = false,
    this.syncDate,
  });

  Map<String, dynamic> toMap() { 
    return <String, dynamic>{
      'id': id,
      'companySlug': companySlug,
      'branchId': branchId,
      'applicationUserId': applicationUserId,
      'serverDateTime': serverDateTime?.toIso8601String(),
      'locationDateTime': locationDateTime?.toIso8601String(),
      'altitude': altitude,
      'heading': heading,
      'speed': speed,
      'altitudeAccuracy': altitudeAccuracy,
      'longitude': longitude,
      'latitude': latitude,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
    };
  }

  factory TravelLogModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return TravelLogModel(
      id: map['id'] != null ? map['id'] as int : null,
      companySlug: slug ?? map['companySlug'],
      branchId: map['branchId'] != null ? map['branchId'] as int : null,
      applicationUserId: map['applicationUserId'] != null ? map['applicationUserId'] as String : null,
      serverDateTime: map['serverDateTime'] != null ? DateTime.parse(map['serverDateTime']) : null,
      locationDateTime: map['locationDateTime'] != null ? DateTime.parse(map['locationDateTime']) : null,
      altitude: map['altitude'] as double,
      heading: map['heading'] as double,
      speed: map['speed'] as double,
      altitudeAccuracy: map['altitudeAccuracy'] as double,
      longitude: map['longitude'] as double,
      latitude: map['latitude'] as double,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate'] ) : null,
    );
  }

 @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return TravelLogModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
    
  }

  List<TravelLogModel> FromJson(String str, String slug) => List<TravelLogModel>.from(json.decode(str).map((x) => TravelLogModel().fromJson(x, slug: slug)));

  String ToJson({required List<TravelLogModel> data}) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
 
}

