// CREATE TABLE [dbo].[SalePricingCustomersModel](
// 	[Id] [int] NOT NULL,
// 	[SalePricingId] [int] NOT NULL,
// 	[CustomerId] [int] NOT NULL,

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalePricingCustomerFields {
  static const String id = 'id';
  static const String companySlug = 'companySlug';
  static const String isSync = 'isSync';
  static const String syncDate = 'syncDate';
  static const String salePricingId = 'salePricingId';
  static const String customerId = 'customerId';
}

class SalePricingCustomersModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  int? salePricingId;
  int? customerId;
  SalePricingCustomersModel({this.id, this.companySlug, this.isSync = false, this.syncDate, this.salePricingId, this.customerId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.millisecondsSinceEpoch,
      'salePricingId': salePricingId,
      'customerId': customerId,
    };
  }

  factory SalePricingCustomersModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalePricingCustomersModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      salePricingId: map['salePricingId']?.toInt(),
      customerId: map['customerId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalePricingCustomersModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalePricingCustomersModel> FromJson(String str, String slug) => List<SalePricingCustomersModel>.from(json.decode(str).map((x) => SalePricingCustomersModel().fromJson(x, slug: slug)));

  String ToJson(List<SalePricingCustomersModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
