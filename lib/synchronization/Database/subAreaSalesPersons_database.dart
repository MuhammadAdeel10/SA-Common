import 'package:sa_common/utils/Helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import '../../Controller/BaseRepository.dart';
import '../../utils/TablesName.dart';
import 'package:sa_common/schemes/models/SubAreaSalesPersonsModel.dart';


class SubAreaSalesPersonsDatabase {
  static final dao = BaseRepository<SubAreaSalesPersonsModel>(SubAreaSalesPersonsModel(),
      tableName: Tables.SubAreaSalesPersons);

  Future<SubAreaSalesPersonsModel> find(int id) => dao.find(id);

  Future<List<SubAreaSalesPersonsModel>> getAll() => dao.getAll();

  Future<int> insert(SubAreaSalesPersonsModel model) => dao.insert(model);

  Future<void> update(SubAreaSalesPersonsModel model) => dao.update(model);

  Future<void> delete(SubAreaSalesPersonsModel model) => dao.delete(model);

  Future<void> deleteById(int id) => dao.deleteById(id);

   
    static Future<void> bulkInsert(List<SubAreaSalesPersonsModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SubAreaSalesPersonsDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.SubAreaSalesPersons,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.SubAreaSalesPersons, val.toMap());
      }
    });
    await batch.commit();
  }

  static Future<List<SubAreaSalesPersonsModel>> GetFilterSubAreas() async {
    var user = Helper.user;
    List<SubAreaSalesPersonsModel> subAreaList = [];
    List<Map<String, Object?>> map = List.empty();
    final db = await DatabaseHelper.instance.database;
    
    if (Helper.requestContext.enableSalesGeography){

     map = await db.rawQuery(
        '''select s.SubAreaId, sa.Name as subAreaName from SubAreaSalesPersons s
            left join  SubAreas sa on s.SubAreaId = sa.Id
            join SalesPerson SP on SP.id = s.salesPersonId
            where s.companySlug = '${user.companyId}' and s.branchId = ${user.branchId} and sp.applicationUserId = '${user.userId}' ''');
    }

    else{
      map = await db.rawQuery(
        '''select sa.id as SubAreaId, sa.Name as subAreaName from SubAreas sa
        where sa.companySlug = '${user.companyId}' and sa.branchId = ${user.branchId}
        ''');
    }
    map.forEach((val) {
      if (val.length > 0) {
        var model = SubAreaSalesPersonsModel().fromJson(val) as SubAreaSalesPersonsModel;
        subAreaList.add(model);
      }
    });
    return subAreaList;
  }
}
