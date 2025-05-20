// CREATE TABLE [dbo].[SalePricingRegionsModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[RegionId] [int] NOT NULL,

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingRegionsFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String regionId = 'regionId';
}

class SalePricingRegionsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? regionId;
  SalePricingRegionsModel({this.id, this.companySlug, this.isSync = false, this.syncDate, this.salePricingId, this.regionId});

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingRegionsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingRegionsModel> FromJson(String str, String slug) => List<SalePricingRegionsModel>.from(json.decode(str).map((x) => SalePricingRegionsModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingRegionsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'salePricingId': salePricingId,
      'regionId': regionId,
    };
  }

  factory SalePricingRegionsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingRegionsModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      regionId: map['regionId']?.toInt(),
    );
  }
}
