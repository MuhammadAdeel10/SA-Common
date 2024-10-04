class SchemesViewModel {
  int? id;
  String? name;
  int? schemeTypeId;
  int? schemeProductId;
  int? schemeProductCategoryId;
  num? discountProductQuantity;
  num? productDiscountRate;
  num? productDiscountAmount;
  num? invoiceAmount;
  num? bonusAmount;
  num? discountRate;
  int? bounsProductId;
  num? schemeBounsQuantity;
  num? bounsProductQuantity;
  num? bonusProductPrice;
  num? schemeProductQuantity;

  SchemesViewModel({this.id, this.name, this.schemeTypeId, this.bonusProductPrice, this.bounsProductId, this.discountProductQuantity, this.discountRate, this.schemeProductCategoryId, this.invoiceAmount, this.productDiscountAmount, this.productDiscountRate, this.schemeBounsQuantity, this.schemeProductId, this.schemeProductQuantity, this.bonusAmount, this.bounsProductQuantity});

  factory SchemesViewModel.fromMap(Map<String, dynamic> map) {
    return SchemesViewModel(
      id: map['id']?.toInt() ?? 0,
      name: map['name'] ?? '',
      schemeTypeId: map['schemeTypeId']?.toInt(),
      bonusProductPrice: map['bonusProductPrice'],
      bounsProductId: map['bounsProductId']?.toInt(),
      discountProductQuantity: map['discountProductQuantity'],
      discountRate: map['discountRate'],
      invoiceAmount: map['invoiceAmount'],
      bonusAmount: map['bounsAmount'],
      productDiscountAmount: map['productDiscountAmount'],
      productDiscountRate: map['productDiscountRate'],
      schemeBounsQuantity: map['schemeBounsQuantity'],
      schemeProductQuantity: map['schemeProductQuantity'],
      bounsProductQuantity: map['bounsProductQuantity'],
      schemeProductId: map['schemeProductId']?.toInt(),
      schemeProductCategoryId: map['schemeProductCategoryId']?.toInt(),
    );
  }
}
