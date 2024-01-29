// import 'package:pos/Helper/Constant/TablesName.dart';
// import 'package:pos/Helper/Controller/BaseRepository.dart';
// import 'package:pos/Helper/DatabaseHelper.dart';
// import 'package:sqflite/sqflite.dart';

// import '../Models/SubAreaModel.dart';

// class SubAreaDatabase {
//   static final dao =
//       BaseRepository<SubAreaModel>(SubAreaModel(), tableName: Tables.SubArea);
//   Future<SubAreaModel> find(int id) => dao.find(id);
//   Future<List<SubAreaModel>> getAll() => dao.getAll();
//   Future<int> insert(SubAreaModel model) => dao.insert(model);
//   Future<void> update(SubAreaModel model) => dao.update(model);
//   Future<void> delete(SubAreaModel model) => dao.delete(model);
//   Future<void> deleteById(int id) => dao.deleteById(id);
//   // Future<List<CountryModel>> getProducts() async {
//   //   List<CountryModel> productList = [];
//   //   final db = await DatabaseHelper.instance.database;
//   //   var map =
//   //       await db.rawQuery('select * from Products order by id desc Limit 100');
//   //   map.forEach((val) {
//   //     if (val.length > 0) {
//   //       var model = CountryModel().fromJson(val) as CountryModel;
//   //       productList.add(model);
//   //     }
//   //   });

//   //   return productList;
//   // }

//   static Future<void> bulkInsert(List<SubAreaModel> model) async {
//     final db = await DatabaseHelper.instance.database;
//     var getAll = await SubAreaDatabase.dao.getAll();
//     Batch batch = db.batch();
//     model.forEach((val) {
//       var exist = getAll.any((element) => element.id == val.id);
//       if (exist) {
//         batch.update(
//           Tables.SubArea,
//           val.toJson(),
//           where: "id = ?",
//           whereArgs: [val.id],
//         );
//       } else {
//         batch.insert(Tables.SubArea, val.toMap());
//       }
//     });
//     await batch.commit();
//   }

//   // Future<List<ProductModel>> getCategoryId(int productCategoryId) async {
//   //   List<ProductModel> productList = [];
//   //   final db = await DatabaseHelper.instance.database;
//   //   var map = await db.rawQuery(
//   //       'select * from Products where productCategoryId = $productCategoryId');
//   //   map.forEach((val) {
//   //     print(val);
//   //     if (val.length > 0) {
//   //       var model = ProductModel().fromJson(val) as ProductModel;
//   //       productList.add(model);
//   //     }
//   //   });
//   //   return productList;
//   // }
// }
