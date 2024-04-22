import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/SchemeInvoiceDiscountModel.dart';

class SchemeInvoiceDiscountDatabase {
  static final dao = BaseRepository<SchemeInvoiceDiscountModel>(SchemeInvoiceDiscountModel(), tableName: Tables.SchemeInvoiceDiscount);
  Future<SchemeInvoiceDiscountModel> find(int id) => dao.find(id);
  Future<List<SchemeInvoiceDiscountModel>> getAll() => dao.getAll();
  Future<List<SchemeInvoiceDiscountModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SchemeInvoiceDiscountModel model) => dao.insert(model);
  Future<void> update(SchemeInvoiceDiscountModel model) => dao.update(model);
  Future<void> delete(SchemeInvoiceDiscountModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SchemeInvoiceDiscountModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SchemeInvoiceDiscountDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SchemeInvoiceDiscount,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SchemeInvoiceDiscount, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
