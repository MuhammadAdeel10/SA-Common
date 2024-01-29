// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class BranchesSchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String schemeId = 'schemeId';
  static final String branchId = 'branchId';
  static final String updatedOn = 'updatedOn';
}

class BranchesSchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  int? schemeId;
  int? branchId;

  BranchesSchemesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.schemeId,
    this.branchId,
    this.updatedOn,
  });

  BranchesSchemesModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    int? schemeId,
    int? branchId,
    DateTime? updatedOn,
  }) {
    return BranchesSchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      schemeId: schemeId ?? this.schemeId,
      branchId: branchId ?? this.branchId,
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
      'updatedOn': updatedOn?.toIso8601String(),
      'schemeId': schemeId,
      'branchId': branchId,
    };
  }

  factory BranchesSchemesModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return BranchesSchemesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      schemeId: map['schemeId']?.toInt(),
      branchId: map['branchId']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'BranchesSchemesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, schemeId: $schemeId, branchId: $branchId, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BranchesSchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.schemeId == schemeId &&
        other.branchId == branchId &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        schemeId.hashCode ^
        branchId.hashCode ^
        updatedOn.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return BranchesSchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<BranchesSchemesModel> FromJson(String str, String slug) =>
      List<BranchesSchemesModel>.from(json
          .decode(str)
          .map((x) => BranchesSchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<BranchesSchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
