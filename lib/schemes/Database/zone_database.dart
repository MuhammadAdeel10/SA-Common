import 'package:sqflite/sqflite.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../models/zonesModel.dart';

class ZonesDatabase {
  static final dao =
      BaseRepository<ZonesModel>(ZonesModel(), tableName: Tables.Zones);
  Future<ZonesModel> find(int id) => dao.find(id);
  Future<List<ZonesModel>> getAll() => dao.getAll();
  Future<List<ZonesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(ZonesModel model) => dao.insert(model);
  Future<void> update(ZonesModel model) => dao.update(model);
  Future<void> delete(ZonesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<ZonesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await ZonesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Zones,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Zones, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
