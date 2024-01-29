import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../Models/BranchProductTaxModel.dart';

class BranchProductTaxDatabase {
  static final dao = BaseRepository<BranchProductTaxModel>(
      BranchProductTaxModel(),
      tableName: Tables.BranchProductTaxes);
  Future<BranchProductTaxModel> find(int id) => dao.find(id);
  Future<List<BranchProductTaxModel>> getAll() => dao.getAll();
  Future<int> insert(BranchProductTaxModel model) => dao.insert(model);
  Future<void> update(BranchProductTaxModel model) => dao.update(model);
  Future<void> delete(BranchProductTaxModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<List<BranchProductTaxModel>> getByCompanySlug() =>
      dao.getByCompanySlug();

  static Future<void> bulkInsert(List<BranchProductTaxModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await BranchProductTaxDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.BranchProductTaxes,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.BranchProductTaxes, val.toMap());
      }
    });
    await batch.commit();
  }
}
