import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingBranchesDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingBranchesModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingBranchesController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingBranchesModel>(
      tableName: Tables.SalePricingBranches,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingBranches",
      fromJson: (json, slug) => SalePricingBranchesModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingBranchesDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
