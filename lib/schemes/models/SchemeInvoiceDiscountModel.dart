import 'dart:convert';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/utils/Enums.dart';
import '../../Controller/BaseRepository.dart';

class SchemeInvoiceDiscountField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String branchId = 'branchId';
  static final String discountAmount = 'discountAmount';
  static final String discountPercent = 'discountPercent';
  static final String appliedOn = 'appliedOn';
  static final String sort = 'sort';
  static final String discountType = 'discountType';
  static final String discountId = 'discountId';
  static final String schemeId = 'schemeId';
  static final String masterGroupId = 'masterGroupId';
  static final String currencyId = 'currencyId';
  static final String narration = 'narration';
  static final String sourceCreatedOn = 'sourceCreatedOn';
  static final String source = 'source';
  static final String sourceId = 'sourceId';
}

class SchemeInvoiceDiscountModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? branchId;
  num? discountAmount;
  num? discountPercent;
  DiscountAppliedOn? appliedOn;
  int? sort;
  DiscountInvoiceType? discountType;
  int? discountId;
  DiscountModel? discount;
  int? schemeId;
  int? masterGroupId;
  int? currencyId;
  String? narration;
  DateTime? sourceCreatedOn;
  String? source;
  int? sourceId;
  SchemeInvoiceDiscountModel(
      {this.id,
      this.companySlug,
      this.branchId,
      this.discountAmount,
      this.discountPercent,
      this.appliedOn,
      this.sort,
      this.discountType,
      this.discountId,
      this.discount,
      this.schemeId,
      this.masterGroupId,
      this.currencyId,
      this.narration,
      this.sourceCreatedOn,
      this.source,
      this.sourceId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'branchId': branchId,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'appliedOn': appliedOn?.value,
      'sort': sort,
      'discountType': discountType?.value,
      'discountId': discountId,
      'schemeId': schemeId,
      'masterGroupId': masterGroupId,
      'currencyId': currencyId,
      'narration': narration,
      'sourceCreatedOn': sourceCreatedOn?.toIso8601String(),
      'source': source,
      'sourceId': sourceId
    };
  }

  factory SchemeInvoiceDiscountModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return SchemeInvoiceDiscountModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      branchId: map['branchId']?.toInt(),
      sourceId: map['sourceId']?.toInt(),
      discountAmount: map['discountAmount']?.toDouble(),
      discountPercent: map['discountPercent']?.toDouble(),
      appliedOn: map['appliedOn'] != null
          ? intToDiscountAppliedOn(map['appliedOn'])
          : null,
      sort: map['sort']?.toInt(),
      discountType: map['discountType'] != null
          ? intToDiscountInvoiceType(map['discountType'])
          : null,
      discountId: map['discountId']?.toInt(),
      discount: map['discount'] != null
          ? DiscountModel.fromMap(map['discount'])
          : null,
      schemeId: map['schemeId']?.toInt(),
      masterGroupId: map['masterGroupId']?.toInt(),
      currencyId: map['currencyId']?.toInt(),
      narration: map['narration'],
      sourceCreatedOn: map['sourceCreatedOn'] != null
          ? DateTime.parse(map['sourceCreatedOn'])
          : null,
      source: map['source'],
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SchemeInvoiceDiscountModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SchemeInvoiceDiscountModel> FromJson(String str, String slug) =>
      List<SchemeInvoiceDiscountModel>.from(json
          .decode(str)
          .map((x) => SchemeInvoiceDiscountModel().fromJson(x, slug: slug)));

  String ToJson(List<SchemeInvoiceDiscountModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
