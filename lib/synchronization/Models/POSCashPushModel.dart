import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';

class POSCashPush {
  int? id;
  String? companySlug;
  String name;
  Guid? cashRegisterSessionId;
  Guid? userId;
  int? cashAccountId;
  int? creditCardBankAccountId;
  int? bankExpenseAccountId;
  num? bankChargesRate;
  num? bankChargesAmount;
  int? warehouseId;
  int? masterGroupId;
  String? posInvoiceSeries;
  String? posReturnSeries;
  int? fbrPosRegistationNo;
  String? fbrCounterAuthToken;
  bool? enableFbrPosOnCounter;
  String? posRefundSeries;
  bool isActive;
  String? comments;
  DateTime? updatedOn;
  num? difference;
  bool isReserved;
  String? macAddress;
  String? machineName;
  int? branchId;
  DateTime? checkInTime;
  DateTime? checkOutTime;
  num totalCashAmount;
  bool isDesktop;
  String? prefix;
  POSCashPush(
      {this.id,
      this.companySlug,
      this.name = "",
      this.cashRegisterSessionId,
      this.userId,
      this.cashAccountId,
      this.creditCardBankAccountId,
      this.bankExpenseAccountId,
      this.bankChargesRate,
      this.bankChargesAmount,
      this.warehouseId,
      this.masterGroupId,
      this.posInvoiceSeries,
      this.posReturnSeries,
      this.fbrPosRegistationNo,
      this.fbrCounterAuthToken,
      this.enableFbrPosOnCounter,
      this.posRefundSeries,
      this.isActive = false,
      this.comments,
      this.updatedOn,
      this.difference,
      this.isReserved = false,
      this.macAddress,
      this.machineName,
      this.branchId,
      this.checkInTime,
      this.checkOutTime,
      this.isDesktop = false,
      this.prefix,
      this.totalCashAmount = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'name': name,
      'cashRegisterSessionId': cashRegisterSessionId?.toString(),
      'userId': userId?.toString(),
      'cashAccountId': cashAccountId,
      'creditCardBankAccountId': creditCardBankAccountId,
      'bankExpenseAccountId': bankExpenseAccountId,
      'bankChargesRate': bankChargesRate,
      'bankChargesAmount': bankChargesAmount,
      'warehouseId': warehouseId,
      'masterGroupId': masterGroupId,
      'posInvoiceSeries': posInvoiceSeries,
      'posReturnSeries': posReturnSeries,
      'fbrPosRegistationNo': fbrPosRegistationNo,
      'fbrCounterAuthToken': fbrCounterAuthToken,
      'enableFbrPosOnCounter': enableFbrPosOnCounter == true ? 1 : 0,
      'posRefundSeries': posRefundSeries,
      'isActive': isActive == true ? 1 : 0,
      'comments': comments,
      'updatedOn': updatedOn?.toIso8601String(),
      'difference': difference,
      'isReserved': isReserved == true ? 1 : 0,
      'isDesktop': isDesktop == true ? 1 : 0,
      'macAddress': macAddress,
      'machineName': machineName,
      'branchId': branchId,
      'checkInTime': checkInTime?.toIso8601String(),
      'checkOutTime': checkOutTime?.toIso8601String(),
      'prefix': prefix,
      'totalCashAmount': totalCashAmount
    };
  }

  factory POSCashPush.fromMap(Map<String, dynamic> map) {
    return POSCashPush(
      id: map['id']?.toInt(),
      companySlug: map['companySlug'],
      name: map['name'] ?? '',
      prefix: map['prefix'] ?? '',
      cashRegisterSessionId: map['cashRegisterSessionId'] != null
          ? Guid(map['cashRegisterSessionId'])
          : null,
      userId: map['userId'] != null ? Guid(map['userId']) : null,
      cashAccountId: map['cashAccountId']?.toInt(),
      creditCardBankAccountId: map['creditCardBankAccountId']?.toInt(),
      bankExpenseAccountId: map['bankExpenseAccountId']?.toInt(),
      bankChargesRate: map['bankChargesRate'],
      bankChargesAmount: map['bankChargesAmount'],
      warehouseId: map['warehouseId']?.toInt(),
      masterGroupId: map['masterGroupId']?.toInt(),
      posInvoiceSeries: map['posInvoiceSeries'],
      posReturnSeries: map['posReturnSeries'],
      fbrPosRegistationNo: map['fbrPosRegistationNo']?.toInt(),
      fbrCounterAuthToken: map['fbrCounterAuthToken'],
      enableFbrPosOnCounter: (map['enableFbrPosOnCounter'] == 0 ||
              map['enableFbrPosOnCounter'] == false)
          ? false
          : true,
      posRefundSeries: map['posRefundSeries'],
      isActive:
          (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      comments: map['comments'],
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      difference: map['difference'],
      isReserved:
          (map['isReserved'] == 0 || map['isReserved'] == false) ? false : true,
      isDesktop:
          (map['isDesktop'] == 0 || map['isDesktop'] == false) ? false : true,
      macAddress: map['macAddress'],
      machineName: map['machineName'],
      branchId: map['branchId']?.toInt(),
      checkInTime: map['checkInTime'] != null
          ? DateTime.parse(map['checkInTime'])
          : null,
      checkOutTime: map['checkOutTime'] != null
          ? DateTime.parse(map['checkOutTime'])
          : null,
      totalCashAmount: map['totalCashAmount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory POSCashPush.fromJson(String source) =>
      POSCashPush.fromMap(json.decode(source));

  @override
  String toString() {
    return 'POSCashPush(id: $id, companySlug: $companySlug, name: $name, cashRegisterSessionId: $cashRegisterSessionId, userId: $userId, cashAccountId: $cashAccountId, creditCardBankAccountId: $creditCardBankAccountId, bankExpenseAccountId: $bankExpenseAccountId, bankChargesRate: $bankChargesRate, bankChargesAmount: $bankChargesAmount, warehouseId: $warehouseId, masterGroupId: $masterGroupId, posInvoiceSeries: $posInvoiceSeries, posReturnSeries: $posReturnSeries, fbrPosRegistationNo: $fbrPosRegistationNo, fbrCounterAuthToken: $fbrCounterAuthToken, enableFbrPosOnCounter: $enableFbrPosOnCounter, posRefundSeries: $posRefundSeries, isActive: $isActive, comments: $comments, updatedOn: $updatedOn, difference: $difference, isReserved: $isReserved, macAddress: $macAddress, machineName: $machineName, branchId: $branchId, checkInTime: $checkInTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is POSCashPush &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.name == name &&
        other.cashRegisterSessionId == cashRegisterSessionId &&
        other.userId == userId &&
        other.cashAccountId == cashAccountId &&
        other.creditCardBankAccountId == creditCardBankAccountId &&
        other.bankExpenseAccountId == bankExpenseAccountId &&
        other.bankChargesRate == bankChargesRate &&
        other.bankChargesAmount == bankChargesAmount &&
        other.warehouseId == warehouseId &&
        other.masterGroupId == masterGroupId &&
        other.posInvoiceSeries == posInvoiceSeries &&
        other.posReturnSeries == posReturnSeries &&
        other.fbrPosRegistationNo == fbrPosRegistationNo &&
        other.fbrCounterAuthToken == fbrCounterAuthToken &&
        other.enableFbrPosOnCounter == enableFbrPosOnCounter &&
        other.posRefundSeries == posRefundSeries &&
        other.isActive == isActive &&
        other.comments == comments &&
        other.updatedOn == updatedOn &&
        other.difference == difference &&
        other.isReserved == isReserved &&
        other.macAddress == macAddress &&
        other.machineName == machineName &&
        other.branchId == branchId &&
        other.checkInTime == checkInTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        name.hashCode ^
        cashRegisterSessionId.hashCode ^
        userId.hashCode ^
        cashAccountId.hashCode ^
        creditCardBankAccountId.hashCode ^
        bankExpenseAccountId.hashCode ^
        bankChargesRate.hashCode ^
        bankChargesAmount.hashCode ^
        warehouseId.hashCode ^
        masterGroupId.hashCode ^
        posInvoiceSeries.hashCode ^
        posReturnSeries.hashCode ^
        fbrPosRegistationNo.hashCode ^
        fbrCounterAuthToken.hashCode ^
        enableFbrPosOnCounter.hashCode ^
        posRefundSeries.hashCode ^
        isActive.hashCode ^
        comments.hashCode ^
        updatedOn.hashCode ^
        difference.hashCode ^
        isReserved.hashCode ^
        macAddress.hashCode ^
        machineName.hashCode ^
        branchId.hashCode ^
        checkInTime.hashCode;
  }
}
