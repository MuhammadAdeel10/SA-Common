import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:sqflite/sqflite.dart';

class DiscountDatabase {
  static final dao = BaseRepository<DiscountModel>(DiscountModel(), tableName: Tables.Discount);
  Future<DiscountModel> find(int id) => dao.find(id);
  Future<List<DiscountModel>> getAll() => dao.getAll();
  Future<List<DiscountModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(DiscountModel model) => dao.insert(model);

  static Future<void> bulkInsert(List<DiscountModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await DiscountDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Discount,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Discount, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<DiscountModel?> DefaultDiscount() async {
    final db = await DatabaseHelper.instance.database;
    var pref = PrefUtils();

    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    var map = await db.rawQuery('''select * from ${Tables.Discount} where ${DiscountField.companySlug} = '$slug' and ${DiscountField.isDefault} = 1''');

    if (map.length > 0) {
      var model = DiscountModel().fromJson(map[0]) as DiscountModel;
      return model;
    }
    return null;
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;
    db.close();
  }
}
