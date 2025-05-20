import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/schemes/models/invoiceDetailTaxModel.dart';

class SaleOrderDetailField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String saleOrderId = 'saleOrderId';
  static final String productId = 'productId';
  static final String accountId = 'accountId';
  static final String description = 'description';
  static final String quantity = 'quantity';
  static final String remainingQuantity = 'remainingQuantity';
  static final String price = 'price';
  static final String discountInPercent = 'discountInPercent';
  static final String grossAmount = 'grossAmount';
  static final String taxAmount = 'taxAmount';
  static final String discountAmount = 'discountAmount';
  static final String netAmount = 'netAmount';
  static final String packingDetail = 'packingDetail';
  static final String detailBGroupId = 'detailBGroupId';
  static final String detailAGroupId = 'detailAGroupId';
  static final String quantityCalculation = 'quantityCalculation';
  static final String batchId = 'batchId';
  static final String warehouseId = 'warehouseId';
  static final String serialNumber = 'serialNumber';
  static final String isMRPExclusiveTax = 'isMRPExclusiveTax';
  static final String purchasePrice = 'purchasePrice';
  static final String maximumRetailPrice = 'maximumRetailPrice';
  static final String consignmentId = 'consignmentId';
  static final String branchId = 'branchId';
  static final String isBonusProduct = 'isBonusProduct';
  static final String tagPrice = 'tagPrice';
  static final String totalSavedAmount = 'totalSavedAmount';
  static final String posPaymentMode = 'posPaymentMode';
  static final String amount = 'amount';
  static final String isInitial = 'isInitial';
}

class SaleOrderDetailsModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? saleOrderId;
  int? productId;
  int? accountId;
  String? description;
  num? quantity;
  num? remainingQuantity;
  num? price;
  num? maximumRetailPrice;
  bool? isMRPExclusiveTax;
  num? purchasePrice;
  num? discountInPercent;
  num? discountAmount;
  num? grossAmount;
  num? taxAmount;
  num? netAmount;
  String? quantityCalculation;
  List<LineItemTaxModel>? taxes;
  List<SaleOrderDiscountsModel>? discounts;
  bool? isBonusProduct;
  int? branchId;
  bool? isInitial;
  int? detailAGroupId;
  int? detailBGroupId;

  SaleOrderDetailsModel({this.detailAGroupId, this.detailBGroupId, this.saleOrderId, this.branchId, this.companySlug, this.productId, this.accountId, this.description, this.quantity, this.remainingQuantity, this.price, this.maximumRetailPrice, this.isMRPExclusiveTax, this.purchasePrice, this.discountInPercent, this.discountAmount, this.grossAmount, this.taxAmount, this.netAmount, this.quantityCalculation, this.taxes, this.discounts, this.isBonusProduct = false, this.id, this.isInitial = false});

  SaleOrderDetailsModel.fromJson(Map<String, dynamic> json, {String? slug}) {
    companySlug = slug ?? json['companySlug'];
    saleOrderId = json['saleOrderId'];
    productId = json['productId'];
    accountId = json['accountId'];
    description = json['description'];
    quantity = json['quantity'];
    remainingQuantity = json['remainingQuantity'];
    price = json['price'];
    maximumRetailPrice = json['maximumRetailPrice'];
    isMRPExclusiveTax = (json['isMRPExclusiveTax'] == 0 || json['isMRPExclusiveTax'] == false) ? false : true;
    isInitial = (json['isInitial'] == 0 || json['isInitial'] == false || json['isInitial'] == null) ? false : true;
    purchasePrice = json['purchasePrice'];
    discountInPercent = json['discountInPercent'];
    discountAmount = json['discountAmount'];
    detailAGroupId = json['detailAGroupId'] != null ? json['detailAGroupId'] as int : null;
    detailBGroupId = json['detailBGroupId'] != null ? json['detailBGroupId'] as int : null;
    grossAmount = json['grossAmount'];
    taxAmount = json['taxAmount'];
    netAmount = json['netAmount'];
    branchId = json['branchId'];
    quantityCalculation = json['quantityCalculation'] ?? "";
    if (json['taxes'] != null) {
      taxes = <LineItemTaxModel>[];
      json['taxes'].forEach((v) {
        taxes!.add(new LineItemTaxModel.fromMap(v));
      });
    }
    if (json['discounts'] != null) {
      discounts = <SaleOrderDiscountsModel>[];
      json['discounts'].forEach((v) {
        discounts!.add(new SaleOrderDiscountsModel.fromMap(v));
      });
    }
    isBonusProduct = (json['isBonusProduct'] == 0 || json['isBonusProduct'] == false) ? false : true;
    id = json['id'];
  }

  Map<String, dynamic> toJson({bool? isOnline = false, bool isLocal = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companySlug'] = this.companySlug;
    data['saleOrderId'] = this.saleOrderId;
    data['productId'] = this.productId;
    data['accountId'] = this.accountId;
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['remainingQuantity'] = this.remainingQuantity ?? 0;
    data['price'] = this.price ?? 0;
    data['maximumRetailPrice'] = this.maximumRetailPrice ?? 0;
    data['isMRPExclusiveTax'] = this.isMRPExclusiveTax == false ? 0 : 1;
    data['purchasePrice'] = this.purchasePrice ?? 0;
    data['discountInPercent'] = this.discountInPercent;
    data['discountAmount'] = this.discountAmount;
    data['grossAmount'] = this.grossAmount ?? 0;
    data['taxAmount'] = this.taxAmount ?? 0;
    data['netAmount'] = this.netAmount ?? 0;
    data['quantityCalculation'] = this.quantityCalculation;
    data['branchId'] = this.branchId;
    data['isInitial'] = isInitial == false ? 0 : 1;
    data['detailAGroupId'] = detailAGroupId == 0 ? null : this.detailAGroupId;
    data['detailBGroupId'] = detailBGroupId == 0 ? null : this.detailBGroupId;
    if (isOnline == true && this.taxes != null) {
      data['taxes'] = this.taxes!.map((v) => v.toJson()).toList();
    }
    if (!isLocal && this.discounts != null) {
      data['discounts'] = this.discounts!.map((v) => v.toJson()).toList();
    }
    if (isOnline == true) {
      data['isBonusProduct'] = this.isBonusProduct == false ? 0 : 1;
    } else
      data['isBonusProduct'] = this.isBonusProduct;
    data['id'] = this.id;
    return data;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SaleOrderDetailsModel.fromJson(json, slug: slug);
  }
}
