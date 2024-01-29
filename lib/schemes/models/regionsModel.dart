import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class RegionsField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String name = 'name';
}

class RegionsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  String? name;
  RegionsModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.updatedOn,
    this.name,
  });

  RegionsModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    DateTime? updatedOn,
    String? name,
  }) {
    return RegionsModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      updatedOn: updatedOn ?? this.updatedOn,
      name: name ?? this.name,
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
    };
  }

  factory RegionsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return RegionsModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      name: map['name'],
    );
  }

  @override
  String toString() {
    return 'RegionsModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, updatedOn: $updatedOn, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RegionsModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.updatedOn == updatedOn &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        updatedOn.hashCode ^
        name.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return RegionsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<RegionsModel> FromJson(String str, String slug) =>
      List<RegionsModel>.from(
          json.decode(str).map((x) => RegionsModel().fromJson(x, slug: slug)));

  String ToJson(List<RegionsModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
