import 'dart:convert';

import '../Controller/BaseRepository.dart';

class ProductCategoryFields {
  static final List<String> values = [
    /// Add all fields
    id, name, imageUrl, isActive, updatedOn, parentCategoryId
  ];
  static final String id = 'id';
  static final String name = 'name';
  static final String imageUrl = 'imageUrl';
  static final String isActive = 'isActive';
  static final String updatedOn = 'updatedOn';
  static final String parentCategoryId = 'parentCategoryId';
  static final String companySlug = 'companySlug';
}

class ProductCategoryModel extends BaseModel {
  String? name;
  int? parentCategoryId;
  String? imageUrl;
  bool isActive;
  DateTime? updatedOn;
  String? companySlug;

  ProductCategoryModel({
    this.name,
    this.parentCategoryId,
    this.imageUrl,
    this.isActive = true,
    this.updatedOn,
    this.companySlug = "",
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['parentCategoryId'] = this.parentCategoryId;
    data['imageUrl'] = this.imageUrl;
    // data['isActive'] = this.isActive;
    data['isActive'] = this.isActive == true ? 1 : 0;
    data['updatedOn'] = this.updatedOn?.toIso8601String();
    data['id'] = this.id;
    data['companySlug'] = this.companySlug;
    return data;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    ProductCategoryModel model = ProductCategoryModel();
    model.name = json['name'];
    model.parentCategoryId = json['parentCategoryId'];
    model.imageUrl = json['imageUrl'];
    // model.isActive = json['isActive'];
    model.isActive = (json['isActive'] == 0 || json['isActive'] == false) ? false : true;
    model.updatedOn = json['updatedOn'] == null ? null : DateTime.parse(json['updatedOn'] as String);
    model.id = json['id'];
    model.companySlug = slug ?? '';
    return model;
  }

  List<ProductCategoryModel> FromJson(String str, String slug) => List<ProductCategoryModel>.from(json.decode(str).map((x) => ProductCategoryModel().fromJson(x, slug: slug)));

  String ToJson(List<ProductCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
