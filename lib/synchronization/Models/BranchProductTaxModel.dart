import 'dart:convert';
import '../../Controller/BaseRepository.dart';

class BranchProductTaxField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String productId = 'productId';
  static final String taxId = 'taxId';
  static final String branchId = 'branchId';
  static final String source = 'source';
}

class BranchProductTaxModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  int? productId;
  int? taxId;
  bool isSync;
  DateTime? syncDate;
  int? branchId;
  String? source;
  BranchProductTaxModel({
    this.id,
    this.companySlug,
    this.productId,
    this.taxId,
    this.isSync = false,
    this.syncDate,
    this.branchId,
    this.source,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'productId': productId,
      'taxId': taxId,
      'isSync': isSync,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'branchId': branchId,
      'source': source,
    };
  }

  factory BranchProductTaxModel.fromMap(Map<String, dynamic> map,
      {String? slug}) {
    return BranchProductTaxModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      productId: map['productId']?.toInt(),
      taxId: map['taxId']?.toInt(),
      isSync: (map['isSync'] == 0 || map['isSync'] == false),
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      branchId: map['branchId']?.toInt(),
      source: map['source'],
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return BranchProductTaxModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<BranchProductTaxModel> FromJson(String str, String slug) =>
      List<BranchProductTaxModel>.from(json
          .decode(str)
          .map((x) => BranchProductTaxModel().fromJson(x, slug: slug)));

  String ToJson(List<BranchProductTaxModel> data) => json
      .encode(List<BranchProductTaxModel>.from(data.map((x) => x.toJson())));
}
