import 'package:sa_common/cart/model/cart_discountView_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../model/cart_discount_model.dart';

class CartDiscountDatabase {
  static final dao = BaseRepository<CartDiscountModel>(CartDiscountModel(), tableName: Tables.saleOrderCartDetail);
  Future<CartDiscountModel> find(int id) => dao.find(id);
  Future<List<CartDiscountModel>> getAll() => dao.getAll();
  Future<int> insert(CartDiscountModel model) => dao.insert(model);
  Future<void> update(CartDiscountModel model) => dao.update(model);
  Future<void> delete(CartDiscountModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<CartDiscountModel> model, {int? productId, String? slug}) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await CartDiscountDatabase.dao.getAll();
    Batch batch = db.batch();
    if (productId != null) {
        batch.rawQuery(''' 
            DELETE FROM ${Tables.saleOrderCartDetail}
            WHERE cartId IN (
            SELECT c.id
            FROM ${Tables.saleOrderCart} c
            INNER JOIN ${Tables.saleOrderCartDetail} pd ON c.id = pd.cartId
            WHERE pd.schemeId IS NOT NULL 
            AND c.productId = $productId 
            AND c.isProductScheme = 1 
            AND c.companySlug = '$slug'
            );
        ''');
    }

    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.saleOrderCartDetail,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.saleOrderCartDetail, val.toJson());
      }
    });
    await batch.commit();
  }

  Future<List<CartDiscountModel>> getDiscountByCartId(int cartId) async {
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    List<CartDiscountModel> cartDiscountList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('''select * from ${Tables.saleOrderCartDetail} where CartId = $cartId And companySlug = '$slug' ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = CartDiscountModel().fromJson(val) as CartDiscountModel;
        cartDiscountList.add(model);
      }
    });
    return cartDiscountList;
  }

  Future<void> deleteBySchemeId(int productId) async {
    String slug = Helper.user.companyId ?? "";
    final db = await DatabaseHelper.instance.database;
    await db.rawQuery(''' 
        DELETE FROM ${Tables.saleOrderCartDetail}
        WHERE cartId IN (
        SELECT c.id
        FROM ${Tables.saleOrderCart} c
        INNER JOIN ${Tables.saleOrderCartDetail} pd ON c.id = pd.cartId
        WHERE pd.schemeId IS NOT NULL 
        AND c.productId = $productId 
        AND c.isProductScheme = 1 
        AND c.companySlug = '$slug'
        );    
    ''');
  }

  Future<List<CartDiscountViewModel>> getCartDiscount(int cartId) async {
    var prefs = await SharedPreferences.getInstance();
    var slug = prefs.get(LocalStorageKey.companySlug) as String;
    List<CartDiscountViewModel> cartDiscountList = [];
    final db = await DatabaseHelper.instance.database;
    var map = await db.rawQuery('''select ${Tables.saleOrderCartDetail}.id,${Tables.saleOrderCartDetail}.companySlug, ${Tables.saleOrderCartDetail}.discountId,
           ${Tables.saleOrderCartDetail}.discountInAmount,${Tables.saleOrderCartDetail}.discountInPercent, 
           ${Tables.Discount}.name,${Tables.Discount}.abbreviation ,${Tables.saleOrderCartDetail}.discountType,${Tables.saleOrderCartDetail}.schemeId,
           ${Tables.saleOrderCartDetail}.schemeId,${Tables.saleOrderCartDetail}.schemeDetailId
           from ${Tables.saleOrderCartDetail}  inner join ${Tables.Discount} on ${Tables.saleOrderCartDetail}.discountId = ${Tables.Discount}.id
           where ${Tables.saleOrderCartDetail}.companySlug = '$slug' and cartId = '$cartId' ''');
    map.forEach((val) {
      if (val.length > 0) {
        var model = CartDiscountViewModel.fromMap(val);
        cartDiscountList.add(model);
      }
    });
    return cartDiscountList;
  }
}
