
import 'package:sa_common/schemes/Database/productSalesTax_database.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product_model.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/TablesName.dart';

class ProductDatabase {
  static final dao = BaseRepository<ProductModel>(ProductModel(), tableName: Tables.products);
  Future<ProductModel> find(int id) => dao.find(id);
  Future<List<ProductModel>> getAll() => dao.getAll();
  Future<int> insert(ProductModel model) => dao.insert(model);
  Future<void> update(ProductModel model) => dao.update(model);
  Future<void> delete(ProductModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<List<ProductModel>> getProducts() async {
    var slug = Helper.user.companyId ?? "";

    List<ProductModel> productList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('''select * from Products where companySlug = '$slug' and productCategoryId is null and isOpening = 0 and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null)) order by id Limit 30''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductModel().fromJson(val) as ProductModel;
        productList.add(model);
      }
    });

    return productList;
  }

 static Future<void> bulkInsert(String imageBaseUrl, List<ProductModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAllProduct = await ProductDatabase.dao.getAll();
    var user = Helper.user;
    Batch batch = db.batch();
    for (var val in model) {
      var exist = getAllProduct.any((element) => element.id == val.id);
      if (exist) {
        batch.rawQuery("delete from '${Tables.ProductSalesTax}' where companySlug = '${user.companyId}' and ProductId = ${val.id} ");
        batch.rawQuery("delete from '${Tables.BranchProductTaxes}' where companySlug = '${user.companyId}' and ProductId = ${val.id} ");
        batch.update(
          Tables.products,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.products, val.toMap());
      }
    }
    ;
    batch.commit();
    model.forEach((val) {
      if (val.saleTaxes != null) {
        val.saleTaxes!.map((e) => e.companySlug = e.companySlug != null ? e.companySlug : val.companySlug).toList();
        ProductSalesTaxDatabase.bulkInsert(val.saleTaxes!);
      }
    });
  }

  Future<List<ProductModel>> getCategoryId(int productCategoryId) async {
    List<ProductModel> productList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from Products where productCategoryId = $productCategoryId and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null))');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductModel().fromJson(val) as ProductModel;
        productList.add(model);
      }
    });
    return productList;
  }

  Future<ProductModel?> GetProductCode(String code) async {
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery("select * from Products WHERE code like '$code' and companySlug = '$slug' and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null)) ");

    if (map.length == 0) {
      map = await db.rawQuery("select * from Products WHERE barcode like '$code' and companySlug = '$slug' and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null)) ");
    }
    if (map.length > 0) {
      var model = ProductModel().fromJson(map.first) as ProductModel;
      return model;
    }
    return null;
  }

  Future<List<ProductModel>> GetProductSearch(String filterText) async {
    List<ProductModel> productList = [];
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(
      "select * from Products where companySlug= '$slug' and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null)) and code like  '%$filterText%'  limit 25",
    );
    if (map.length == 0) {
      map = await db.rawQuery(
        "select * from Products where companySlug= '$slug' and isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null)) and name like '%$filterText%'  limit 25",
      );
    }
    if (map.length == 0) {
      map = await db.rawQuery(
        "select * from Products where companySlug= '$slug' and (productType = 10 or (productType = 40 and baseProductId is not null)) and barcode like '%$filterText%'  limit 25",
      );
    }
    if (map.length == 0) {
      map = await db.rawQuery(
        "select * from Products where companySlug= '$slug' and (productType = 10 or (productType = 40 and baseProductId is not null)) and sku like '%$filterText%'  limit 25",
      );
    }

    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductModel().fromJson(val) as ProductModel;
        productList.add(model);
      }
    });
    return productList;
  }

  Future<List<ProductModel>> getProductsWithCategory() async {
    List<ProductModel> productList = [];
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('''select * from Products where productCategoryId = is not null and companySlug= '$slug' and (productType = 10 or (productType = 40 and baseProductId is not null)) ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductModel().fromJson(val) as ProductModel;
        productList.add(model);
      }
    });
    return productList;
  }
}
