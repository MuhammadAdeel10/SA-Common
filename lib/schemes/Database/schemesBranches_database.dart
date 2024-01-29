import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/models/SchemeBranchesModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class BranchesSchemesDatabase {
  static final dao = BaseRepository<BranchesSchemesModel>(
      BranchesSchemesModel(),
      tableName: Tables.SchemeBranches);
  Future<BranchesSchemesModel> find(int id) => dao.find(id);
  Future<List<BranchesSchemesModel>> getAll() => dao.getAll();
  Future<List<BranchesSchemesModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(BranchesSchemesModel model) => dao.insert(model);
  Future<void> update(BranchesSchemesModel model) => dao.update(model);
  Future<void> delete(BranchesSchemesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<BranchesSchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await BranchesSchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemeBranches,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemeBranches, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
