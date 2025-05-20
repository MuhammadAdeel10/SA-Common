// CREATE TABLE [dbo].[SalePricingTerritoriesModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[TerritoryId] [int] NOT NULL,
// 	[CompanyId] [uniqueidentifier] NOT NULL,
//  CONSTRAINT [PK_SalePricingTerritories] PRIMARY KEY CLUSTERED a

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingTerritoriesFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String territoryId = 'territoryId';
}

class SalePricingTerritoriesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? territoryId;
  SalePricingTerritoriesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.territoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.millisecondsSinceEpoch,
      'salePricingId': salePricingId,
      'territoryId': territoryId,
    };
  }

  factory SalePricingTerritoriesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingTerritoriesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      territoryId: map['territoryId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingTerritoriesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingTerritoriesModel> FromJson(String str, String slug) => List<SalePricingTerritoriesModel>.from(json.decode(str).map((x) => SalePricingTerritoriesModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingTerritoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
