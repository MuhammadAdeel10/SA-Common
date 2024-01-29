import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../../SyncSetting/Database.dart';
import '../Database/customerCategory_database.dart';
import '../Models/CustomerCategoryModel.dart';

class CustomerCategoryController extends BaseController {
  Future<void> Pull(String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
        Tables.CustomerCategory,
        slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted =
        Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient()
        .get("$slug/${ApiEndPoint.getCustomerCategories}${formatted}")
        .catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var pullData = CustomerCategoryModel().FromJson(response.body, slug);
      CustomerCategoryDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> Delete(String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
        Tables.CustomerCategory,
        slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted =
        Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var getAll = await CustomerCategoryDatabase.dao.getAll();

    var response = await BaseClient()
        .get("${slug}${ApiEndPoint.deleteCustomerCategories}${formatted}")
        .catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var models = CustomerCategoryModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await CustomerCategoryDatabase.dao.deleteById(model.id!);
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
