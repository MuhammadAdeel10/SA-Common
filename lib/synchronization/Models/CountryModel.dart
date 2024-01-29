import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class CountryField {
  static final String id = 'id';
  static final String name = 'name';
  static final String isDefault = 'isDefault';
  static final String currencyId = 'currencyId';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
}

class CountryModel extends BaseModel<int> {
  @override
  int? id;
  String name;
  bool isDefault;
  int? currencyId;
  bool isSync;
  DateTime? syncDate;
  CountryModel({
    this.name = "",
    this.isDefault = false,
    this.currencyId,
    this.isSync = false,
    this.syncDate,
    this.id,
  });

  CountryModel copyWith({
    String? name,
    bool? isDefault,
    int? currencyId,
    bool? IsSync,
    DateTime? SyncDate,
  }) {
    return CountryModel(
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      currencyId: currencyId ?? this.currencyId,
      isSync: IsSync ?? this.isSync,
      syncDate: SyncDate ?? this.syncDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'isDefault': isDefault == true ? 1 : 0,
      'currencyId': currencyId,
      'IsSync': isSync == true ? 1 : 0,
      'SyncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      isDefault:
          (map['isDefault'] == 0 || map['isDefault'] == false) ? false : true,
      currencyId: map['currencyId']?.toInt(),
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['SyncDate'] != null ? DateTime.parse(map['SyncDate']) : null,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CountryModel.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'SynchronizationModel(name: $name, isDefault: $isDefault, currencyId: $currencyId, IsSync: $isSync, SyncDate: $syncDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryModel &&
        other.name == name &&
        other.isDefault == isDefault &&
        other.currencyId == currencyId &&
        other.isSync == isSync &&
        other.syncDate == syncDate;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        isDefault.hashCode ^
        currencyId.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode;
  }

  List<CountryModel> FromJson(String str, String slug) =>
      List<CountryModel>.from(
          json.decode(str).map((x) => CountryModel().fromJson(x, slug: slug)));

  String ToJson(List<CountryModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
