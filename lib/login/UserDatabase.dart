import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'UserModel.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  UserDatabase._init();

  Future<UserModel> create(UserModel model) async {
    final db = await DatabaseHelper.instance.database;
    final id = await db.insert(Tables.user, model.toJson());
    return model.copy(id: id);
  }

  Future<UserModel> GetUserById(int id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      Tables.user,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<UserModel> GetUserByGuid(String id) async {
    final db = await DatabaseHelper.instance.database;

    final maps = await db.query(
      Tables.user,
      where: '${UserFields.userId} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return UserModel.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<UserModel>> readAllUsers() async {
    final db = await DatabaseHelper.instance.database;
    final result = await db.query(Tables.user);
    return result.map((json) => UserModel.fromJson(json)).toList();
  }

  Future<int> update(UserModel model) async {
    final db = await DatabaseHelper.instance.database;

    return db.update(
      Tables.user,
      model.toJson(),
      where: '${UserFields.id} = ?',
      whereArgs: [model.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await DatabaseHelper.instance.database;

    return await db.delete(
      Tables.user,
      where: '${UserFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<UserModel?> getLogin(String email, String password) async {
    var dbClient = await DatabaseHelper.instance.database;
    var res = await dbClient.rawQuery(
        "SELECT * FROM users WHERE ${UserFields.email} = '$email' and ${UserFields.password} = '$password'");

    if (res.length > 0) {
      return UserModel.fromJson(res.first);
    }
    return null;
  }

  Future close() async {
    final db = await DatabaseHelper.instance.database;

    db.close();
  }
}
