import 'dart:convert';

class SchemeProductBonusParamsModel {
  int? productId;
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

  SchemeProductBonusParamsModel({
    this.productId,
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

  SchemeProductBonusParamsModel copyWith({
    int? productId,
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
    return SchemeProductBonusParamsModel(
      productId: productId ?? this.productId,
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
      'productId': productId,
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

  factory SchemeProductBonusParamsModel.fromMap(Map<String, dynamic> map) {
    return SchemeProductBonusParamsModel(
      productId: map['productId']?.toInt(),
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

  factory SchemeProductBonusParamsModel.fromJson(String source) =>
      SchemeProductBonusParamsModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeProductBonusParamsModel(productId: $productId, currencyId: $currencyId, date: $date, branchId: $branchId, customerCategoryId: $customerCategoryId, customerId: $customerId, quantity: $quantity, regionId: $regionId, zoneId: $zoneId, territoryId: $territoryId, areaId: $areaId, subAreaId: $subAreaId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeProductBonusParamsModel &&
        other.productId == productId &&
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
    return productId.hashCode ^
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
