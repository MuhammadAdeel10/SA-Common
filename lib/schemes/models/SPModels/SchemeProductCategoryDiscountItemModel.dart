import 'dart:convert';
import 'package:sa_common/utils/Enums.dart';

class SchemeProductCategoryDiscountItemModel {
  int? SchemeId;
  int? SchemeDetailId;
  int? DiscountId;
  num? DiscountRate;
  DiscountEffectTypes? DiscountEffect;
  int? ProductCategoryId;
  num DiscountAmount;
  num DiscountProductQuantity;
  SchemeProductCategoryDiscountItemModel(
      {this.SchemeId,
      this.SchemeDetailId,
      this.DiscountId,
      this.DiscountRate,
      this.DiscountEffect,
      this.ProductCategoryId,
      this.DiscountAmount = 0,
      this.DiscountProductQuantity = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'SchemeId': SchemeId,
      'SchemeDetailId': SchemeDetailId,
      'DiscountId': DiscountId,
      'DiscountRate': DiscountRate,
      'DiscountEffect': DiscountEffect,
      'ProductCategoryId': ProductCategoryId,
      'DiscountAmount': DiscountAmount,
      'DiscountProductQuantity': DiscountProductQuantity,
    };
  }

  factory SchemeProductCategoryDiscountItemModel.fromMap(
      Map<String, dynamic> map) {
    return SchemeProductCategoryDiscountItemModel(
      SchemeId: map['SchemeId']?.toInt(),
      SchemeDetailId: map['SchemeDetailId']?.toInt(),
      DiscountId: map['DiscountId']?.toInt(),
      DiscountRate: map['DiscountRate'],
      DiscountEffect: map['DiscountEffect'] != null
          ? intToDiscountEffect(map['DiscountEffect'])
          : null,
      ProductCategoryId: map['ProductCategoryId']?.toInt(),
      DiscountAmount: map['DiscountAmount'],
      DiscountProductQuantity: map['DiscountProductQuantity'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeProductCategoryDiscountItemModel.fromJson(String source) =>
      SchemeProductCategoryDiscountItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeProductCategoryDiscountItemModel(SchemeId: $SchemeId, SchemeDetailId: $SchemeDetailId, DiscountId: $DiscountId, DiscountRate: $DiscountRate, DiscountEffect: $DiscountEffect, ProductCategoryId: $ProductCategoryId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeProductCategoryDiscountItemModel &&
        other.SchemeId == SchemeId &&
        other.SchemeDetailId == SchemeDetailId &&
        other.DiscountId == DiscountId &&
        other.DiscountRate == DiscountRate &&
        other.DiscountEffect == DiscountEffect &&
        other.ProductCategoryId == ProductCategoryId;
  }

  @override
  int get hashCode {
    return SchemeId.hashCode ^
        SchemeDetailId.hashCode ^
        DiscountId.hashCode ^
        DiscountRate.hashCode ^
        DiscountEffect.hashCode ^
        ProductCategoryId.hashCode;
  }
}
