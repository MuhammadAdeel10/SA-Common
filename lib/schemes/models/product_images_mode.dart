// To parse this JSON data, do
//
//     final productImages = productImagesFromJson(jsonString);

import 'dart:convert';

ProductImages productImagesFromJson(String str) => ProductImages.fromJson(json.decode(str));

String productImagesToJson(ProductImages data) => json.encode(data.toJson());
class ProductImagesFields {
  static final String id = 'id';
  static final String companySlug= 'companySlug';
  static final String imageUrl = 'imageUrl';
  static final String base64ImageString = 'base64ImageString';
  static final String productId = 'productId';
  static final String updatedOn = 'updatedOn';
}
class ProductImages {
    String? imageUrl;
    dynamic base64ImageString;
    int? productId;
    DateTime? updatedOn;
    int? id;

    ProductImages({
        this.imageUrl,
        this.base64ImageString,
        this.productId,
        this.updatedOn,
        this.id,
    });

    ProductImages copyWith({
        String? imageUrl,
        dynamic base64ImageString,
        int? productId,
        DateTime? updatedOn,
        int? id,
    }) => 
        ProductImages(
            imageUrl: imageUrl ?? this.imageUrl,
            base64ImageString: base64ImageString ?? this.base64ImageString,
            productId: productId ?? this.productId,
            updatedOn: updatedOn ?? this.updatedOn,
            id: id ?? this.id,
        );

    factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
        imageUrl: json["imageUrl"],
        base64ImageString: json["base64ImageString"],
        productId: json["productId"],
        updatedOn: json["updatedOn"] == null ? null : DateTime.parse(json["updatedOn"]),
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "imageUrl": imageUrl,
        "base64ImageString": base64ImageString,
        "productId": productId,
        "updatedOn": updatedOn?.toIso8601String(),
        "id": id,
    };
}
