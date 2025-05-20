import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingSubAreasDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingSubAreasModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingSubAreasController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingSubAreasModel>(
      tableName: Tables.SalePricingSubAreas,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingSubAreas",
      fromJson: (json, slug) => SalePricingSubAreasModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingSubAreaDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
