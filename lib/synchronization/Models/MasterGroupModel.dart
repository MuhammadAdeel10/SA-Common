import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class MasterGroupField {
  static final String id = 'id';
  static final String name = 'name';
  static final String isDefault = 'isDefault';
  static final String isActive = 'isActive';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
}

class MasterGroupModel extends BaseModel<int> {
  @override
  int? id;
  String name;
  bool isDefault;
  bool isActive;
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  MasterGroupModel({
    this.name = "",
    this.isDefault = false,
    this.isActive = true,
    this.companySlug = "",
    this.isSync = false,
    this.syncDate,
    this.id,
  });

  MasterGroupModel copyWith({
    int? id,
    String? name,
    bool? isDefault,
    bool? isActive,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
  }) {
    return MasterGroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault == true ? 1 : 0,
      'isActive': isActive == true ? 1 : 0,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory MasterGroupModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return MasterGroupModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      isDefault:
          (map['isDefault'] == 0 || map['isDefault'] == false) ? false : true,
      isActive:
          (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      companySlug: slug ?? '',
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return MasterGroupModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'MasterGroupModel(name: $name, isDefault: $isDefault, isActive: $isActive, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MasterGroupModel &&
        other.name == name &&
        other.isDefault == isDefault &&
        other.isActive == isActive &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        isDefault.hashCode ^
        isActive.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode;
  }

  List<MasterGroupModel> FromJson(String str, String slug) =>
      List<MasterGroupModel>.from(json
          .decode(str)
          .map((x) => MasterGroupModel().fromJson(x, slug: slug)));

  String ToJson(List<MasterGroupModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
