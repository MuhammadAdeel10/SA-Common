import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingCustomerCategoryFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String customerCategoryId = 'customerCategoryId';
}

class SalePricingCustomerCategoriesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? customerCategoryId;
  SalePricingCustomerCategoriesModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.customerCategoryId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'salePricingId': salePricingId,
      'customerCategoryId': customerCategoryId,
    };
  }

  factory SalePricingCustomerCategoriesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingCustomerCategoriesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      customerCategoryId: map['customerCategoryId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingCustomerCategoriesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingCustomerCategoriesModel> FromJson(String str, String slug) => List<SalePricingCustomerCategoriesModel>.from(json.decode(str).map((x) => SalePricingCustomerCategoriesModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingCustomerCategoriesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
