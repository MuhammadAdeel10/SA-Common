import 'dart:convert';

import 'package:sa_common/schemes/models/tax_model.dart';

import '../../Controller/BaseRepository.dart';
import '../../utils/Enums.dart';

class ProductSalesTaxField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String productId = 'productId';
  static final String taxId = 'taxId';
  static final String taxAmount = 'taxAmount';
  static final String appliedOn = 'appliedOn';
  static final String sort = 'sort';
  static final String applicableToAllBranches = 'applicableToAllBranches';
}

class ProductSalesTaxModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? productId;
  int? taxId;
  num? taxAmount;
  SaleTaxAppliedOn appliedOn;
  int? sort;
  TaxModel? tax;
  bool applicableToAllBranches;
  bool isSync;
  DateTime? syncDate;
  ProductSalesTaxModel(
      {this.id,
      this.companySlug,
      this.productId,
      this.taxId,
      this.taxAmount,
      this.appliedOn = SaleTaxAppliedOn.SalePrice,
      this.sort,
      this.tax,
      this.applicableToAllBranches = false,
      this.isSync = false,
      this.syncDate});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'productId': productId,
      'taxId': taxId,
      'taxAmount': taxAmount,
      'appliedOn': appliedOn.value,
      'sort': sort,
      'applicableToAllBranches': applicableToAllBranches,
    };
  }

  factory ProductSalesTaxModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return ProductSalesTaxModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      productId: map['productId']?.toInt(),
      taxId: map['taxId']?.toInt(),
      taxAmount: map['taxAmount'],
      appliedOn: intToSaleTaxAppliedOn(map['appliedOn']),
      sort: map['sort']?.toInt(),
      tax: map['tax'] != null
          ? (map['tax']?.map((x) => TaxModel.fromMap(x)))
          : null,
      applicableToAllBranches: (map['applicableToAllBranches'] == 0 ||
              map['applicableToAllBranches'] == false)
          ? false
          : true,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return ProductSalesTaxModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<ProductSalesTaxModel> FromJson(String str, String slug) =>
      List<ProductSalesTaxModel>.from(json
          .decode(str)
          .map((x) => ProductSalesTaxModel().fromJson(x, slug: slug)));

  String ToJson(List<ProductSalesTaxModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
