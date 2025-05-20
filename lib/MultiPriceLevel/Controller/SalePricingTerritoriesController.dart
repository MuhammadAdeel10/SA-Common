import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingTerritoriesDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingRegionsModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingTerritoriesModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingTerritoriesController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingTerritoriesModel>(
      tableName: Tables.SalePricingTerritories,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingTerritories",
      fromJson: (json, slug) => SalePricingRegionsModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingTerritoriesDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
