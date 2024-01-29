import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/TablesName.dart';
import '../Models/DetailBGroupModel.dart';

class DetailBGroupDatabase {
  static final dao = BaseRepository<DetailBGroupModel>(DetailBGroupModel(),
      tableName: Tables.DetailBGroup);
  Future<DetailBGroupModel> find(int id) => dao.find(id);
  Future<List<DetailBGroupModel>> getAll() => dao.getAll();
  Future<int> insert(DetailBGroupModel model) => dao.insert(model);
  Future<void> update(DetailBGroupModel model) => dao.update(model);
  Future<void> delete(DetailBGroupModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<DetailBGroupModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await DetailBGroupDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.DetailBGroup,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.DetailBGroup, val.toMap());
      }
    });
    await batch.commit();
  }
}
