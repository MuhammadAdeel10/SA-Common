import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class DiscountField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String name = 'name';
  static final String abbreviation = 'abbreviation';
  static final String isDefault = 'isDefault';
  static final String syncDate = 'syncDate';
  static final String isSync = 'isSync';
}

class DiscountModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  String name;
  String abbreviation;
  bool isDefault;
  DateTime? syncDate;
  bool isSync;
  DiscountModel({
    this.id,
    this.companySlug,
    this.name = "",
    this.abbreviation = "",
    this.isDefault = false,
    this.syncDate,
    this.isSync = false,
  });

  DiscountModel copyWith({
    int? id,
    String? companySlug,
    String? name,
    String? abbreviation,
    bool? isDefault,
    DateTime? syncDate,
    bool? isSync,
  }) {
    return DiscountModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      isDefault: isDefault ?? this.isDefault,
      syncDate: syncDate ?? this.syncDate,
      isSync: isSync ?? this.isSync,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'name': name,
      'abbreviation': abbreviation,
      'isDefault': isDefault == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'isSync': isSync == true ? 1 : 0,
    };
  }

  factory DiscountModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return DiscountModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      name: map['name'] ?? '',
      abbreviation: map['abbreviation'] ?? '',
      isDefault:
          (map['isDefault'] == 0 || map['isDefault'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return DiscountModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'DiscountModel(id: $id, companySlug: $companySlug, name: $name, abbreviation: $abbreviation, isDefault: $isDefault, syncDate: $syncDate, isSync: $isSync)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiscountModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.name == name &&
        other.abbreviation == abbreviation &&
        other.isDefault == isDefault &&
        other.syncDate == syncDate &&
        other.isSync == isSync;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        name.hashCode ^
        abbreviation.hashCode ^
        isDefault.hashCode ^
        syncDate.hashCode ^
        isSync.hashCode;
  }

  List<DiscountModel> FromJson(String str, String slug) =>
      List<DiscountModel>.from(
          json.decode(str).map((x) => DiscountModel().fromJson(x, slug: slug)));

  String ToJson(List<DiscountModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
