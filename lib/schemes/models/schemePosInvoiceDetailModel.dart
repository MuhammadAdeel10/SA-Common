import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'POSInvoiceDetailTaxModel.dart';
import 'POSInvoiceDiscountModel.dart';

class SchemePOSInvoiceDetailModel {
  int? id;
  String? companySlug;
  int? saleInvoiceId;
  int? productId;
  int? accountId;
  String? description;
  num? quantity;
  num? price;
  num? discountInPercent;
  num? grossAmount;
  num? taxAmount;
  num? discountAmount;
  num? netAmount;
  String? packingDetail;
  int? detailBGroupId;
  int? detailAGroupId;
  String? quantityCalculation;
  int? batchId;
  int? warehouseId;
  String? serialNumber;
  bool? isMRPExclusiveTax;
  num? purchasePrice;
  num? maximumRetailPrice;
  int? consignmentId;
  int? branchId;
  bool isBonusProduct;
  num? tagPrice;
  num? totalSavedAmount;
  int? discountType;
  List<POSInvoiceDetailDiscountModel>? discounts;
  List<POSInvoiceTaxModel>? taxes;
  ProductModel? product;

  SchemePOSInvoiceDetailModel({
    this.id,
    this.companySlug,
    this.saleInvoiceId,
    this.productId,
    this.accountId,
    this.description,
    this.quantity = 0,
    this.price,
    this.discountInPercent,
    this.grossAmount,
    this.taxAmount,
    this.discountAmount,
    this.netAmount,
    this.packingDetail,
    this.detailBGroupId,
    this.detailAGroupId,
    this.quantityCalculation,
    this.batchId,
    this.warehouseId,
    this.serialNumber,
    this.isMRPExclusiveTax,
    this.purchasePrice,
    this.maximumRetailPrice,
    this.consignmentId,
    this.branchId,
    this.isBonusProduct = false,
    this.tagPrice,
    this.totalSavedAmount,
    this.discountType,
    this.discounts,
    this.taxes,
    this.product,
  });

  SchemePOSInvoiceDetailModel copyWith({
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
    int? discountType,
    List<POSInvoiceDetailDiscountModel>? discounts,
    List<POSInvoiceTaxModel>? taxes,
    ProductModel? product,
  }) {
    return SchemePOSInvoiceDetailModel(
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
      discountType: discountType ?? this.discountType,
      discounts: discounts ?? this.discounts,
      taxes: taxes ?? this.taxes,
      product: product ?? this.product,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'saleInvoiceId': saleInvoiceId,
      'productId': productId,
      'accountId': accountId,
      'description': description,
      'quantity': quantity,
      'price': price,
      'discountInPercent': discountInPercent,
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'netAmount': netAmount,
      'packingDetail': packingDetail,
      'detailBGroupId': detailBGroupId,
      'detailAGroupId': detailAGroupId,
      'quantityCalculation': quantityCalculation,
      'batchId': batchId,
      'warehouseId': warehouseId,
      'serialNumber': serialNumber,
      'isMRPExclusiveTax': isMRPExclusiveTax,
      'purchasePrice': purchasePrice,
      'maximumRetailPrice': maximumRetailPrice,
      'consignmentId': consignmentId,
      'branchId': branchId,
      'isBonusProduct': isBonusProduct,
      'tagPrice': tagPrice,
      'totalSavedAmount': totalSavedAmount,
      'discountType': discountType,
      'discounts': discounts?.map((x) => x.toMap()).toList(),
      'taxes': taxes?.map((x) => x.toMap()).toList(),
      'product': product?.toMap(),
    };
  }

  factory SchemePOSInvoiceDetailModel.fromMap(Map<String, dynamic> map) {
    return SchemePOSInvoiceDetailModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      saleInvoiceId: map['saleInvoiceId']?.toInt(),
      productId: map['productId']?.toInt(),
      accountId: map['accountId']?.toInt(),
      description: map['description'],
      quantity: map['quantity'] ?? 0,
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
      isMRPExclusiveTax: map['isMRPExclusiveTax'],
      purchasePrice: map['purchasePrice'],
      maximumRetailPrice: map['maximumRetailPrice'],
      consignmentId: map['consignmentId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      isBonusProduct: map['isBonusProduct'],
      tagPrice: map['tagPrice'],
      totalSavedAmount: map['totalSavedAmount'],
      discountType: map['discountType']?.toInt(),
      discounts: map['discounts'] != null
          ? List<POSInvoiceDetailDiscountModel>.from(map['discounts']
              ?.map((x) => POSInvoiceDetailDiscountModel.fromMap(x)))
          : null,
      taxes: map['taxes'] != null
          ? List<POSInvoiceTaxModel>.from(
              map['taxes']?.map((x) => POSInvoiceTaxModel.fromMap(x)))
          : null,
      product:
          map['product'] != null ? ProductModel.fromMap(map['product']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemePOSInvoiceDetailModel.fromJson(String source) =>
      SchemePOSInvoiceDetailModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemePOSInvoiceDetailModel(id: $id, companySlug: $companySlug, saleInvoiceId: $saleInvoiceId, productId: $productId, accountId: $accountId, description: $description, quantity: $quantity, price: $price, discountInPercent: $discountInPercent, grossAmount: $grossAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, netAmount: $netAmount, packingDetail: $packingDetail, detailBGroupId: $detailBGroupId, detailAGroupId: $detailAGroupId, quantityCalculation: $quantityCalculation, batchId: $batchId, warehouseId: $warehouseId, serialNumber: $serialNumber, isMRPExclusiveTax: $isMRPExclusiveTax, purchasePrice: $purchasePrice, maximumRetailPrice: $maximumRetailPrice, consignmentId: $consignmentId, branchId: $branchId, isBonusProduct: $isBonusProduct, tagPrice: $tagPrice, totalSavedAmount: $totalSavedAmount, discountType: $discountType, discounts: $discounts, taxes: $taxes, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemePOSInvoiceDetailModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.saleInvoiceId == saleInvoiceId &&
        other.productId == productId &&
        other.accountId == accountId &&
        other.description == description &&
        other.quantity == quantity &&
        other.price == price &&
        other.discountInPercent == discountInPercent &&
        other.grossAmount == grossAmount &&
        other.taxAmount == taxAmount &&
        other.discountAmount == discountAmount &&
        other.netAmount == netAmount &&
        other.packingDetail == packingDetail &&
        other.detailBGroupId == detailBGroupId &&
        other.detailAGroupId == detailAGroupId &&
        other.quantityCalculation == quantityCalculation &&
        other.batchId == batchId &&
        other.warehouseId == warehouseId &&
        other.serialNumber == serialNumber &&
        other.isMRPExclusiveTax == isMRPExclusiveTax &&
        other.purchasePrice == purchasePrice &&
        other.maximumRetailPrice == maximumRetailPrice &&
        other.consignmentId == consignmentId &&
        other.branchId == branchId &&
        other.isBonusProduct == isBonusProduct &&
        other.tagPrice == tagPrice &&
        other.totalSavedAmount == totalSavedAmount &&
        other.discountType == discountType &&
        listEquals(other.discounts, discounts) &&
        listEquals(other.taxes, taxes) &&
        other.product == product;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        saleInvoiceId.hashCode ^
        productId.hashCode ^
        accountId.hashCode ^
        description.hashCode ^
        quantity.hashCode ^
        price.hashCode ^
        discountInPercent.hashCode ^
        grossAmount.hashCode ^
        taxAmount.hashCode ^
        discountAmount.hashCode ^
        netAmount.hashCode ^
        packingDetail.hashCode ^
        detailBGroupId.hashCode ^
        detailAGroupId.hashCode ^
        quantityCalculation.hashCode ^
        batchId.hashCode ^
        warehouseId.hashCode ^
        serialNumber.hashCode ^
        isMRPExclusiveTax.hashCode ^
        purchasePrice.hashCode ^
        maximumRetailPrice.hashCode ^
        consignmentId.hashCode ^
        branchId.hashCode ^
        isBonusProduct.hashCode ^
        tagPrice.hashCode ^
        totalSavedAmount.hashCode ^
        discountType.hashCode ^
        discounts.hashCode ^
        taxes.hashCode ^
        product.hashCode;
  }
}
