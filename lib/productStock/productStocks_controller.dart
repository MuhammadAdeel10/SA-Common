import 'dart:convert';
import 'package:sa_common/productStock/productStock_database.dart';
import 'package:sa_common/productStock/productStock_model.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sqflite/sqflite.dart';

import '../Controller/BaseController.dart';
import '../HttpService/Basehttp.dart';
import '../SyncSetting/Database.dart';
import '../utils/ApiEndPoint.dart';
import '../utils/Logger.dart';
import '../utils/TablesName.dart';

class ProductStocksController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId, {int page = 1}) async {
    try {
      var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.ProductStocks, slug: slug, branchId: branchId, isBranch: true);
      DateTime syncDate = DateTime.now().toUtc();
      var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);
      var response = await BaseClient()
          .get(
              baseUrl,
              "$slug/${branchId}${ApiEndPoint.getProductStocks}"
              "${syncDateString}"
              "?page=${page}&pageSize=5000")
          .catchError(
        (error) {
          handleError(error);
        },
      );
      if (response != null) {
        var decode = json.decode(response.body);
        if (decode.length > 0) {
          var currentPage = decode['page'];
          var totalPages = decode['pages'];
          var productStocks = decode['results'];
          var productStocksList = List<ProductStockModel>.from(productStocks.map((x) => ProductStockModel().fromJson(x, slug: slug)));

          await ProductStockDatabase.bulkInsert(productStocksList);
          if (currentPage <= totalPages) {
            print("Pages" + "$currentPage");
            await Pull(baseUrl, slug, branchId, page: currentPage + 1);
          }
        }
        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    } catch (ex) {
      Logger.ErrorLog("Error ProductStocks Pull: $ex");
    }
  }

  Future<bool> ValidateStock(int productId, int wareHouseId, num quantity, Transaction transaction, {int? batchId, String? serialNumbers, bool isPosInvoice = false}) async {
    var product = Helper.allProductModel.firstWhere((element) => element.id == productId);
    var companySlug = Helper.user.companyId;
    ProductStockModel? productStock;

    if (product.hasBatch == true) {
      var map = await transaction.query(Tables.ProductStocks, where: "${ProductSockField.companySlug} = ? AND ${ProductSockField.productId} = ? AND ${ProductSockField.warehouseId} = ? AND ${ProductSockField.batchId} = ?", whereArgs: [companySlug, productId, wareHouseId, batchId]);

      if (map.length > 0) {
        productStock = ProductStockModel.fromMap(map.first);
      }
    }

    if (product.hasSerialNumber == true) {
      var serialNumber = serialNumbers?.split("|");
      if (serialNumber != null) {
        for (var element in serialNumber) {
          var map = await transaction.query(Tables.ProductStocks, where: "${ProductSockField.companySlug} = ? AND ${ProductSockField.productId} = ? AND ${ProductSockField.warehouseId} = ? AND ${ProductSockField.serialNumber} = ?", whereArgs: [companySlug, productId, wareHouseId, element.trim()]);

          if (map.length > 0) {
            productStock = ProductStockModel.fromMap(map.first);
          }

          if (productStock == null || productStock.quantityInHand < 1) {
            Helper.errorMsg("Add POS Invoice", "Out of stock, ${product.name} available quantity is ${productStock?.quantityInHand} ${product.symbol} against ${serialNumbers}.", context);
            Helper.dialogHide();
            return false;
          }
          productStock.quantityInHand = productStock.quantityInHand - 1;
          await Update(productStock, quantity, transaction);
        }
      }
    } else {
      var map = await transaction.query(Tables.ProductStocks, where: "${ProductSockField.companySlug} = ? AND ${ProductSockField.productId} = ? AND ${ProductSockField.warehouseId} = ?", whereArgs: [companySlug, productId, wareHouseId]);
      if (map.length > 0) {
        productStock = ProductStockModel.fromMap(map.first);
      }
    }

    if (!Helper.requestContext.allowNegativeStock && product.hasSerialNumber == false) {
      if (productStock == null || productStock.quantityInHand < quantity) {
        Helper.errorMsg("Add POS Invoice", "Negative stock sale is not allowed", context);
        Helper.dialogHide();
        return false;
      }
    }
    if (productStock != null && product.hasSerialNumber == false) {
      productStock.quantityInHand -= quantity;
      await Update(productStock, quantity, transaction);
    }
    return true;
  }

  Future<void> Update(ProductStockModel? productStock, num quantity, Transaction transaction) async {
    if (productStock != null) {
      await transaction.update(
        Tables.ProductStocks,
        productStock.toJson(),
        where: "id = ?",
        whereArgs: [productStock.id],
      );
    }
  }
}
