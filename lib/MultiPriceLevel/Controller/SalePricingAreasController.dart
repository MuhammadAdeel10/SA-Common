import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingAreasDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingAreasModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingAreasController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingAreasModel>(
      tableName: Tables.SalePricingAreas,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingAreas",
      fromJson: (json, slug) => SalePricingAreasModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingAreasDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
