import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

class AttachmentsDatabase {
  static final dao = BaseRepository<AttachmentsModel>(AttachmentsModel(), tableName: Tables.Attachments);
  var tableName = Tables.Attachments;
  Future<AttachmentsModel> find(int id) => dao.find(id);
  Future<List<AttachmentsModel>> getAll() => dao.getAll();
  Future<List<AttachmentsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<void> update(AttachmentsModel model) => dao.update(model);
  Future<void> insert(AttachmentsModel model) => dao.insert(model);

  Future<void> delete(AttachmentsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);
  Future<Database> get db => DatabaseHelper.instance.database;

  Future<void> deleteBySourceId(int sourceId) async {
    try {
      final dbClient = await db;
      await dbClient.delete(tableName, where: "sourceId = ?", whereArgs: [sourceId]);
    } catch (ex) {
      Logger.ErrorLog("Delete $tableName: $ex");
      throw ex;
    }
  }

  Future<void> PushUpdateAttachments(List<AttachmentsModel> attachments) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await AttachmentsDatabase.dao.getAll();
    db.transaction(
      (txn) async {
        Batch batch = txn.batch();
        attachments.forEach((val) {
          var exist = getAll.any((element) => element.id == val.id);
          if (exist) {
            batch.update(
              Tables.Attachments,
              val.toJson(),
              where: "id = ?",
              whereArgs: [val.id],
            );
          } else {
            batch.insert(Tables.Attachments, val.toJson());
          }
        });
        await batch.commit();
      },
    );
  }
}
