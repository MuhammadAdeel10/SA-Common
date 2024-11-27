import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/SalesPerson/model/trip_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class TripDatabase {
  static final dao = BaseRepository<TripModel>(TripModel(), tableName: Tables.Trips);
  Future<TripModel> find(int id) => dao.find(id);
  Future<List<TripModel>> getAll() => dao.getAll();
  Future<int> insert(TripModel model) => dao.insert(model);
  Future<void> update(TripModel model) => dao.update(model);
  Future<void> delete(TripModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<TripModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await TripDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Trips,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Trips, val.toMap());
      }
    });
    await batch.commit();
  }

  static Future<void> bulkUpdate() async {
    final db = await DatabaseHelper.instance.database;
    var companySlug = Helper.user.companyId;
    var branchId = Helper.user.branchId;
    Batch batch = db.batch();
    batch.rawQuery(''' update ${Tables.Trips} set IsSync = 1 where companySlug = '$companySlug' and branchId = $branchId ''');
    await batch.commit();
  }
}
