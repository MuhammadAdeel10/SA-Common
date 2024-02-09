import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/synchronization/Database/currency_database.dart';
import 'package:sa_common/synchronization/Models/CurrencyModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class CurrencyController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.Currency, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var response = await BaseClient().get(baseUrl, "${ApiEndPoint.getCurrencies}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var pullData = CurrencyModel().FromJson(response.body, slug);
      CurrencyDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
}
