import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/synchronization/Database/country_database.dart';
import 'package:sa_common/synchronization/Models/CountryModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class CountryController extends BaseController {
  Future<void> Pull(String slug, int branchId) async {
    var getSyncSetting =
        await SyncSettingDatabase.GetByTableName(Tables.Country, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var response =
        await BaseClient().get("${ApiEndPoint.getCountries}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var pullData = CountryModel().FromJson(response.body, slug);
      CountryDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
}
