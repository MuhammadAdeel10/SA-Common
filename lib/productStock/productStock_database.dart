import 'package:sa_common/productStock/productStock_model.dart';
import 'package:sqflite/sqflite.dart';

import '../Controller/BaseRepository.dart';
import '../utils/DatabaseHelper.dart';
import '../utils/TablesName.dart';

class ProductStockDatabase {
  static final dao = BaseRepository<ProductStockModel>(ProductStockModel(), tableName: Tables.ProductStocks);
  Future<ProductStockModel> find(int id) => dao.find(id);
  Future<List<ProductStockModel>> getAll() => dao.getAll();
  Future<int> insert(ProductStockModel model) => dao.insert(model);
  Future<void> update(ProductStockModel model) => dao.update(model);
  Future<void> delete(ProductStockModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }

  static Future<void> bulkInsert(List<ProductStockModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await ProductStockDatabase.dao.getAll();
    Batch batch = db.batch();

    for (var val in model) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.ProductStocks,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.ProductStocks, val.toJson());
      }
    }
    await batch.commit();
  }
}
