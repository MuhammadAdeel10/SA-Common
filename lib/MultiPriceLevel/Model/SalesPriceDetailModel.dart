// CREATE TABLE [dbo].[SalePricingDetailsModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[ProductId] [int] NOT NULL,
// 	[Price] [decimal](30, 10) NOT NULL,
// 	[CompanyId] [uniqueidentifier] NOT NULL,
//  CONSTRAINT [PK_SalePricingDetails] PRIMARY KEY CLUSTERED

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingDetailFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String productId = 'productId';
  static const String price = 'price';
}

class SalePricingDetailsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? productId;
  num price;
  SalePricingDetailsModel({
    this.id,
    this.companySlug,
    this.isSync = false,
    this.syncDate,
    this.salePricingId,
    this.productId,
    this.price = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'salePricingId': salePricingId,
      'productId': productId,
      'price': price,
    };
  }

  factory SalePricingDetailsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingDetailsModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      productId: map['productId']?.toInt(),
      price: map['price'] ?? 0,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingDetailsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingDetailsModel> FromJson(String str, String slug) => List<SalePricingDetailsModel>.from(json.decode(str).map((x) => SalePricingDetailsModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingDetailsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
