import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class CustomerLoyaltyPointBalanceField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String loyaltyPoints = 'loyaltyPoints';
  static final String customerId = 'customerId';
  static final String updatedOn = 'updatedOn';
}

class CustomerLoyaltyPointBalanceModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int loyaltyPoints;
  int? customerId;
  DateTime? updatedOn;
  CustomerLoyaltyPointBalanceModel({
    this.id,
    this.companySlug,
    this.loyaltyPoints = 0,
    this.customerId,
    this.updatedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'loyaltyPoints': loyaltyPoints,
      'customerId': customerId,
      'updatedOn': updatedOn?.toIso8601String(),
    };
  }

  factory CustomerLoyaltyPointBalanceModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return CustomerLoyaltyPointBalanceModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      loyaltyPoints: map['loyaltyPoints']?.toInt() ?? 0,
      customerId: map['customerId']?.toInt(),
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CustomerLoyaltyPointBalanceModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<CustomerLoyaltyPointBalanceModel> FromJson(String str, String slug) =>
      List<CustomerLoyaltyPointBalanceModel>.from(json.decode(str).map(
          (x) => CustomerLoyaltyPointBalanceModel().fromJson(x, slug: slug)));

  String ToJson(List<CustomerLoyaltyPointBalanceModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
