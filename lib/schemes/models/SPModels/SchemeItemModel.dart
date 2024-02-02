import 'dart:convert';
import 'package:sa_common/utils/Enums.dart';

class SchemeItemModel {
  int? SchemeId;
  int? SchemeDetailId;
  int? DiscountId;
  double? DiscountRate;
  DiscountEffectTypes? DiscountEffect;
  double DiscountAmount;
  double DiscountProductQuantity;

  SchemeItemModel({this.SchemeId, this.SchemeDetailId, this.DiscountId, this.DiscountRate, this.DiscountEffect, this.DiscountAmount = 0, this.DiscountProductQuantity = 0.0});

  Map<String, dynamic> toMap() {
    return {'SchemeId': SchemeId, 'SchemeDetailId': SchemeDetailId, 'DiscountId': DiscountId, 'DiscountRate': DiscountRate, 'DiscountEffect': DiscountEffect, 'DiscountAmount': DiscountAmount, 'DiscountProductQuantity': DiscountProductQuantity};
  }

  factory SchemeItemModel.fromMap(Map<String, dynamic> map) {
    return SchemeItemModel(
      SchemeId: map['SchemeId']?.toInt(),
      SchemeDetailId: map['SchemeDetailId']?.toInt(),
      DiscountId: map['DiscountId']?.toInt(),
      DiscountRate: map['DiscountRate'],
      DiscountEffect: map['DiscountEffect'] != null ? intToDiscountEffect(map['DiscountEffect']) : null,
      DiscountAmount: map['DiscountAmount'] ?? 0.0,
      DiscountProductQuantity: map['DiscountProductQuantity'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeItemModel.fromJson(String source) => SchemeItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeItemModel(SchemeId: $SchemeId, SchemeDetailId: $SchemeDetailId, DiscountId: $DiscountId, DiscountRate: $DiscountRate, DiscountEffect: $DiscountEffect)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeItemModel && other.SchemeId == SchemeId && other.SchemeDetailId == SchemeDetailId && other.DiscountId == DiscountId && other.DiscountRate == DiscountRate && other.DiscountEffect == DiscountEffect;
  }

  @override
  int get hashCode {
    return SchemeId.hashCode ^ SchemeDetailId.hashCode ^ DiscountId.hashCode ^ DiscountRate.hashCode ^ DiscountEffect.hashCode;
  }
}
