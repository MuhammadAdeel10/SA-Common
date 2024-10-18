import 'package:sa_common/synchronization/Models/WarehouseModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';

class WarehouseDatabase {
  static final dao = BaseRepository<Warehouse>(Warehouse(), tableName: Tables.WareHouse);
  Future<Warehouse> find(int id) => dao.find(id);
  Future<List<Warehouse>> getAll() => dao.getAll();
  Future<int> insert(Warehouse model) => dao.insert(model);
  Future<void> update(Warehouse model) => dao.update(model);
  Future<void> delete(Warehouse model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<Warehouse> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await WarehouseDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.WareHouse,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.WareHouse, val.toMap());
      }
    });
    await batch.commit();
  }
}
