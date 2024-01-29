import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/TablesName.dart';
import '../Models/NumberSerialsModel.dart';

class NumberSerialDatabase {
  static final dao = BaseRepository<NumberSerialsModel>(NumberSerialsModel(),
      tableName: Tables.NumberSerials);
  Future<NumberSerialsModel> find(int id) => dao.find(id);
  Future<List<NumberSerialsModel>> getAll() => dao.getAll();
  Future<List<NumberSerialsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(NumberSerialsModel model) => dao.insert(model);
  Future<void> update(NumberSerialsModel model) => dao.update(model);
  Future<void> delete(NumberSerialsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<NumberSerialsModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await NumberSerialDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.NumberSerials,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.NumberSerials, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }

  Future<NumberSerialsModel?> GetLastNumber(
      String series, String companySlug, int branchId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(
        "select * from ${Tables.NumberSerials} where companySlug = '$companySlug' and  ${NumberSerialsField.series} = '$series' and branchId = $branchId ");
    if (map.length > 0) {
      var model = NumberSerialsModel().fromJson(map[0]) as NumberSerialsModel;
      return model;
    }

    return null;
  }

  Future<void> DeleteNumberSerials(
      String series, String companySlug, int branchId) async {
    final db = await DatabaseHelper.instance.database;
    await db.rawQuery(
        "delete from ${Tables.NumberSerials} where companySlug = '$companySlug' and ${NumberSerialsField.series} = '$series' and branchId = $branchId ");
  }
}
