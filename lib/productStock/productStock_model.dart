import 'dart:convert';

import '../Controller/BaseRepository.dart';

class ProductSockField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String productId = 'productId';
  static final String warehouseId = 'warehouseId';
  static final String consignmentId = 'consignmentId';
  static final String batchId = 'batchId';
  static final String quantityInHand = 'quantityInHand';
  static final String serialNumber = 'serialNumber';
}

class ProductStockModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  int? productId;
  int? warehouseId;
  int? consignmentId;
  int? batchId;
  num quantityInHand;
  String? serialNumber;
  int? screenType;
  ProductStockModel({this.id, this.companySlug, this.isSync = false, this.syncDate, this.updatedOn, this.productId, this.warehouseId, this.consignmentId, this.batchId, this.quantityInHand = 0.0, this.serialNumber, this.screenType});

  ProductStockModel copyWith({
    int? id,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
    DateTime? updatedOn,
    int? productId,
    int? warehouseId,
    int? consignmentId,
    int? batchId,
    num? quantityInHand,
    String? serialNumber,
  }) {
    return ProductStockModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
      updatedOn: updatedOn ?? this.updatedOn,
      productId: productId ?? this.productId,
      warehouseId: warehouseId ?? this.warehouseId,
      consignmentId: consignmentId ?? this.consignmentId,
      batchId: batchId ?? this.batchId,
      quantityInHand: quantityInHand ?? this.quantityInHand,
      serialNumber: serialNumber ?? this.serialNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      // 'updatedOn': updatedOn?.toIso8601String,
      'productId': productId,
      'warehouseId': warehouseId,
      'consignmentId': consignmentId,
      'batchId': batchId,
      'quantityInHand': quantityInHand,
      'serialNumber': serialNumber
    };
  }

  factory ProductStockModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return ProductStockModel(
        id: map['id']?.toInt(),
        companySlug: slug ?? map['companySlug'],
        isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
        syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
        updatedOn: map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
        productId: map['productId']?.toInt(),
        warehouseId: map['warehouseId']?.toInt(),
        consignmentId: map['consignmentId']?.toInt(),
        batchId: map['batchId']?.toInt(),
        quantityInHand: map['quantityInHand'] ?? 0,
        serialNumber: map['serialNumber'],
        screenType: map['screenType']);
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return ProductStockModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<ProductStockModel> FromJson(String str, String slug) => List<ProductStockModel>.from(json.decode(str).map((x) => ProductStockModel().fromJson(x, slug: slug)));

  String ToJson(List<ProductStockModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
