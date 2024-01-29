import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/SchemeCustomersModel.dart';

class CustomersSchemesDatabase {
  static final dao = BaseRepository<CustomersSchemesModel>(
      CustomersSchemesModel(),
      tableName: Tables.SchemeCustomers);
  Future<CustomersSchemesModel> find(int id) => dao.find(id);
  Future<List<CustomersSchemesModel>> getAll() => dao.getAll();
  Future<List<CustomersSchemesModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(CustomersSchemesModel model) => dao.insert(model);
  Future<void> update(CustomersSchemesModel model) => dao.update(model);
  Future<void> delete(CustomersSchemesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<CustomersSchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CustomersSchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemeCustomers,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemeCustomers, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
