import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/cart/model/cart_discount_model.dart';
import 'package:sa_common/schemes/models/invoiceDetailTaxModel.dart';
import 'package:sa_common/utils/Enums.dart';

class CartFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String productName = 'productName';
  static final String description = 'description';
  static final String qty = 'qty';
  static final String price = 'price';
  static final String productId = 'productId';
  static final String grossAmount = 'grossAmount';
  static final String customerId = 'customerId';
  static final String salesPersonId = 'salesPersonId';
  static final String discountInPercent = 'discountInPercent';
  static final String discountInAmount = 'discountInAmount';
  static final String discountType = 'discountType';
  static final String isAppliedScheme = 'isAppliedScheme';
  static final String isProductScheme = 'isProductScheme';
  static final String pOSCashRegisterId = 'POSCashRegisterId';
  static final String fractionalUnit = 'fractionalUnit';
  static final String netAmount = 'netAmount';
  static final String batchId = 'batchId';
  static final String serialNumber = 'serialNumber';
  static final String totalTaxAmonut = 'totalTaxAmonut';
  static final String purchasePrice = 'purchasePrice';
  static final String maximumRetailPrice = 'maximumRetailPrice';
  static final String isMRPExclusiveTax = 'isMRPExclusiveTax';
  static final String isNew = 'isNew';
}

class CartModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  String productName;
  String? description;
  num qty;
  num price;
  int? productId;
  num grossAmount;
  int? customerId;
  int? salesPersonId;
  num? discountInPercent;
  num? discountInAmount;
  DiscountType? discountType;
  bool isAppliedScheme;
  bool isProductScheme;
  int? pOSCashRegisterId;
  bool fractionalUnit;
  num netAmount;
  int? batchId;
  String? serialNumber;
  num? totalTaxAmonut;
  num purchasePrice;
  num maximumRetailPrice;
  bool? isMRPExclusiveTax;
  List<CartDiscountModel>? cartDiscounts;
  List<LineItemTaxModel>? cartTaxes;
  bool? isNew;

  CartModel(
      {this.id,
      this.companySlug,
      this.purchasePrice = 0.00,
      this.maximumRetailPrice = 0.00,
      this.isMRPExclusiveTax,
      this.productName = "",
      this.description,
      this.qty = 0,
      this.price = 0,
      this.productId,
      this.grossAmount = 0,
      this.customerId,
      this.cartTaxes,
      this.salesPersonId,
      this.discountInPercent,
      this.discountInAmount,
      this.discountType,
      this.isAppliedScheme = false,
      this.isProductScheme = false,
      this.cartDiscounts,
      this.pOSCashRegisterId,
      this.netAmount = 0,
      this.fractionalUnit = false,
      this.batchId,
      this.serialNumber,
      this.isNew = false,
      this.totalTaxAmonut});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'productName': productName,
      'description': description,
      'qty': qty,
      'price': price,
      'productId': productId,
      'grossAmount': grossAmount,
      'netAmount': netAmount,
      'customerId': customerId,
      'salesPersonId': salesPersonId,
      'discountInPercent': discountInPercent,
      'discountInAmount': discountInAmount,
      'discountType': discountType?.value,
      'purchasePrice': purchasePrice,
      'maximumRetailPrice': maximumRetailPrice,
      'isMRPExclusiveTax': isMRPExclusiveTax == true ? 1 : 0,
      'isAppliedScheme': isAppliedScheme == true ? 1 : 0,
      'isProductScheme': isProductScheme == true ? 1 : 0,
      'pOSCashRegisterId': pOSCashRegisterId,
      'fractionalUnit': fractionalUnit == true ? 1 : 0,
      'batchId': batchId,
      'isNew' : isNew == true ? 1 : 0,
      'serialNumber': serialNumber,
      'totalTaxAmonut': totalTaxAmonut,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return CartModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      productName: map['productName'] ?? '',
      description: map['description'] ?? '',
      qty: map['qty'] ?? 0,
      price: map['price'] ?? 0,
      productId: map['productId']?.toInt() ?? 0,
      grossAmount: map['grossAmount'] ?? 0,
      netAmount: map['netAmount'] ?? 0,
      purchasePrice: map['purchasePrice']?.toDouble() ?? 0.0,
      maximumRetailPrice: map['maximumRetailPrice']?.toDouble() ?? 0.0,
      isMRPExclusiveTax: map['isMRPExclusiveTax'] == 0 ? false : true,
      customerId: map['customerId'],
      serialNumber: map['serialNumber'],
      batchId: map['batchId'],
      salesPersonId: map['salesPersonId'],
      cartTaxes: map['cartTaxes'] != null ? List<LineItemTaxModel>.from(map['cartTaxes']?.map((x) => LineItemTaxModel.fromMap(x))) : null,
      discountInPercent: map['discountInPercent']?.toDouble(),
      discountInAmount: map['discountInAmount']?.toDouble(),
      pOSCashRegisterId: map['pOSCashRegisterId']?.toInt(),
      totalTaxAmonut: map['totalTaxAmonut'] ?? 0,
      isAppliedScheme: map['isAppliedScheme'] == 0 || map['isAppliedScheme'] == false ? false : true,
      isProductScheme: map['isProductScheme'] == 0 || map['isProductScheme'] == false ? false : true,
      discountType: map['discountType'] != null ? intDiscountType(map['discountType']) : null,
      cartDiscounts: map['cartDiscounts'] != null ? List<CartDiscountModel>.from(map['cartDiscounts']?.map((x) => CartDiscountModel.fromMap(x))) : null,
      fractionalUnit: map['fractionalUnit'] == 0 || map['fractionalUnit'] == false ? false : true,
      isNew: map['isNew'] == 0 || map['isNew'] == false ? false : true,
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CartModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<CartModel> FromJson(String str, String slug) => List<CartModel>.from(json.decode(str).map((x) => CartModel(cartDiscounts: []).fromJson(x, slug: slug)));

  String ToJson(List<CartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
