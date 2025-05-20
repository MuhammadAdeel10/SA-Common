import 'dart:convert';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/schemes/models/invoiceDetailTaxModel.dart';

class SaleOrderDetailsModel {
  SaleOrderDetailsModel({
    this.id,
    this.companySlug,
    this.saleOrderId,
    this.productId,
    this.accountId,
    this.description,
    this.quantity,
    this.remainingQuantity,
    this.price,
    this.maximumRetailPrice,
    this.isMRPExclusiveTax,
    this.purchasePrice,
    this.discountInPercent,
    this.discountAmount,
    this.grossAmount,
    this.taxAmount,
    this.netAmount,
    this.quantityCalculation,
    this.taxes,
    this.discounts,
    this.isBonusProduct,
    this.branchId,
  });

  factory SaleOrderDetailsModel.fromJson(String source) => SaleOrderDetailsModel.fromMap(json.decode(source));

  factory SaleOrderDetailsModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SaleOrderDetailsModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      saleOrderId: map['saleOrderId']?.toInt(),
      productId: map['productId']?.toInt(),
      accountId: map['accountId']?.toInt(),
      description: map['description'],
      quantity: map['quantity'],
      remainingQuantity: map['remainingQuantity'],
      price: map['price'],
      maximumRetailPrice: map['maximumRetailPrice'],
      isMRPExclusiveTax: map['isMRPExclusiveTax'] == 1 ? true : false,
      purchasePrice: map['purchasePrice'],
      discountInPercent: map['discountInPercent'],
      discountAmount: map['discountAmount'],
      grossAmount: map['grossAmount'],
      taxAmount: map['taxAmount'],
      netAmount: map['netAmount'],
      quantityCalculation: map['quantityCalculation'],
      taxes: map['taxes'] != null ? List<LineItemTaxModel>.from(map['taxes']?.map((x) => LineItemTaxModel.fromMap(x))) : null,
      discounts: map['discounts'] != null ? List<SaleOrderDiscountsModel>.from(map['discounts']?.map((x) => SaleOrderDiscountsModel.fromMap(x))) : null,
      isBonusProduct: map['isBonusProduct'] == 1 ? true : false,
      branchId: map['branchId']?.toInt(),
    );
  }

  int? accountId;
  int? branchId;
  String? companySlug;
  String? description;
  num? discountAmount;
  num? discountInPercent;
  List<SaleOrderDiscountsModel>? discounts;
  num? grossAmount;
  int? id;
  bool? isBonusProduct;
  bool? isMRPExclusiveTax;
  num? maximumRetailPrice;
  num? netAmount;
  num? price;
  int? productId;
  num? purchasePrice;
  num? quantity;
  String? quantityCalculation;
  num? remainingQuantity;
  int? saleOrderId;
  num? taxAmount;
  List<LineItemTaxModel>? taxes;

  Map<String, dynamic> toMap({bool isLocal = false}) {
    return {
      'id': id,
      'companySlug': companySlug,
      'saleOrderId': saleOrderId,
      'productId': productId,
      'accountId': accountId,
      'description': description,
      'quantity': quantity,
      'remainingQuantity': remainingQuantity,
      'price': price,
      'maximumRetailPrice': maximumRetailPrice,
      'isMRPExclusiveTax': isMRPExclusiveTax,
      'purchasePrice': purchasePrice,
      'discountInPercent': discountInPercent,
      'discountAmount': discountAmount,
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'netAmount': netAmount,
      'quantityCalculation': quantityCalculation,
      if (!isLocal) 'taxes': taxes?.map((x) => x.toMap()).toList(),
      if (!isLocal) 'discounts': discounts?.map((x) => x.toMap()).toList(),
      'isBonusProduct': isBonusProduct,
      'branchId': branchId,
    };
  }

  String toJson() => json.encode(toMap());
}
