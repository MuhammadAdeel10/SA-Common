// 	[BranchId] [int] NOT NULL,

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingBranchFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String branchId = 'branchId';
}

class SalePricingBranchesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? branchId;
  SalePricingBranchesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.branchId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.millisecondsSinceEpoch,
      'salePricingId': salePricingId,
      'branchId': branchId,
    };
  }

  factory SalePricingBranchesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingBranchesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      branchId: map['branchId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingBranchesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingBranchesModel> FromJson(String str, String slug) => List<SalePricingBranchesModel>.from(json.decode(str).map((x) => SalePricingBranchesModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingBranchesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
