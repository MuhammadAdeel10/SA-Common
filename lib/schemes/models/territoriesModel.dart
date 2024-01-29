import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class TerritoriesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String name = 'name';
  static final String regionId = 'regionId';
  static final String zoneId = 'zoneId';
}

class TerritoriesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  String? name;
  int? regionId;
  int? zoneId;
  TerritoriesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.updatedOn,
    this.name,
    this.regionId,
    this.zoneId,
  });

  TerritoriesModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    DateTime? updatedOn,
    String? name,
    int? regionId,
    int? zoneId,
  }) {
    return TerritoriesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      updatedOn: updatedOn ?? this.updatedOn,
      name: name ?? this.name,
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
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
    };
  }

  factory TerritoriesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return TerritoriesModel(
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
    );
  }

  @override
  String toString() {
    return 'TerritoriesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, updatedOn: $updatedOn, name: $name, regionId: $regionId, zoneId: $zoneId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TerritoriesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.updatedOn == updatedOn &&
        other.name == name &&
        other.regionId == regionId &&
        other.zoneId == zoneId;
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
        zoneId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return TerritoriesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<TerritoriesModel> FromJson(String str, String slug) =>
      List<TerritoriesModel>.from(json
          .decode(str)
          .map((x) => TerritoriesModel().fromJson(x, slug: slug)));

  String ToJson(List<TerritoriesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
