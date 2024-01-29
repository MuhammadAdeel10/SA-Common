import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';
import '../Database/detailAGroup_database.dart';
import '../Database/detailBGroup_database.dart';
import '../Models/DetailBGroupModel.dart';

class DetailBGroupController extends BaseController {
  Future<void> Pull(String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
        Tables.DetailBGroup,
        slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted =
        Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient()
        .get("$slug${ApiEndPoint.getDetailBGroups}${formatted}")
        .catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var pullData = DetailBGroupModel().FromJson(response.body, slug);
      DetailBGroupDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> Delete(String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
        Tables.DetailBGroup,
        slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getAll = await DetailAGroupDatabase.dao.getAll();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted =
        Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient()
        .get("${slug}${ApiEndPoint.deleteDetailBGroups}${formatted}")
        .catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var models = DetailBGroupModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await DetailBGroupDatabase.dao.deleteById(model.id!);
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
