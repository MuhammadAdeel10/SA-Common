import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';

class SalePricingFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String series = 'series';
  static const String number = 'number';
  static const String name = 'name';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';
  static const String currencyId = 'currencyId';
  static const String isActive = 'isActive';
  static const String reference = 'reference';
  static const String forFranchise = 'forFranchise';
  static const String isApplied = 'isApplied';
  static const String isReverted = 'isReverted';
  static const String status = 'status';
}

class SalePricingsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  String series;
  String number;
  String name;
  DateTime? startDate;
  DateTime? endDate;
  int? currencyId;
  bool isActive;
  String? reference;
  bool forFranchise;
  bool isApplied;
  bool isReverted;
  SalePriceStatus status;
  SalePricingsModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.series = "",
    this.number = "",
    this.name = "",
    this.startDate,
    this.endDate,
    this.currencyId,
    this.isActive = false,
    this.reference,
    this.forFranchise = false,
    this.isApplied = false,
    this.isReverted = false,
    this.status = SalePriceStatus.Draft,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'series': series,
      'number': number,
      'name': name,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'currencyId': currencyId,
      'isActive': isActive == true ? 1 : 0,
      'reference': reference,
      'forFranchise': forFranchise == true ? 1 : 0,
      'isApplied': isApplied == true ? 1 : 0,
      'isReverted': isReverted == true ? 1 : 0,
      'status': status.value,
    };
  }

  factory SalePricingsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingsModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      series: map['series'] ?? '',
      number: map['number'] ?? '',
      name: map['name'] ?? '',
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      currencyId: map['currencyId']?.toInt(),
      isActive: (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      reference: map['reference'],
      forFranchise: (map['forFranchise'] == 0 || map['forFranchise'] == false) ? false : true,
      isApplied: (map['isApplied'] == 0 || map['isApplied'] == false) ? false : true,
      isReverted: (map['isReverted'] == 0 || map['isReverted'] == false) ? false : true,
      status: intToSalePriceStatuss(map['status'] ?? 0),
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingsModel> FromJson(String str, String slug) => List<SalePricingsModel>.from(json.decode(str).map((x) => SalePricingsModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
