import 'dart:convert';
import 'package:flutter_guid/flutter_guid.dart';

import '../../Controller/BaseRepository.dart';

class PosCashRegisterFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String cashRegisterSessionId = 'cashRegisterSessionId';
  static final String userId = 'userId';
  static final String cashAccountId = 'cashAccountId';
  static final String creditCardBankAccountId = 'creditCardBankAccountId';
  static final String bankExpenseAccountId = 'bankExpenseAccountId';
  static final String bankChargesRate = 'bankChargesRate';
  static final String bankChargesAmount = 'bankChargesAmount';
  static final String warehouseId = 'warehouseId';
  static final String masterGroupId = 'masterGroupId';
  static final String posInvoiceSeries = 'posInvoiceSeries';
  static final String posReturnSeries = 'posReturnSeries';
  static final String fbrPosRegistationNo = 'fbrPosRegistationNo';
  static final String fbrCounterAuthToken = 'fbrCounterAuthToken';
  static final String enableFbrPosOnCounter = 'enableFbrPosOnCounter';
  static final String posRefundSeries = 'posRefundSeries';
  static final String comments = 'comments';
  static final String updatedOn = 'updatedOn';
  static final String difference = 'difference';
  static final String isActive = 'isActive';
  static final String isReserved = 'isReserved ';
  static final String macAddress = 'macAddress ';
  static final String machineName = 'machineName';
  static final String branchId = 'branchId';
  static final String prefix = 'prefix';
}

class PosCashRegisterModel extends BaseModel<int> {
  @override
  int? id;
  @override
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
  bool isSync;
  DateTime? syncDate;
  num? difference;
  bool isReserved;
  String? macAddress;
  String? machineName;
  int? branchId;
  PosCashRegisterModel(
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
      this.isSync = false,
      this.syncDate,
      this.difference,
      this.isReserved = false,
      this.macAddress,
      this.machineName,
      this.branchId});

  PosCashRegisterModel copyWith({
    int? id,
    String? companySlug,
    String? name,
    Guid? cashRegisterSessionId,
    Guid? userId,
    int? cashAccountId,
    int? creditCardBankAccountId,
    int? bankExpenseAccountId,
    num? bankChargesRate,
    num? bankChargesAmount,
    int? warehouseId,
    int? masterGroupId,
    String? posInvoiceSeries,
    String? posReturnSeries,
    int? fbrPosRegistationNo,
    String? fbrCounterAuthToken,
    bool? enableFbrPosOnCounter,
    String? posRefundSeries,
    bool? isActive,
    String? comments,
    DateTime? updatedOn,
    bool? isSync,
    DateTime? syncDate,
    num? totalCashAmount,
    num? difference,
    bool? isReserved,
    String? macAddress,
    String? machineName,
    int? branchId,
  }) {
    return PosCashRegisterModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      name: name ?? this.name,
      cashRegisterSessionId: cashRegisterSessionId ?? this.cashRegisterSessionId,
      userId: userId ?? this.userId,
      cashAccountId: cashAccountId ?? this.cashAccountId,
      creditCardBankAccountId: creditCardBankAccountId ?? this.creditCardBankAccountId,
      bankExpenseAccountId: bankExpenseAccountId ?? this.bankExpenseAccountId,
      bankChargesRate: bankChargesRate ?? this.bankChargesRate,
      bankChargesAmount: bankChargesAmount ?? this.bankChargesAmount,
      warehouseId: warehouseId ?? this.warehouseId,
      masterGroupId: masterGroupId ?? this.masterGroupId,
      posInvoiceSeries: posInvoiceSeries ?? this.posInvoiceSeries,
      posReturnSeries: posReturnSeries ?? this.posReturnSeries,
      fbrPosRegistationNo: fbrPosRegistationNo ?? this.fbrPosRegistationNo,
      fbrCounterAuthToken: fbrCounterAuthToken ?? this.fbrCounterAuthToken,
      enableFbrPosOnCounter: enableFbrPosOnCounter ?? this.enableFbrPosOnCounter,
      posRefundSeries: posRefundSeries ?? this.posRefundSeries,
      isActive: isActive ?? this.isActive,
      comments: comments ?? this.comments,
      updatedOn: updatedOn ?? this.updatedOn,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      difference: difference ?? this.difference,
      isReserved: isReserved ?? this.isReserved,
      macAddress: macAddress ?? this.macAddress,
      machineName: machineName ?? this.machineName,
      branchId: branchId ?? this.branchId,
    );
  }

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
      'fbrPosRegistationNo': fbrPosRegistationNo?.toInt(),
      'fbrCounterAuthToken': fbrCounterAuthToken,
      'enableFbrPosOnCounter': enableFbrPosOnCounter == true ? 1 : 0,
      'posRefundSeries': posRefundSeries,
      'isActive': isActive == true ? 1 : 0,
      'comments': comments,
      'updatedOn': updatedOn?.toIso8601String(),
      'isSync': isSync == true ? 1 : 0,
      'SyncDate': syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'difference': difference,
      'isReserved': isReserved == true ? 1 : 0,
      'macAddress': macAddress,
      'machineName': machineName,
      'branchId': branchId,
    };
  }

  factory PosCashRegisterModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return PosCashRegisterModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      name: map['name'] ?? '',
      cashRegisterSessionId: map['cashRegisterSessionId'] != null ? Guid(map['cashRegisterSessionId']) : null,
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
      enableFbrPosOnCounter: (map['enableFbrPosOnCounter'] == 0 || map['enableFbrPosOnCounter'] == false) ? false : true,
      posRefundSeries: map['posRefundSeries'],
      isActive: (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      comments: map['comments'],
      updatedOn: DateTime.parse((map['updatedOn'])),
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      difference: map['difference'],
      isReserved: (map['isReserved'] == 0 || map['isReserved'] == false) ? false : true,
      macAddress: map['macAddress'],
      machineName: map['machineName'],
      branchId: map['branchId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return PosCashRegisterModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PosCashRegisterModel(id: $id, companySlug: $companySlug, name: $name, cashRegisterSessionId: $cashRegisterSessionId, userId: $userId, cashAccountId: $cashAccountId, creditCardBankAccountId: $creditCardBankAccountId, bankExpenseAccountId: $bankExpenseAccountId, bankChargesRate: $bankChargesRate, bankChargesAmount: $bankChargesAmount, warehouseId: $warehouseId, masterGroupId: $masterGroupId, posInvoiceSeries: $posInvoiceSeries, posReturnSeries: $posReturnSeries, fbrPosRegistationNo: $fbrPosRegistationNo, fbrCounterAuthToken: $fbrCounterAuthToken, enableFbrPosOnCounter: $enableFbrPosOnCounter, posRefundSeries: $posRefundSeries, isActive: $isActive, comments: $comments, updatedOn: $updatedOn, isSync: $isSync, syncDate: $syncDate, difference: $difference, isReserved: $isReserved, macAddress: $macAddress, machineName: $machineName, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PosCashRegisterModel &&
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
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.difference == difference &&
        other.isReserved == isReserved &&
        other.macAddress == macAddress &&
        other.machineName == machineName &&
        other.branchId == branchId;
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
        isSync.hashCode ^
        syncDate.hashCode ^
        difference.hashCode ^
        isReserved.hashCode ^
        macAddress.hashCode ^
        machineName.hashCode ^
        branchId.hashCode;
  }

  List<PosCashRegisterModel> FromJson(String str, String slug) => List<PosCashRegisterModel>.from(json.decode(str).map((x) => PosCashRegisterModel().fromJson(x, slug: slug)));

  String ToJson(List<PosCashRegisterModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
