import 'dart:convert';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/schemes/Database/productSalesTax_database.dart';
import 'package:sa_common/schemes/Database/product_database.dart';
import 'package:sa_common/schemes/Database/product_images_database.dart';
import 'package:sa_common/schemes/models/product_images_mode.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/synchronization/Database/BranchProductTax_database.dart';
import 'package:sa_common/synchronization/Models/BranchProductTaxModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../../SyncSetting/Database.dart';

class ProductController extends BaseController {
  Future<void> GetAllProduct(String baseUrl, String imageBaseUrl, String slug, int branchId, int page) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.products, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient()
        .get(
      baseUrl,
      "${slug}/${branchId}${ApiEndPoint.getAllProduct}"
      "${formatted}"
      "&page=${page}&pageSize=5000",
    )
        .catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var decode = json.decode(response.body);
      //as List<Map<String, dynamic>>;
      if (decode.length > 0) {
        var currentPage = decode['page'];
        //var pageSize = decode['size'];
        var totalPages = decode['pages'];
        // int totalRecord = decode['records'];
        var products = decode['results'];
        var productList = List<ProductModel>.from(products.map((x) => ProductModel().fromJson(x, slug: slug)));

        await ProductDatabase.bulkInsert(imageBaseUrl, productList);
        if (currentPage <= totalPages) {
          print("Pages" + "$currentPage");
          await GetAllProduct(baseUrl, imageBaseUrl, slug, branchId, currentPage + 1);
        }
      }
      var productSalesTaxes = await ProductSalesTaxDatabase.dao.SelectList("applicableToAllBranches = 0");
      if (productSalesTaxes != null) {
        for (var productSalesTax in productSalesTaxes) {
          var branchProductTaxes = await BaseClient().get(baseUrl, "${slug}/${branchId}/Products/branchProductTaxes/${productSalesTax.productId}").catchError(
            (error) {
              handleError(error);
              throw error;
            },
          );
          if (branchProductTaxes != null && branchProductTaxes.statusCode == 200) {
            var branchProductTaxesModel = BranchProductTaxModel().FromJson(branchProductTaxes.body, slug);
            await BranchProductTaxDatabase.bulkInsert(branchProductTaxesModel);
            //
          }
        }
      }
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> DeleteProduct(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.products, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();

    var getProductCategories = await ProductDatabase.dao.getAll();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(baseUrl, "${slug}/${branchId}${ApiEndPoint.deleteProduct}${formatted}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var productCategories = ProductModel().FromJson(response.body);

      if (productCategories.any((element) => true)) {
        for (var unit in productCategories) {
          var exist = getProductCategories.any((element) => element.id == unit.id);
          if (exist) {
            await ProductDatabase.dao.deleteById(unit.id!);
          }
        }
        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    }
  }
  // Future<List<BaseModel>> GetAllContact(String slug, int brachId) async {
  //   var getAllContact = await contactDatabase.dao.getAll();
  //   List<BaseModel> lstContact = getAllContact;
  //   if (lstContact.length == 0) {
  //     var response = await BaseClient()
  //         .get("${slug}/${brachId}${ApiEndPoint.defaultContacts}")
  //         .catchError(
  //       (error) {
  //         handleError(error);
  //       },
  //     );

  //     if (response != null) {
  //       var jsondecodes = json.decode(response.body);

  //       for (var jsondecodes in jsondecodes) {
  //         if (jsondecodes != null) {
  //           var model = ContactModel().fromJson(jsondecodes);
  //           lstContact.add(model);
  //         }
  //       }
  //     }
  //     if (lstContact.length > 0) {
  //       lstContact.forEach((element) async {
  //         await contactDatabase.dao.insert(element);
  //       });
  //     }
  //   }
  //   return lstContact;
  // }

  // Future<List<BaseModel>> GetAllAccount(String slug, int brachId) async {
  //   var getAllAccount = await AccountDatabase.dao.getAll();
  //   List<BaseModel> lstAccount = getAllAccount;
  //   if (lstAccount.length == 0) {
  //     var response = await BaseClient()
  //         .get("${slug}/${brachId}${ApiEndPoint.Accounts}")
  //         .catchError(
  //       (error) {
  //         handleError(error);
  //       },
  //     );

  //     if (response != null) {
  //       var jsondecodes = json.decode(response.body);

  //       for (var jsondecodes in jsondecodes) {
  //         if (jsondecodes != null) {
  //           var model = AccountModel().fromJson(jsondecodes);
  //           lstAccount.add(model);
  //         }
  //       }
  //     }
  //     if (lstAccount.length > 0) {
  //       lstAccount.forEach((element) async {
  //         await AccountDatabase.dao.insert(element);
  //       });
  //     }
  //   }
  //   return lstAccount;
  // }

  // Future<List<BaseModel>> GetAllBrands(String slug) async {
  //   var getAllBrands = await BrandDatabase.dao.getAll();
  //   List<BaseModel> lstBrands = getAllBrands;
  //   if (lstBrands.length == 0) {
  //     var response =
  //         await BaseClient().get("${slug}${ApiEndPoint.Brands}").catchError(
  //       (error) {
  //         handleError(error);
  //       },
  //     );

  //     if (response != null) {
  //       var jsondecodes = json.decode(response.body);

  //       for (var jsondecodes in jsondecodes) {
  //         if (jsondecodes != null) {
  //           var model = BrandModel().fromJson(jsondecodes);
  //           lstBrands.add(model);
  //         }
  //       }
  //     }
  //     if (lstBrands.length > 0) {
  //       lstBrands.forEach((element) async {
  //         await BrandDatabase.dao.insert(element);
  //       });
  //     }
  //   }
  //   return lstBrands;
  // }

  Future<void> PullProductImages(String baseUrl, String slug, {int page = 1}) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
      Tables.productImages,
      slug: slug,
    );
    DateTime syncDate = DateTime.now().toUtc();
    var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);
    var response = await BaseClient()
        .get(
      baseUrl,
      "${slug}${ApiEndPoint.productImages}"
      "${syncDateString}"
      "?page=${page}&pageSize=5000",
    )
        .catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var decode = json.decode(response.body);
      //as List<Map<String, dynamic>>;
      if (decode.length > 0) {
        var currentPage = decode['page'];
        var totalPages = decode['pages'];
        var productImages = decode['results'];
        var pullData = List<ProductImages>.from(productImages.map((x) => ProductImages().fromJson(x, slug: slug)));

        await ProductImagesDatabase.bulkInsert(pullData);
        if (currentPage <= totalPages) {
          print("Pages" + "$currentPage");
          await PullProductImages(baseUrl, slug, page: currentPage + 1);
        }
      }
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

}
