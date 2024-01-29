import 'dart:convert';

class SchemeProductCategoryDiscountParamsModel {
  int? productCategoryId;
  int? currencyId;
  DateTime? date;
  int? branchId;
  int? customerCategoryId;
  int? customerId;
  num? quantity;
  int? regionId;
  int? zoneId;
  int? territoryId;
  int? areaId;
  int? subAreaId;

  SchemeProductCategoryDiscountParamsModel({
    this.productCategoryId,
    this.currencyId,
    this.date,
    this.branchId,
    this.customerCategoryId,
    this.customerId,
    this.quantity,
    this.regionId,
    this.zoneId,
    this.territoryId,
    this.areaId,
    this.subAreaId,
  });

  SchemeProductCategoryDiscountParamsModel copyWith({
    int? productCategoryId,
    int? currencyId,
    DateTime? date,
    int? branchId,
    int? customerCategoryId,
    int? customerId,
    num? quantity,
    int? regionId,
    int? zoneId,
    int? territoryId,
    int? areaId,
    int? subAreaId,
  }) {
    return SchemeProductCategoryDiscountParamsModel(
      productCategoryId: productCategoryId ?? this.productCategoryId,
      currencyId: currencyId ?? this.currencyId,
      date: date ?? this.date,
      branchId: branchId ?? this.branchId,
      customerCategoryId: customerCategoryId ?? this.customerCategoryId,
      customerId: customerId ?? this.customerId,
      quantity: quantity ?? this.quantity,
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
      territoryId: territoryId ?? this.territoryId,
      areaId: areaId ?? this.areaId,
      subAreaId: subAreaId ?? this.subAreaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productCategoryId': productCategoryId,
      'currencyId': currencyId,
      'date': date?.toIso8601String(),
      'branchId': branchId,
      'customerCategoryId': customerCategoryId,
      'customerId': customerId,
      'quantity': quantity,
      'regionId': regionId,
      'zoneId': zoneId,
      'territoryId': territoryId,
      'areaId': areaId,
      'subAreaId': subAreaId,
    };
  }

  factory SchemeProductCategoryDiscountParamsModel.fromMap(
      Map<String, dynamic> map) {
    return SchemeProductCategoryDiscountParamsModel(
      productCategoryId: map['productCategoryId']?.toInt(),
      currencyId: map['currencyId']?.toInt(),
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      branchId: map['branchId']?.toInt(),
      customerCategoryId: map['customerCategoryId']?.toInt(),
      customerId: map['customerId']?.toInt(),
      quantity: map['quantity'],
      regionId: map['regionId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
      territoryId: map['territoryId']?.toInt(),
      areaId: map['areaId']?.toInt(),
      subAreaId: map['subAreaId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeProductCategoryDiscountParamsModel.fromJson(String source) =>
      SchemeProductCategoryDiscountParamsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeProductCategoryDiscountParamsModel(productCategoryId: $productCategoryId, currencyId: $currencyId, date: $date, branchId: $branchId, customerCategoryId: $customerCategoryId, customerId: $customerId, quantity: $quantity, regionId: $regionId, zoneId: $zoneId, territoryId: $territoryId, areaId: $areaId, subAreaId: $subAreaId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeProductCategoryDiscountParamsModel &&
        other.productCategoryId == productCategoryId &&
        other.currencyId == currencyId &&
        other.date == date &&
        other.branchId == branchId &&
        other.customerCategoryId == customerCategoryId &&
        other.customerId == customerId &&
        other.quantity == quantity &&
        other.regionId == regionId &&
        other.zoneId == zoneId &&
        other.territoryId == territoryId &&
        other.areaId == areaId &&
        other.subAreaId == subAreaId;
  }

  @override
  int get hashCode {
    return productCategoryId.hashCode ^
        currencyId.hashCode ^
        date.hashCode ^
        branchId.hashCode ^
        customerCategoryId.hashCode ^
        customerId.hashCode ^
        quantity.hashCode ^
        regionId.hashCode ^
        zoneId.hashCode ^
        territoryId.hashCode ^
        areaId.hashCode ^
        subAreaId.hashCode;
  }
}
