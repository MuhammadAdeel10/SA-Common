import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalesPriceDetailDatabasel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceDetailModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalesPriceDetailController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingDetailsModel>(
      tableName: Tables.SalesPriceDetail,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingDetails",
      fromJson: (json, slug) => SalePricingDetailsModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingDetailsDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
