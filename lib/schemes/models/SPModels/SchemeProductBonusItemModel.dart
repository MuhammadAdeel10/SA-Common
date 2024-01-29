import 'dart:convert';

class SchemeProductBonusItemModel {
  int? SchemeId;
  int? SchemeDetailId;
  int? ProductId;
  String? ProductName;
  num? ProductQuantity;
  num? Quantity;
  num? ProductPrice;

  SchemeProductBonusItemModel({
    this.SchemeId,
    this.SchemeDetailId,
    this.ProductId,
    this.ProductName,
    this.ProductQuantity,
    this.Quantity,
    this.ProductPrice,
  });

  SchemeProductBonusItemModel copyWith({
    int? SchemeId,
    int? SchemeDetailId,
    int? ProductId,
    String? ProductName,
    num? ProductQuantity,
    num? Quantity,
    num? ProductPrice,
  }) {
    return SchemeProductBonusItemModel(
      SchemeId: SchemeId ?? this.SchemeId,
      SchemeDetailId: SchemeDetailId ?? this.SchemeDetailId,
      ProductId: ProductId ?? this.ProductId,
      ProductName: ProductName ?? this.ProductName,
      ProductQuantity: ProductQuantity ?? this.ProductQuantity,
      Quantity: Quantity ?? this.Quantity,
      ProductPrice: ProductPrice ?? this.ProductPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'SchemeId': SchemeId,
      'SchemeDetailId': SchemeDetailId,
      'ProductId': ProductId,
      'ProductName': ProductName,
      'ProductQuantity': ProductQuantity,
      'Quantity': Quantity,
      'ProductPrice': ProductPrice,
    };
  }

  factory SchemeProductBonusItemModel.fromMap(Map<String, dynamic> map) {
    return SchemeProductBonusItemModel(
      SchemeId: map['SchemeId']?.toInt(),
      SchemeDetailId: map['SchemeDetailId']?.toInt(),
      ProductId: map['ProductId']?.toInt(),
      ProductName: map['ProductName'],
      ProductQuantity: map['ProductQuantity'],
      Quantity: map['Quantity'],
      ProductPrice: map['ProductPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeProductBonusItemModel.fromJson(String source) =>
      SchemeProductBonusItemModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeProductBonusItemModel(SchemeId: $SchemeId, SchemeDetailId: $SchemeDetailId, ProductId: $ProductId, ProductName: $ProductName, ProductQuantity: $ProductQuantity, Quantity: $Quantity, ProductPrice: $ProductPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeProductBonusItemModel &&
        other.SchemeId == SchemeId &&
        other.SchemeDetailId == SchemeDetailId &&
        other.ProductId == ProductId &&
        other.ProductName == ProductName &&
        other.ProductQuantity == ProductQuantity &&
        other.Quantity == Quantity &&
        other.ProductPrice == ProductPrice;
  }

  @override
  int get hashCode {
    return SchemeId.hashCode ^
        SchemeDetailId.hashCode ^
        ProductId.hashCode ^
        ProductName.hashCode ^
        ProductQuantity.hashCode ^
        Quantity.hashCode ^
        ProductPrice.hashCode;
  }
}
