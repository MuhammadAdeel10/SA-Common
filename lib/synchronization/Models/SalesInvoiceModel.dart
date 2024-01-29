//Push Server Model

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:sa_common/synchronization/Models/SalesInvoiceDetail_model.dart';
import '../../schemes/models/SchemeInvoiceDiscountDtoModel.dart';
import '../../schemes/models/posPaymentDetailModel.dart';
import 'CustomerModel.dart';

class SalesInvoiceModel {
  int? id;
  int? posInvoiceId;
  int? saleQuotationId;
  String saleQuotationNumber;
  int? saleOrderId;
  String saleOrderNumber;
  String fbrPosInvoiceNumber;
  DateTime? saleOrderDate;
  int customerId;
  int currencyId;
  num exchangeRate;
  String shippingAddress;
  String billingAddress;
  String series;
  String number;
  DateTime? date;
  DateTime? dueDate;
  String reference;
  String subject;
  int? accountId;
  String paymentReference;
  String comments;
  String narration;
  num grossAmount;
  num taxAmount;
  num discountPercent;
  num discountAmount;
  num otherCharges;
  num shippingCharges;
  num manualRoundOff;
  num autoRoundOff;
  num netAmount;
  num fbrPosFee;
  num paidAmount;
  num receivedAmount;
  num unAllocatedAmount;
  bool isVoid;
  num outstandingBalance;
  List<SalesInvoiceDetailModel> posInvoiceDetails;
  List<SchemeInvoiceDiscountDto>? posInvoiceDiscounts;
  int? masterGroupId;
  int? salesmanId;
  bool isPosInvoice;
  DateTime? time;
  Guid? userId;
  int? posCashRegisterId;
  Guid? cashRegisterSessionId;
  num saleReturnedAmount;
  num changeReturnedAmount;
  List<PosPaymentModel> posPaymentDetails;
  num amountToAllocate;
  bool isFbrPosInvoice;
  int? templateDefinitionId;
  int branchId;
  Guid? companyId;
  bool isAppliedScheme;
  bool isSaleReturn;
  bool isDesktop;
  CustomerModel? customer;
  SalesInvoiceModel(
      {this.posInvoiceId,
      this.saleQuotationId,
      this.saleQuotationNumber = "",
      this.saleOrderId = 0,
      this.saleOrderNumber = "",
      this.fbrPosInvoiceNumber = "",
      this.saleOrderDate,
      this.customerId = 0,
      this.currencyId = 0,
      this.exchangeRate = 0,
      this.shippingAddress = "",
      this.billingAddress = "",
      this.series = "",
      this.number = "",
      this.date,
      this.dueDate,
      this.reference = "",
      this.subject = "",
      this.accountId = 0,
      this.paymentReference = "",
      this.comments = "",
      this.narration = "",
      this.grossAmount = 0,
      this.taxAmount = 0,
      this.discountPercent = 0,
      this.discountAmount = 0,
      this.otherCharges = 0,
      this.shippingCharges = 0,
      this.manualRoundOff = 0,
      this.autoRoundOff = 0,
      this.netAmount = 0,
      this.fbrPosFee = 0,
      this.paidAmount = 0,
      this.receivedAmount = 0,
      this.unAllocatedAmount = 0,
      this.isVoid = false,
      this.outstandingBalance = 0,
      required this.posInvoiceDetails,
      this.posInvoiceDiscounts,
      this.masterGroupId,
      this.salesmanId,
      this.isPosInvoice = false,
      this.time,
      this.userId,
      this.posCashRegisterId,
      this.cashRegisterSessionId,
      this.saleReturnedAmount = 0,
      this.changeReturnedAmount = 0,
      required this.posPaymentDetails,
      this.amountToAllocate = 0,
      this.isFbrPosInvoice = false,
      this.templateDefinitionId = 0,
      this.branchId = 0,
      this.companyId,
      this.isAppliedScheme = false,
      this.isSaleReturn = false,
      this.isDesktop = true,
      this.id,
      this.customer});

  SalesInvoiceModel copyWith({
    int? posInvoiceId,
    int? saleQuotationId,
    String? saleQuotationNumber,
    int? saleOrderId,
    String? saleOrderNumber,
    String? fbrPosInvoiceNumber,
    DateTime? saleOrderDate,
    int? customerId,
    int? currencyId,
    num? exchangeRate,
    String? shippingAddress,
    String? billingAddress,
    String? series,
    String? number,
    DateTime? date,
    DateTime? dueDate,
    String? reference,
    String? subject,
    int? accountId,
    String? paymentReference,
    String? comments,
    String? narration,
    num? grossAmount,
    num? taxAmount,
    num? discountPercent,
    num? discountAmount,
    num? otherCharges,
    num? shippingCharges,
    num? manualRoundOff,
    num? autoRoundOff,
    num? netAmount,
    num? fbrPosFee,
    num? paidAmount,
    num? receivedAmount,
    num? unAllocatedAmount,
    bool? isVoid,
    num? outstandingBalance,
    List<SalesInvoiceDetailModel>? posInvoiceDetails,
    List<SchemeInvoiceDiscountDto>? saleInvoiceDiscounts,
    int? masterGroupId,
    int? orderBookerId,
    int? deliveryPersonId,
    int? salesmanId,
    bool? isPosInvoice,
    DateTime? time,
    Guid? userId,
    int? posCashRegisterId,
    Guid? cashRegisterSessionId,
    num? saleReturnedAmount,
    num? changeReturnedAmount,
    List<PosPaymentModel>? posPaymentDetails,
    num? amountToAllocate,
    bool? isFbrPosInvoice,
    int? templateDefinitionId,
    int? branchId,
    Guid? companyId,
    bool? isAppliedScheme,
    bool? isSaleReturn,
    CustomerModel? customer,
  }) {
    return SalesInvoiceModel(
      posInvoiceId: posInvoiceId ?? this.posInvoiceId,
      saleQuotationId: saleQuotationId ?? this.saleQuotationId,
      saleQuotationNumber: saleQuotationNumber ?? this.saleQuotationNumber,
      saleOrderId: saleOrderId ?? this.saleOrderId,
      saleOrderNumber: saleOrderNumber ?? this.saleOrderNumber,
      fbrPosInvoiceNumber: fbrPosInvoiceNumber ?? this.fbrPosInvoiceNumber,
      saleOrderDate: saleOrderDate ?? this.saleOrderDate,
      customerId: customerId ?? this.customerId,
      currencyId: currencyId ?? this.currencyId,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      billingAddress: billingAddress ?? this.billingAddress,
      series: series ?? this.series,
      number: number ?? this.number,
      date: date ?? this.date,
      dueDate: dueDate ?? this.dueDate,
      reference: reference ?? this.reference,
      subject: subject ?? this.subject,
      accountId: accountId ?? this.accountId,
      paymentReference: paymentReference ?? this.paymentReference,
      comments: comments ?? this.comments,
      narration: narration ?? this.narration,
      grossAmount: grossAmount ?? this.grossAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      otherCharges: otherCharges ?? this.otherCharges,
      shippingCharges: shippingCharges ?? this.shippingCharges,
      manualRoundOff: manualRoundOff ?? this.manualRoundOff,
      autoRoundOff: autoRoundOff ?? this.autoRoundOff,
      netAmount: netAmount ?? this.netAmount,
      fbrPosFee: fbrPosFee ?? this.fbrPosFee,
      paidAmount: paidAmount ?? this.paidAmount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      unAllocatedAmount: unAllocatedAmount ?? this.unAllocatedAmount,
      isVoid: isVoid ?? this.isVoid,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      posInvoiceDetails: posInvoiceDetails ?? this.posInvoiceDetails,
      posInvoiceDiscounts: saleInvoiceDiscounts ?? this.posInvoiceDiscounts,
      masterGroupId: masterGroupId ?? this.masterGroupId,
      salesmanId: salesmanId ?? this.salesmanId,
      isPosInvoice: isPosInvoice ?? this.isPosInvoice,
      time: time ?? this.time,
      userId: userId ?? this.userId,
      posCashRegisterId: posCashRegisterId ?? this.posCashRegisterId,
      cashRegisterSessionId:
          cashRegisterSessionId ?? this.cashRegisterSessionId,
      saleReturnedAmount: saleReturnedAmount ?? this.saleReturnedAmount,
      changeReturnedAmount: changeReturnedAmount ?? this.changeReturnedAmount,
      posPaymentDetails: posPaymentDetails ?? this.posPaymentDetails,
      amountToAllocate: amountToAllocate ?? this.amountToAllocate,
      isFbrPosInvoice: isFbrPosInvoice ?? this.isFbrPosInvoice,
      templateDefinitionId: templateDefinitionId ?? this.templateDefinitionId,
      branchId: branchId ?? this.branchId,
      companyId: companyId ?? this.companyId,
      isAppliedScheme: isAppliedScheme ?? this.isAppliedScheme,
      isSaleReturn: isSaleReturn ?? this.isSaleReturn,
      customer: customer ?? this.customer,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'posInvoiceId': posInvoiceId == 0 ? null : posInvoiceId,
      'saleQuotationId': saleQuotationId == 0 ? null : saleQuotationId,
      'saleQuotationNumber': saleQuotationNumber,
      'saleOrderId': saleOrderId == 0 ? null : saleOrderId,
      'saleOrderNumber': saleOrderNumber,
      'fbrPosInvoiceNumber': fbrPosInvoiceNumber,
      'saleOrderDate': saleOrderDate?.toIso8601String(),
      'customerId': customerId == 0 ? null : customerId,
      'currencyId': currencyId == 0 ? null : currencyId,
      'exchangeRate': exchangeRate,
      'shippingAddress': shippingAddress,
      'billingAddress': billingAddress,
      'series': series,
      'number': number,
      'date': date?.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'reference': reference,
      'subject': subject,
      'accountId': accountId == 0 ? null : accountId,
      'paymentReference': paymentReference,
      'comments': comments,
      'narration': narration,
      'grossAmount': grossAmount,
      'taxAmount': taxAmount,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'otherCharges': otherCharges,
      'shippingCharges': shippingCharges,
      'manualRoundOff': manualRoundOff,
      'autoRoundOff': autoRoundOff,
      'netAmount': netAmount,
      'fbrPosFee': fbrPosFee,
      'paidAmount': paidAmount,
      'receivedAmount': receivedAmount,
      'unAllocatedAmount': unAllocatedAmount,
      'isVoid': isVoid,
      'outstandingBalance': outstandingBalance,
      'posInvoiceDetails': posInvoiceDetails.map((x) => x.toMap()).toList(),
      'posInvoiceDiscounts':
          posInvoiceDiscounts?.map((x) => x.toMap()).toList(),
      'masterGroupId': masterGroupId,
      'salesmanId': salesmanId == 0 ? null : salesmanId,
      'isPosInvoice': isPosInvoice,
      'time': time?.toIso8601String(),
      'userId': userId.toString(),
      'posCashRegisterId': posCashRegisterId,
      'cashRegisterSessionId': cashRegisterSessionId.toString(),
      'saleReturnedAmount': saleReturnedAmount,
      'changeReturnedAmount': changeReturnedAmount,
      'posPaymentDetails': posPaymentDetails.map((x) => x.toMap()).toList(),
      'amountToAllocate': amountToAllocate,
      'isFbrPosInvoice': isFbrPosInvoice,
      'templateDefinitionId': templateDefinitionId,
      'branchId': branchId == 0 ? null : branchId,
      'companyId': companyId.toString(),
      'isAppliedScheme': isAppliedScheme,
      'isSaleReturn': isSaleReturn,
      'isDesktop': isDesktop,
      'customer': customer?.toMap(),
    };
  }

  factory SalesInvoiceModel.fromMap(Map<String, dynamic> map) {
    return SalesInvoiceModel(
      id: map['id']?.toInt(),
      customer: map['customer'] != null
          ? CustomerModel?.fromMap(map['customer'])
          : null,
      posInvoiceId: map['posInvoiceId']?.toInt(),
      saleQuotationId: map['saleQuotationId']?.toInt(),
      saleQuotationNumber: map['saleQuotationNumber'],
      saleOrderId: map['saleOrderId']?.toInt(),
      saleOrderNumber: map['saleOrderNumber'],
      fbrPosInvoiceNumber: map['fbrPosInvoiceNumber'],
      saleOrderDate: map['saleOrderDate'] != null
          ? DateTime.parse(map['saleOrderDate'])
          : null,
      customerId: map['customerId']?.toInt(),
      currencyId: map['currencyId']?.toInt(),
      exchangeRate: map['exchangeRate'],
      shippingAddress: map['shippingAddress'],
      billingAddress: map['billingAddress'],
      series: map['series'],
      number: map['number'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      reference: map['reference'],
      subject: map['subject'],
      accountId: map['accountId']?.toInt(),
      paymentReference: map['paymentReference'],
      comments: map['comments'],
      narration: map['narration'],
      grossAmount: map['grossAmount'],
      taxAmount: map['taxAmount'],
      discountPercent: map['discountPercent'],
      discountAmount: map['discountAmount'],
      otherCharges: map['otherCharges'],
      shippingCharges: map['shippingCharges'],
      manualRoundOff: map['manualRoundOff'],
      autoRoundOff: map['autoRoundOff'],
      netAmount: map['netAmount'],
      fbrPosFee: map['fbrPosFee'],
      paidAmount: map['paidAmount'],
      receivedAmount: map['receivedAmount'],
      unAllocatedAmount: map['unAllocatedAmount'],
      isVoid: map['isVoid'],
      outstandingBalance: map['outstandingBalance'],
      posInvoiceDetails: List<SalesInvoiceDetailModel>.from(
          map['posInvoiceDetails']
              ?.map((x) => SalesInvoiceDetailModel.fromMap(x))),
      posInvoiceDiscounts: map['saleInvoiceDiscounts'] != null
          ? List<SchemeInvoiceDiscountDto>.from(map['saleInvoiceDiscounts']
              ?.map((x) => SchemeInvoiceDiscountDto.fromMap(x)))
          : null,
      masterGroupId: map['masterGroupId']?.toInt(),
      salesmanId: map['salesmanId']?.toInt(),
      isPosInvoice: map['isPosInvoice'] == 1 ? true : false,
      isSaleReturn: map['isSaleReturn'] == 1 ? true : false,
      time: map['time'] != null ? DateTime.parse(map['time']) : null,
      userId: map['userId'] != null ? Guid(map['userId']) : null,
      posCashRegisterId: map['posCashRegisterId']?.toInt(),
      cashRegisterSessionId: map['cashRegisterSessionId'] != null
          ? Guid(map['cashRegisterSessionId'])
          : null,
      saleReturnedAmount: map['saleReturnedAmount'],
      changeReturnedAmount: map['changeReturnedAmount'],
      posPaymentDetails: List<PosPaymentModel>.from(
          map['posPaymentDetails']?.map((x) => PosPaymentModel.fromMap(x))),
      amountToAllocate: map['amountToAllocate'],
      isFbrPosInvoice: map['isFbrPosInvoice'] == 1 ? true : false,
      templateDefinitionId: map['templateDefinitionId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      companyId: map['companyId'] != null ? Guid(map['companyId']) : null,
      isAppliedScheme: map['isAppliedScheme'] == 1 ? true : false,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesInvoiceModel.fromJson(String source) =>
      SalesInvoiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SalesInvoiceModel(posInvoiceId: $posInvoiceId, saleQuotationId: $saleQuotationId, saleQuotationNumber: $saleQuotationNumber, saleOrderId: $saleOrderId, saleOrderNumber: $saleOrderNumber, fbrPosInvoiceNumber: $fbrPosInvoiceNumber, saleOrderDate: $saleOrderDate, customerId: $customerId, currencyId: $currencyId, exchangeRate: $exchangeRate, shippingAddress: $shippingAddress, billingAddress: $billingAddress, series: $series, number: $number, date: $date, dueDate: $dueDate, reference: $reference, subject: $subject, accountId: $accountId, paymentReference: $paymentReference, comments: $comments, narration: $narration, grossAmount: $grossAmount, taxAmount: $taxAmount, discountPercent: $discountPercent, discountAmount: $discountAmount, otherCharges: $otherCharges, shippingCharges: $shippingCharges, manualRoundOff: $manualRoundOff, autoRoundOff: $autoRoundOff, netAmount: $netAmount, fbrPosFee: $fbrPosFee, paidAmount: $paidAmount, receivedAmount: $receivedAmount, unAllocatedAmount: $unAllocatedAmount, isVoid: $isVoid, outstandingBalance: $outstandingBalance, posInvoiceDetails: $posInvoiceDetails, saleInvoiceDiscounts: $posInvoiceDiscounts, masterGroupId: $masterGroupId, salesmanId: $salesmanId, isPosInvoice: $isPosInvoice, time: $time, userId: $userId, posCashRegisterId: $posCashRegisterId, cashRegisterSessionId: $cashRegisterSessionId, saleReturnedAmount: $saleReturnedAmount, changeReturnedAmount: $changeReturnedAmount, posPaymentDetails: $posPaymentDetails, amountToAllocate: $amountToAllocate, isFbrPosInvoice: $isFbrPosInvoice, templateDefinitionId: $templateDefinitionId, branchId: $branchId, companyId: $companyId, isAppliedScheme: $isAppliedScheme)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SalesInvoiceModel &&
        other.posInvoiceId == posInvoiceId &&
        other.saleQuotationId == saleQuotationId &&
        other.saleQuotationNumber == saleQuotationNumber &&
        other.saleOrderId == saleOrderId &&
        other.saleOrderNumber == saleOrderNumber &&
        other.fbrPosInvoiceNumber == fbrPosInvoiceNumber &&
        other.saleOrderDate == saleOrderDate &&
        other.customerId == customerId &&
        other.currencyId == currencyId &&
        other.exchangeRate == exchangeRate &&
        other.shippingAddress == shippingAddress &&
        other.billingAddress == billingAddress &&
        other.series == series &&
        other.number == number &&
        other.date == date &&
        other.dueDate == dueDate &&
        other.reference == reference &&
        other.subject == subject &&
        other.accountId == accountId &&
        other.paymentReference == paymentReference &&
        other.comments == comments &&
        other.narration == narration &&
        other.grossAmount == grossAmount &&
        other.taxAmount == taxAmount &&
        other.discountPercent == discountPercent &&
        other.discountAmount == discountAmount &&
        other.otherCharges == otherCharges &&
        other.shippingCharges == shippingCharges &&
        other.manualRoundOff == manualRoundOff &&
        other.autoRoundOff == autoRoundOff &&
        other.netAmount == netAmount &&
        other.fbrPosFee == fbrPosFee &&
        other.paidAmount == paidAmount &&
        other.receivedAmount == receivedAmount &&
        other.unAllocatedAmount == unAllocatedAmount &&
        other.isVoid == isVoid &&
        other.outstandingBalance == outstandingBalance &&
        listEquals(other.posInvoiceDetails, posInvoiceDetails) &&
        listEquals(other.posInvoiceDiscounts, posInvoiceDiscounts) &&
        other.masterGroupId == masterGroupId &&
        other.salesmanId == salesmanId &&
        other.isPosInvoice == isPosInvoice &&
        other.time == time &&
        other.userId == userId &&
        other.posCashRegisterId == posCashRegisterId &&
        other.cashRegisterSessionId == cashRegisterSessionId &&
        other.saleReturnedAmount == saleReturnedAmount &&
        other.changeReturnedAmount == changeReturnedAmount &&
        listEquals(other.posPaymentDetails, posPaymentDetails) &&
        other.amountToAllocate == amountToAllocate &&
        other.isFbrPosInvoice == isFbrPosInvoice &&
        other.templateDefinitionId == templateDefinitionId &&
        other.branchId == branchId &&
        other.companyId == companyId &&
        other.isAppliedScheme == isAppliedScheme;
  }

  @override
  int get hashCode {
    return posInvoiceId.hashCode ^
        saleQuotationId.hashCode ^
        saleQuotationNumber.hashCode ^
        saleOrderId.hashCode ^
        saleOrderNumber.hashCode ^
        fbrPosInvoiceNumber.hashCode ^
        saleOrderDate.hashCode ^
        customerId.hashCode ^
        currencyId.hashCode ^
        exchangeRate.hashCode ^
        shippingAddress.hashCode ^
        billingAddress.hashCode ^
        series.hashCode ^
        number.hashCode ^
        date.hashCode ^
        dueDate.hashCode ^
        reference.hashCode ^
        subject.hashCode ^
        accountId.hashCode ^
        paymentReference.hashCode ^
        comments.hashCode ^
        narration.hashCode ^
        grossAmount.hashCode ^
        taxAmount.hashCode ^
        discountPercent.hashCode ^
        discountAmount.hashCode ^
        otherCharges.hashCode ^
        shippingCharges.hashCode ^
        manualRoundOff.hashCode ^
        autoRoundOff.hashCode ^
        netAmount.hashCode ^
        fbrPosFee.hashCode ^
        paidAmount.hashCode ^
        receivedAmount.hashCode ^
        unAllocatedAmount.hashCode ^
        isVoid.hashCode ^
        outstandingBalance.hashCode ^
        posInvoiceDetails.hashCode ^
        posInvoiceDiscounts.hashCode ^
        masterGroupId.hashCode ^
        salesmanId.hashCode ^
        isPosInvoice.hashCode ^
        time.hashCode ^
        userId.hashCode ^
        posCashRegisterId.hashCode ^
        cashRegisterSessionId.hashCode ^
        saleReturnedAmount.hashCode ^
        changeReturnedAmount.hashCode ^
        posPaymentDetails.hashCode ^
        amountToAllocate.hashCode ^
        isFbrPosInvoice.hashCode ^
        templateDefinitionId.hashCode ^
        branchId.hashCode ^
        companyId.hashCode ^
        isAppliedScheme.hashCode;
  }
}
