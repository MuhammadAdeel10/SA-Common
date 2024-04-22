import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/synchronization/Models/MasterGroupModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../../utils/Helper.dart';
import '../Database/masterGroup_database.dart';

class MasterGroupController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.MasterGroup, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(baseUrl, "$slug${ApiEndPoint.getMasterGroups}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var pullData = MasterGroupModel().FromJson(response.body, slug);
      MasterGroupDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> Delete(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.MasterGroup, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getAll = await MasterGroupDatabase.dao.getAll();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(baseUrl, "${slug}${ApiEndPoint.deleteMasterGroups}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var models = MasterGroupModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await MasterGroupDatabase.dao.deleteById(model.id!);
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
