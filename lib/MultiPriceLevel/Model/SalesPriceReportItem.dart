class SalePriceReportItem {
  final int productId;
  final int salePricingId;
  final double price;

  SalePriceReportItem({
    required this.productId,
    required this.salePricingId,
    required this.price,
  });

  factory SalePriceReportItem.fromMap(Map<String, dynamic> map) {
    return SalePriceReportItem(
      productId: map['productId'] ?? 0,
      salePricingId: map['salePricingId'] ?? 0,
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'salePricingId': salePricingId,
      'price': price,
    };
  }
}
