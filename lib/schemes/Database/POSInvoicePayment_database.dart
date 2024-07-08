import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../models/paymentDetailModel.dart';
import '../../utils/DatabaseHelper.dart';

class POSInvoicePaymentDatabase {
  static final dao = BaseRepository<PaymentModel>(PaymentModel(), tableName: Tables.PosInvoicePayment);
  Future<PaymentModel> find(int id) => dao.find(id);
  Future<List<PaymentModel>> getAll() => dao.getAll();
  Future<int> insert(PaymentModel model) => dao.insert(model);
  Future<void> update(PaymentModel model) => dao.update(model);
  Future<void> delete(PaymentModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<PaymentModel> model) async {
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

  static Future<List<PaymentModel>> Get(int posInvoiceId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from ${Tables.PosInvoicePayment} where ${PosPaymentField.posInvoiceId}  = $posInvoiceId');

    return List.generate(map.length, (index) => PaymentModel.fromMap(map[index]));
  }
}
