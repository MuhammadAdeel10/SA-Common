

import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class TravelLogDatabase {
  static final dao = BaseRepository<TravelLogModel>(TravelLogModel(), tableName: Tables.TravelLogs);
  Future<TravelLogModel> find(int id) => dao.find(id);
  Future<List<TravelLogModel>> getAll() => dao.getAll();
  Future<int> insert(TravelLogModel model) => dao.insert(model);
  Future<void> update(TravelLogModel model) => dao.update(model);
  Future<void> delete(TravelLogModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<TravelLogModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await TravelLogDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.TravelLogs,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.TravelLogs, val.toMap());
      }
    });
    await batch.commit();
  }
  static Future<void> bulkUpdate() async {
     final db = await DatabaseHelper.instance.database;
    var companySlug = Helper.user.companyId;
    var branchId = Helper.user.branchId;
    Batch batch = db.batch();
    batch.rawQuery(''' update ${Tables.TravelLogs} set IsSync = 1 where companySlug = '$companySlug' and branchId = $branchId ''');
    await batch.commit();
  }

}
