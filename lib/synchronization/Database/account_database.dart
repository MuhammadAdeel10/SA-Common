import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../Models/AccountModel.dart';

class AccountDatabase {
  static final dao =
      BaseRepository<AccountModel>(AccountModel(), tableName: Tables.accounts);
  Future<AccountModel> find(int id) => dao.find(id);
  Future<List<AccountModel>> getAll() => dao.getAll();
  Future<int> insert(AccountModel model) => dao.insert(model);
  Future<void> update(AccountModel model) => dao.update(model);
  Future<void> delete(AccountModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<AccountModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await AccountDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.accounts,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.accounts, val.toMap());
      }
    });
    await batch.commit();
  }

  Future<List<AccountModel>> GetBankAccount() async {
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;

    List<AccountModel> accountList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(
        '''SELECT * from Accounts where accountTypeId = 112 and companySlug = '$slug' ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = AccountModel().fromJson(val) as AccountModel;
        accountList.add(model);
      }
    });

    return accountList;
  }
}
