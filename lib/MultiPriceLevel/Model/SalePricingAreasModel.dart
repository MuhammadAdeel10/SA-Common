import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingAreaFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String areaId = 'areaId';
}

class SalePricingAreasModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? areaId;
  SalePricingAreasModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.areaId,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'salePricingId': salePricingId,
      'areaId': areaId,
    };
  }

  factory SalePricingAreasModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingAreasModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      areaId: map['areaId']?.toInt(),
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingAreasModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingAreasModel> FromJson(String str, String slug) => List<SalePricingAreasModel>.from(json.decode(str).map((x) => SalePricingAreasModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingAreasModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
