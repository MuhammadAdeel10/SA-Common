import 'dart:convert';
import 'package:sa_common/utils/Enums.dart';

class CartDiscountViewModel {
  int id;
  String companySlug;
  int discountId;
  num? discountInAmount;
  num? discountInPercent;
  String name;
  String abbreviation;
  DiscountType? discountType;
  int? schemeId;
  int? schemeDetailId;
  CartDiscountViewModel({this.id = 0, this.companySlug = "", this.discountId = 0, this.discountInAmount, this.discountInPercent, this.name = "", this.abbreviation = "", this.discountType, this.schemeDetailId, this.schemeId});
  CartDiscountViewModel copyWith({
    int? id,
    String? companySlug,
    int? discountId,
    int? discountInAmount,
    int? discountInPercent,
    String? name,
    String? abbreviation,
    DiscountType? discountType,
  }) {
    return CartDiscountViewModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      discountId: discountId ?? this.discountId,
      discountInAmount: discountInAmount ?? this.discountInAmount,
      discountInPercent: discountInPercent ?? this.discountInPercent,
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      discountType: discountType ?? this.discountType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'discountId': discountId,
      'discountInAmount': discountInAmount,
      'discountInPercent': discountInPercent,
      'name': name,
      'abbreviation': abbreviation,
      'discountType': discountType,
      'schemeId': schemeId,
      'schemeDetailId': schemeDetailId,
    };
  }

  factory CartDiscountViewModel.fromMap(Map<String, dynamic> map) {
    return CartDiscountViewModel(
      id: map['id']?.toInt() ?? 0,
      companySlug: map['companySlug'] ?? '',
      discountId: map['discountId']?.toInt() ?? 0,
      discountInAmount: map['discountInAmount']?.toInt(),
      discountInPercent: map['discountInPercent']?.toInt(),
      schemeDetailId: map['schemeDetailId']?.toInt(),
      schemeId: map['schemeId']?.toInt(),
      name: map['name'] ?? '',
      abbreviation: map['abbreviation'] ?? '',
      discountType: map['discountType'] != null ? intDiscountType(map['discountType']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartDiscountViewModel.fromJson(String source) => CartDiscountViewModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CartDiscountViewModel(id: $id, companySlug: $companySlug, discountId: $discountId, discountInAmount: $discountInAmount, discountInPercent: $discountInPercent, name: $name, abbreviation: $abbreviation, discountType: $discountType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CartDiscountViewModel && other.id == id && other.companySlug == companySlug && other.discountId == discountId && other.discountInAmount == discountInAmount && other.discountInPercent == discountInPercent && other.name == name && other.abbreviation == abbreviation && other.discountType == discountType;
  }

  @override
  int get hashCode {
    return id.hashCode ^ companySlug.hashCode ^ discountId.hashCode ^ discountInAmount.hashCode ^ discountInPercent.hashCode ^ name.hashCode ^ abbreviation.hashCode ^ discountType.hashCode;
  }

  List<CartDiscountViewModel> FromJson(String str) => List<CartDiscountViewModel>.from(json.decode(str).map((x) => CartDiscountViewModel.fromMap(x)));

  String ToJson(List<CartDiscountViewModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
