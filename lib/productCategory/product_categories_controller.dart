import 'package:sa_common/productCategory/product_categoriesDatabase.dart';
import 'package:sa_common/productCategory/product_categories_model.dart';

import '../../SyncSetting/Database.dart';
import '../Controller/BaseController.dart';
import '../Controller/BaseRepository.dart';
import '../HttpService/Basehttp.dart';
import '../utils/ApiEndPoint.dart';
import '../utils/Helper.dart';
import '../utils/TablesName.dart';

class ProductCategoriesController extends BaseController {
  Future<List<BaseModel>> GetAllProductCategories(String baseUrl, String imageBaseUrl, String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.productsCategories, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var getAllProductCategory = await ProductCategoryDatabase.dao.getAll();

    var response = await BaseClient().get(baseUrl, "${slug}/${ApiEndPoint.getProductCategories}${formatted}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var pullData = ProductCategoryModel().FromJson(response.body, slug);
      ProductCategoryDatabase.bulkInsert(imageBaseUrl, pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }

    return getAllProductCategory;
  }

  Future<void> DeleteProductCategories(String baseUrl, String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.productsCategories, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getProductCategories = await ProductCategoryDatabase.dao.getAll();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(baseUrl, "${slug}${ApiEndPoint.deleteCategories}${formatted}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var productCategories = ProductCategoryModel().FromJson(response.body, slug);

      if (productCategories.any((element) => true)) {
        for (var unit in productCategories) {
          var exist = getProductCategories.any((element) => element.id == unit.id);
          if (exist) {
            await ProductCategoryDatabase.dao.deleteById(unit.id!);
          }
        }
        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    }
  }
}
