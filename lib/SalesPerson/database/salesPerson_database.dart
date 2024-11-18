import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import '../model/SalesPersonModel.dart';

class SalesPersonDatabase {
  static final dao = BaseRepository<SalesPersonModel>(SalesPersonModel(), tableName: Tables.SalesPerson);
  Future<SalesPersonModel> find(int id) => dao.find(id);
  Future<List<SalesPersonModel>> getAll() => dao.getAll();
  Future<int> insert(SalesPersonModel model) => dao.insert(model);
  Future<void> update(SalesPersonModel model) => dao.update(model);
  Future<void> delete(SalesPersonModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalesPersonModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SalesPersonDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SalesPerson,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SalesPerson, val.toMap());
      }
    });
    await batch.commit();
  }

  Future<List<SalesPersonModel>> GetFilterSalesPerson(String? filter) async {
    List<SalesPersonModel> salesPersonList = [];
    List<Map<String, Object?>> map;
    final db = await DatabaseHelper.instance.database;
    var companySlug = Helper.user.companyId;
    var branchId = Helper.user.branchId;
    map = await db.rawQuery('''select * from SalesPerson where companySlug = '$companySlug' and isActive = 1  and branchId = $branchId and name like '%${filter}%' ''');

    map.forEach((val) {
      if (val.length > 0) {
        var model = SalesPersonModel().fromJson(val) as SalesPersonModel;
        salesPersonList.add(model);
      }
    });
    return salesPersonList;
  }

  Future<SalesPersonModel?> GetSalesPersonByUserId(String slug, String appId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery(''' select * from SalesPerson where companySlug = '$slug' and applicationUserId = '$appId' ''');
    if (map.length > 0) {
      return SalesPersonModel.fromMap(map.first);
    } else {
      return null;
    }
  }
}
