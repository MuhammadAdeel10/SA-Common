import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/schemes/Database/schemesBranches_database.dart';
import 'package:sa_common/schemes/Database/schemesCustomerCategories_database.dart';
import 'package:sa_common/schemes/Database/schemesDetails_database.dart';
import 'package:sa_common/schemes/Database/schemesSalesGeography_database.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../models/schemeGetModel.dart';
import '../models/schemesModel.dart';

class SchemesDatabase {
  static final dao =
      BaseRepository<SchemesModel>(SchemesModel(), tableName: Tables.Schemes);
  Future<SchemesModel> find(int id) => dao.find(id);
  Future<List<SchemesModel>> getAll() => dao.getAll();
  Future<List<SchemesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SchemesModel model) => dao.insert(model);
  Future<void> update(SchemesModel model) => dao.update(model);
  Future<void> delete(SchemesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SchemesModel> model) async {
    final db = await DatabaseHelper.instance.database;
    var getAll = await SchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();
    model.forEach((val) {
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Schemes,
          val.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Schemes, val.toJson());
      }
    });
    await batch.commit();
  }

  static Future<void> bulkWithMasterDetailInsert(
      List<SchemeGetModel> models) async {
    final db = await DatabaseHelper.instance.database;

    var getAll = await SchemesDatabase.dao.getByCompanySlug();
    Batch batch = db.batch();

    models.forEach((val) {
      var map = val.toMap();
      var schemeModel = SchemesModel.fromMap(map);
      var exist = getAll.any((element) => element.id == val.id);
      if (exist) {
        batch.update(
          Tables.Schemes,
          schemeModel.toJson(),
          where: "id = ?",
          whereArgs: [val.id],
        );
      } else {
        batch.insert(Tables.Schemes, schemeModel.toJson());
      }
    });
    await batch.commit();
    models.forEach((val) {
      if (val.schemeDetails != null) {
        val.schemeDetails!
            .map((e) => e.companySlug =
                e.companySlug != null ? e.companySlug : val.companySlug)
            .toList();
        DetailsSchemesDatabase.bulkInsert(val.schemeDetails!);
      }
      if (val.linkedBranches != null) {
        val.linkedBranches!
            .map((e) => e.companySlug =
                e.companySlug != null ? e.companySlug : val.companySlug)
            .toList();
        BranchesSchemesDatabase.bulkInsert(val.linkedBranches!);
      }
      if (val.linkedCustomerCategories != null) {
        val.linkedCustomerCategories!
            .map((e) => e.companySlug =
                e.companySlug != null ? e.companySlug : val.companySlug)
            .toList();
        CustomerCategoriesSchemesDatabase.bulkInsert(
            val.linkedCustomerCategories!);
      }
      if (val.schemeSalesGeography != null) {
        val.schemeSalesGeography!
            .map((e) => e.companySlug =
                e.companySlug != null ? e.companySlug : val.companySlug)
            .toList();
        SalesGeographySchemesDatabase.bulkInsert(val.schemeSalesGeography!);
      }
    });

    // var getAllSchemes = await SchemesDatabase.dao.getByCompanySlug();
    // var getAllSchemesDetail =
    //     await DetailsSchemesDatabase.dao.getByCompanySlug();
    // var getAllSchemesBranches =
    //     await BranchesSchemesDatabase.dao.getByCompanySlug();
    // var getAllSchemesCategory =
    //     await CustomerCategoriesSchemesDatabase.dao.getByCompanySlug();
    // var getAllSchemesGeography =
    //     await SalesGeographySchemesDatabase.dao.getByCompanySlug();

    // models.forEach((scheme) async {
    //   var map = scheme.toMap();
    //   var schemeModel = SchemesModel.fromMap(map);

    //   print(schemeModel);

    //   await db.insert(Tables.Schemes, schemeModel.toJson());
    // });
    // await db.transaction((txn) async {
    //   Batch batch = txn.batch();
    //   models.forEach((scheme) {
    //     var map = scheme.toMap();
    //     var schemeModel = SchemesModel.fromMap(map);

    //     Check(batch, Tables.Schemes, schemeModel, getAllSchemes);
    //     // scheme.schemeDetails?.map(
    //     //   (e) {
    //     //     return Check(batch, Tables.SchemeDetails, e, getAllSchemesDetail);
    //     //   },
    //     // ).toList();
    //     scheme.linkedBranches?.map(
    //       (e) {
    //         e.companySlug = scheme.companySlug;
    //         return Check(
    //             batch, Tables.SchemeBranches, e, getAllSchemesBranches);
    //       },
    //     ).toList();
    //     scheme.linkedCustomerCategories?.map(
    //       (e) {
    //         e.companySlug = scheme.companySlug;
    //         return Check(
    //             batch, Tables.CustomerCategory, e, getAllSchemesCategory);
    //       },
    //     ).toList();
    //     scheme.schemeSalesGeography?.map(
    //       (e) {
    //         e.companySlug = scheme.companySlug;
    //         return Check(
    //             batch, Tables.SchemesSalesGeography, e, getAllSchemesGeography);
    //       },
    //     ).toList();
    //   });
    //   await batch.commit();
    // });
  }

  static void Check(Batch batch, String tableName, model, existModel) {
    var exist = existModel.any((element) => element.id == model.id);
    if (exist) {
      batch.update(
        tableName,
        model.toJson(),
        where: "id = ?",
        whereArgs: [model.id],
      );
    } else {
      batch.insert(tableName, model.toJson());
    }
  }
}
