// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class CustomersSchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String schemeId = 'schemeId';
  static final String customerId = 'customerId';
  static final String updatedOn = 'updatedOn';
}

class CustomersSchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? schemeId;
  int? customerId;
  DateTime? updatedOn;
  CustomersSchemesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.schemeId,
    this.customerId,
    this.updatedOn,
  });

  CustomersSchemesModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    int? schemeId,
    int? customerId,
    DateTime? updatedOn,
  }) {
    return CustomersSchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      schemeId: schemeId ?? this.schemeId,
      customerId: customerId ?? this.customerId,
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
      'customerId': customerId,
      'updatedOn': updatedOn?.toIso8601String(),
    };
  }

  factory CustomersSchemesModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return CustomersSchemesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      schemeId: map['schemeId']?.toInt(),
      customerId: map['customerId']?.toInt(),
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  @override
  String toString() {
    return 'CustomersSchemesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, schemeId: $schemeId, customerId: $customerId, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomersSchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.schemeId == schemeId &&
        other.customerId == customerId &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        schemeId.hashCode ^
        customerId.hashCode ^
        updatedOn.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CustomersSchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<CustomersSchemesModel> FromJson(String str, String slug) =>
      List<CustomersSchemesModel>.from(json
          .decode(str)
          .map((x) => CustomersSchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<CustomersSchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
