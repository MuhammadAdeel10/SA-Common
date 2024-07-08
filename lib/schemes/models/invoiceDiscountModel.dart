import 'dart:convert';

import '../../Controller/BaseRepository.dart';
import '../../utils/Enums.dart';

class InvoiceDetailDiscountFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String posInvoiceDetailId = 'posInvoiceDetailId';
  static final String discountId = 'discountId';
  static final String discountInAmount = 'discountInAmount';
  static final String discountInPrice = 'discountInPrice';
  static final String discountInPercent = 'discountInPercent';
  static final String discountAmount = 'discountAmount';
  static final String totalSavedAmount = 'totalSavedAmount';
  static final String appliedOn = 'appliedOn';
  static final String sort = 'sort';
  static final String schemeId = 'schemeId';
  static final String schemeDetailId = 'schemeDetailId';
  static final String branchId = 'branchId';
  static final String discountType = 'discountType';
}

class InvoiceDetailDiscountModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? posInvoiceDetailId;
  int discountId;
  num discountInAmount;
  num? discountInPrice;
  num? discountInPercent;
  num discountAmount;
  num? totalSavedAmount;
  DiscountAppliedOn? appliedOn;
  int sort;
  int? schemeId;
  int? schemeDetailId;
  int? branchId;
  DiscountType discountType;
  InvoiceDetailDiscountModel({
    this.id,
    this.companySlug,
    this.posInvoiceDetailId,
    this.discountId = 0,
    this.discountInAmount = 0.0,
    this.discountInPrice,
    this.discountInPercent,
    this.discountAmount = 0.0,
    this.totalSavedAmount,
    this.appliedOn,
    this.sort = 0,
    this.schemeId,
    this.schemeDetailId,
    this.branchId,
    this.discountType = DiscountType.Percent,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'posInvoiceDetailId': posInvoiceDetailId,
      'discountId': discountId,
      'discountInAmount': discountInAmount,
      'discountInPrice': discountInPrice,
      'discountInPercent': discountInPercent,
      'discountAmount': discountAmount,
      'totalSavedAmount': totalSavedAmount,
      'appliedOn': appliedOn?.value,
      'sort': sort,
      'schemeId': schemeId,
      'schemeDetailId': schemeDetailId,
      'branchId': branchId,
      'discountType': discountType.value,
    };
  }

  factory InvoiceDetailDiscountModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return InvoiceDetailDiscountModel(
        id: map['id']?.toInt(),
        companySlug: map['companySlug'],
        posInvoiceDetailId: map['posInvoiceDetailId']?.toInt(),
        discountId: map['discountId']?.toInt(),
        discountInAmount: map['discountInAmount'] ?? 0.0,
        discountInPrice: map['discountInPrice'],
        discountInPercent: map['discountInPercent'],
        discountAmount: map['discountAmount'] ?? 0.0,
        totalSavedAmount: map['totalSavedAmount'],
        appliedOn: map['appliedOn'] != null ? intToDiscountAppliedOn(map['appliedOn']) : null,
        sort: map['sort'] == null ? 0 : map['sort'],
        schemeId: map['schemeId']?.toInt(),
        schemeDetailId: map['schemeDetailId']?.toInt(),
        branchId: map['branchId']?.toInt(),
        discountType: intToDiscountType(map['discountType'] ?? 0));
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return InvoiceDetailDiscountModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<InvoiceDetailDiscountModel> FromJson(String str, String slug) => List<InvoiceDetailDiscountModel>.from(json.decode(str).map((x) => InvoiceDetailDiscountModel().fromJson(x, slug: slug)));

  String ToJson(List<InvoiceDetailDiscountModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
