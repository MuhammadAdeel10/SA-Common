import 'dart:convert';
import 'package:sa_common/schemes/models/POSInvoiceDiscountModel.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/utils/Enums.dart';

import '../../schemes/models/POSInvoiceDetailTaxModel.dart';

class SalesInvoiceDetailModel {
  int? id;
  String? companySlug;
  int saleInvoiceId;
  int productId;
  int? accountId;
  String description;
  num quantity;
  num price;
  num discountInPercent;
  num grossAmount;
  num taxAmount;
  num discountAmount;
  num netAmount;
  String packingDetail;
  int? detailBGroupId;
  int? detailAGroupId;
  String quantityCalculation;
  int? batchId;
  int warehouseId;
  String serialNumber;
  bool isMRPExclusiveTax;
  num purchasePrice;
  num maximumRetailPrice;
  int? consignmentId;
  int? branchId;
  bool isBonusProduct;
  num tagPrice;
  num totalSavedAmount;
  PosPaymentMode posPaymentMode;
  num amount;
  List<POSInvoiceDetailDiscountModel> discounts;
  ProductModel? product;
  List<POSInvoiceTaxModel>? taxes;
  SalesInvoiceDetailModel({
    this.id,
    this.companySlug,
    this.saleInvoiceId = 0,
    this.productId = 0,
    this.accountId,
    this.description = "",
    this.quantity = 0,
    this.price = 0,
    this.discountInPercent = 0,
    this.grossAmount = 0,
    this.taxAmount = 0,
    this.discountAmount = 0,
    this.netAmount = 0,
    this.packingDetail = "",
    this.detailBGroupId,
    this.detailAGroupId,
    this.quantityCalculation = "",
    this.batchId,
    this.warehouseId = 0,
    this.serialNumber = "",
    this.isMRPExclusiveTax = false,
    this.purchasePrice = 0,
    this.maximumRetailPrice = 0,
    this.consignmentId,
    this.branchId,
    this.isBonusProduct = false,
    this.tagPrice = 0,
    this.totalSavedAmount = 0,
    this.posPaymentMode = PosPaymentMode.Cash,
    this.amount = 0,
    required this.discounts,
    this.product,
    this.taxes,
  });

  SalesInvoiceDetailModel copyWith({
    int? id,
    String? companySlug,
    int? saleInvoiceId,
    int? productId,
    int? accountId,
    String? description,
    num? quantity,
    num? price,
    num? discountInPercent,
    num? grossAmount,
    num? taxAmount,
    num? discountAmount,
    num? netAmount,
    String? packingDetail,
    int? detailBGroupId,
    int? detailAGroupId,
    String? quantityCalculation,
    int? batchId,
    int? warehouseId,
    String? serialNumber,
    bool? isMRPExclusiveTax,
    num? purchasePrice,
    num? maximumRetailPrice,
    int? consignmentId,
    int? branchId,
    bool? isBonusProduct,
    num? tagPrice,
    num? totalSavedAmount,
    PosPaymentMode? posPaymentMode,
    num? amount,
    List<POSInvoiceDetailDiscountModel>? discounts,
    ProductModel? product,
    List<POSInvoiceTaxModel>? taxes,
  }) {
    return SalesInvoiceDetailModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      saleInvoiceId: saleInvoiceId ?? this.saleInvoiceId,
      productId: productId ?? this.productId,
      accountId: accountId ?? this.accountId,
      description: description ?? this.description,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discountInPercent: discountInPercent ?? this.discountInPercent,
      grossAmount: grossAmount ?? this.grossAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      netAmount: netAmount ?? this.netAmount,
      packingDetail: packingDetail ?? this.packingDetail,
      detailBGroupId: detailBGroupId ?? this.detailBGroupId,
      detailAGroupId: detailAGroupId ?? this.detailAGroupId,
      quantityCalculation: quantityCalculation ?? this.quantityCalculation,
      batchId: batchId ?? this.batchId,
      warehouseId: warehouseId ?? this.warehouseId,
      serialNumber: serialNumber ?? this.serialNumber,
      isMRPExclusiveTax: isMRPExclusiveTax ?? this.isMRPExclusiveTax,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      maximumRetailPrice: maximumRetailPrice ?? this.maximumRetailPrice,
      consignmentId: consignmentId ?? this.consignmentId,
      branchId: branchId ?? this.branchId,
      isBonusProduct: isBonusProduct ?? this.isBonusProduct,
      tagPrice: tagPrice ?? this.tagPrice,
      totalSavedAmount: totalSavedAmount ?? this.totalSavedAmount,
      posPaymentMode: posPaymentMode ?? this.posPaymentMode,
      amount: amount ?? this.amount,
      discounts: discounts ?? this.discounts,
      product: product ?? this.product,
      taxes: taxes ?? this.taxes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'saleInvoiceId': saleInvoiceId,
      'productId': productId == 0 ? null : productId,
      'accountId': accountId == 0 ? null : accountId,
      'description': description,
      'quantity': quantity,
      'price': price,
      'discountInPercent': discountInPercent,
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'netAmount': netAmount,
      'packingDetail': packingDetail,
      'detailBGroupId': detailBGroupId == 0 ? null : detailBGroupId,
      'detailAGroupId': detailAGroupId == 0 ? null : detailAGroupId,
      'quantityCalculation': quantityCalculation,
      'batchId': batchId == 0 ? null : batchId,
      'warehouseId': warehouseId,
      'serialNumber': serialNumber,
      'isMRPExclusiveTax': isMRPExclusiveTax == true ? 1 : 0,
      'purchasePrice': purchasePrice,
      'maximumRetailPrice': maximumRetailPrice,
      'consignmentId': consignmentId == 0 ? null : consignmentId,
      'branchId': branchId,
      'isBonusProduct': isBonusProduct == true ? 1 : 0,
      'tagPrice': tagPrice,
      'totalSavedAmount': totalSavedAmount,
      'posPaymentMode': posPaymentMode.value,
      'amount': amount,
      'discounts': discounts.map((x) => x.toMap()).toList(),
      'product': product?.toMap(),
      'taxes': taxes?.map((x) => x.toMap()).toList(),
    };
  }

  factory SalesInvoiceDetailModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return SalesInvoiceDetailModel(
      id: map['id']?.toInt(),
      companySlug: slug,
      saleInvoiceId: map['saleInvoiceId']?.toInt(),
      productId: map['productId']?.toInt(),
      accountId: map['accountId']?.toInt(),
      description: map['description'],
      quantity: map['quantity'],
      price: map['price'],
      discountInPercent: map['discountInPercent'],
      grossAmount: map['grossAmount'],
      taxAmount: map['taxAmount'],
      discountAmount: map['discountAmount'],
      netAmount: map['netAmount'],
      packingDetail: map['packingDetail'],
      detailBGroupId: map['detailBGroupId']?.toInt(),
      detailAGroupId: map['detailAGroupId']?.toInt(),
      quantityCalculation: map['quantityCalculation'],
      batchId: map['batchId']?.toInt(),
      warehouseId: map['warehouseId']?.toInt(),
      serialNumber: map['serialNumber'],
      isMRPExclusiveTax:
          (map['isMRPExclusiveTax'] == 0 || map['isMRPExclusiveTax'] == false)
              ? false
              : true,
      purchasePrice: map['purchasePrice'],
      maximumRetailPrice: map['maximumRetailPrice'],
      consignmentId: map['consignmentId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      isBonusProduct:
          (map['isBonusProduct'] == 0 || map['isBonusProduct'] == false)
              ? false
              : true,
      tagPrice: map['tagPrice'],
      totalSavedAmount: map['totalSavedAmount'],
      posPaymentMode: intToPosPaymentMode(map['posPaymentMode']),
      amount: map['amount'],
      discounts: map['discounts'] == null
          ? []
          : List<POSInvoiceDetailDiscountModel>.from(map['discounts']
              ?.map((x) => POSInvoiceDetailDiscountModel.fromMap(x))),
      product:
          map['product'] != null ? ProductModel.fromMap(map['product']) : null,
      taxes: map['taxes'] != null
          ? List<POSInvoiceTaxModel>.from(
              map['taxes']?.map((x) => POSInvoiceTaxModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesInvoiceDetailModel.fromJson(String source) =>
      SalesInvoiceDetailModel.fromMap(json.decode(source));
}
