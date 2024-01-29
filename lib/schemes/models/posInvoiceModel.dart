import 'package:flutter/foundation.dart';
import 'package:flutter_guid/flutter_guid.dart';
import 'package:sa_common/schemes/models/posPaymentDetailModel.dart';
import 'package:sa_common/schemes/models/schemePosInvoiceDetailModel.dart';
import 'SchemeInvoiceDiscountDtoModel.dart';

class SchemePOSInvoiceModel {
  int? id;
  String? companySlug;
  String? series;
  String? number;
  int? fbrInvoiceQrCode;
  String? fbrPosInvoiceNumber;
  num? fbrPosFee;
  int? posCashRegisterId;
  Guid? cashRegisterSessionId;
  int? customerId;
  int? currencyId;
  int? status;
  Guid? userId;
  num? exchangeRate;
  num? outstandingBalance;
  num? grossAmount;
  num? discountAmount;
  num? taxAmount;
  int? masterGroupId;
  num? autoRoundOff;
  num? manualRoundOff;
  num? discountPercent;
  num netAmount;
  num? amountBeforeDiscount;
  num? receivedAmount;
  num? returnAmount;
  DateTime? date;
  DateTime? time;
  bool? isVoid;
  int? templateDefinitionId;
  int? branchId;
  Guid? companyId;
  int? salesmanId;
  num? unAllocatedAmount;
  bool? isAppliedScheme;
  bool? isPosInvoice;
  bool? isSaleReturn;
  List<SchemePOSInvoiceDetailModel> posInvoiceDetails;
  List<SchemeInvoiceDiscountDto> posInvoiceDiscounts;
  List<PosPaymentModel>? posPaymentDetails;
  SchemePOSInvoiceModel({
    this.id,
    this.companySlug,
    this.series,
    this.number,
    this.fbrInvoiceQrCode,
    this.fbrPosInvoiceNumber,
    this.fbrPosFee,
    this.posCashRegisterId,
    this.cashRegisterSessionId,
    this.customerId,
    this.currencyId,
    this.status,
    this.userId,
    this.exchangeRate,
    this.outstandingBalance,
    this.grossAmount,
    this.discountAmount,
    this.taxAmount,
    this.masterGroupId,
    this.autoRoundOff,
    this.manualRoundOff,
    this.discountPercent = 0,
    this.netAmount = 0.0,
    this.amountBeforeDiscount,
    this.receivedAmount,
    this.returnAmount,
    this.date,
    this.time,
    this.isVoid,
    this.templateDefinitionId,
    this.branchId,
    this.companyId,
    this.salesmanId,
    this.unAllocatedAmount,
    this.isAppliedScheme,
    this.isPosInvoice,
    this.isSaleReturn,
    required this.posInvoiceDetails,
    required this.posInvoiceDiscounts,
    this.posPaymentDetails,
  });

  SchemePOSInvoiceModel copyWith({
    int? id,
    String? companySlug,
    String? series,
    String? number,
    int? fbrInvoiceQrCode,
    String? fbrPosInvoiceNumber,
    num? fbrPosFee,
    int? posCashRegisterId,
    Guid? cashRegisterSessionId,
    int? customerId,
    int? currencyId,
    int? status,
    Guid? userId,
    num? exchangeRate,
    num? outstandingBalance,
    num? grossAmount,
    num? discountAmount,
    num? taxAmount,
    int? masterGroupId,
    num? autoRoundOff,
    num? manualRoundOff,
    num? discountPercent,
    num? netAmount,
    num? amountBeforeDiscount,
    num? receivedAmount,
    num? returnAmount,
    DateTime? date,
    DateTime? time,
    bool? isVoid,
    int? templateDefinitionId,
    int? branchId,
    Guid? companyId,
    int? salesmanId,
    num? unAllocatedAmount,
    bool? isAppliedScheme,
    bool? isPosInvoice,
    bool? isSaleReturn,
    List<SchemePOSInvoiceDetailModel>? posInvoiceDetails,
    List<SchemeInvoiceDiscountDto>? posInvoiceDiscounts,
    List<PosPaymentModel>? posPaymentDetails,
  }) {
    return SchemePOSInvoiceModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      series: series ?? this.series,
      number: number ?? this.number,
      fbrInvoiceQrCode: fbrInvoiceQrCode ?? this.fbrInvoiceQrCode,
      fbrPosInvoiceNumber: fbrPosInvoiceNumber ?? this.fbrPosInvoiceNumber,
      fbrPosFee: fbrPosFee ?? this.fbrPosFee,
      posCashRegisterId: posCashRegisterId ?? this.posCashRegisterId,
      cashRegisterSessionId:
          cashRegisterSessionId ?? this.cashRegisterSessionId,
      customerId: customerId ?? this.customerId,
      currencyId: currencyId ?? this.currencyId,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      grossAmount: grossAmount ?? this.grossAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      taxAmount: taxAmount ?? this.taxAmount,
      masterGroupId: masterGroupId ?? this.masterGroupId,
      autoRoundOff: autoRoundOff ?? this.autoRoundOff,
      manualRoundOff: manualRoundOff ?? this.manualRoundOff,
      discountPercent: discountPercent ?? this.discountPercent,
      netAmount: netAmount ?? this.netAmount,
      amountBeforeDiscount: amountBeforeDiscount ?? this.amountBeforeDiscount,
      receivedAmount: receivedAmount ?? this.receivedAmount,
      returnAmount: returnAmount ?? this.returnAmount,
      date: date ?? this.date,
      time: time ?? this.time,
      isVoid: isVoid ?? this.isVoid,
      templateDefinitionId: templateDefinitionId ?? this.templateDefinitionId,
      branchId: branchId ?? this.branchId,
      companyId: companyId ?? this.companyId,
      salesmanId: salesmanId ?? this.salesmanId,
      unAllocatedAmount: unAllocatedAmount ?? this.unAllocatedAmount,
      isAppliedScheme: isAppliedScheme ?? this.isAppliedScheme,
      isPosInvoice: isPosInvoice ?? this.isPosInvoice,
      isSaleReturn: isSaleReturn ?? this.isSaleReturn,
      posInvoiceDetails: posInvoiceDetails ?? this.posInvoiceDetails,
      posInvoiceDiscounts: posInvoiceDiscounts ?? this.posInvoiceDiscounts,
      posPaymentDetails: posPaymentDetails ?? this.posPaymentDetails,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'series': series,
      'number': number,
      'fbrInvoiceQrCode': fbrInvoiceQrCode,
      'fbrPosInvoiceNumber': fbrPosInvoiceNumber,
      'fbrPosFee': fbrPosFee,
      'posCashRegisterId': posCashRegisterId,
      'cashRegisterSessionId': cashRegisterSessionId?.toString(),
      'customerId': customerId,
      'currencyId': currencyId,
      'status': status,
      'userId': userId?.toString(),
      'exchangeRate': exchangeRate,
      'outstandingBalance': outstandingBalance,
      'grossAmount': grossAmount,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'masterGroupId': masterGroupId,
      'autoRoundOff': autoRoundOff,
      'manualRoundOff': manualRoundOff,
      'discountPercent': discountPercent,
      'netAmount': netAmount,
      'amountBeforeDiscount': amountBeforeDiscount,
      'receivedAmount': receivedAmount,
      'returnAmount': returnAmount,
      'date': date?.toIso8601String(),
      'time': time?.toIso8601String(),
      'isVoid': isVoid,
      'templateDefinitionId': templateDefinitionId,
      'branchId': branchId,
      'companyId': companyId?.toString(),
      'salesmanId': salesmanId,
      'unAllocatedAmount': unAllocatedAmount,
      'isAppliedScheme': isAppliedScheme,
      'isPosInvoice': isPosInvoice,
      'isSaleReturn': isSaleReturn,
      'posInvoiceDetails': posInvoiceDetails.map((x) => x.toMap()).toList(),
      'posInvoiceDiscounts': posInvoiceDiscounts.map((x) => x.toMap()).toList(),
      'posPaymentDetails': posPaymentDetails?.map((x) => x.toMap()).toList(),
    };
  }

  factory SchemePOSInvoiceModel.fromMap(Map<String, dynamic> map) {
    return SchemePOSInvoiceModel(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      series: map['series'],
      number: map['number'],
      fbrInvoiceQrCode: map['fbrInvoiceQrCode']?.toInt(),
      fbrPosInvoiceNumber: map['fbrPosInvoiceNumber'],
      fbrPosFee: map['fbrPosFee'],
      posCashRegisterId: map['posCashRegisterId']?.toInt(),
      cashRegisterSessionId: map['cashRegisterSessionId'] != null
          ? Guid(map['cashRegisterSessionId'])
          : null,
      customerId: map['customerId']?.toInt(),
      currencyId: map['currencyId']?.toInt(),
      status: map['status']?.toInt(),
      userId: map['userId'] != null ? Guid(map['userId']) : null,
      exchangeRate: map['exchangeRate'],
      outstandingBalance: map['outstandingBalance'],
      grossAmount: map['grossAmount'],
      discountAmount: map['discountAmount'] ?? 0,
      taxAmount: map['taxAmount'],
      masterGroupId: map['masterGroupId']?.toInt(),
      autoRoundOff: map['autoRoundOff'],
      manualRoundOff: map['manualRoundOff'],
      discountPercent: map['discountPercent'] ?? 0,
      netAmount: map['netAmount'],
      amountBeforeDiscount: map['amountBeforeDiscount'],
      receivedAmount: map['receivedAmount'],
      returnAmount: map['returnAmount'],
      date: map['date'] != null ? DateTime.parse(map['date']) : null,
      time: map['time'] != null ? DateTime.parse(map['time']) : null,
      isVoid: map['isVoid'],
      templateDefinitionId: map['templateDefinitionId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      companyId: map['companyId'] != null ? Guid(map['companyId']) : null,
      salesmanId: map['salesmanId']?.toInt(),
      unAllocatedAmount: map['unAllocatedAmount'],
      isAppliedScheme: map['isAppliedScheme'],
      isPosInvoice: map['isPosInvoice'],
      isSaleReturn: map['isSaleReturn'],
      posInvoiceDetails: List<SchemePOSInvoiceDetailModel>.from(
          map['posInvoiceDetails']
              ?.map((x) => SchemePOSInvoiceDetailModel.fromMap(x))),
      posInvoiceDiscounts: List<SchemeInvoiceDiscountDto>.from(
          map['posInvoiceDiscounts']
              ?.map((x) => SchemeInvoiceDiscountDto.fromMap(x))),
      posPaymentDetails: map['posPaymentDetails'] != null
          ? List<PosPaymentModel>.from(
              map['posPaymentDetails']?.map((x) => PosPaymentModel.fromMap(x)))
          : null,
    );
  }

  // String toJson() => json.encode(toMap());

  // factory SchemePOSInvoiceModel.fromJson(String source) =>
  //     SchemePOSInvoiceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SchemePOSInvoiceModel(id: $id, companySlug: $companySlug, series: $series, number: $number, fbrInvoiceQrCode: $fbrInvoiceQrCode, fbrPosInvoiceNumber: $fbrPosInvoiceNumber, fbrPosFee: $fbrPosFee, posCashRegisterId: $posCashRegisterId, cashRegisterSessionId: $cashRegisterSessionId, customerId: $customerId, currencyId: $currencyId, status: $status, userId: $userId, exchangeRate: $exchangeRate, outstandingBalance: $outstandingBalance, grossAmount: $grossAmount, discountAmount: $discountAmount, taxAmount: $taxAmount, masterGroupId: $masterGroupId, autoRoundOff: $autoRoundOff, manualRoundOff: $manualRoundOff, discountPercent: $discountPercent, netAmount: $netAmount, amountBeforeDiscount: $amountBeforeDiscount, receivedAmount: $receivedAmount, returnAmount: $returnAmount, date: $date, time: $time, isVoid: $isVoid, templateDefinitionId: $templateDefinitionId, branchId: $branchId, companyId: $companyId, salesmanId: $salesmanId, unAllocatedAmount: $unAllocatedAmount, isAppliedScheme: $isAppliedScheme, isPosInvoice: $isPosInvoice, isSaleReturn: $isSaleReturn, posInvoiceDetails: $posInvoiceDetails, posInvoiceDiscounts: $posInvoiceDiscounts, posPaymentDetails: $posPaymentDetails)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemePOSInvoiceModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.series == series &&
        other.number == number &&
        other.fbrInvoiceQrCode == fbrInvoiceQrCode &&
        other.fbrPosInvoiceNumber == fbrPosInvoiceNumber &&
        other.fbrPosFee == fbrPosFee &&
        other.posCashRegisterId == posCashRegisterId &&
        other.cashRegisterSessionId == cashRegisterSessionId &&
        other.customerId == customerId &&
        other.currencyId == currencyId &&
        other.status == status &&
        other.userId == userId &&
        other.exchangeRate == exchangeRate &&
        other.outstandingBalance == outstandingBalance &&
        other.grossAmount == grossAmount &&
        other.discountAmount == discountAmount &&
        other.taxAmount == taxAmount &&
        other.masterGroupId == masterGroupId &&
        other.autoRoundOff == autoRoundOff &&
        other.manualRoundOff == manualRoundOff &&
        other.discountPercent == discountPercent &&
        other.netAmount == netAmount &&
        other.amountBeforeDiscount == amountBeforeDiscount &&
        other.receivedAmount == receivedAmount &&
        other.returnAmount == returnAmount &&
        other.date == date &&
        other.time == time &&
        other.isVoid == isVoid &&
        other.templateDefinitionId == templateDefinitionId &&
        other.branchId == branchId &&
        other.companyId == companyId &&
        other.salesmanId == salesmanId &&
        other.unAllocatedAmount == unAllocatedAmount &&
        other.isAppliedScheme == isAppliedScheme &&
        other.isPosInvoice == isPosInvoice &&
        other.isSaleReturn == isSaleReturn &&
        listEquals(other.posInvoiceDetails, posInvoiceDetails) &&
        listEquals(other.posInvoiceDiscounts, posInvoiceDiscounts) &&
        listEquals(other.posPaymentDetails, posPaymentDetails);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        series.hashCode ^
        number.hashCode ^
        fbrInvoiceQrCode.hashCode ^
        fbrPosInvoiceNumber.hashCode ^
        fbrPosFee.hashCode ^
        posCashRegisterId.hashCode ^
        cashRegisterSessionId.hashCode ^
        customerId.hashCode ^
        currencyId.hashCode ^
        status.hashCode ^
        userId.hashCode ^
        exchangeRate.hashCode ^
        outstandingBalance.hashCode ^
        grossAmount.hashCode ^
        discountAmount.hashCode ^
        taxAmount.hashCode ^
        masterGroupId.hashCode ^
        autoRoundOff.hashCode ^
        manualRoundOff.hashCode ^
        discountPercent.hashCode ^
        netAmount.hashCode ^
        amountBeforeDiscount.hashCode ^
        receivedAmount.hashCode ^
        returnAmount.hashCode ^
        date.hashCode ^
        time.hashCode ^
        isVoid.hashCode ^
        templateDefinitionId.hashCode ^
        branchId.hashCode ^
        companyId.hashCode ^
        salesmanId.hashCode ^
        unAllocatedAmount.hashCode ^
        isAppliedScheme.hashCode ^
        isPosInvoice.hashCode ^
        isSaleReturn.hashCode ^
        posInvoiceDetails.hashCode ^
        posInvoiceDiscounts.hashCode ^
        posPaymentDetails.hashCode;
  }
}
