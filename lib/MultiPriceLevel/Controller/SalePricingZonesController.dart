import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingZonesDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingZonesModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingZonesController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingZonesModel>(
      tableName: Tables.SalePricingTerritories,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingZones",
      fromJson: (json, slug) => SalePricingZonesModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingZoneDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
