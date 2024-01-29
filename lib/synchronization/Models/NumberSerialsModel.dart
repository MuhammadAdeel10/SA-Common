import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class NumberSerialsField {
  static final String id = 'id';
  static final String entityName = 'entityName';
  static final String isDefault = 'isDefault';
  static final String lastNumber = 'lastNumber';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String branchId = 'branchId';
  static final String series = 'series';
}

class NumberSerialsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  String entityName;
  String lastNumber;
  int? branchId;
  bool isDefault;
  bool isSync;
  DateTime? syncDate;
  String series;
  NumberSerialsModel({
    this.id,
    this.companySlug,
    this.entityName = "",
    this.lastNumber = "",
    this.branchId,
    this.isDefault = true,
    this.isSync = false,
    this.syncDate,
    this.series = "",
  });

  NumberSerialsModel copyWith({
    int? id,
    String? companySlug,
    String? entityName,
    String? lastNumber,
    int? branchId,
    bool? isDefault,
    bool? isSync,
    DateTime? syncDate,
    String? series,
  }) {
    return NumberSerialsModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      entityName: entityName ?? this.entityName,
      lastNumber: lastNumber ?? this.lastNumber,
      branchId: branchId ?? this.branchId,
      isDefault: isDefault ?? this.isDefault,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      series: series ?? this.series,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'entityName': entityName,
      'lastNumber': lastNumber,
      'branchId': branchId,
      'isDefault': isDefault == true ? 1 : 0,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'series': series,
    };
  }

  factory NumberSerialsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return NumberSerialsModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      entityName: map['entityName'] ?? '',
      lastNumber: map['lastNumber'] ?? '',
      branchId: map['branchId']?.toInt(),
      isDefault:
          (map['isDefault'] == 0 || map['isDefault'] == false) ? false : true,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null
          ? DateTime.parse(map['syncDate'])
          : DateTime.now(),
      series: map['series'] ?? '',
    );
  }

  @override
  String toString() {
    return 'NumberSerialsModel(id: $id, companySlug: $companySlug, entityName: $entityName, lastNumber: $lastNumber, branchId: $branchId, isDefault: $isDefault, isSync: $isSync, syncDate: $syncDate, series: $series)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NumberSerialsModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.entityName == entityName &&
        other.lastNumber == lastNumber &&
        other.branchId == branchId &&
        other.isDefault == isDefault &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.series == series;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        entityName.hashCode ^
        lastNumber.hashCode ^
        branchId.hashCode ^
        isDefault.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        series.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return NumberSerialsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<NumberSerialsModel> FromJson(String str, String slug) =>
      List<NumberSerialsModel>.from(json
          .decode(str)
          .map((x) => NumberSerialsModel().fromJson(x, slug: slug)));

  String ToJson(List<NumberSerialsModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
