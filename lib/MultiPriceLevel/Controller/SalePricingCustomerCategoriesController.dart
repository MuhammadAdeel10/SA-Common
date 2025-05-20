import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingCustomerCategoriesDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomerCategoriesModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingCustomerCategoriesController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingCustomerCategoriesModel>(
      tableName: Tables.SalePricingCustomerCategories,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingCustomerCategories",
      fromJson: (json, slug) => SalePricingCustomerCategoriesModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingCustomerCategoriesDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
