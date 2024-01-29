import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Enums.dart';

class DetailsSchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String schemeId = 'schemeId';
  static final String invoiceAmount = 'invoiceAmount';
  static final String discountRate = 'discountRate';
  static final String schemeProductId = 'schemeProductId';
  static final String discountProductQuantity = 'discountProductQuantity';
  static final String productDiscountRate = 'productDiscountRate';
  static final String discountProductAmount = 'discountProductAmount';
  static final String bounsAmount = 'bounsAmount';
  static final String bounsProductId = 'bounsProductId';
  static final String bounsProductQuantity = 'bounsProductQuantity';
  static final String schemeProductQuantity = 'schemeProductQuantity';
  static final String schemeProductAmount = 'schemeProductAmount';
  static final String schemeBounsQuantity = 'schemeBounsQuantity';
  static final String schemeProductCategoryId = 'schemeProductCategoryId';
  static final String discountEffect = 'discountEffect';
  static final String bonusProductPrice = 'bonusProductPrice';
  static final String updatedOn = 'updatedOn';
  static final String productDiscountAmount = 'productDiscountAmount';
}

class DetailsSchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  int? schemeId;
  num? invoiceAmount;
  num? discountRate;
  int? schemeProductId;
  num? discountProductQuantity;
  num? discountProductAmount;
  num? productDiscountRate;
  num? bounsAmount;
  int? bounsProductId;
  num? bounsProductQuantity;
  num? schemeProductQuantity;
  num? schemeProductAmount;
  num? schemeBounsQuantity;
  int? schemeProductCategoryId;
  int? discountEffect;
  num? bonusProductPrice;
  num productDiscountAmount;
  DiscountType? discountType;

  DetailsSchemesModel(
      {this.id,
      this.companySlug,
      this.isSync = false,
      this.syncDate,
      this.schemeId,
      this.invoiceAmount,
      this.discountRate,
      this.schemeProductId,
      this.discountProductQuantity,
      this.discountProductAmount,
      this.productDiscountRate,
      this.bounsAmount,
      this.bounsProductId,
      this.bounsProductQuantity,
      this.schemeProductQuantity,
      this.schemeProductAmount,
      this.schemeBounsQuantity,
      this.schemeProductCategoryId,
      this.discountEffect,
      this.bonusProductPrice,
      this.updatedOn,
      this.productDiscountAmount = 0.0,
      this.discountType});

  DetailsSchemesModel copyWith(
      {int? id,
      String? companySlug,
      bool? isSync,
      DateTime? syncDate,
      int? schemeId,
      num? invoiceAmount,
      num? discountRate,
      int? schemeProductId,
      num? discountProductQuantity,
      num? discountProductAmount,
      num? productDiscountRate,
      num? bounsAmount,
      int? bounsProductId,
      num? bounsProductQuantity,
      num? schemeProductQuantity,
      num? schemeProductAmount,
      num? schemeBounsQuantity,
      int? schemeProductCategoryId,
      int? discountEffect,
      num? bonusProductPrice,
      DateTime? updatedOn,
      num? productDiscountAmount}) {
    return DetailsSchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      schemeId: schemeId ?? this.schemeId,
      invoiceAmount: invoiceAmount ?? this.invoiceAmount,
      discountRate: discountRate ?? this.discountRate,
      schemeProductId: schemeProductId ?? this.schemeProductId,
      discountProductQuantity:
          discountProductQuantity ?? this.discountProductQuantity,
      discountProductAmount:
          discountProductAmount ?? this.discountProductAmount,
      productDiscountRate: productDiscountRate ?? this.productDiscountRate,
      bounsAmount: bounsAmount ?? this.bounsAmount,
      bounsProductId: bounsProductId ?? this.bounsProductId,
      bounsProductQuantity: bounsProductQuantity ?? this.bounsProductQuantity,
      schemeProductQuantity:
          schemeProductQuantity ?? this.schemeProductQuantity,
      schemeProductAmount: schemeProductAmount ?? this.schemeProductAmount,
      schemeBounsQuantity: schemeBounsQuantity ?? this.schemeBounsQuantity,
      schemeProductCategoryId:
          schemeProductCategoryId ?? this.schemeProductCategoryId,
      discountEffect: discountEffect ?? this.discountEffect,
      bonusProductPrice: bonusProductPrice ?? this.bonusProductPrice,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'schemeId': schemeId,
      'invoiceAmount': invoiceAmount,
      'discountRate': discountRate,
      'schemeProductId': schemeProductId,
      'discountProductQuantity': discountProductQuantity,
      'discountProductAmount': discountProductAmount,
      'productDiscountRate': productDiscountRate,
      'bounsAmount': bounsAmount,
      'bounsProductId': bounsProductId,
      'bounsProductQuantity': bounsProductQuantity,
      'schemeProductQuantity': schemeProductQuantity,
      'schemeProductAmount': schemeProductAmount,
      'schemeBounsQuantity': schemeBounsQuantity,
      'schemeProductCategoryId': schemeProductCategoryId,
      'discountEffect': discountEffect,
      'bonusProductPrice': bonusProductPrice,
      'updatedOn': updatedOn?.toIso8601String(),
      'productDiscountAmount': productDiscountAmount
    };
  }

  factory DetailsSchemesModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return DetailsSchemesModel(
        id: map['id']?.toInt(),
        companySlug: slug ?? map['companySlug'],
        isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
        syncDate:
            map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
        schemeId: map['schemeId']?.toInt(),
        invoiceAmount: map['invoiceAmount'],
        discountRate: map['discountRate'],
        schemeProductId: map['schemeProductId']?.toInt(),
        discountProductQuantity: map['discountProductQuantity'],
        discountProductAmount: map['discountProductAmount'],
        productDiscountRate: map['productDiscountRate'],
        bounsAmount: map['bounsAmount'],
        bounsProductId: map['bounsProductId']?.toInt(),
        bounsProductQuantity: map['bounsProductQuantity'],
        schemeProductQuantity: map['schemeProductQuantity'],
        schemeProductAmount: map['schemeProductAmount'],
        schemeBounsQuantity: map['schemeBounsQuantity'],
        schemeProductCategoryId: map['schemeProductCategoryId']?.toInt(),
        discountEffect: map['discountEffect']?.toInt(),
        bonusProductPrice: map['bonusProductPrice'],
        productDiscountAmount: map['productDiscountAmount'],
        updatedOn:
            map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
        discountType: (map['productDiscountAmount'] > 0)
            ? DiscountType.Amount
            : DiscountType.Percent);
  }

  @override
  String toString() {
    return 'DetailsSchemesModel(id: $id, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate, schemeId: $schemeId, invoiceAmount: $invoiceAmount, discountRate: $discountRate, schemeProductId: $schemeProductId, discountProductQuantity: $discountProductQuantity, discountProductAmount: $discountProductAmount, productDiscountRate: $productDiscountRate, bounsAmount: $bounsAmount, bounsProductId: $bounsProductId, bounsProductQuantity: $bounsProductQuantity, schemeProductQuantity: $schemeProductQuantity, schemeProductAmount: $schemeProductAmount, schemeBounsQuantity: $schemeBounsQuantity, schemeProductCategoryId: $schemeProductCategoryId, discountEffect: $discountEffect, bonusProductPrice: $bonusProductPrice, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetailsSchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate &&
        other.schemeId == schemeId &&
        other.invoiceAmount == invoiceAmount &&
        other.discountRate == discountRate &&
        other.schemeProductId == schemeProductId &&
        other.discountProductQuantity == discountProductQuantity &&
        other.discountProductAmount == discountProductAmount &&
        other.productDiscountRate == productDiscountRate &&
        other.bounsAmount == bounsAmount &&
        other.bounsProductId == bounsProductId &&
        other.bounsProductQuantity == bounsProductQuantity &&
        other.schemeProductQuantity == schemeProductQuantity &&
        other.schemeProductAmount == schemeProductAmount &&
        other.schemeBounsQuantity == schemeBounsQuantity &&
        other.schemeProductCategoryId == schemeProductCategoryId &&
        other.discountEffect == discountEffect &&
        other.bonusProductPrice == bonusProductPrice &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode ^
        schemeId.hashCode ^
        invoiceAmount.hashCode ^
        discountRate.hashCode ^
        schemeProductId.hashCode ^
        discountProductQuantity.hashCode ^
        discountProductAmount.hashCode ^
        productDiscountRate.hashCode ^
        bounsAmount.hashCode ^
        bounsProductId.hashCode ^
        bounsProductQuantity.hashCode ^
        schemeProductQuantity.hashCode ^
        schemeProductAmount.hashCode ^
        schemeBounsQuantity.hashCode ^
        schemeProductCategoryId.hashCode ^
        discountEffect.hashCode ^
        bonusProductPrice.hashCode ^
        updatedOn.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return DetailsSchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<DetailsSchemesModel> FromJson(String str, String slug) =>
      List<DetailsSchemesModel>.from(json
          .decode(str)
          .map((x) => DetailsSchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<DetailsSchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
