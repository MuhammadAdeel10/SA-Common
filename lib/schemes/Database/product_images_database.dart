

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/models/product_images_mode.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';


class ProductImagesDatabase {
  static final dao = BaseRepository<ProductImages>(ProductImages(), tableName: Tables.productImages);
  Future<ProductImages> find(int id) => dao.find(id);
  Future<List<ProductImages>> getAll() => dao.getAll();
  Future<List<ProductImages>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(ProductImages model) => dao.insert(model);
  Future<void> update(ProductImages model) => dao.update(model);
  Future<void> delete(ProductImages model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<ProductImages> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await ProductImagesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.productImages,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.productImages, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
