import 'package:sa_common/utils/Helper.dart';
import 'package:sqflite/sqflite.dart';
import '../Models/CustomerModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';

class CustomerDatabase {
  static final dao = BaseRepository<CustomerModel>(CustomerModel(),
      tableName: Tables.Customer);

  Future<CustomerModel> find(int id) => dao.find(id);

  Future<List<CustomerModel>> getAll() => dao.getAll();

  Future<int> insert(CustomerModel model) => dao.insert(model);

  Future<void> update(CustomerModel model) => dao.update(model);

  Future<void> delete(CustomerModel model) => dao.delete(model);

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

  static Future<void> bulkInsert(List<CustomerModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CustomerDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Customer,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Customer, val.toMap());
      }
    });
    await batch.commit();
  }

  static Future<List<CustomerModel>> GetFilterCustomers(String filter) async {
    var user = Helper.user;
    List<CustomerModel> customerList = [];

    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(
        '''select * from Customers where companySlug = '${user.companyId}' and branchId = ${user.branchId} And isActive = 1 And (name like '%${filter}%' or code like '%${filter}%' or phone like '%${filter}%') LIMIT 30 ''');
    // if (map.isEmpty) {
    //   map = await db.rawQuery(
    //       '''select * from Customers where companySlug = '${user.companyId}' and branchId = ${user.branchId} And code like '%${filter}%' LIMIT 30 ''');
    // }
    // if (map.isEmpty) {
    //   map = await db.rawQuery(
    //       '''select * from Customers where companySlug = '${user.companyId}' and branchId = ${user.branchId} And phone like '%${filter}%' LIMIT 30 ''');
    // }
    map.forEach((val) {
      if (val.length > 0) {
        var model = CustomerModel().fromJson(val) as CustomerModel;
        customerList.add(model);
      }
    });
    return customerList;
  }
}
