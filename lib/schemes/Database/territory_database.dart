import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../models/territoriesModel.dart';

class TerritoriesDatabase {
  static final dao = BaseRepository<TerritoriesModel>(TerritoriesModel(),
      tableName: Tables.Territories);
  Future<TerritoriesModel> find(int id) => dao.find(id);
  Future<List<TerritoriesModel>> getAll() => dao.getAll();
  Future<List<TerritoriesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(TerritoriesModel model) => dao.insert(model);
  Future<void> update(TerritoriesModel model) => dao.update(model);
  Future<void> delete(TerritoriesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<TerritoriesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await TerritoriesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Territories,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Territories, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
