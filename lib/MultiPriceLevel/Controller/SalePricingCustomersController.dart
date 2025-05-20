import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalePricingCustomersDatabase.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomersModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingCustomerController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingCustomersModel>(
      tableName: Tables.SalePricingCustomer,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetweenSalePricingCustomers",
      fromJson: (json, slug) => SalePricingCustomersModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingCustomerDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }
}
