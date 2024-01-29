import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/Helper.dart';
import '../../utils/TablesName.dart';
import '../Models/EndOfTheDay_model.dart';

class EndOfTheDayDatabase {
  static final dao = BaseRepository<EndOfTheDayModel>(EndOfTheDayModel(), tableName: Tables.EndOfTheDay);
  Future<EndOfTheDayModel> find(int id) => dao.find(id);
  Future<List<EndOfTheDayModel>> getAll() => dao.getAll();
  Future<List<EndOfTheDayModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(EndOfTheDayModel model) => dao.insert(model);
  Future<void> update(EndOfTheDayModel model) => dao.update(model);
  Future<void> delete(EndOfTheDayModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<EndOfTheDayModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await EndOfTheDayDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.EndOfTheDay,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.EndOfTheDay, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<void> DeletePrevious() async {
    var user = Helper.user;
    final db = await DatabaseHelper.instance.database;
    await db.rawQuery(''' Delete from ${Tables.EndOfTheDay} where companySlug = '${user.companyId}' and branchId = ${user.branchId} ''');
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
