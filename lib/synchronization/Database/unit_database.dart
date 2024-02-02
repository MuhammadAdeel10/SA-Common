import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/TablesName.dart';
import '../models/unit_model.dart';

class UnitDatabase {
  static final dao = BaseRepository<UnitModel>(UnitModel(), tableName: Tables.units);
  Future<UnitModel> find(int id) => dao.find(id);
  Future<List<UnitModel>> getAll() => dao.getAll();
  Future<int> insert(UnitModel model) => dao.insert(model);
  Future<void> update(UnitModel model) => dao.update(model);
  Future<void> delete(UnitModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<UnitModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await UnitDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.units,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.units, val.toJson());
      }
    });
    await batch.commit();
  }
}
