import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class SaleOrderTaxField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String saleOrderDetailId = 'saleOrderDetailId';
  static final String taxId = 'taxId';
  static final String appliedOn = 'appliedOn';
  static final String taxRate = 'taxRate';
  static final String taxAmount = 'taxAmount';
  static final String sort = 'sort';
  static final String branchId = 'branchId';
}

class SaleOrderTaxesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? saleOrderDetailId;
  int? taxId;
  int? appliedOn;
  int? taxRate;
  int? taxAmount;
  int? sort;

  SaleOrderTaxesModel({
    this.id,
    this.companySlug,
    this.saleOrderDetailId,
    this.taxId,
    this.appliedOn,
    this.taxRate,
    this.taxAmount,
    this.sort,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'saleOrderDetailId': saleOrderDetailId,
      'taxId': taxId,
      'appliedOn': appliedOn,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'sort': sort,
    };
  }

  factory SaleOrderTaxesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SaleOrderTaxesModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      saleOrderDetailId: map['saleOrderDetailId']?.toInt(),
      taxId: map['taxId']?.toInt(),
      appliedOn: map['appliedOn']?.toInt(),
      taxRate: map['taxRate']?.toInt(),
      taxAmount: map['taxAmount']?.toInt(),
      sort: map['sort']?.toInt(),
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SaleOrderTaxesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SaleOrderTaxesModel> FromJson(String str, String slug) => List<SaleOrderTaxesModel>.from(json.decode(str).map((x) => SaleOrderTaxesModel().fromJson(x, slug: slug)));

  String ToJson(List<SaleOrderTaxesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
