import 'package:sqflite/sqflite.dart';
import '../Models/DetailAGroupModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';

class DetailAGroupDatabase {
  static final dao = BaseRepository<DetailAGroupModel>(DetailAGroupModel(),
      tableName: Tables.DetailAGroup);
  Future<DetailAGroupModel> find(int id) => dao.find(id);
  Future<List<DetailAGroupModel>> getAll() => dao.getAll();
  Future<int> insert(DetailAGroupModel model) => dao.insert(model);
  Future<void> update(DetailAGroupModel model) => dao.update(model);
  Future<void> delete(DetailAGroupModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<DetailAGroupModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await DetailAGroupDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.DetailAGroup,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.DetailAGroup, val.toMap());
      }
    });
    await batch.commit();
  }
}
