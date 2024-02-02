import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class BaseRepository<T extends BaseModel> {
  Future<Database> get db => DatabaseHelper.instance.database;
  final String tableName;
  final BaseModel instance;

  BaseRepository(this.instance, {required this.tableName});

  BaseModel fromJson(dynamic map) => instance.fromJson(map);

  Future<T> find(int id) async {
    try {
      final dbClient = await db;
      var map = await dbClient.query(tableName, where: "id = ?", whereArgs: [id]);

      return fromJson(map.first) as T;
    } catch (ex) {
      Logger.ErrorLog("Find By Id $tableName: $ex");
      throw ex;
    }
  }

  Future<T?> SelectSingle(String filter) async {
    try {
      PrefUtils pref = PrefUtils();
      var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
      final dbClient = await db;
      var map = await dbClient.rawQuery('''Select * from $tableName where companySlug = '$slug' and  $filter ''');

      if (map.length > 0) {
        return fromJson(map.first) as T;
      } else {
        return null;
      }
    } catch (ex) {
      Logger.ErrorLog("SelectSingle $tableName: $ex");
      throw ex;
    }
  }

  Future<List<T>?> SelectList(String filter) async {
    try {
      PrefUtils pref = PrefUtils();
      var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
      var dbClient = await db;
      var map = await dbClient.rawQuery('''Select * from $tableName where companySlug = '$slug' and $filter ''');
      if (map.length > 0) {
        return List.generate(map.length, (i) => fromJson(map[i]) as T);
      } else {
        return null;
      }
    } catch (ex) {
      Logger.ErrorLog("SelectList $tableName: $ex");
      throw ex;
    }
  }

  Future<List<T>> getAll() async {
    try {
      var dbClient = await db;
      var map = await dbClient.query(tableName);
      return List.generate(map.length, (i) => fromJson(map[i]) as T);
    } catch (ex) {
      Logger.ErrorLog("Find All $tableName: $ex");
      throw ex;
    }
  }

  Future<List<T>> getByCompanySlug() async {
    try {
      var dbClient = await db;
      var prefs = await SharedPreferences.getInstance();
      var companySlug = prefs.get(LocalStorageKey.companySlug) as String;
      var map = await dbClient.query(tableName, where: "companySlug = ?", whereArgs: [companySlug]);
      return List.generate(map.length, (i) => fromJson(map[i]) as T);
    } catch (ex) {
      Logger.ErrorLog("Find By Company Slug $tableName: $ex");
      throw ex;
    }
  }

  Future<int> insert(BaseModel model) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      var companySlug = prefs.get(LocalStorageKey.companySlug) as String;
      model.companySlug = companySlug;
      var dbClient = await db;
      var response = await dbClient.insert(tableName, model.toJson());
      return response;
    } catch (ex) {
      Logger.ErrorLog("Insert $tableName: $ex");
      throw ex;
    }
  }

  Future<int> update(BaseModel model) async {
    try {
      final dbClient = await db;
      var response = await dbClient.update(
        tableName,
        model.toJson(),
        where: "id = ?",
        whereArgs: [model.id],
      );

      return response;
    } catch (ex) {
      Logger.ErrorLog("Update $tableName: $ex");
      throw ex;
    }
  }

  Future<void> delete(BaseModel model) async {
    try {
      final dbClient = await db;
      await dbClient.delete(tableName, where: "id = ?", whereArgs: [model.id]);
    } catch (ex) {
      Logger.ErrorLog("Delete $tableName: $ex");
      throw ex;
    }
  }

  Future<void> deleteById(int id) async {
    try {
      final dbClient = await db;
      await dbClient.delete(tableName, where: "id = ?", whereArgs: [id]);
    } catch (ex) {
      Logger.ErrorLog("Delete $tableName: $ex");
      throw ex;
    }
  }

  Future close() async {
    final dbClient = await db;
    dbClient.close();
  }
}

abstract class BaseModel<Tkey> {
  Tkey? id;
  String? companySlug;
  Map<String, dynamic> toJson();
  BaseModel fromJson(Map<String, dynamic> json, {String slug});
}
