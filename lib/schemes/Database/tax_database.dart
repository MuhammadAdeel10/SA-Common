import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tax_model.dart';

class TaxDatabase {
  static final dao =
      BaseRepository<TaxModel>(TaxModel(), tableName: Tables.Tax);
  Future<TaxModel> find(int id) => dao.find(id);
  Future<List<TaxModel>> getAll() => dao.getAll();
  Future<List<TaxModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(TaxModel model) => dao.insert(model);
  Future<void> update(TaxModel model) => dao.update(model);
  Future<void> delete(TaxModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }

  static Future<void> bulkInsert(List<TaxModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await TaxDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Tax,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Tax, val.toJson());
      }
    });
    await batch.commit();
  }
}
