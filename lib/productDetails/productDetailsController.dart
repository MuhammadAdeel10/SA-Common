import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/schemes/Database/product_images_database.dart';
import 'package:sa_common/schemes/models/product_images_mode.dart';

class ProductDetailController extends GetxController {
  RxBool isDropDownOpen = false.obs;
  RxBool isCollapse = true.obs;
  RxBool isDataSelected = false.obs;
  var productController = TextEditingController().obs;
  var descriptionController = TextEditingController().obs;
  var qtyController = TextEditingController().obs;
  var priceController = TextEditingController().obs;
  var discountController = TextEditingController().obs;
  List<ProductImages>? productImagesList = [];
  String catalogContentHTML = '';

  GetAllProductImagesById(int? id) async {
    if (id != null) {
      try {
        List<ProductImages>? value = await ProductImagesDatabase.dao.SelectList('productId = $id');
        productImagesList = value;
        return productImagesList ?? [];
      } catch (e) {
        print(e);
      }
    }
  }
}
