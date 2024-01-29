import 'dart:convert';

class SchemeInvoiceBonusItem {
  int? SchemeId;
  int? SchemeDetailId;
  int? ProductId;
  String? ProductName;
  num? Quantity;
  num? ProductPrice;
  SchemeInvoiceBonusItem({
    this.SchemeId,
    this.SchemeDetailId,
    this.ProductId,
    this.ProductName,
    this.Quantity,
    this.ProductPrice,
  });

  SchemeInvoiceBonusItem copyWith({
    int? SchemeId,
    int? SchemeDetailId,
    int? ProductId,
    String? ProductName,
    num? Quantity,
    num? ProductPrice,
  }) {
    return SchemeInvoiceBonusItem(
      SchemeId: SchemeId ?? this.SchemeId,
      SchemeDetailId: SchemeDetailId ?? this.SchemeDetailId,
      ProductId: ProductId ?? this.ProductId,
      ProductName: ProductName ?? this.ProductName,
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
      'Quantity': Quantity,
      'ProductPrice': ProductPrice,
    };
  }

  factory SchemeInvoiceBonusItem.fromMap(Map<String, dynamic> map) {
    return SchemeInvoiceBonusItem(
      SchemeId: map['SchemeId']?.toInt(),
      SchemeDetailId: map['SchemeDetailId']?.toInt(),
      ProductId: map['ProductId']?.toInt(),
      ProductName: map['ProductName'],
      Quantity: map['Quantity'],
      ProductPrice: map['ProductPrice'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeInvoiceBonusItem.fromJson(String source) =>
      SchemeInvoiceBonusItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemeInvoiceBonusItem(SchemeId: $SchemeId, SchemeDetailId: $SchemeDetailId, ProductId: $ProductId, ProductName: $ProductName, Quantity: $Quantity, ProductPrice: $ProductPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeInvoiceBonusItem &&
        other.SchemeId == SchemeId &&
        other.SchemeDetailId == SchemeDetailId &&
        other.ProductId == ProductId &&
        other.ProductName == ProductName &&
        other.Quantity == Quantity &&
        other.ProductPrice == ProductPrice;
  }

  @override
  int get hashCode {
    return SchemeId.hashCode ^
        SchemeDetailId.hashCode ^
        ProductId.hashCode ^
        ProductName.hashCode ^
        Quantity.hashCode ^
        ProductPrice.hashCode;
  }
}
