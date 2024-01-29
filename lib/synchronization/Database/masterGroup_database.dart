import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/TablesName.dart';
import '../Models/MasterGroupModel.dart';

class MasterGroupDatabase {
  static final dao = BaseRepository<MasterGroupModel>(MasterGroupModel(),
      tableName: Tables.MasterGroup);
  Future<MasterGroupModel> find(int id) => dao.find(id);
  Future<List<MasterGroupModel>> getAll() => dao.getAll();
  Future<int> insert(MasterGroupModel model) => dao.insert(model);
  Future<void> update(MasterGroupModel model) => dao.update(model);
  Future<void> delete(MasterGroupModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<MasterGroupModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await MasterGroupDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.MasterGroup,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.MasterGroup, val.toMap());
      }
    });
    await batch.commit();
  }
}
