 
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/synchronization/Models/visits_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class VisitsDatabase {
  static final dao = BaseRepository<VisitsModel>(VisitsModel(), tableName: Tables.visits);
  var tableName = Tables.visits;
  Future<VisitsModel> find(int id) => dao.find(id);
  Future<List<VisitsModel>> getAll() => dao.getAll();
  Future<List<VisitsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<void> update(VisitsModel model) => dao.update(model);
  Future<void> insert(VisitsModel model) => dao.insert(model);

  
  Future<void> delete(VisitsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<Database> get db => DatabaseHelper.instance.database;


    static Future<void> SyncUpdate(int localId, VisitsModel visitsModel) async {
    final db = await DatabaseHelper.instance.database;

    Batch batch = db.batch();

    batch.rawUpdate("update ${Tables.visits} set ${VisitsModelField.isSync} = 1, ${VisitsModelField.id} = ${visitsModel.id} where id = $localId");
 
    await batch.commit();
  }
  
  static Future<bool> BulkUpdateVisits(int? customerId, int? localCustomerId, String? companySlug) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.rawQuery('''Update ${Tables.visits} set customerId = $customerId where CompanySlug = '$companySlug' and customerId = $localCustomerId ''');
      return true;
    } catch (ex) {
      return false;
    }
  }

 
}
