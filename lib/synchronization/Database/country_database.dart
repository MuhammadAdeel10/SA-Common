import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../Models/CountryModel.dart';

class CountryDatabase {
  static final dao =
      BaseRepository<CountryModel>(CountryModel(), tableName: Tables.Country);
  Future<CountryModel> find(int id) => dao.find(id);
  Future<List<CountryModel>> getAll() => dao.getAll();
  Future<int> insert(CountryModel model) => dao.insert(model);
  Future<void> update(CountryModel model) => dao.update(model);
  Future<void> delete(CountryModel model) => dao.delete(model);
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

  static Future<void> bulkInsert(List<CountryModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CountryDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Country,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Country, val.toMap());
      }
    });
    await batch.commit();
  }

  // Future<List<ProductModel>> getCategoryId(int productCategoryId) async {
  //   List<ProductModel> productList = [];
  //   final db = await DatabaseHelper.instance.database;
  //   var map = await db.rawQuery(
  //       'select * from Products where productCategoryId = $productCategoryId');
  //   map.forEach((val) {
  //     print(val);
  //     if (val.length > 0) {
  //       var model = ProductModel().fromJson(val) as ProductModel;
  //       productList.add(model);
  //     }
  //   });
  //   return productList;
  // }
}
