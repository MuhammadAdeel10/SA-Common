// To parse this JSON data, do
//
//     final productImages = productImagesFromJson(jsonString);

import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

String productImagesToJson(ProductImages data) => json.encode(data.toJson());

class ProductImagesFields {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String imageUrl = 'imageUrl';
  static final String base64ImageString = 'base64ImageString';
  static final String productId = 'productId';
  static final String updatedOn = 'updatedOn';
}

class ProductImages extends BaseModel<int> {
  @override
  String? companySlug;
  String? imageUrl;
  int? productId;
  DateTime? updatedOn;
  int? id;

  ProductImages({
    this.imageUrl,
    this.companySlug,
    this.productId,
    this.updatedOn,
    this.id,
  });

  factory ProductImages.fromMap(Map<String, dynamic> json, {String? slug}) =>
      ProductImages(
        imageUrl: json["imageUrl"],
        companySlug: slug ?? json['companySlug'],
        productId: json["productId"],
        updatedOn: json["updatedOn"] == null
            ? null
            : DateTime.parse(json["updatedOn"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        'companySlug': companySlug,
        "imageUrl": imageUrl,
        "productId": productId,
        "updatedOn": updatedOn?.toIso8601String(),
        "id": id,
      };

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return ProductImages.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<ProductImages> FromJson(String str, String slug) =>
      List<ProductImages>.from(
          json.decode(str).map((x) => ProductImages().fromJson(x, slug: slug)));

  String ToJson(List<ProductImages> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
