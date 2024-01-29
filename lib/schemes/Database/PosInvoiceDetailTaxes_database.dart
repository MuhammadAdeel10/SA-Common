import 'package:sa_common/schemes/models/POSInvoiceDetailTaxModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';

class PosInvoiceDetailTaxesDatabase {
  static final dao = BaseRepository<POSInvoiceTaxModel>(POSInvoiceTaxModel(),
      tableName: Tables.POSInvoiceDetailTaxes);
  Future<POSInvoiceTaxModel> find(int id) => dao.find(id);
  Future<List<POSInvoiceTaxModel>> getAll() => dao.getAll();
  Future<List<POSInvoiceTaxModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(POSInvoiceTaxModel model) => dao.insert(model);
  Future<void> update(POSInvoiceTaxModel model) => dao.update(model);
  Future<void> delete(POSInvoiceTaxModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<POSInvoiceTaxModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await PosInvoiceDetailTaxesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.POSInvoiceDetailTaxes,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.POSInvoiceDetailTaxes, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
