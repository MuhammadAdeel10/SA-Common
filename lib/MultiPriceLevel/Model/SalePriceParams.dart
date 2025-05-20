class SalePriceFilter {
  final int productId;
  final int currencyId;
  final DateTime date;
  final String compaluSlug;
  final bool enableGeography;
  int? branchId;
  int? customerCategoryId;
  int? customerId;
  int? regionId;
  int? zoneId;
  int? territoryId;
  int? areaId;
  int? subAreaId;

  SalePriceFilter({
    required this.productId,
    required this.currencyId,
    required this.date,
    required this.compaluSlug,
    required this.enableGeography,
    this.branchId,
    this.customerCategoryId,
    this.customerId,
    this.regionId,
    this.zoneId,
    this.territoryId,
    this.areaId,
    this.subAreaId,
  });
}
