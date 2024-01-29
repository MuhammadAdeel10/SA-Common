import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/schemeCustomerCategoriesModel.dart';

class CustomerCategoriesSchemesDatabase {
  static final dao = BaseRepository<CustomerCategoriesSchemesModel>(
      CustomerCategoriesSchemesModel(),
      tableName: Tables.SchemeCustomerCategories);
  Future<CustomerCategoriesSchemesModel> find(int id) => dao.find(id);
  Future<List<CustomerCategoriesSchemesModel>> getAll() => dao.getAll();
  Future<List<CustomerCategoriesSchemesModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(CustomerCategoriesSchemesModel model) => dao.insert(model);
  Future<void> update(CustomerCategoriesSchemesModel model) =>
      dao.update(model);
  Future<void> delete(CustomerCategoriesSchemesModel model) =>
      dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(
      List<CustomerCategoriesSchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CustomerCategoriesSchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemeCustomerCategories,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemeCustomerCategories, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
