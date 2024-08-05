import 'dart:convert';
import '../../SalesPerson/model/SalesPersonModel.dart';
import '../../Controller/BaseRepository.dart';

class CustomerCategoryFields {
  static final String id = 'id';
  static final String contactType = 'contactType';
  static final String name = 'name';
  static final String companySlug = 'companySlug';
  static final String sequenceName = 'sequenceName';
  static final String syncDate = 'syncDate';
  static final String isSync = 'isSync';
}

class CustomerCategoryModel extends BaseModel<int> with DropDown {
  @override
  int? id;
  int contactType;
  String name;
  String? companySlug;
  String sequenceName;
  DateTime? syncDate;
  bool isSync;
  CustomerCategoryModel({
    this.id,
    this.contactType = 0,
    this.name = "",
    this.companySlug = "",
    this.sequenceName = "",
    this.syncDate,
    this.isSync = false,
  });

  CustomerCategoryModel copyWith({
    int? id,
    int? contactType,
    String? name,
    String? companySlug,
    String? sequenceName,
    DateTime? syncDate,
    bool? isSync,
  }) {
    return CustomerCategoryModel(
      id: id ?? this.id,
      contactType: contactType ?? this.contactType,
      name: name ?? this.name,
      companySlug: companySlug ?? this.companySlug,
      sequenceName: sequenceName ?? this.sequenceName,
      syncDate: syncDate ?? this.syncDate,
      isSync: isSync ?? this.isSync,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contactType': contactType,
      'name': name,
      'companySlug': companySlug,
      'sequenceName': sequenceName,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'isSync': isSync == true ? 1 : 0,
    };
  }

  factory CustomerCategoryModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return CustomerCategoryModel(
      id: map['id']?.toInt(),
      contactType: map['contactType']?.toInt() ?? 0,
      name: map['name'] ?? '',
      companySlug: slug ?? '',
      sequenceName: map['sequenceName'] ?? '',
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CustomerCategoryModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CustomerCategoryModel(id: $id, contactType: $contactType, name: $name, companyId: $companySlug, sequenceName: $sequenceName, syncDate: $syncDate, isSync: $isSync)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerCategoryModel &&
        other.id == id &&
        other.contactType == contactType &&
        other.name == name &&
        other.companySlug == companySlug &&
        other.sequenceName == sequenceName &&
        other.syncDate == syncDate &&
        other.isSync == isSync;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        contactType.hashCode ^
        name.hashCode ^
        companySlug.hashCode ^
        sequenceName.hashCode ^
        syncDate.hashCode ^
        isSync.hashCode;
  }

  List<CustomerCategoryModel> FromJson(String str, String slug) =>
      List<CustomerCategoryModel>.from(json
          .decode(str)
          .map((x) => CustomerCategoryModel().fromJson(x, slug: slug)));

  String ToJson(List<CustomerCategoryModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
