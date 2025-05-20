import 'dart:convert';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/sale_order/model/sale_order_detail.dart';
import 'package:sa_common/schemes/models/SchemeInvoiceDiscountDtoModel.dart';

class SaleOrder {
  int? id;
  int? customerId;
  int? currencyId;
  num? exchangeRate;
  String? series;
  String? number;
  DateTime? date;
  DateTime? deliveryDate;
  num? grossAmount;
  num? taxAmount;
  num? discountPercent;
  num? discountAmount;
  num? shippingCharges;
  num? netAmount;
  int? status;
  String? updatedOn;
  List<SaleOrderDetailsModel>? saleOrderDetails;
  List<SchemeInvoiceDiscountDto>? saleOrderDiscounts;
  int? deliveriesCount;
  int? invoicesCount;
  int? orderBookerId;
  int? deliveryPersonId;
  int? salesmanId;
  bool? isAppliedScheme;
  int? branchId;
  String? reference;
  String? subject;
  String? comments;
  List<AttachmentsModel>? attachments;
  int? masterGroupId;

  SaleOrder({
    this.updatedOn,
    this.id,
    this.customerId,
    this.currencyId,
    this.exchangeRate,
    this.series,
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
    this.isAppliedScheme,
    this.branchId,
    this.reference,
    this.subject,
    this.comments,
    this.attachments,
    this.masterGroupId = null,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'currencyId': currencyId,
      'exchangeRate': exchangeRate,
      'series': series,
      'number': number,
      'date': date?.toIso8601String(),
      'deliveryDate': deliveryDate == null ? DateTime.now().toIso8601String() : deliveryDate?.toIso8601String(),
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'shippingCharges': shippingCharges,
      'netAmount': netAmount,
      'updatedOn': updatedOn,
      'status': status,
      'saleOrderDetails': saleOrderDetails?.map((x) => x.toMap()).toList(),
      'saleOrderDiscounts': saleOrderDiscounts?.map((x) => x.toMap()).toList(),
      'deliveriesCount': deliveriesCount,
      'invoicesCount': invoicesCount,
      'orderBookerId': orderBookerId,
      'deliveryPersonId': deliveryPersonId,
      'salesmanId': salesmanId,
      'isAppliedScheme': isAppliedScheme,
      'branchId': branchId,
      'masterGroupId': masterGroupId,
      'reference': reference,
      'subject': subject,
      'comments': comments,
      'attachments': attachments?.map((x) => x.toMap()).toList()
    };
  }

  factory SaleOrder.fromMap(Map<String, dynamic> map) {
    return SaleOrder(
        id: map['id']?.toInt(),
        customerId: map['customerId']?.toInt(),
        currencyId: map['currencyId']?.toInt(),
        exchangeRate: map['exchangeRate']?.toInt(),
        series: map['series'],
        number: map['number'],
        updatedOn: map['updatedOn'] != null ? map['updatedOn'] as String : null,
        date: map['date'] != null ? DateTime.parse(map['date']) : null,
        deliveryDate: map['deliveryDate'] != null ? DateTime.parse(map['deliveryDate']) : null,
        grossAmount: map['grossAmount'],
        taxAmount: map['taxAmount']?.toDouble(),
        discountPercent: map['discountPercent'],
        discountAmount: map['discountAmount'],
        shippingCharges: map['shippingCharges']?.toInt(),
        netAmount: map['netAmount'],
        status: map['status']?.toInt(),
        saleOrderDetails: map['saleOrderDetails'] != null ? List<SaleOrderDetailsModel>.from(map['saleOrderDetails']?.map((x) => SaleOrderDetailsModel.fromMap(x))) : null,
        saleOrderDiscounts: map['saleOrderDiscounts'] != null ? List<SchemeInvoiceDiscountDto>.from(map['saleOrderDiscounts']?.map((x) => SchemeInvoiceDiscountDto.fromMap(x))) : null,
        deliveriesCount: map['deliveriesCount']?.toInt(),
        invoicesCount: map['invoicesCount']?.toInt(),
        orderBookerId: map['orderBookerId']?.toInt(),
        deliveryPersonId: map['deliveryPersonId']?.toInt(),
        salesmanId: map['salesmanId']?.toInt(),
        isAppliedScheme: map['isAppliedScheme'] == 0 ? false : true,
        branchId: map['branchId']?.toInt(),
        reference: map['reference'],
        subject: map['subject'],
        comments: map['comments'],
        masterGroupId: map['masterGroupId'] != null ? map['masterGroupId'] as int : null,
        attachments: map['attachments'] != null ? List<AttachmentsModel>.from(map['attachments']?.map((x) => AttachmentsModel.fromMap(x))) : null);
  }

  String toJson() => json.encode(toMap());

  factory SaleOrder.fromJson(String source) => SaleOrder.fromMap(json.decode(source));
}
