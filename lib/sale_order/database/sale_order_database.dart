import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/sale_order/model/sale_order.dart';
import 'package:sa_common/sale_order/model/sale_order_detail_model.dart';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/sale_order/model/sale_order_model.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/models/SchemeInvoiceDiscountModel.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sqflite/sqflite.dart';

class SaleOrderDatabase {
  static final dao = BaseRepository<SaleOrderModel>(SaleOrderModel(), tableName: Tables.saleOrder);
  Future<SaleOrderModel> find(int id) => dao.find(id);
  Future<List<SaleOrderModel>> getAll() => dao.getAll();
  Future<int> insert(SaleOrderModel model) => dao.insert(model);
  Future<void> update(SaleOrderModel model) => dao.update(model);
  Future<void> delete(SaleOrderModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SaleOrderModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SaleOrderDatabase.dao.getAll();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.saleOrder,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.saleOrder, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<SaleOrderModel?> NewInsert(SaleOrderModel model, List<SaleOrderDetailsModel> detail, List<SaleOrderDiscountsModel> discounts, {List<SchemeInvoiceDiscountModel>? schemeInvoiceDiscount, List<AttachmentsModel>? attachments, required VoidCallback hideLoading}) async {
    final db = await DatabaseHelper.instance.database;
    model.isNew = true;
    try {
      await db.transaction((txn) async {
        var id = await txn.insert(Tables.saleOrder, model.toJson(isLocal: true));
        model.id = id;
        if (detail.length > 0) {
          for (var element in detail) {
            element.saleOrderId = id;
            await txn.delete(Tables.saleOrderDetailTax, where: 'saleOrderDetailId = ?', whereArgs: [element.id]);
            await txn.insert(Tables.saleOrderDetail, element.toJson(isLocal: true));
            if (discounts.length > 0) {
              var disc = discounts.where((e) => e.saleOrderDetailId == element.id || e.saleOrderDetailId == null).toList();
              for (var discount in disc) {
                discount.saleOrderDetailId = element.id;
                print("Discount $discount");
                await txn.insert(Tables.saleOrderDiscount, discount.toJson());
              }
            }
            if (element.taxes != null && element.taxes!.isNotEmpty) {
              for (var tax in element.taxes!) {
                tax.saleOrderDetailId = element.id;
                tax.companySlug = Helper.user.companyId;
                tax.id = null;
                await txn.insert(Tables.saleOrderDetailTax, tax.toJson());
              }
            }
          }
        }
        if (schemeInvoiceDiscount != null && schemeInvoiceDiscount.isNotEmpty && schemeInvoiceDiscount.length > 0) {
          for (var element in schemeInvoiceDiscount) {
            element.sourceId = id;
            await txn.insert(Tables.SchemeInvoiceDiscount, element.toJson());
          }
        }
        if (attachments != null && attachments.length > 0) {
          for (var element in attachments) {
            element.sourceId = id;
            await txn.insert(Tables.Attachments, element.toJson());
          }
        }
      });
      return model;
    } catch (ex) {
      hideLoading;
      return throw ex;
    }
  }

  static Future<SaleOrderModel?> updateRecord(SaleOrderModel model, List<SaleOrderDetailsModel> detail, List<SaleOrderDiscountsModel> discounts, {List<SchemeInvoiceDiscountModel>? schemeInvoiceDiscount, List<AttachmentsModel>? attachments, required VoidCallback hideLoading}) async {
    final db = await DatabaseHelper.instance.database;
    model.isEdit = true;
    try {
      await db.transaction(
        (txn) async {
          await txn.update(
            Tables.saleOrder,
            model.toJson(),
            where: "id = ?",
            whereArgs: [model.id],
          );

          if (detail.length > 0) {
            for (var element in detail) {
              element.saleOrderId = model.id;
              await txn.rawQuery('''Delete from  ${Tables.saleOrderDetail} where saleOrderId = ${model.id} and isBonusProduct = 1 ''');
              await txn.delete(Tables.saleOrderDiscount, where: 'saleOrderDetailId = ?', whereArgs: [element.id]);
              if (element.id == null) {
                await txn.insert(Tables.saleOrderDetail, element.toJson());
              } else {
                await txn.update(
                  Tables.saleOrderDetail,
                  element.toJson(),
                  where: "id = ?",
                  whereArgs: [element.id],
                );
              }
              if (discounts.isNotEmpty) {
                var disc = discounts.where((e) => e.saleOrderDetailId == element.id).toList();
                for (var discount in disc) {
                  discount.saleOrderDetailId = element.id;
                  if (discount.id == null) {
                    await txn.insert(Tables.saleOrderDiscount, discount.toJson());
                  } else {
                    int count = await txn.update(
                      Tables.saleOrderDiscount,
                      discount.toJson(),
                      where: "id = ?",
                      whereArgs: [discount.id],
                    );
                    if (count == 0) {
                      await txn.insert(Tables.saleOrderDiscount, discount.toJson());
                    }
                  }
                }
              }
              if (element.taxes != null && element.taxes!.isNotEmpty) {
                for (var tax in element.taxes!) {
                  tax.saleOrderDetailId = element.id;
                  tax.companySlug = Helper.user.companyId;
                  tax.id = null;
                  await txn.update(
                    Tables.saleOrderDetailTax,
                    tax.toJson(),
                    where: "id = ?",
                    whereArgs: [tax.id],
                  );
                }
              }
            }
          }
          if (schemeInvoiceDiscount != null && schemeInvoiceDiscount.isNotEmpty && schemeInvoiceDiscount.length > 0) {
            for (var element in schemeInvoiceDiscount) {
              await txn.update(
                Tables.SchemeInvoiceDiscount,
                element.toJson(),
                where: "id = ?",
                whereArgs: [element.id],
              );
            }
          }
          if (attachments != null && attachments.length > 0) {
            for (var element in attachments) {
              if (element.id == null) {
                await txn.insert(Tables.Attachments, element.toJson());
              } else {
                await txn.update(
                  Tables.Attachments,
                  element.toJson(),
                  where: "id = ?",
                  whereArgs: [element.id],
                );
              }
            }
          }
        },
      );
      return model;
    } catch (ex) {
      hideLoading;
      return throw ex;
    }
  }

  static Future<void> SyncUpdate(int localId, SaleOrder saleOrderModel) async {
    final db = await DatabaseHelper.instance.database;

    Batch batch = db.batch();
    batch.rawQuery('''Delete from ${Tables.saleOrder} where id = $localId ''');
    batch.execute('''Delete from ${Tables.saleOrderDetail}  where saleOrderId = $localId ''');
    if (saleOrderModel.attachments != null && saleOrderModel.attachments!.isNotEmpty) {
      batch.execute('''Delete from ${Tables.Attachments} where source = '${AttachmentsSource.SaleOrder.name}' and sourceId = $localId''');
      for (var attaches in saleOrderModel.attachments!) {
        File files = File(attaches.path ?? "");
        if (await files.exists()) {
          files.delete();
        }
      }
    }
    await batch.commit();
  }

  static Future<bool> BulkUpdateCustomer(int? customerId, int? localCustomerId, String? companySlug) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.rawQuery('''Update ${Tables.saleOrder} set customerId = $customerId where CompanySlug = '$companySlug' and customerId = $localCustomerId ''');
      return true;
    } catch (ex) {
      log("Error With catch Exception $ex");
      return false;
    }
  }

  static Future<List<SaleOrderModel>?> saleOrderListData({String filter = ""}) async {
    final db = await DatabaseHelper.instance.database;

    var user = Helper.user;

    var mapResponse = await db.rawQuery('''
      select c.name as customerName, s.*  from ${Tables.saleOrder} s 
      inner join customers c on s.customerId = c.id 
      where s.companySlug = '${user.companyId}' and s.branchId = ${user.branchId} and 
      (s.number like '%$filter%' or c.name like '%$filter%') order by id desc
      ''');
    if (mapResponse.length > 0) {
      return List.generate(mapResponse.length, (i) => SaleOrderModel.fromJson(mapResponse[i]));
    }
    return null;
  }

  static Future<List<SaleOrderModel>?> saleOrderListDataCustomerPortal({String filter = "", required int customerId}) async {
    final db = await DatabaseHelper.instance.database;

    var user = Helper.user;

    var mapResponse = await db.rawQuery('''
      select * from ${Tables.saleOrder} s 
      where s.companySlug = '${user.companyId}' and s.branchId = ${user.branchId} and s.customerId = ${customerId} and
      (s.number like '%$filter%') order by id desc
      ''');
    if (mapResponse.length > 0) {
      return List.generate(mapResponse.length, (i) => SaleOrderModel.fromJson(mapResponse[i]));
    }
    return null;
  }

  static Future<SaleOrderModel?> getSaleOrder(String number) async {
    final db = await DatabaseHelper.instance.database;

    // Fetch the sale order
    final saleOrderMap = await db.query(
      Tables.saleOrder,
      where: "number = ?",
      whereArgs: [number],
    );

    if (saleOrderMap.isEmpty) return null;

    // Parse sale order
    final saleOrder = SaleOrderModel.fromJson(saleOrderMap.first);

    // Fetch the sale order details
    final saleOrderDetailMap = await db.query(
      Tables.saleOrderDetail,
      where: "SaleOrderId = ?",
      whereArgs: [saleOrder.id],
    );

    // Parse and attach details if any
    if (saleOrderDetailMap.isNotEmpty) {
      saleOrder.saleOrderDetails = saleOrderDetailMap.map((detail) => SaleOrderDetailsModel.fromJson(detail)).toList();

      for (var saleOrderDetail in saleOrder.saleOrderDetails!) {
        final saleOrderDetailDiscountMap = await db.query(
          Tables.saleOrderDiscount,
          where: "SaleOrderDetailId = ?",
          whereArgs: [saleOrderDetail.id],
        );
        if (saleOrderDetailDiscountMap.isNotEmpty) {
          if (saleOrderDetail.discounts == null) {
            saleOrderDetail.discounts = [];
          }
          var discount = saleOrderDetailDiscountMap.map((detail) => SaleOrderDiscountsModel.fromMap(detail, slug: saleOrder.companySlug)).toList();
          saleOrderDetail.discounts?.addAll(discount);
        }
      }
    }

    return saleOrder;
  }
}
