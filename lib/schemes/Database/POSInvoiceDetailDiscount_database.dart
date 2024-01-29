import 'package:sa_common/schemes/models/POSInvoiceDiscountModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';

class POSInvoiceDetailDiscountDatabase {
  static final dao = BaseRepository<POSInvoiceDetailDiscountModel>(
      POSInvoiceDetailDiscountModel(),
      tableName: Tables.POSInvoiceDetailDiscount);
  Future<POSInvoiceDetailDiscountModel> find(int id) => dao.find(id);
  Future<List<POSInvoiceDetailDiscountModel>> getAll() => dao.getAll();
  Future<List<POSInvoiceDetailDiscountModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
  Future<int> insert(POSInvoiceDetailDiscountModel model) => dao.insert(model);
  Future<void> update(POSInvoiceDetailDiscountModel model) => dao.update(model);
  Future<void> delete(POSInvoiceDetailDiscountModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(
      List<POSInvoiceDetailDiscountModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await POSInvoiceDetailDiscountDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.POSInvoiceDetailDiscount,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.POSInvoiceDetailDiscount, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
