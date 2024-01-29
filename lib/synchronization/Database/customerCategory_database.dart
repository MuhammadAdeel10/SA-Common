import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../Models/CustomerCategoryModel.dart';

class CustomerCategoryDatabase {
  static final dao = BaseRepository<CustomerCategoryModel>(
      CustomerCategoryModel(),
      tableName: Tables.CustomerCategory);
  Future<CustomerCategoryModel> find(int id) => dao.find(id);
  Future<List<CustomerCategoryModel>> getAll() => dao.getAll();
  Future<int> insert(CustomerCategoryModel model) => dao.insert(model);
  Future<void> update(CustomerCategoryModel model) => dao.update(model);
  Future<void> delete(CustomerCategoryModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<List<CustomerCategoryModel>> getByCompanySlug() =>
      dao.getByCompanySlug();
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

  static Future<void> bulkInsert(List<CustomerCategoryModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CustomerCategoryDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.CustomerCategory,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.CustomerCategory, val.toMap());
      }
    });
    await batch.commit();
  }

  static Future<List<CustomerCategoryModel>> Get(String name) async {
    final db = await DatabaseHelper.instance.database;
    List<CustomerCategoryModel> list = [];

    var map = await db.rawQuery(
        '''SELECT * from CustomerCategory where name like '%${name}%''');

    map.forEach((val) {
      if (val.length > 0) {
        var model =
            CustomerCategoryModel().fromJson(val) as CustomerCategoryModel;
        list.add(model);
      }
    });
    return list;
  }
}
