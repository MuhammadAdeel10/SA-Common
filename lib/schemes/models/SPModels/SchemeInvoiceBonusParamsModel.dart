import 'dart:convert';

class SchemeInvoiceBonusParams {
  DateTime? date;
  int? branchId;
  int? customerCategoryId;
  int? customerId;
  num? amount;
  int? regionId;
  int? zoneId;
  int? territoryId;
  int? areaId;
  int? subAreaId;
  SchemeInvoiceBonusParams({
    this.date,
    this.branchId,
    this.customerCategoryId,
    this.customerId,
    this.amount,
    this.regionId,
    this.zoneId,
    this.territoryId,
    this.areaId,
    this.subAreaId,
  });

  SchemeInvoiceBonusParams copyWith({
    DateTime? date,
    int? branchId,
    int? customerCategoryId,
    int? customerId,
    num? amount,
    int? regionId,
    int? zoneId,
    int? territoryId,
    int? areaId,
    int? subAreaId,
  }) {
    return SchemeInvoiceBonusParams(
      date: date ?? this.date,
      branchId: branchId ?? this.branchId,
      customerCategoryId: customerCategoryId ?? this.customerCategoryId,
      customerId: customerId ?? this.customerId,
      amount: amount ?? this.amount,
      regionId: regionId ?? this.regionId,
      zoneId: zoneId ?? this.zoneId,
      territoryId: territoryId ?? this.territoryId,
      areaId: areaId ?? this.areaId,
      subAreaId: subAreaId ?? this.subAreaId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date?.toIso8601String(),
      'branchId': branchId,
      'customerCategoryId': customerCategoryId,
      'customerId': customerId,
      'amount': amount,
      'regionId': regionId,
      'zoneId': zoneId,
      'territoryId': territoryId,
      'areaId': areaId,
      'subAreaId': subAreaId,
    };
  }

  factory SchemeInvoiceBonusParams.fromMap(Map<String, dynamic> map) {
    return SchemeInvoiceBonusParams(
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      branchId: map['branchId']?.toInt(),
      customerCategoryId: map['customerCategoryId']?.toInt(),
      customerId: map['customerId']?.toInt(),
      amount: map['amount'],
      regionId: map['regionId']?.toInt(),
      zoneId: map['zoneId']?.toInt(),
      territoryId: map['territoryId']?.toInt(),
      areaId: map['areaId']?.toInt(),
      subAreaId: map['subAreaId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeInvoiceBonusParams.fromJson(String source) =>
      SchemeInvoiceBonusParams.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeInvoiceBonusParams(date: $date, branchId: $branchId, customerCategoryId: $customerCategoryId, customerId: $customerId, amount: $amount, regionId: $regionId, zoneId: $zoneId, territoryId: $territoryId, areaId: $areaId, subAreaId: $subAreaId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeInvoiceBonusParams &&
        other.date == date &&
        other.branchId == branchId &&
        other.customerCategoryId == customerCategoryId &&
        other.customerId == customerId &&
        other.amount == amount &&
        other.regionId == regionId &&
        other.zoneId == zoneId &&
        other.territoryId == territoryId &&
        other.areaId == areaId &&
        other.subAreaId == subAreaId;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        branchId.hashCode ^
        customerCategoryId.hashCode ^
        customerId.hashCode ^
        amount.hashCode ^
        regionId.hashCode ^
        zoneId.hashCode ^
        territoryId.hashCode ^
        areaId.hashCode ^
        subAreaId.hashCode;
  }
}
