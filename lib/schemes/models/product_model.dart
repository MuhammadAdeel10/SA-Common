import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

import '../../schemes/models/ProductSalesTaxModel.dart';

class ProductFields {
  static final String id = 'id';
  static final String code = 'code';
  static final String number = 'number';
  static final String barcode = 'barcode';
  static final String sku = 'sku';
  static final String name = 'name';
  static final String description = 'description';
  static final String catalogContent = 'catalogContent';
  static final String shortName = 'shortName';
  static final String productCategoryId = 'productCategoryId';
  static final String brandName = 'brandName';
  static final String symbol = 'symbol';
  static final String isOpening = 'isOpening ';
  static final String purchasePrice = 'purchasePrice';
  static final String maximumRetailPrice = 'maximumRetailPrice';
  static final String isMRPExclusiveTax = 'isMRPExclusiveTax';
  static final String baseProductId = 'baseProductId';
  static final String productType = 'productType ';
  static final String precision = 'precision';
  static final String unitId = 'unitId';
  static final String salePrice = 'salePrice';
  static final String imageUrl = 'imageUrl';
  static final String isActive = 'isActive';
  static final String isSync = 'isSync';
  static final String fractionalUnit = 'fractionalUnit ';
  static final String syncDate = 'syncDate';
  static final String companySlug = 'companySlug';
  static final String hasBatch = 'hasBatch';
  static final String hasSerialNumber = 'hasSerialNumber';
  static final String basePackingId = 'basePackingId';
  static final String baseVariantId = 'baseVariantId';
  static final String isForSale = 'isForSale';
}

class ProductModel extends BaseModel<int> {
  @override
  int? id;
  String code;
  String number;
  String barcode;
  String sku;
  String name;
  String description;
  String catalogContent;
  String shortName;
  int? productCategoryId;
  String brandName;
  String symbol;
  bool isOpening;
  double purchasePrice;
  double maximumRetailPrice;
  bool isMRPExclusiveTax;
  int? baseProductId;
  int productType;
  int precision;
  int? unitId;
  double salePrice;
  String imageUrl;
  bool isActive;
  bool isSync;
  bool fractionalUnit;
  DateTime? syncDate;
  String? companySlug;
  bool? hasSerialNumber;
  bool? hasBatch;
  bool? isForSale;
  int? baseVariantId;
  int? basePackingId;
  List<ProductSalesTaxModel>? saleTaxes;
  ProductModel(
      {this.code = "",
      this.number = "",
      this.barcode = "",
      this.sku = "",
      this.name = "",
      this.description = "",
      this.catalogContent = "",
      this.shortName = "",
      this.productCategoryId,
      this.brandName = "",
      this.symbol = "",
      this.isOpening = false,
      this.purchasePrice = 0.00,
      this.maximumRetailPrice = 0.00,
      this.isMRPExclusiveTax = false,
      this.baseProductId,
      this.productType = 0,
      this.precision = 0,
      this.unitId,
      this.salePrice = 0.00,
      this.imageUrl = "",
      this.isActive = true,
      this.isSync = false,
      this.fractionalUnit = false,
      this.syncDate,
      this.id,
      this.companySlug = "",
      this.saleTaxes,
      this.hasBatch,
      this.isForSale,
      this.hasSerialNumber,
      this.basePackingId,
      this.baseVariantId});

  ProductModel copyWith(
      {String? code,
      String? number,
      String? barcode,
      String? name,
      String? description,
      String? catalogContent,
      String? shortName,
      int? productCategoryId,
      String? brandName,
      String? symbol,
      bool? isOpening,
      double? purchasePrice,
      double? maximumRetailPrice,
      bool? isMRPExclusiveTax,
      int? baseProductId,
      int? productType,
      int? precision,
      int? unitId,
      double? salePrice,
      String? imageUrl,
      bool? isActive,
      bool? isSync,
      bool? fractionalUnit,
      DateTime? syncDate,
      String? companySlug,
      List<ProductSalesTaxModel>? saleTaxes,
      bool? hasSerialNumber,
      bool? isForSale,
      bool? hasBatch}) {
    return ProductModel(
        code: code ?? this.code,
        number: number ?? this.number,
        barcode: barcode ?? this.barcode,
        name: name ?? this.name,
        description: description ?? this.description,
        catalogContent: catalogContent ?? this.catalogContent,
        shortName: shortName ?? this.shortName,
        productCategoryId: productCategoryId ?? this.productCategoryId,
        brandName: brandName ?? this.brandName,
        symbol: symbol ?? this.symbol,
        isOpening: isOpening ?? this.isOpening,
        purchasePrice: purchasePrice ?? this.purchasePrice,
        maximumRetailPrice: maximumRetailPrice ?? this.maximumRetailPrice,
        isMRPExclusiveTax: isMRPExclusiveTax ?? this.isMRPExclusiveTax,
        baseProductId: baseProductId ?? this.baseProductId,
        productType: productType ?? this.productType,
        precision: precision ?? this.precision,
        unitId: unitId ?? this.unitId,
        salePrice: salePrice ?? this.salePrice,
        imageUrl: imageUrl ?? this.imageUrl,
        isActive: isActive ?? this.isActive,
        isSync: isSync ?? this.isSync,
        fractionalUnit: fractionalUnit ?? this.fractionalUnit,
        syncDate: syncDate ?? this.syncDate,
        companySlug: companySlug ?? this.companySlug,
        saleTaxes: saleTaxes ?? this.saleTaxes,
        hasBatch: hasBatch ?? this.hasBatch,
        isForSale: isForSale ?? this.isForSale,
        hasSerialNumber: hasSerialNumber ?? this.hasSerialNumber);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'number': number,
      'barcode': barcode,
      'sku': sku,
      'name': name,
      'description': description,
      'catalogContent': catalogContent,
      'shortName': shortName,
      'productCategoryId': productCategoryId,
      'brandName': brandName,
      'symbol': symbol,
      'isOpening': isOpening == true ? 1 : 0,
      'purchasePrice': purchasePrice,
      'maximumRetailPrice': maximumRetailPrice,
      'isMRPExclusiveTax': isMRPExclusiveTax == true ? 1 : 0,
      'baseProductId': baseProductId,
      'productType': productType,
      'precision': precision,
      'unitId': unitId,
      'companySlug': companySlug,
      'salePrice': salePrice,
      'imageUrl': imageUrl,
      'isActive': isActive == true ? 1 : 0,
      'isSync': isSync == true ? 1 : 0,
      'fractionalUnit': fractionalUnit == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'hasBatch': hasBatch,
      'isForSale': isForSale == true ? 1 : 0,
      'hasSerialNumber': hasSerialNumber,
      'baseVariantId': baseVariantId,
      'basePackingId': basePackingId,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return ProductModel(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      number: map['number'] ?? '',
      barcode: map['barcode'] ?? '',
      sku: map['sku'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      catalogContent: map['catalogContent'] ?? '',
      shortName: map['shortName'] ?? '',
      productCategoryId: map['productCategoryId']?.toInt(),
      brandName: map['brandName'] ?? '',
      symbol: map['symbol'] ?? '',
      isOpening:
          (map['isOpening'] == 0 || map['isOpening'] == false) ? false : true,
      purchasePrice: map['purchasePrice']?.toDouble() ?? 0.0,
      maximumRetailPrice: map['maximumRetailPrice']?.toDouble() ?? 0.0,
      isMRPExclusiveTax:
          (map['isMRPExclusiveTax'] == 0 || map['isMRPExclusiveTax'] == false)
              ? false
              : true,
      baseProductId: map['baseProductId']?.toInt(),
      basePackingId: map['basePackingId']?.toInt(),
      baseVariantId: map['baseVariantId']?.toInt(),
      productType: map['productType']?.toInt() ?? 0,
      precision: map['precision']?.toInt() ?? 0,
      unitId: map['unitId']?.toInt(),
      salePrice: map['salePrice']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      isActive:
          (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      isForSale: (map['isForSale'] == 0 || map['isForSale'] == false) ? false : true,
      fractionalUnit:
          (map['fractionalUnit'] == 0 || map['fractionalUnit'] == false)
              ? false
              : true,
      syncDate: map['syncDate'] == null
          ? null
          : DateTime.parse(map['syncDate'] as String),
      companySlug: slug,
      saleTaxes: map['saleTaxes'] != null
          ? List<ProductSalesTaxModel>.from(
              map['saleTaxes']?.map((x) => ProductSalesTaxModel.fromMap(x)))
          : null,
      hasBatch:
          (map['hasBatch'] == 0 || map['hasBatch'] == false) ? false : true,
      hasSerialNumber:
          (map['hasSerialNumber'] == 0 || map['hasSerialNumber'] == false)
              ? false
              : true,
    );
  }
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return ProductModel.fromMap(json, slug: slug ?? '');
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'ProductModel(code: $code, number: $number, barcode: $barcode, name: $name, description: $description,  catalogContent: $catalogContent,shortName: $shortName, productCategoryId: $productCategoryId, brandName: $brandName, symbol: $symbol, isOpening: $isOpening, purchasePrice: $purchasePrice, maximumRetailPrice: $maximumRetailPrice, isMRPExclusiveTax: $isMRPExclusiveTax, baseProductId: $baseProductId, productType: $productType, precision: $precision, unitId: $unitId, salePrice: $salePrice, imageUrl: $imageUrl, isActive: $isActive, isSync: $isSync, isForSale: $isForSale, fractionalUnit: $fractionalUnit, syncDate: $syncDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ProductModel &&
        other.code == code &&
        other.number == number &&
        other.barcode == barcode &&
        other.name == name &&
        other.description == description &&
        other.catalogContent == catalogContent &&
        other.shortName == shortName &&
        other.productCategoryId == productCategoryId &&
        other.brandName == brandName &&
        other.symbol == symbol &&
        other.isOpening == isOpening &&
        other.purchasePrice == purchasePrice &&
        other.maximumRetailPrice == maximumRetailPrice &&
        other.isMRPExclusiveTax == isMRPExclusiveTax &&
        other.baseProductId == baseProductId &&
        other.productType == productType &&
        other.precision == precision &&
        other.unitId == unitId &&
        other.salePrice == salePrice &&
        other.imageUrl == imageUrl &&
        other.isActive == isActive &&
        other.isSync == isSync &&
        other.isForSale == isForSale &&
        other.fractionalUnit == fractionalUnit &&
        other.syncDate == syncDate;
  }

  @override
  int get hashCode {
    return code.hashCode ^
        number.hashCode ^
        barcode.hashCode ^
        name.hashCode ^
        description.hashCode ^
        catalogContent.hashCode ^
        shortName.hashCode ^
        productCategoryId.hashCode ^
        brandName.hashCode ^
        symbol.hashCode ^
        isOpening.hashCode ^
        purchasePrice.hashCode ^
        maximumRetailPrice.hashCode ^
        isMRPExclusiveTax.hashCode ^
        baseProductId.hashCode ^
        productType.hashCode ^
        precision.hashCode ^
        unitId.hashCode ^
        salePrice.hashCode ^
        imageUrl.hashCode ^
        isActive.hashCode ^
        isSync.hashCode ^
        isForSale.hashCode ^
        fractionalUnit.hashCode ^
        syncDate.hashCode;
  }

  List<ProductModel> FromJson(String str) => List<ProductModel>.from(
      json.decode(str).map((x) => ProductModel().fromJson(x)));

  String ToJson(List<ProductModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
