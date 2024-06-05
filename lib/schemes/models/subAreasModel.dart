import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SubAreasField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String name = 'name';
  static final String regionId = 'regionId';
  static final String territoryId = 'territoryId';
  static final String zoneId = 'zoneId';
  static final String areaId = 'areaId';
  static final String branchId = 'branchId';
}

class SubAreasModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  String name;
  int? regionId;
  int? zoneId;
  int? territoryId;
  int? areaId;
  int? branchId;
  SubAreasModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.updatedOn,
    this.name = "",
    this.regionId,
    this.zoneId,
    this.territoryId,
    this.areaId,
    this.branchId,
  });

  SubAreasModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    DateTime? updatedOn,
    String? name,
    int? regionId,
    int? zoneId,
    int? territoryId,
    int? areaId,
    int? branchId,
  }) {
    return SubAreasModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      updatedOn: updatedOn ?? this.updatedOn,
      name: name ?? this.name,
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
      territoryId: territoryId ?? this.territoryId,
      areaId: areaId ?? this.areaId,
      branchId: branchId ?? this.branchId,
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
      'name': name,
      'regionId': regionId,
      'zoneId': zoneId,
      'territoryId': territoryId,
      'areaId': areaId,
      'branchId': branchId,
    };
  }

  factory SubAreasModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SubAreasModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      name: map['name'],
      regionId: map['regionId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
      territoryId: map['territoryId']?.toInt(),
      areaId: map['areaId']?.toInt(),
      branchId: map['branchId']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'SubAreasModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, updatedOn: $updatedOn, name: $name, regionId: $regionId, zoneId: $zoneId, territoryId: $territoryId, areaId: $areaId, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubAreasModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.updatedOn == updatedOn &&
        other.name == name &&
        other.regionId == regionId &&
        other.zoneId == zoneId &&
        other.territoryId == territoryId &&
        other.areaId == areaId &&
        other.branchId == branchId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        updatedOn.hashCode ^
        name.hashCode ^
        regionId.hashCode ^
        zoneId.hashCode ^
        territoryId.hashCode ^
        areaId.hashCode ^
        branchId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SubAreasModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SubAreasModel> FromJson(String str, String slug) =>
      List<SubAreasModel>.from(
          json.decode(str).map((x) => SubAreasModel().fromJson(x, slug: slug)));

  String ToJson(List<SubAreasModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
