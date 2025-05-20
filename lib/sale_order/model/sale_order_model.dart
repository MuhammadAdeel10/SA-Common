import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/sale_order/model/CardBaseModel.dart';
import 'package:sa_common/sale_order/model/sale_order_detail_model.dart';
import 'package:sa_common/schemes/models/SchemeInvoiceDiscountDtoModel.dart';

class SaleOrderModelField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String saleQuotationId = 'saleQuotationId';
  static final String saleOrderId = 'saleOrderId';
  static final String saleDeliveryId = 'saleDeliveryId';
  static final String customerId = 'customerId';
  static final String currencyId = 'currencyId';
  static final String exchangeRate = 'exchangeRate';
  static final String shippingAddress = 'shippingAddress';
  static final String billingAddress = 'billingAddress';
  static final String number = 'number';
  static final String date = 'date';
  static final String reference = 'reference';
  static final String accountId = 'accountId';
  static final String paymentReference = 'paymentReference';
  static final String comments = 'comments';
  static final String grossAmount = 'grossAmount';
  static final String taxAmount = 'taxAmount';
  static final String discountPercent = 'discountPercent';
  static final String discountAmount = 'discountAmount';
  static final String otherCharges = 'otherCharges';
  static final String netAmount = 'netAmount';
  static final String paidAmount = 'paidAmount';
  static final String receivedAmount = 'receivedAmount';
  static final String status = 'status';
  static final String autoRoundOff = 'autoRoundOff';
  static final String manualRoundOff = 'manualRoundOff';
  static final String masterGroupId = 'masterGroupId';
  static final String shippingCharges = 'shippingCharges';
  static final String time = 'time';
  static final String userId = 'userId';
  static final String deliveryPersonId = 'deliveryPersonId';
  static final String orderBookerId = 'orderBookerId';
  static final String salesmanId = 'salesmanId';
  static final String series = 'series';
  static final String subject = 'subject';
  static final String narration = 'narration';
  static final String branchId = 'branchId';
  static final String createdBy = 'createdBy';
  static final String createdOn = 'createdOn';
  static final String isSync = 'isSync';
  static final String deliveryDate = 'deliveryDate';
  static final String deliveriesCount = 'deliveriesCount';
  static final String invoicesCount = 'invoicesCount';
  static final String isAppliedScheme = 'isAppliedScheme';
  static final String isNew = 'isNew';
  static final String isEdit = 'isEdit';
  static final String isDeleted = 'isDeleted';
  static final String updatedOn = 'updatedOn';
}

class SaleOrderModel extends BaseModel<int> implements CardBase {
  @override
  int? id;
  @override
  String? companySlug;
  int? customerId;
  int? currencyId;
  num? exchangeRate;
  String? series;
  String? number;
  DateTime? date;
  DateTime? deliveryDate;
  num? grossAmount;
  num? taxAmount;
  String? updatedOn;
  num? discountPercent;
  num? discountAmount;
  int? masterGroupId;
  num? shippingCharges;
  num? netAmount;
  int? status;
  List<SaleOrderDetailsModel>? saleOrderDetails;
  // List<SaleOrderDiscountsModel>? saleOrderDiscounts;
  List<SchemeInvoiceDiscountDto>? saleOrderDiscounts;
  int? deliveriesCount;
  int? invoicesCount;
  int? orderBookerId;
  int? deliveryPersonId;
  int? salesmanId;
  bool? isAppliedScheme;
  int? branchId;
  bool? isSync;
  bool? isNew;
  bool? isEdit;
  bool? isDeleted;
  String? reference;
  String? subject;
  String? comments;
  String? customerName;
  num? withHoldingTaxPercent;
  num? withHoldingTaxAmount;
  List<AttachmentsModel>? attachments;

  SaleOrderModel({
    this.updatedOn,
    this.customerId,
    this.branchId,
    this.reference,
    this.subject,
    this.comments,
    this.currencyId,
    this.isNew = false,
    this.isEdit = false,
    this.isDeleted = false,
    this.isSync = false,
    this.exchangeRate,
    this.series = "",
    this.number,
    this.date,
    this.deliveryDate,
    this.grossAmount,
    this.taxAmount,
    this.discountPercent,
    this.discountAmount,
    this.shippingCharges,
    this.netAmount,
    this.status,
    this.saleOrderDetails,
    this.saleOrderDiscounts,
    this.deliveriesCount,
    this.invoicesCount,
    this.orderBookerId,
    this.deliveryPersonId,
    this.salesmanId,
    this.id,
    this.customerName,
    this.attachments,
    this.withHoldingTaxAmount,
    this.withHoldingTaxPercent,
    this.masterGroupId = null,
  });

  SaleOrderModel.fromJson(Map<String, dynamic> json, {String? slug}) {
    companySlug = slug ?? json['companySlug'];
    customerId = json['customerId'];
    currencyId = json['currencyId'];
    exchangeRate = json['exchangeRate'];
    series = json['series'] != null ? json['series'] as String : null;
    customerName = json['customerName'];
    number = json['number'];
    date = DateTime.parse(json['date']);
    deliveryDate = json['deliveryDate'] == null ? null : DateTime.parse(json['deliveryDate']);
    grossAmount = json['grossAmount'];
    taxAmount = json['taxAmount'];
    discountPercent = json['discountPercent'];
    discountAmount = json['discountAmount'];
    shippingCharges = json['shippingCharges'];
    netAmount = json['netAmount'];
    branchId = json['branchId'];
    updatedOn = json['updatedOn'] != null ? json['updatedOn'] as String : null;
    reference = json['reference'] == null ? "" : json['reference'];
    subject = json['subject'];
    comments = json['comments'];
    masterGroupId = json['masterGroupId'] != null ? json['masterGroupId'] as int : null;
    status = json['status'];
    if (json['saleOrderDetails'] != null) {
      saleOrderDetails = <SaleOrderDetailsModel>[];
      json['saleOrderDetails'].forEach((v) {
        saleOrderDetails!.add(new SaleOrderDetailsModel.fromJson(v));
      });
    }
    if (json['saleOrderDiscounts'] != null) {
      saleOrderDiscounts = <SchemeInvoiceDiscountDto>[];
      json['saleOrderDiscounts'].forEach((v) {
        saleOrderDiscounts!.add(new SchemeInvoiceDiscountDto.fromMap(v));
      });
    }
    deliveriesCount = json['deliveriesCount'];
    invoicesCount = json['invoicesCount'];
    orderBookerId = json['orderBookerId'];
    deliveryPersonId = json['deliveryPersonId'];
    salesmanId = json['salesmanId'];
    isAppliedScheme = json['isAppliedScheme'] == 0 ? false : true;
    isSync = (json['isSync'] == 0 || json['isSync'] == null) ? false : true;
    isNew = json['isNew'] == 1 ? true : false;
    isEdit = json['isEdit'] == 1 ? true : false;
    isDeleted = json['isDeleted'] == 1 ? true : false;
    if (json['withHoldingTaxAmount'] != null) {
      withHoldingTaxAmount = json['withHoldingTaxAmount'];
    }
    if (json['withHoldingTaxPercent'] != null) {
      withHoldingTaxPercent = json['withHoldingTaxPercent'];
    }
    attachments = json['attachments'] != null ? List<AttachmentsModel>.from(json['attachments']?.map((x) => AttachmentsModel.fromMap(x))) : null;
    // if (json['attachments'] != null) {
    //   attachments = <Attachments>[];
    //   json['attachments'].forEach((v) {
    //     attachments!.add(new Attachments.fromJson(v));
    //   });
    // }
    id = json['id'];
  }

  Map<String, dynamic> toJson({bool isLocal = false}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companySlug'] = this.companySlug;
    data['customerId'] = this.customerId;
    data['currencyId'] = this.currencyId;
    data['exchangeRate'] = this.exchangeRate;
    data['series'] = this.series;
    data['updatedOn'] = this.updatedOn;
    data['number'] = this.number;
    data['date'] = this.date?.toIso8601String();
    data['deliveryDate'] = this.deliveryDate?.toIso8601String();
    data['grossAmount'] = this.grossAmount;
    data['taxAmount'] = this.taxAmount;
    data['discountPercent'] = this.discountPercent;
    data['discountAmount'] = this.discountAmount;
    data['shippingCharges'] = this.shippingCharges;
    data['netAmount'] = this.netAmount;
    data['status'] = this.status;
    data['branchId'] = this.branchId;
    data['masterGroupId'] = this.masterGroupId;
    data['reference'] = this.reference;
    data['subject'] = this.subject;
    data['comments'] = this.comments;
    if (!isLocal && this.saleOrderDetails != null) {
      data['saleOrderDetails'] = this.saleOrderDetails!.map((v) => v.toJson()).toList();
    }
    if (!isLocal && this.saleOrderDiscounts != null) {
      data['saleOrderDiscounts'] = this.saleOrderDiscounts!.map((v) => v.toJson()).toList();
    }
    data['deliveriesCount'] = this.deliveriesCount;
    data['invoicesCount'] = this.invoicesCount;
    data['orderBookerId'] = this.orderBookerId;
    data['deliveryPersonId'] = this.deliveryPersonId;
    data['salesmanId'] = this.salesmanId;
    data['isAppliedScheme'] = this.isAppliedScheme == false ? 0 : 1;
    data['isSync'] = this.isSync == true ? 1 : 0;
    data['isNew'] = this.isNew == false ? 0 : 1;
    data['isEdit'] = this.isEdit == false ? 0 : 1;
    data['isDeleted'] = this.isDeleted == false ? 0 : 1;
    if (this.withHoldingTaxPercent != null) {
      data['withHoldingTaxPercent'] = this.withHoldingTaxPercent;
    }
    if (this.withHoldingTaxAmount != null) {
      data['withHoldingTaxAmount'] = this.withHoldingTaxAmount;
    }
    if (this.attachments != null) data['attachments'] = attachments?.map((x) => x.toJson()).toList();
    // if (this.attachments != null) {
    //   data['attachments'] = this.attachments!.map((v) => v.toJson()).toList();
    // }
    data['id'] = this.id;
    return data;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SaleOrderModel.fromJson(json, slug: slug);
  }

  List<SaleOrderModel> FromJson(String str, String slug) => List<SaleOrderModel>.from(json.decode(str).map((x) => SaleOrderModel().fromJson(x, slug: slug)));
}
