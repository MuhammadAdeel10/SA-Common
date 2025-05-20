 
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/models/invoiceDetailTaxModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class SaleOrderDetailTaxesDatabase {
  static final dao = BaseRepository<LineItemTaxModel>(LineItemTaxModel(), tableName: Tables.saleOrderDetailTax);
  Future<LineItemTaxModel> find(int id) => dao.find(id);
  Future<List<LineItemTaxModel>> getAll() => dao.getAll();
  Future<List<LineItemTaxModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(LineItemTaxModel model) => dao.insert(model);
  Future<void> update(LineItemTaxModel model) => dao.update(model);
  Future<void> delete(LineItemTaxModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<LineItemTaxModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SaleOrderDetailTaxesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.saleOrderDetailTax,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.saleOrderDetailTax, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
