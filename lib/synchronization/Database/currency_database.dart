import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../Models/CurrencyModel.dart';

class CurrencyDatabase {
  static final dao = BaseRepository<CurrencyModel>(CurrencyModel(),
      tableName: Tables.Currency);
  Future<CurrencyModel> find(int id) => dao.find(id);
  Future<List<CurrencyModel>> getAll() => dao.getAll();
  Future<int> insert(CurrencyModel model) => dao.insert(model);
  Future<void> update(CurrencyModel model) => dao.update(model);
  Future<void> delete(CurrencyModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  // Future<List<CountryModel>> getProducts() async {
  //   List<CountryModel> productList = [];
  //   final db = await DatabaseHelper.instance.database;
  //   var map =
  //       await db.rawQuery('select * from Products order by id desc Limit 100');
  //   map.forEach((val) {
  //     if (val.length > 0) {
  //       var model = CountryModel().fromJson(val) as CountryModel;
  //       productList.add(model);
  //     }
  //   });

  //   return productList;
  // }

  static Future<void> bulkInsert(List<CurrencyModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CurrencyDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Currency,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Currency, val.toMap());
      }
    });
    await batch.commit();
  }

  Future<CurrencyModel?> GetDefaultCurrency() async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(
        'select * from ${Tables.Currency} where ${CurrencyField.isDefault} = 1');
    if (map.length > 0) {
      var model = CurrencyModel().fromJson(map[0]) as CurrencyModel;
      return model;
    }

    return null;
  }
}
