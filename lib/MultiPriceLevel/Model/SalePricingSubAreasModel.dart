// CREATE TABLE [dbo].[SalePricingSubAreasModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[SubAreaId] [int] NOT NULL,
// 	[CompanyId] [uniqueidentifier] NOT NULL,

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
class SalePricingSubAreasFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String subAreaId = 'subAreaId';
}
class SalePricingSubAreasModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? subAreaId;
  SalePricingSubAreasModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.subAreaId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'salePricingId': salePricingId,
      'subAreaId': subAreaId,
    };
  }

  factory SalePricingSubAreasModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingSubAreasModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      subAreaId: map['subAreaId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingSubAreasModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingSubAreasModel> FromJson(String str, String slug) => List<SalePricingSubAreasModel>.from(json.decode(str).map((x) => SalePricingSubAreasModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingSubAreasModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
