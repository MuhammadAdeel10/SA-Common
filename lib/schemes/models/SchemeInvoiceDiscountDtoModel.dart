import 'dart:convert';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/utils/Enums.dart';

class SchemeInvoiceDiscountDto {
  int? Id;
  int? sourceId;
  num? discountAmount;
  num? discountPercent;
  DiscountAppliedOn appliedOn;
  int? sort;
  DiscountInvoiceType discountType;
  int? discountId;
  DiscountModel? discount;
  int? schemeId;
  SchemeInvoiceDiscountDto({
    this.Id,
    this.sourceId,
    this.discountAmount,
    this.discountPercent,
    this.appliedOn = DiscountAppliedOn.GrossAmount,
    this.sort,
    this.discountType = DiscountInvoiceType.Scheme,
    this.discountId,
    this.discount,
    this.schemeId,
  });

  SchemeInvoiceDiscountDto copyWith({
    int? Id,
    int? sourceId,
    num? discountAmount,
    num? discountPercent,
    DiscountAppliedOn? appliedOn,
    int? sort,
    DiscountInvoiceType? discountType,
    int? discountId,
    DiscountModel? discount,
    int? schemeId,
  }) {
    return SchemeInvoiceDiscountDto(
      Id: Id ?? this.Id,
      sourceId: sourceId ?? this.sourceId,
      discountAmount: discountAmount ?? this.discountAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      appliedOn: appliedOn ?? this.appliedOn,
      sort: sort ?? this.sort,
      discountType: discountType ?? this.discountType,
      discountId: discountId ?? this.discountId,
      discount: discount ?? this.discount,
      schemeId: schemeId ?? this.schemeId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': Id,
      'sourceId': sourceId,
      'discountAmount': discountAmount,
      'discountPercent': discountPercent,
      'appliedOn': appliedOn.value,
      'sort': sort,
      'discountType': discountType.value,
      'discountId': discountId,
      'schemeId': schemeId,
    };
  }

  factory SchemeInvoiceDiscountDto.fromMap(Map<String, dynamic> map) {
    return SchemeInvoiceDiscountDto(
      Id: map['Id']?.toInt(),
      sourceId: map['sourceId']?.toInt(),
      discountAmount: map['discountAmount'],
      discountPercent: map['discountPercent'],
      appliedOn: intToDiscountAppliedOn((map['appliedOn']) ?? 10),
      sort: map['sort']?.toInt(),
      discountType: intToDiscountInvoiceType((map['discountType']) ?? 1),
      discountId: map['discountId']?.toInt(),
      discount: map['discount'] != null
          ? DiscountModel.fromMap(map['discount'])
          : null,
      schemeId: map['schemeId']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeInvoiceDiscountDto.fromJson(String source) =>
      SchemeInvoiceDiscountDto.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeInvoiceDiscountDto(Id: $Id, sourceId: $sourceId, discountAmount: $discountAmount, discountPercent: $discountPercent, appliedOn: $appliedOn, sort: $sort, discountType: $discountType, discountId: $discountId, discount: $discount, schemeId: $schemeId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeInvoiceDiscountDto &&
        other.Id == Id &&
        other.sourceId == sourceId &&
        other.discountAmount == discountAmount &&
        other.discountPercent == discountPercent &&
        other.appliedOn == appliedOn &&
        other.sort == sort &&
        other.discountType == discountType &&
        other.discountId == discountId &&
        other.discount == discount &&
        other.schemeId == schemeId;
  }

  @override
  int get hashCode {
    return Id.hashCode ^
        sourceId.hashCode ^
        discountAmount.hashCode ^
        discountPercent.hashCode ^
        appliedOn.hashCode ^
        sort.hashCode ^
        discountType.hashCode ^
        discountId.hashCode ^
        discount.hashCode ^
        schemeId.hashCode;
  }
}
