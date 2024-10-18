import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/synchronization/Database/warehouse_database.dart';
import 'package:sa_common/synchronization/Models/WarehouseModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class WarehouseController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.WareHouse, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var response = await BaseClient().get(baseUrl, "${slug}/${ApiEndPoint.getWarehouses}").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var pullData = Warehouse().FromJson(response.body, slug);
      WarehouseDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
}
