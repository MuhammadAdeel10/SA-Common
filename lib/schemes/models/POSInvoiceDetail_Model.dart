import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';

import '../../schemes/models/POSInvoiceDetailTaxModel.dart';

class POSInvoiceDetailFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String saleInvoiceId = 'saleInvoiceId';
  static final String productId = 'productId';
  static final String accountId = 'accountId';
  static final String description = 'description';
  static final String quantity = 'quantity';
  static final String price = 'price';
  static final String discountInPercent = 'discountInPercent';
  static final String grossAmount = 'grossAmount';
  static final String taxAmount = 'taxAmount';
  static final String discountAmount = 'discountAmount';
  static final String netAmount = 'netAmount';
  static final String packingDetail = 'packingDetail';
  static final String detailBGroupId = 'detailBGroupId';
  static final String detailAGroupId = 'detailAGroupId';
  static final String quantityCalculation = 'quantityCalculation';
  static final String batchId = 'batchId';
  static final String warehouseId = 'warehouseId';
  static final String serialNumber = 'serialNumber';
  static final String isMRPExclusiveTax = 'isMRPExclusiveTax';
  static final String purchasePrice = 'purchasePrice';
  static final String maximumRetailPrice = 'maximumRetailPrice';
  static final String consignmentId = 'consignmentId';
  static final String branchId = 'branchId';
  static final String isBonusProduct = 'isBonusProduct';
  static final String tagPrice = 'tagPrice';
  static final String totalSavedAmount = 'totalSavedAmount';
  static final String posPaymentMode = 'posPaymentMode';
  static final String amount = 'amount';
}

class POSInvoiceDetailModel extends BaseModel<int> {
  @override
  int? id;
  @override
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
  List<LineItemTaxModel>? taxes;
  POSInvoiceDetailModel(
      {this.id,
      this.companySlug,
      this.saleInvoiceId = 0,
      this.productId = 0,
      this.accountId = 0,
      this.description = "",
      this.quantity = 0,
      this.price = 0,
      this.discountInPercent = 0,
      this.grossAmount = 0,
      this.taxAmount = 0,
      this.discountAmount = 0,
      this.netAmount = 0,
      this.packingDetail = "",
      this.detailBGroupId = 0,
      this.detailAGroupId = 0,
      this.quantityCalculation = "",
      this.batchId = 0,
      this.warehouseId = 0,
      this.serialNumber = "",
      this.isMRPExclusiveTax = false,
      this.purchasePrice = 0,
      this.maximumRetailPrice = 0,
      this.consignmentId = 0,
      this.branchId = 0,
      this.isBonusProduct = false,
      this.tagPrice = 0,
      this.totalSavedAmount = 0,
      this.posPaymentMode = PosPaymentMode.Cash,
      this.amount = 0.0,
      this.taxes});

  POSInvoiceDetailModel copyWith({
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
  }) {
    return POSInvoiceDetailModel(
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
      'amount': amount
    };
  }

  factory POSInvoiceDetailModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return POSInvoiceDetailModel(
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
        isMRPExclusiveTax: (map['isMRPExclusiveTax'] == 0 || map['isMRPExclusiveTax'] == false) ? false : true,
        purchasePrice: map['purchasePrice'],
        maximumRetailPrice: map['maximumRetailPrice'],
        consignmentId: map['consignmentId']?.toInt(),
        branchId: map['branchId']?.toInt(),
        isBonusProduct: (map['isBonusProduct'] == 0 || map['isBonusProduct'] == false) ? false : true,
        tagPrice: map['tagPrice'],
        totalSavedAmount: map['totalSavedAmount'],
        taxes: map['taxes'] != null ? List<LineItemTaxModel>.from(map['taxes']?.map((x) => LineItemTaxModel.fromMap(x))) : null,
        posPaymentMode: intToPosPaymentMode(map['posPaymentMode']),
        amount: map['amount']);
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return POSInvoiceDetailModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'POSInvoiceDetailModel(id: $id, companySlug: $companySlug, saleInvoiceId: $saleInvoiceId, productId: $productId, accountId: $accountId, description: $description, quantity: $quantity, price: $price, discountInPercent: $discountInPercent, grossAmount: $grossAmount, taxAmount: $taxAmount, discountAmount: $discountAmount, netAmount: $netAmount, packingDetail: $packingDetail, detailBGroupId: $detailBGroupId, detailAGroupId: $detailAGroupId, quantityCalculation: $quantityCalculation, batchId: $batchId, warehouseId: $warehouseId, serialNumber: $serialNumber, isMRPExclusiveTax: $isMRPExclusiveTax, purchasePrice: $purchasePrice, maximumRetailPrice: $maximumRetailPrice, consignmentId: $consignmentId, branchId: $branchId, isBonusProduct: $isBonusProduct, tagPrice: $tagPrice, totalSavedAmount: $totalSavedAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is POSInvoiceDetailModel &&
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
        other.totalSavedAmount == totalSavedAmount;
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
        totalSavedAmount.hashCode;
  }

  List<POSInvoiceDetailModel> FromJson(String str) => List<POSInvoiceDetailModel>.from(json.decode(str).map((x) => POSInvoiceDetailModel().fromJson(x)));

  String ToJson(List<POSInvoiceDetailModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
