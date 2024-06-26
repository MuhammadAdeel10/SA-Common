import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../Database/account_database.dart';
import '../Models/AccountModel.dart';

class AccountController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.accounts, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;

    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await this.baseClient.get(baseUrl, "$slug/${branchId}${ApiEndPoint.getAccountsAccordingAssociation}currencyId=${Helper.requestContext.currencyId}&includeHomeCurrency=false&isActive=true").catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var pullData = AccountModel().FromJson(response.body, slug);
      AccountDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> Delete(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.accounts, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var getAll = await AccountDatabase.dao.getAll();

    var response = await BaseClient().get(baseUrl, "${slug}/${branchId}${ApiEndPoint.deleteAccounts}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var models = AccountModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await AccountDatabase.dao.deleteById(model.id!);
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
