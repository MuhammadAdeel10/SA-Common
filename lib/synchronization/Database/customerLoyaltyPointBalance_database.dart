import 'package:sqflite/sqflite.dart';
import '../Models/CustomerLoyaltyPointBalanceModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';

class CustomerLoyaltyPointBalanceDatabase {
  static final dao = BaseRepository<CustomerLoyaltyPointBalanceModel>(
      CustomerLoyaltyPointBalanceModel(),
      tableName: Tables.CustomerLoyaltyPointBalance);
  Future<CustomerLoyaltyPointBalanceModel> find(int id) => dao.find(id);
  Future<List<CustomerLoyaltyPointBalanceModel>> getAll() => dao.getAll();
  Future<int> insert(CustomerLoyaltyPointBalanceModel model) =>
      dao.insert(model);
  Future<void> update(CustomerLoyaltyPointBalanceModel model) =>
      dao.update(model);
  Future<void> delete(CustomerLoyaltyPointBalanceModel model) =>
      dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(
      List<CustomerLoyaltyPointBalanceModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CustomerLoyaltyPointBalanceDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.CustomerLoyaltyPointBalance,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.CustomerLoyaltyPointBalance, val.toMap());
      }
    });
    await batch.commit();
  }
}
