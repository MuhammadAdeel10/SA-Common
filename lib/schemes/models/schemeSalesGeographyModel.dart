import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class SalesGeographySchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String schemeId = 'schemeId';
  static final String regionId = 'regionId';
  static final String zoneId = 'zoneId';
  static final String territoryId = 'territoryId';
  static final String areaId = 'areaId';
  static final String subAreaId = 'subAreaId';
}

class SalesGeographySchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  int? schemeId;
  int? regionId;
  int? zoneId;
  int? territoryId;
  int? areaId;
  int? subAreaId;
  SalesGeographySchemesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.updatedOn,
    this.schemeId,
    this.regionId,
    this.zoneId,
    this.territoryId,
    this.areaId,
    this.subAreaId,
  });

  SalesGeographySchemesModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    DateTime? updatedOn,
    int? schemeId,
    int? regionId,
    int? zoneId,
    int? territoryId,
    int? areaId,
    int? subAreaId,
  }) {
    return SalesGeographySchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      updatedOn: updatedOn ?? this.updatedOn,
      schemeId: schemeId ?? this.schemeId,
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
      territoryId: territoryId ?? this.territoryId,
      areaId: areaId ?? this.areaId,
      subAreaId: subAreaId ?? this.subAreaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updatedOn': updatedOn?.toIso8601String(),
      'schemeId': schemeId,
      'regionId': regionId,
      'zoneId': zoneId,
      'territoryId': territoryId,
      'areaId': areaId,
      'subAreaId': subAreaId,
    };
  }

  factory SalesGeographySchemesModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return SalesGeographySchemesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      schemeId: map['schemeId']?.toInt(),
      regionId: map['regionId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
      territoryId: map['territoryId']?.toInt(),
      areaId: map['areaId']?.toInt(),
      subAreaId: map['subAreaId']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'SalesGeographySchemesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, updatedOn: $updatedOn, schemeId: $schemeId, regionId: $regionId, zoneId: $zoneId, territoryId: $territoryId, areaId: $areaId, subAreaId: $subAreaId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SalesGeographySchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.updatedOn == updatedOn &&
        other.schemeId == schemeId &&
        other.regionId == regionId &&
        other.zoneId == zoneId &&
        other.territoryId == territoryId &&
        other.areaId == areaId &&
        other.subAreaId == subAreaId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        updatedOn.hashCode ^
        schemeId.hashCode ^
        regionId.hashCode ^
        zoneId.hashCode ^
        territoryId.hashCode ^
        areaId.hashCode ^
        subAreaId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalesGeographySchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalesGeographySchemesModel> FromJson(String str, String slug) =>
      List<SalesGeographySchemesModel>.from(json
          .decode(str)
          .map((x) => SalesGeographySchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<SalesGeographySchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
