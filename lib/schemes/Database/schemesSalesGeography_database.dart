import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/schemeSalesGeographyModel.dart';

class SalesGeographySchemesDatabase {
  static final dao = BaseRepository<SalesGeographySchemesModel>(
      SalesGeographySchemesModel(),
      tableName: Tables.SchemesSalesGeography);
  Future<SalesGeographySchemesModel> find(int id) => dao.find(id);
  Future<List<SalesGeographySchemesModel>> getAll() => dao.getAll();
  Future<List<SalesGeographySchemesModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(SalesGeographySchemesModel model) => dao.insert(model);
  Future<void> update(SalesGeographySchemesModel model) => dao.update(model);
  Future<void> delete(SalesGeographySchemesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalesGeographySchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SalesGeographySchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemesSalesGeography,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemesSalesGeography, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
