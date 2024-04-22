import 'dart:convert';

import 'package:sa_common/schemes/models/tax_model.dart';

import '../../Controller/BaseRepository.dart';
import '../../utils/Enums.dart';

class LineItemTaxField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String posInvoiceDetailId = 'posInvoiceDetailId';
  static final String saleOrderDetailId = 'saleOrderDetailId';
  static final String taxId = 'taxId';
  static final String appliedOn = 'appliedOn';
  static final String taxRate = 'taxRate';
  static final String taxAmount = 'taxAmount';
  static final String sort = 'sort';
  static final String branchId = 'branchId';
}

class LineItemTaxModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? posInvoiceDetailId;
  int? saleOrderDetailId;
  int? taxId;
  SaleTaxAppliedOn? appliedOn;
  num? taxRate;
  num? taxAmount;
  int? sort;
  int? branchId;
  TaxModel? tax;
  LineItemTaxModel({this.id, this.companySlug, this.saleOrderDetailId, this.posInvoiceDetailId, this.taxId, this.appliedOn, this.taxRate, this.taxAmount, this.sort, this.branchId, this.tax});

  LineItemTaxModel copyWith({
    int? id,
    String? companySlug,
    int? posInvoiceDetailId,
    int? taxId,
    SaleTaxAppliedOn? appliedOn,
    num? taxRate,
    num? taxAmount,
    int? sort,
    int? branchId,
  }) {
    return LineItemTaxModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      posInvoiceDetailId: posInvoiceDetailId ?? this.posInvoiceDetailId,
      taxId: taxId ?? this.taxId,
      appliedOn: appliedOn ?? this.appliedOn,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      sort: sort ?? this.sort,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'posInvoiceDetailId': posInvoiceDetailId,
      'saleOrderDetailId': saleOrderDetailId,
      'taxId': taxId,
      'appliedOn': appliedOn?.value,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'sort': sort,
      'branchId': branchId,
    };
  }

  factory LineItemTaxModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return LineItemTaxModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      posInvoiceDetailId: map['posInvoiceDetailId']?.toInt(),
      saleOrderDetailId: map['saleOrderDetailId']?.toInt(),
      taxId: map['taxId']?.toInt(),
      appliedOn: intToSaleTaxAppliedOn(map['appliedOn']),
      taxRate: map['taxRate'],
      taxAmount: map['taxAmount'],
      sort: map['sort']?.toInt(),
      branchId: map['branchId']?.toInt(),
      tax: map['tax'] != null ? TaxModel?.fromMap(map['tax']) : null,
    );
  }

  @override
  String toString() {
    return 'POSInvoiceTaxModel(id: $id, companySlug: $companySlug, posInvoiceDetailId: $posInvoiceDetailId, taxId: $taxId, appliedOn: $appliedOn, taxRate: $taxRate, taxAmount: $taxAmount, sort: $sort, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LineItemTaxModel && other.id == id && other.companySlug == companySlug && other.posInvoiceDetailId == posInvoiceDetailId && other.taxId == taxId && other.appliedOn == appliedOn && other.taxRate == taxRate && other.taxAmount == taxAmount && other.sort == sort && other.branchId == branchId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ companySlug.hashCode ^ posInvoiceDetailId.hashCode ^ taxId.hashCode ^ appliedOn.hashCode ^ taxRate.hashCode ^ taxAmount.hashCode ^ sort.hashCode ^ branchId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return LineItemTaxModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<LineItemTaxModel> FromJson(String str, String slug) => List<LineItemTaxModel>.from(json.decode(str).map((x) => LineItemTaxModel().fromJson(x, slug: slug)));

  String ToJson(List<LineItemTaxModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
