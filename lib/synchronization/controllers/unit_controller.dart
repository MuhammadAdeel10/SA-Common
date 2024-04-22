import '../../Controller/BaseController.dart';
import '../../HttpService/Basehttp.dart';
import '../../SyncSetting/Database.dart';
import '../../utils/ApiEndPoint.dart';
import '../../utils/TablesName.dart';
import '../database/Unit_database.dart';
import '../models/unit_model.dart';

class UnitController extends BaseController {
  Future<void> GetAllUnits(String baseUrl, String slug, int branchId) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.units, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();
    var getUnits = await UnitDatabase.dao.getAll();

    var response = await BaseClient().get(baseUrl, "${slug}/${branchId}${ApiEndPoint.getUnit}?isActive=true").catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var units = UnitModel().FromJson(response.body);

      for (var unit in units) {
        var exist = getUnits.any((element) => element.id == unit.id);

        if (exist) {
          await UnitDatabase.dao.update(unit);
        } else {
          await UnitDatabase.dao.insert(unit);
        }
      }
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
}
