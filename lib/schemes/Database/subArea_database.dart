import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

import '../models/subAreasModel.dart';

class SubAreasDatabase {
  static final dao = BaseRepository<SubAreasModel>(SubAreasModel(),
      tableName: Tables.SubAreas);
  Future<SubAreasModel> find(int id) => dao.find(id);
  Future<List<SubAreasModel>> getAll() => dao.getAll();
  Future<List<SubAreasModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SubAreasModel model) => dao.insert(model);
  Future<void> update(SubAreasModel model) => dao.update(model);
  Future<void> delete(SubAreasModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SubAreasModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SubAreasDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SubAreas,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SubAreas, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
