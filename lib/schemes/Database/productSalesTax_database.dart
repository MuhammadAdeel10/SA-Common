import 'package:sa_common/schemes/models/ProductSalesTaxModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';

class ProductSalesTaxDatabase {
  static final dao = BaseRepository<ProductSalesTaxModel>(ProductSalesTaxModel(), tableName: Tables.ProductSalesTax);
  Future<ProductSalesTaxModel> find(int id) => dao.find(id);
  Future<List<ProductSalesTaxModel>> getAll() => dao.getAll();
  Future<List<ProductSalesTaxModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(ProductSalesTaxModel model) => dao.insert(model);
  Future<void> update(ProductSalesTaxModel model) => dao.update(model);
  Future<void> delete(ProductSalesTaxModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<ProductSalesTaxModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await ProductSalesTaxDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.ProductSalesTax,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.ProductSalesTax, val.toJson());
      }
    });
    await batch.commit();
  }

  Future<List<ProductSalesTaxModel>> GetByProductId(int productId) async {
    List<ProductSalesTaxModel> productTaxList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from ${Tables.ProductSalesTax} where ${ProductSalesTaxField.productId} = $productId');
    map.forEach((val) {
      if (val.length > 0) {
        var model = ProductSalesTaxModel().fromJson(val) as ProductSalesTaxModel;
        productTaxList.add(model);
      }
    });
    return productTaxList;
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
