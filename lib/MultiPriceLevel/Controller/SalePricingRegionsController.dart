import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingRegionsDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingRegionsModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingRegionsController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingRegionsModel>(
      tableName: Tables.SalePricingRegions,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingRegions",
      fromJson: (json, slug) => SalePricingRegionsModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingRegionDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
