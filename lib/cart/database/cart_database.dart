 
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/cart/model/cart_discount_model.dart';
import 'package:sa_common/cart/model/cart_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartDatabase {
  static final dao = BaseRepository<CartModel>(CartModel(), tableName: Tables.saleOrderCart);
  Future<CartModel> find(int id) => dao.find(id);
  Future<List<CartModel>> getAll() => dao.getAll();
  Future<int> insert(CartModel model) => dao.insert(model);
  Future<void> update(CartModel model) => dao.update(model);
  Future<void> delete(CartModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  Future<void> bulkInsert(List<CartModel> model, List<CartModel> existing, String companySlug) async {
    final db = await DatabaseHelper.instance.database;

    await db.transaction((txn) async {
      final batch = txn.batch();
      batch.rawQuery(
        '''delete from ${Tables.saleOrderCart} where companySlug = '$companySlug' and isAppliedScheme = 1''',
      );

      for (var val in model) {
        batch.insert(Tables.saleOrderCart, val.toJson());
      }

      await batch.commit();
    });
  }

  Future<CartModel?> getProductId(int productId) async {
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('select * from ${Tables.saleOrderCart} WHERE productId = $productId');
    if (map.length > 0) {
      var model = CartModel().fromJson(map.first) as CartModel;
      return model;
    }

    return null;
  }

  Future<void> DeleteAll() async {
    final db = await DatabaseHelper.instance.database;
    var prefs = await SharedPreferences.getInstance();
    var companySlug = prefs.get(LocalStorageKey.companySlug) as String;
    await db.rawQuery("delete from ${Tables.saleOrderCart} where companySlug = '$companySlug'");
  }

  Future<void> DeleteSchemeProduct(String companySlug) async {
    final db = await DatabaseHelper.instance.database;

    await db.rawQuery("delete from ${Tables.saleOrderCart} where companySlug = '$companySlug' and isAppliedScheme = 1");
  }

  Future<List<CartModel>> getByCartID() async {
    final db = await DatabaseHelper.instance.database;
    var companySlug = Helper.user.companyId;
    var map = await db.rawQuery("select * from ${Tables.saleOrderCart} WHERE companySlug = '$companySlug' order by isAppliedScheme, id desc");
    var modelList = List.generate(map.length, (index) => CartModel.fromMap(map[index])).toList();
    for (var model in modelList) {
      var detail = await db.rawQuery("select * from ${Tables.saleOrderCartDetail} WHERE companySlug = '$companySlug' and ${CartDiscountFields.cartId} = ${model.id}");
      if (detail.length > 0) {
        var detailModel = List.generate(detail.length, (index) => CartDiscountModel.fromMap(detail[index])).toList();
        model.cartDiscounts = detailModel;
      }
    }
    return modelList;
  }

  static Future<void> deleteByProductIds(List<int> productIds) async {
    final db = await DatabaseHelper.instance.database;
    // Batch batch = db.batch();
    String ids = productIds.join(",");

    print("productId = $ids");

    await db.rawQuery('''delete from ${Tables.saleOrderCart} where productid not in ($ids) ''');

    // await batch.commit();
  }

  static Future<void> deleteByProductId(int productIds) async {
    final db = await DatabaseHelper.instance.database;
    await db.rawQuery('''delete from ${Tables.saleOrderCart} where productId = $productIds''');
  }
}
