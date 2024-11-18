import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../../HttpService/Basehttp.dart';
import '../../SyncSetting/Database.dart';
import '../../utils/ApiEndPoint.dart';
import '../../utils/Helper.dart';
import '../database/salesPerson_database.dart';
import '../model/SalesPersonModel.dart';

class SalesPersonController extends BaseController {
  RxBool isDropDownOpen = false.obs;
  RxBool isCollapse = true.obs;
  Future<void> Pull(String slug, String baseUrl) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.SalesPerson, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(baseUrl, "$slug${ApiEndPoint.getSalesPersons}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var pullData = SalesPersonModel().FromJson(response.body, slug);
      await SalesPersonDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> Delete(String slug, String baseUrl) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.SalesPerson, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var getAll = await SalesPersonDatabase.dao.getAll();

    var response = await BaseClient().get(baseUrl, "${slug}${ApiEndPoint.deleteSalesPersons}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var models = SalesPersonModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await SalesPersonDatabase.dao.deleteById(model.id!);
          }
        }
        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    }
  }

  Future<List<SalesPersonModel>> GetFilterSalesPerson(String? filter) async {
    var model = await SalesPersonDatabase().GetFilterSalesPerson(filter);
    return model;
  }
}
