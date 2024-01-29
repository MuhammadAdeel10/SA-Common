import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';
import 'cart_discount_model.dart';

class CartFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String productName = 'productName';
  static final String qty = 'qty';
  static final String price = 'price';
  static final String productId = 'productId';
  static final String screenType = 'screenType';
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
}

class CartModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;

  String productName;
  num qty;
  num price;
  int? productId;
  num screenType;
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
  List<CartDiscountModel>? cartDiscounts;
  CartModel(
      {this.id,
      this.companySlug,
      this.productName = "",
      this.qty = 0,
      this.price = 0,
      this.productId,
      this.screenType = 0,
      this.grossAmount = 0,
      this.customerId,
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
      this.totalTaxAmonut});

  CartModel copyWith(
      {int? id,
      String? companySlug,
      String? productName,
      num? qty,
      num? price,
      int? productId,
      num? screenType,
      num? grossAmount,
      int? customerId,
      int? salesPersonId,
      num? discountInPercent,
      num? discountInAmount,
      DiscountType? discountType,
      bool? isAppliedScheme,
      bool? isProductScheme,
      List<CartDiscountModel>? cartDiscounts}) {
    return CartModel(
        id: id ?? this.id,
        companySlug: companySlug ?? this.companySlug,
        productName: productName ?? this.productName,
        qty: qty ?? this.qty,
        price: price ?? this.price,
        productId: productId ?? this.productId,
        screenType: screenType ?? this.screenType,
        grossAmount: grossAmount ?? this.grossAmount,
        customerId: customerId ?? this.customerId,
        salesPersonId: salesPersonId ?? this.customerId,
        discountInPercent: discountInPercent ?? this.discountInPercent,
        discountInAmount: discountInAmount ?? this.discountInAmount,
        discountType: discountType ?? this.discountType,
        isAppliedScheme: isAppliedScheme ?? this.isAppliedScheme,
        isProductScheme: isProductScheme ?? this.isProductScheme,
        cartDiscounts: cartDiscounts ?? this.cartDiscounts);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'productName': productName,
      'qty': qty,
      'price': price,
      'productId': productId,
      'screenType': screenType,
      'grossAmount': grossAmount,
      'netAmount': netAmount,
      'customerId': customerId,
      'salesPersonId': salesPersonId,
      'discountInPercent': discountInPercent,
      'discountInAmount': discountInAmount,
      'discountType': discountType?.value,
      'isAppliedScheme': isAppliedScheme == true ? 1 : 0,
      'isProductScheme': isProductScheme == true ? 1 : 0,
      'pOSCashRegisterId': pOSCashRegisterId,
      'fractionalUnit': fractionalUnit == true ? 1 : 0,
      'batchId': batchId,
      'serialNumber': serialNumber,
      'totalTaxAmonut': totalTaxAmonut,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return CartModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      productName: map['productName'] ?? '',
      qty: map['qty'] ?? 0,
      price: map['price'] ?? 0,
      productId: map['productId']?.toInt() ?? 0,
      screenType: map['screenType'] ?? 0,
      grossAmount: map['grossAmount'] ?? 0,
      netAmount: map['netAmount'] ?? 0,
      customerId: map['customerId'],
      serialNumber: map['serialNumber'],
      batchId: map['batchId'],
      salesPersonId: map['salesPersonId'],
      discountInPercent: map['discountInPercent']?.toInt(),
      discountInAmount: map['discountInAmount']?.toInt(),
      pOSCashRegisterId: map['pOSCashRegisterId']?.toInt(),
      totalTaxAmonut: map['totalTaxAmonut'] ?? 0,
      isAppliedScheme:
          map['isAppliedScheme'] == 0 || map['isAppliedScheme'] == false
              ? false
              : true,
      isProductScheme:
          map['isProductScheme'] == 0 || map['isProductScheme'] == false
              ? false
              : true,
      discountType: map['discountType'] != null
          ? intDiscountType(map['discountType'])
          : null,
      cartDiscounts: map['cartDiscounts'] != null
          ? List<CartDiscountModel>.from(
              map['cartDiscounts']?.map((x) => CartDiscountModel.fromMap(x)))
          : null,
      fractionalUnit:
          map['fractionalUnit'] == 0 || map['fractionalUnit'] == false
              ? false
              : true,
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

  @override
  String toString() {
    return 'CartModel(id: $id, companySlug: $companySlug, productName: $productName, qty: $qty, price: $price, productId: $productId, screenType: $screenType, grossAmount: $grossAmount, customerId: $customerId, salesPersonId: $salesPersonId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.productName == productName &&
        other.qty == qty &&
        other.price == price &&
        other.productId == productId &&
        other.screenType == screenType &&
        other.salesPersonId == salesPersonId &&
        other.customerId == customerId &&
        other.grossAmount == grossAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        productName.hashCode ^
        qty.hashCode ^
        price.hashCode ^
        productId.hashCode ^
        grossAmount.hashCode ^
        customerId.hashCode ^
        salesPersonId.hashCode ^
        screenType.hashCode;
  }

  List<CartModel> FromJson(String str, String slug) => List<CartModel>.from(json
      .decode(str)
      .map((x) => CartModel(cartDiscounts: []).fromJson(x, slug: slug)));

  String ToJson(List<CartModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
