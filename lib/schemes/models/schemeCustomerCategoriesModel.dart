// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class CustomerCategoriesSchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String schemeId = 'schemeId';
  static final String customerCategoryId = 'customerCategoryId';
  static final String updatedOn = 'updatedOn';
}

class CustomerCategoriesSchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? schemeId;
  int? customerCategoryId;
  DateTime? updatedOn;
  CustomerCategoriesSchemesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.schemeId,
    this.customerCategoryId,
    this.updatedOn,
  });

  CustomerCategoriesSchemesModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    int? schemeId,
    int? customerCategoryId,
    DateTime? updatedOn,
  }) {
    return CustomerCategoriesSchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      schemeId: schemeId ?? this.schemeId,
      customerCategoryId: customerCategoryId ?? this.customerCategoryId,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'schemeId': schemeId,
      'customerCategoryId': customerCategoryId,
      'updatedOn': updatedOn?.toIso8601String(),
    };
  }

  factory CustomerCategoriesSchemesModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return CustomerCategoriesSchemesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      schemeId: map['schemeId']?.toInt(),
      customerCategoryId: map['customerCategoryId']?.toInt(),
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  @override
  String toString() {
    return 'CustomerCategoriesSchemesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, schemeId: $schemeId, branchId: $customerCategoryId, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerCategoriesSchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.schemeId == schemeId &&
        other.customerCategoryId == customerCategoryId &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        schemeId.hashCode ^
        customerCategoryId.hashCode ^
        updatedOn.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CustomerCategoriesSchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<CustomerCategoriesSchemesModel> FromJson(String str, String slug) =>
      List<CustomerCategoriesSchemesModel>.from(json.decode(str).map(
          (x) => CustomerCategoriesSchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<CustomerCategoriesSchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
