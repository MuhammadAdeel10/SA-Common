import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

import '../model/sale_order_detail_model.dart';

class SaleOrderDetailDatabase {
  static final dao = BaseRepository<SaleOrderDetailsModel>(SaleOrderDetailsModel(), tableName: Tables.saleOrderDetail);
  Future<SaleOrderDetailsModel> find(int id) => dao.find(id);
  Future<List<SaleOrderDetailsModel>> getAll() => dao.getAll();
  Future<int> insert(SaleOrderDetailsModel model) => dao.insert(model);
  Future<void> update(SaleOrderDetailsModel model) => dao.update(model);
  Future<void> delete(SaleOrderDetailsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SaleOrderDetailsModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SaleOrderDetailDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.saleOrderDetail,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.saleOrderDetail, val.toJson());
      }
    });
    await batch.commit();
  }
   Future<void> deleteByMasterId(int id) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final dbClient = await db;
      await dbClient.delete(Tables.saleOrderDetail, where: "saleOrderId = ?", whereArgs: [id]);
    } catch (ex) {
     
      throw ex;
    }
  }
  Future<void> deletebyFilter(String filter) async {
    try {
      final db = await DatabaseHelper.instance.database;
      final dbClient = await db;
      await dbClient.rawQuery('''delete from ${Tables.saleOrderDetail} where $filter ''');
    } catch (ex) {
      Logger.ErrorLog("Delete ${Tables.saleOrderDetail}: $ex");
      throw ex;
    }
  }

  static Future<List<SaleOrderDetailsModel>> Get(int saleOrderId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from ${Tables.saleOrderDetail} where ${SaleOrderDetailField.saleOrderId}  = $saleOrderId');

    return List.generate(map.length, (index) => SaleOrderDetailsModel.fromJson(map[index]));
  }
}
