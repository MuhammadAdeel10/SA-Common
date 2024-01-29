import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/TablesName.dart';
import '../models/areasModel.dart';

class AreasDatabase {
  static final dao =
      BaseRepository<AreasModel>(AreasModel(), tableName: Tables.Areas);
  Future<AreasModel> find(int id) => dao.find(id);
  Future<List<AreasModel>> getAll() => dao.getAll();
  Future<List<AreasModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(AreasModel model) => dao.insert(model);
  Future<void> update(AreasModel model) => dao.update(model);
  Future<void> delete(AreasModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<AreasModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await AreasDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Areas,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Areas, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
