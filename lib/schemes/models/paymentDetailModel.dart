import 'dart:convert';

import '../../Controller/BaseRepository.dart';
import '../../utils/Enums.dart';

class PosPaymentField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String posInvoiceId = 'posInvoiceId';
  static final String posPaymentMode = 'posPaymentMode';
  static final String amount = 'amount';
  static final String adjusted = 'adjusted';
  static final String balance = 'balance';
  static final String cardNumber = 'cardNumber';
  static final String creditNoteNumber = 'creditNoteNumber';
  static final String saleReturnNumber = 'saleReturnNumber';
  static final String creditNoteId = 'creditNoteId';
  static final String saleReturnId = 'saleReturnId';
  static final String branchId = 'branchId';
  static final String customerLoyaltyRedeemPoints = 'customerLoyaltyRedeemPoints';
}

class PaymentModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? posInvoiceId;
  PosPaymentMode? posPaymentMode;
  num amount;
  num? adjusted;
  num? balance;
  String? cardNumber;
  String? creditNoteNumber;
  String? saleReturnNumber;
  int? creditNoteId;
  int? saleReturnId;
  int? branchId;
  int customerLoyaltyRedeemPoints;
  PaymentModel({this.id, this.companySlug, this.posInvoiceId, this.posPaymentMode, this.amount = 0.0, this.adjusted, this.balance, this.cardNumber, this.creditNoteNumber, this.saleReturnNumber, this.creditNoteId, this.saleReturnId, this.branchId, this.customerLoyaltyRedeemPoints = 0});

  PaymentModel copyWith({
    int? id,
    String? companySlug,
    int? posInvoiceId,
    PosPaymentMode? posPaymentMode,
    num? amount,
    num? adjusted,
    num? balance,
    String? cardNumber,
    String? creditNoteNumber,
    String? saleReturnNumber,
    int? creditNoteId,
    int? saleReturnId,
    int? branchId,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      posInvoiceId: posInvoiceId ?? this.posInvoiceId,
      posPaymentMode: posPaymentMode ?? this.posPaymentMode,
      amount: amount ?? this.amount,
      adjusted: adjusted ?? this.adjusted,
      balance: balance ?? this.balance,
      cardNumber: cardNumber ?? this.cardNumber,
      creditNoteNumber: creditNoteNumber ?? this.creditNoteNumber,
      saleReturnNumber: saleReturnNumber ?? this.saleReturnNumber,
      creditNoteId: creditNoteId ?? this.creditNoteId,
      saleReturnId: saleReturnId ?? this.saleReturnId,
      branchId: branchId ?? this.branchId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'posInvoiceId': posInvoiceId,
      'posPaymentMode': posPaymentMode?.value,
      'amount': amount,
      // 'adjusted': adjusted,
      // 'balance': balance,
      'cardNumber': cardNumber,
      'creditNoteNumber': creditNoteNumber,
      'saleReturnNumber': saleReturnNumber,
      'creditNoteId': creditNoteId == 0 ? null : creditNoteId,
      'saleReturnId': saleReturnId == 0 ? null : saleReturnId,
      'branchId': branchId,
      'customerLoyaltyRedeemPoints': customerLoyaltyRedeemPoints,
    };
  }

  factory PaymentModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return PaymentModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      posInvoiceId: map['posInvoiceId']?.toInt(),
      posPaymentMode: intToPosPaymentMode(map['posPaymentMode']),
      amount: map['amount'],
      adjusted: map['adjusted'],
      balance: map['balance'],
      cardNumber: map['cardNumber'],
      creditNoteNumber: map['creditNoteNumber'],
      saleReturnNumber: map['saleReturnNumber'],
      creditNoteId: map['creditNoteId']?.toInt(),
      saleReturnId: map['saleReturnId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      customerLoyaltyRedeemPoints: map['customerLoyaltyRedeemPoints']?.toInt(),
    );
  }

  @override
  String toString() {
    return 'PosPaymentDetailModel(id: $id, companySlug: $companySlug, posInvoiceId: $posInvoiceId, posPaymentMode: $posPaymentMode, amount: $amount, adjusted: $adjusted, balance: $balance, cardNumber: $cardNumber, creditNoteNumber: $creditNoteNumber, saleReturnNumber: $saleReturnNumber, creditNoteId: $creditNoteId, saleReturnId: $saleReturnId, branchId: $branchId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentModel && other.id == id && other.companySlug == companySlug && other.posInvoiceId == posInvoiceId && other.posPaymentMode == posPaymentMode && other.amount == amount && other.adjusted == adjusted && other.balance == balance && other.cardNumber == cardNumber && other.creditNoteNumber == creditNoteNumber && other.saleReturnNumber == saleReturnNumber && other.creditNoteId == creditNoteId && other.saleReturnId == saleReturnId && other.branchId == branchId;
  }

  @override
  int get hashCode {
    return id.hashCode ^ companySlug.hashCode ^ posInvoiceId.hashCode ^ posPaymentMode.hashCode ^ amount.hashCode ^ adjusted.hashCode ^ balance.hashCode ^ cardNumber.hashCode ^ creditNoteNumber.hashCode ^ saleReturnNumber.hashCode ^ creditNoteId.hashCode ^ saleReturnId.hashCode ^ branchId.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return PaymentModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<PaymentModel> FromJson(String str, String slug) => List<PaymentModel>.from(json.decode(str).map((x) => PaymentModel().fromJson(x, slug: slug)));

  String ToJson(List<PaymentModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
