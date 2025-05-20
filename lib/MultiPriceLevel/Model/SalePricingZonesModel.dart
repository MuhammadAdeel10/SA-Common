// CREATE TABLE [dbo].[SalePricingZonesModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[ZoneId] [int] NOT NULL,
// 	[CompanyId] [uniqueidentifier] NOT NULL,
//  CONSTRAINT [PK_SalePricingZones] PRIMARY KEY CLUSTERED

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingZonesFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String zoneId = 'zoneId';
}

class SalePricingZonesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? zoneId;
  SalePricingZonesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.zoneId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.millisecondsSinceEpoch,
      'salePricingId': salePricingId,
      'zoneId': zoneId,
    };
  }

  factory SalePricingZonesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingZonesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingZonesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingZonesModel> FromJson(String str, String slug) => List<SalePricingZonesModel>.from(json.decode(str).map((x) => SalePricingZonesModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingZonesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
