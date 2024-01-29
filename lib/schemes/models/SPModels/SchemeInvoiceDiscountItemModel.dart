import 'dart:convert';
import '../../../utils/Enums.dart';

class SchemeInvoiceDiscountItem {
  int? SchemeId;
  int? SchemeDetailId;
  num? InvoiceAmount;
  num? DiscountRate;
  int? DiscountId;
  DiscountEffectTypes? DiscountEffect;
  SchemeInvoiceDiscountItem({
    this.SchemeId,
    this.SchemeDetailId,
    this.InvoiceAmount,
    this.DiscountRate,
    this.DiscountId,
    this.DiscountEffect,
  });

  SchemeInvoiceDiscountItem copyWith({
    int? SchemeId,
    int? SchemeDetailId,
    num? InvoiceAmount,
    num? DiscountRate,
    int? DiscountId,
    DiscountEffectTypes? DiscountEffect,
  }) {
    return SchemeInvoiceDiscountItem(
      SchemeId: SchemeId ?? this.SchemeId,
      SchemeDetailId: SchemeDetailId ?? this.SchemeDetailId,
      InvoiceAmount: InvoiceAmount ?? this.InvoiceAmount,
      DiscountRate: DiscountRate ?? this.DiscountRate,
      DiscountId: DiscountId ?? this.DiscountId,
      DiscountEffect: DiscountEffect ?? this.DiscountEffect,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SchemeId': SchemeId,
      'SchemeDetailId': SchemeDetailId,
      'InvoiceAmount': InvoiceAmount,
      'DiscountRate': DiscountRate,
      'DiscountId': DiscountId,
      'DiscountEffect': DiscountEffect,
    };
  }

  factory SchemeInvoiceDiscountItem.fromMap(Map<String, dynamic> map) {
    return SchemeInvoiceDiscountItem(
      SchemeId: map['SchemeId']?.toInt(),
      SchemeDetailId: map['SchemeDetailId']?.toInt(),
      InvoiceAmount: map['InvoiceAmount'],
      DiscountRate: map['DiscountRate'],
      DiscountId: map['DiscountId']?.toInt(),
      DiscountEffect: map['DiscountEffect'] != null
          ? intToDiscountEffect(map['DiscountEffect'])
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeInvoiceDiscountItem.fromJson(String source) =>
      SchemeInvoiceDiscountItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeInvoiceDiscountItem(SchemeId: $SchemeId, SchemeDetailId: $SchemeDetailId, InvoiceAmount: $InvoiceAmount, DiscountRate: $DiscountRate, DiscountId: $DiscountId, DiscountEffect: $DiscountEffect)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeInvoiceDiscountItem &&
        other.SchemeId == SchemeId &&
        other.SchemeDetailId == SchemeDetailId &&
        other.InvoiceAmount == InvoiceAmount &&
        other.DiscountRate == DiscountRate &&
        other.DiscountId == DiscountId &&
        other.DiscountEffect == DiscountEffect;
  }

  @override
  int get hashCode {
    return SchemeId.hashCode ^
        SchemeDetailId.hashCode ^
        InvoiceAmount.hashCode ^
        DiscountRate.hashCode ^
        DiscountId.hashCode ^
        DiscountEffect.hashCode;
  }
}
