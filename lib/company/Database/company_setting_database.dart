import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseRepository.dart';
import '../../schemes/database/discount_database.dart';
import '../Models/CompanySettingModel.dart';

class CompanySettingDatabase {
  static final dao = BaseRepository<CompanySettingModel>(CompanySettingModel(), tableName: Tables.CompanySetting);
  Future<CompanySettingModel> find(int id) => dao.find(id);
  Future<List<CompanySettingModel>> getAll() => dao.getAll();
  Future<List<CompanySettingModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(CompanySettingModel model) => dao.insert(model);
  Future<void> update(CompanySettingModel model) => dao.update(model);
  Future<void> delete(CompanySettingModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<CompanySettingModel?> GetCompany() async {
    var prefs = PrefUtils();
    var slug = prefs.GetPreferencesString(LocalStorageKey.companySlug);
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery("select * from ${Tables.CompanySetting} where slug = '$slug'");
    if (map.length > 0) {
      var model = CompanySettingModel().fromJson(map[0]) as CompanySettingModel;
      return model;
    }
    return null;
  }

  static Future<void> bulkInsert(List<CompanySettingModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await DiscountDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.CompanySetting,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.CompanySetting, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<CompanySettingModel?> Get(String guId) async {
    final db = await DatabaseHelper.instance.database;

    var map = await db.query(Tables.CompanySetting, where: "id = ?", whereArgs: [guId]);

    if (map.length > 0) {
      var model = CompanySettingModel().fromJson(map.first) as CompanySettingModel;
      return model;
    }
    return null;
  }

  Future<int> newUpdate(CompanySettingModel model) async {
    final db = await DatabaseHelper.instance.database;
    return await db.update(
      Tables.CompanySetting,
      model.toJson(),
      where: "id = ?",
      whereArgs: [model.id.toString()],
    );
  }
}
