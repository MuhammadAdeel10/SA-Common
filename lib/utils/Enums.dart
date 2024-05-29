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
