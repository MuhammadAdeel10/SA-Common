 
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class SaleOrderDetailDiscountDatabase {
  static final dao = BaseRepository<SaleOrderDiscountsModel>(SaleOrderDiscountsModel(), tableName: Tables.saleOrderDiscount);
  Future<SaleOrderDiscountsModel> find(int id) => dao.find(id);
  Future<List<SaleOrderDiscountsModel>> getAll() => dao.getAll();
  Future<List<SaleOrderDiscountsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SaleOrderDiscountsModel model) => dao.insert(model);
  Future<void> update(SaleOrderDiscountsModel model) => dao.update(model);
  Future<void> delete(SaleOrderDiscountsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SaleOrderDiscountsModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SaleOrderDetailDiscountDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.saleOrderDiscount,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.saleOrderDiscount, val.toJson());
      }
    });
    await batch.commit();
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
