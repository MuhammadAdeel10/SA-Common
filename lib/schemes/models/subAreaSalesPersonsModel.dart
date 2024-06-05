import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class SubAreaSalesPersonsFields {
  static final String id = 'id';
  static final String subAreaId = 'subAreaId';
  static final String salesPersonId = 'salesPersonId';
  static final String companySlug = 'companySlug';
  static final String subAreaName = 'subAreaName';
  static final String branchId = 'branchId';
}

class SubAreaSalesPersonsModel extends BaseModel<int>  {
  @override
  int? id;
  int? subAreaId;
  String subAreaName;
  int? salesPersonId;
  String? companySlug;
  int? branchId;

  SubAreaSalesPersonsModel(
      { 
      this.companySlug = "",
      this.id,
      this.subAreaName = "",
      this.salesPersonId,
      this.subAreaId,
      this.branchId

      });

  SubAreaSalesPersonsModel copyWith(
      {int? id,
       int? subAreaId,
       int? salesPersonId,
      String? subAreaName,
      String? companySlug,
      }) {
    return SubAreaSalesPersonsModel(
        subAreaId: subAreaId ?? this.subAreaId,
        salesPersonId: salesPersonId ?? this.salesPersonId,
        id: id ?? this.id,
        subAreaName: subAreaName ?? this.subAreaName,
        companySlug: companySlug ?? this.companySlug
        );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'subAreaId': subAreaId,
     'subAreaName': subAreaName,
      'salesPersonId': salesPersonId,   
      'companySlug': companySlug,
      'branchId': branchId
    };
  }

  factory SubAreaSalesPersonsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SubAreaSalesPersonsModel(
        id: map['id'] ?? 0,
        salesPersonId: map['salesPersonId'] ?? 0,
        subAreaId: map['subAreaId'] ?? 0, 
        subAreaName: map['subAreaName'] ?? '',
        companySlug: slug ?? '',
        branchId: map['branchId']?.toInt(),);
  }
  @override
  String toString() {
    return 'SubAreaSalesPersonsModel(id: $id, subAreaId: $subAreaId,subAreaName: $subAreaName, salesPersonId: $salesPersonId )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SubAreaSalesPersonsModel &&
        other.id == id &&
        other.subAreaName == subAreaName &&
        other.subAreaId == subAreaId &&
        other.salesPersonId == salesPersonId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        salesPersonId.hashCode ^
        subAreaName.hashCode ^
        subAreaId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SubAreaSalesPersonsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SubAreaSalesPersonsModel> FromJson(String str, String slug) => List<SubAreaSalesPersonsModel>.from(
      json.decode(str).map((x) => SubAreaSalesPersonsModel().fromJson(x, slug: slug)));

  String ToJson(List<SubAreaSalesPersonsModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
