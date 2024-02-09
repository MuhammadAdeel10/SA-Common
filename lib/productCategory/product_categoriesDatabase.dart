import 'package:sa_common/productCategory/product_categories_model.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../Controller/BaseRepository.dart';
import '../utils/DatabaseHelper.dart';
import '../utils/LocalStorageKey.dart';
import '../utils/TablesName.dart';
import '../utils/pref_utils.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class ProductCategoryDatabase {
  static final dao = BaseRepository<ProductCategoryModel>(ProductCategoryModel(), tableName: Tables.productsCategories);
  Future<ProductCategoryModel> find(int id) => dao.find(id);
  Future<List<ProductCategoryModel>> getAll() => dao.getAll();
  Future<int> insert(ProductCategoryModel model) async => await dao.insert(model);
  Future<void> update(ProductCategoryModel model) => dao.update(model);
  Future<void> delete(ProductCategoryModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<List<ProductCategoryModel>> getProductsCategories() async {
    var prefs = PrefUtils();
    var slug = prefs.GetPreferencesString(LocalStorageKey.companySlug);
    List<ProductCategoryModel> productList = [];
    final db = await DatabaseHelper.instance.database;
    // var map = await db.rawQuery(
    //     '''select * from ProductsCategories where companySlug = '$slug' and parentCategoryId is null''');
    var map = await db.rawQuery('''select * from ProductsCategories where companySlug = '$slug' and isActive = 1 and parentCategoryId is null ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductCategoryModel().fromJson(val) as ProductCategoryModel;
        productList.add(model);
      }
    });
    return productList;
  }

  Future<List<ProductCategoryModel>> getProductsCategoriesByParentId(int parentId) async {
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    List<ProductCategoryModel> productCategory = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('''select * from ProductsCategories where parentCategoryId = $parentId And companySlug = '$slug' and isActive  = 1 ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductCategoryModel().fromJson(val) as ProductCategoryModel;
        productCategory.add(model);
      }
    });
    return productCategory;
  }

  static Future<void> bulkInsert(String imageBaseUrl, List<ProductCategoryModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var user = Helper.user;
    var path = await Helper.createFolder("uploads/${user.companyId}/");
    var getAll = await ProductCategoryDatabase.dao.getAll();
    Batch batch = db.batch();
    for (var val in model) {
      if (val.imageUrl != null && val.imageUrl!.isNotEmpty) {
        var imageUrl = imageBaseUrl + val.imageUrl!;
        Uri uri = Uri.parse(imageUrl);
        final imageData = await http.get(uri);
        var data = await File(join(path, imageUrl.split("/").last)).create(recursive: true);
        await data.writeAsBytes(imageData.bodyBytes);
      }
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.productsCategories,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.productsCategories, val.toJson());
      }
    }
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
