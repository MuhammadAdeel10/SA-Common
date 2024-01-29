import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'model.dart';

class SyncSettingDatabase {
  static final dao = BaseRepository<SyncSettingModel>(SyncSettingModel(),
      tableName: Tables.syncSetting);
  Future<SyncSettingModel> find(int id) => dao.find(id);
  Future<List<SyncSettingModel>> getAll() => dao.getAll();
  Future<int> insert(SyncSettingModel model) async => await dao.insert(model);
  Future<int> update(SyncSettingModel model) => dao.update(model);
  Future<void> delete(SyncSettingModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<SyncSettingModel> GetByTableName(String tableName,
      {String? slug, int? branchId, bool isBranch = false}) async {
    final db = await DatabaseHelper.instance.database;
    if (isBranch) {
      var dataWithBranch = await db.rawQuery(
          '''SELECT * FROM "syncSettings" where ${SyncSettingFields.tableName} = '${tableName}' And ${SyncSettingFields.companySlug} = '${slug}' And ${SyncSettingFields.branchId} = $branchId Limit 1''');
      if (dataWithBranch.length > 0) {
        return SyncSettingModel().fromJson(dataWithBranch[0])
            as SyncSettingModel;
      }
    } else {
      var data = await db.rawQuery(
          '''SELECT * FROM "syncSettings" where ${SyncSettingFields.tableName} = '${tableName}' And ${SyncSettingFields.companySlug} = '${slug}' Limit 1''');
      if (data.length > 0) {
        return SyncSettingModel().fromJson(data[0]) as SyncSettingModel;
      }
    }
    SyncSettingModel model = SyncSettingModel();
    model.tableName = tableName;
    model.isSync = false;
    model.syncDate = DateTime(2018, 1, 1);
    model.companySlug = slug!;
    model.branchId = branchId ?? null;

    var dbInsert = await db.insert(Tables.syncSetting, model.toJson());
    var response = model.copy(id: dbInsert);
    return response;
  }

  static Future<bool> SalesInvoiceSync() async {
    DateTime now = DateTime.now().toUtc();
    final db = await DatabaseHelper.instance.database;
    var response = await db.rawQuery(
        ''' Update syncSettings set syncDate = '$now' where tableName = '${Tables.POSInvoice}' ''');
    if (response.length > 0) {
      return true;
    }
    return false;
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
