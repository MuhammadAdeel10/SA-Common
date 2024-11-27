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
  static final String tripId = 'tripId';
  static final String heading = 'heading';
  static final String speed = 'speed';
  static final String altitudeAccuracy = 'altitudeAccuracy';
  static final String longitude = 'longitude';
  static final String latitude = 'latitude';
  static final String isIdle = 'isIdle';
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
  int? tripId;
  double heading;
  double speed;
  double altitudeAccuracy;
  double longitude;
  double latitude;
  bool isSync;
  DateTime? syncDate;
  bool isIdle;
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
    this.tripId,
    this.altitudeAccuracy = 0,
    this.longitude = 0,
    this.latitude = 0,
    this.isSync = false,
    this.syncDate,
    this.isIdle = false,
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
      'tripId': tripId,
      'speed': speed,
      'altitudeAccuracy': altitudeAccuracy,
      'longitude': longitude,
      'latitude': latitude,
      'isSync': isSync == true ? 1 : 0,
      'isIdle': isIdle == true ? 1 : 0,
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
      altitude: double.parse(map['altitude'].toString()),
      heading: double.parse(map['heading'].toString()),
      speed: double.parse(map['speed'].toString()),
      tripId: map['tripId'] != null ? map['tripId'] as int : null,
      altitudeAccuracy: double.parse(map['altitudeAccuracy'].toString()),
      longitude: double.parse(map['longitude'].toString()),
      latitude: double.parse(map['latitude'].toString()),
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      isIdle: (map['isIdle'] == 0 || map['isIdle'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
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
