import 'dart:convert';
import 'package:sa_common/utils/Enums.dart';
import '../../Controller/BaseRepository.dart';

class CartDiscountFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String cartId = 'cartId';
  static final String discountId = 'discountId';
  static final String discountInPercent = 'discountInPercent';
  static final String discountInAmount = 'discountInAmount';
  static final String discountType = 'discountType';
  static final String discountAmount = 'discountAmount';
  static final String discountInPrice = 'discountInPrice';
  static final String schemeDetailId = 'schemeDetailId';
  static final String schemeId = 'schemeId';
}

class CartDiscountModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? cartId;
  int discountId;
  num? discountInPercent;
  num? discountInAmount;
  DiscountType? discountType;
  num? discountAmount;
  num? discountInPrice;
  int? schemeId;
  int? schemeDetailId;
  CartDiscountModel(
      {this.id,
      this.companySlug,
      this.cartId,
      this.discountId = 0,
      this.discountInPercent,
      this.discountInAmount,
      this.discountType,
      this.discountInPrice,
      this.discountAmount,
      this.schemeId,
      this.schemeDetailId});
  // @override
  // BaseModel fromJson(Map<String, dynamic> json, {String slug}) {

  //   throw UnimplementedError();
  // }

  // @override
  // Map<String, dynamic> toJson() {

  //   throw UnimplementedError();
  // }

  CartDiscountModel copyWith({
    int? id,
    String? companySlug,
    int? cartId,
    int? discountId,
    num? discountInPercent,
    num? discountInAmount,
    DiscountType? discountType,
  }) {
    return CartDiscountModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      cartId: cartId ?? this.cartId,
      discountId: discountId ?? this.discountId,
      discountInPercent: discountInPercent ?? this.discountInPercent,
      discountInAmount: discountInAmount ?? this.discountInAmount,
      discountType: discountType ?? this.discountType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'cartId': cartId,
      'discountId': discountId,
      'discountInPercent': discountInPercent,
      'discountInAmount': discountInAmount,
      'discountAmount': discountAmount,
      'discountInPrice': discountInPrice,
      'discountType': discountType?.value,
      'schemeId': schemeId,
      'schemeDetailId': schemeDetailId
    };
  }

  factory CartDiscountModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return CartDiscountModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      cartId: map['cartId']?.toInt(),
      discountId: map['discountId']?.toInt() ?? 0,
      discountInPercent: map['discountInPercent'],
      discountInAmount: map['discountInAmount'],
      discountAmount: map['discountAmount'],
      schemeId: map['schemeId'],
      schemeDetailId: map['SchemeDetailId'],
      discountInPrice: map['discountInPrice'],
      discountType: map['discountType'] != null
          ? intDiscountType(map['discountType'])
          : null,
    );
  }

  // @override
  // String toJson() => json.encode(toMap());

  // factory CartDiscountModel.fromJson(String source) =>
  //     CartDiscountModel.fromMap(json.decode(source));
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CartDiscountModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CartDiscountModel(id: $id, companySlug: $companySlug, cartId: $cartId, discountId: $discountId, discountInPercent: $discountInPercent, discountInAmount: $discountInAmount, discountType: $discountType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartDiscountModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.cartId == cartId &&
        other.discountId == discountId &&
        other.discountInPercent == discountInPercent &&
        other.discountInAmount == discountInAmount &&
        other.discountType == discountType;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        cartId.hashCode ^
        discountId.hashCode ^
        discountInPercent.hashCode ^
        discountInAmount.hashCode ^
        discountType.hashCode;
  }

  List<CartDiscountModel> FromJson(String str, String slug) =>
      List<CartDiscountModel>.from(json
          .decode(str)
          .map((x) => CartDiscountModel().fromJson(x, slug: slug)));

  String ToJson(List<CartDiscountModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
