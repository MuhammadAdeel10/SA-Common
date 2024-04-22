import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../schemes/models/posPaymentDetailModel.dart';
import '../../utils/DatabaseHelper.dart';

class POSInvoicePaymentDatabase {
  static final dao = BaseRepository<PosPaymentModel>(PosPaymentModel(), tableName: Tables.PosInvoicePayment);
  Future<PosPaymentModel> find(int id) => dao.find(id);
  Future<List<PosPaymentModel>> getAll() => dao.getAll();
  Future<int> insert(PosPaymentModel model) => dao.insert(model);
  Future<void> update(PosPaymentModel model) => dao.update(model);
  Future<void> delete(PosPaymentModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<PosPaymentModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await POSInvoicePaymentDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.PosInvoicePayment,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.PosInvoicePayment, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<List<PosPaymentModel>> Get(int posInvoiceId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from ${Tables.PosInvoicePayment} where ${PosPaymentField.posInvoiceId}  = $posInvoiceId');

    return List.generate(map.length, (index) => PosPaymentModel.fromMap(map[index]));
  }
}
