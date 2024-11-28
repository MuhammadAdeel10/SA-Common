enum DiscountAppliedOn {
  none(0),
  GrossAmount(10),
  CompoundAmount(20);

  const DiscountAppliedOn(this.value);
  final int value;
}

DiscountAppliedOn intToDiscountAppliedOn(int value) {
  return DiscountAppliedOn.values.firstWhere((element) => element.value == value);
}

enum DiscountType {
  Percent(0),
  Amount(1),
  Price(2);

  const DiscountType(this.value);
  final int value;
}

DiscountType intToDiscountType(int value) {
  return DiscountType.values[value];
}

enum SaleTaxAppliedOn {
  SalePrice(0),
  MaximumRetailPrice(10),
  PurchasePrice(20),
  Compound(100);

  const SaleTaxAppliedOn(this.value);
  final int value;
}

SaleTaxAppliedOn intToSaleTaxAppliedOn(int value) {
  return SaleTaxAppliedOn.values.firstWhere((element) => element.value == value);
}

enum DiscountInvoiceType {
  Normal(0),
  Scheme(1);

  const DiscountInvoiceType(this.value);
  final int value;
}

DiscountInvoiceType intToDiscountInvoiceType(int value) {
  return DiscountInvoiceType.values[value];
}

enum DiscountEffectTypes {
  Append(0),
  Overwrite(1);

  const DiscountEffectTypes(this.value);
  final int value;
}

DiscountEffectTypes intToDiscountEffect(int value) {
  return DiscountEffectTypes.values[value];
}

enum PosPaymentMode {
  Cash(10),
  Card(20),
  CreditNote(30),
  SaleReturn(40),
  ReturnCash(50),
  ReturnCreditNote(60),
  CustomerLoyalty(70);
  //BankTransfer(70);

  const PosPaymentMode(this.value);
  final int value;
}

PosPaymentMode intToPosPaymentMode(int value) {
  return PosPaymentMode.values.firstWhere((element) => element.value == value);
}

enum SaleInvoiceStatus {
  Draft(0),
  Pending(10),
  Approved(20),
  Sent(30),
  PartiallyPaid(40),
  Paid(50),
  Void(60);

  const SaleInvoiceStatus(this.value);
  final int value;
}

SaleInvoiceStatus intToSaleInvoiceStatus(int value) {
  return SaleInvoiceStatus.values.firstWhere((element) => element.value == value);
}

DiscountType intDiscountType(int value) {
  return DiscountType.values[value];
}

enum SaleReturnStatus {
  Draft(0),
  Pending(10),
  Approved(20),
  PartiallyAllocated(25),
  Allocated(27),
  Void(30);

  const SaleReturnStatus(this.value);
  final int value;
}

SaleReturnStatus intToSaleReturnStatus(int value) {
  return SaleReturnStatus.values.firstWhere((element) => element.value == value);
}

enum FundTransferStatus {
  Draft(0),
  Pending(10),
  Approved(20),
  Void(30);

  const FundTransferStatus(this.value);
  final int value;
}

FundTransferStatus intToFundTransferStatus(int value) {
  return FundTransferStatus.values.firstWhere((element) => element.value == value);
}

enum CustomerLoyaltyCalculationType {
  None(0),
  Ceiling(10),
  Floor(20),
  Round(30);

  const CustomerLoyaltyCalculationType(this.value);
  final int value;
}

CustomerLoyaltyCalculationType intToCustomerLoyaltyCalculationType(int value) {
  return CustomerLoyaltyCalculationType.values.firstWhere((element) => element.value == value);
}

enum LicenseStatus {
  Pending(0),
  Activated(10),
  Deactivated(20),
  PaymentNotVerified(30),
  AwaitingPayment(40),
  NearToExpire(50),
  Expired(100),
  Demo(200);

  const LicenseStatus(this.value);
  final int value;
}

enum SchemeType {
  InvoiceDiscountScheme(10, "Discount Invoice Scheme", "Based on Invoice Amount"),
  ProductDiscountScheme(20, "Discount Product Scheme", "Based on Product Quantity"),
  InvoiceBonusScheme(30, "Bonus Invoice Scheme", "Based on Invoice Amount"),
  ProductBonusScheme(40, "Bonus Product Scheme", "Based on Product Quantity"),
  ProductCategoryDiscountScheme(50, "Discount Product Category Scheme", "Based on Product Category"),
  ProductCategoryBonusScheme(60, "Bonus Product Category Scheme", "Based on Bonus Product Category");

  const SchemeType(this.value, this.name, this.description);

  final int value;
  final String name;
  final String description;
}

SchemeType? intoSchemeType(int value) {
  return SchemeType.values.firstWhere((element) => element.value == value);
}

enum DiscountEffect {
  Append(0),
  Overwrite(1);

  const DiscountEffect(this.value);

  final int value;
}

DiscountEffect? intoDiscountEffect(int value) {
  return DiscountEffect.values.firstWhere((element) => element.value == value);
}

enum Days {
  Sun(0),
  Mon(1),
  Tue(2),
  Wed(3),
  Thu(4),
  Fri(5),
  Sat(6);

  const Days(this.value);

  final int value;
}

Days? intoDays(int value) {
  return Days.values.firstWhere((element) => element.value == value);
}

enum OrderDayType  {
  Today(0),
  Yesterday(1),
  DayBeforeYesterday(2);

  const OrderDayType (this.value);

  final int value;
}

OrderDayType intoOrderDateFilterEnum(int value) {
  return OrderDayType.values.firstWhere((element) => element.value == value);
}

enum TravelStatus {
  Moving(0),
  Idle(1);

  const TravelStatus(this.value);

  final int value;
}

TravelStatus? intoTravelStatus(int value) {
  return TravelStatus.values.firstWhere((element) => element.value == value);
}
