import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/schemeDetailsModel.dart';

class DetailsSchemesDatabase {
  static final dao = BaseRepository<DetailsSchemesModel>(DetailsSchemesModel(),
      tableName: Tables.SchemeDetails);
  Future<DetailsSchemesModel> find(int id) => dao.find(id);
  Future<List<DetailsSchemesModel>> getAll() => dao.getAll();
  Future<List<DetailsSchemesModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(DetailsSchemesModel model) => dao.insert(model);
  Future<void> update(DetailsSchemesModel model) => dao.update(model);
  Future<void> delete(DetailsSchemesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<DetailsSchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await DetailsSchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemeDetails,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemeDetails, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
