import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/schemes/Database/tax_database.dart';
import 'package:sa_common/schemes/models/tax_model.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../../SyncSetting/Database.dart';

class TaxController extends BaseController {
  Future<void> GetAllTax(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.Tax, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();

    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());

    var response = await BaseClient().get(baseUrl, "${slug}${ApiEndPoint.getTaxes} ${formatted}} ").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var pullData = TaxModel().FromJson(response.body, slug);
      TaxDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
  //
}
