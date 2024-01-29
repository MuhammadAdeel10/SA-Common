import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';
import '../models/RegionsModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';

class RegionsDatabase {
  static final dao =
      BaseRepository<RegionsModel>(RegionsModel(), tableName: Tables.Regions);
  Future<RegionsModel> find(int id) => dao.find(id);
  Future<List<RegionsModel>> getAll() => dao.getAll();
  Future<List<RegionsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(RegionsModel model) => dao.insert(model);
  Future<void> update(RegionsModel model) => dao.update(model);
  Future<void> delete(RegionsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<RegionsModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await RegionsDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Regions,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Regions, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
