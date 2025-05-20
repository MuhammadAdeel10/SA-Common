import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingAreasController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingBranchesController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingCustomerCategoriesController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingCustomersController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingRegionsController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingSubAreasController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingTerritoriesController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalePricingZonesController.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalesPriceDetailController.dart';
import 'package:sa_common/MultiPriceLevel/Database/SalesPriceModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePriceParams.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceReportItem.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/DatabaseHelper.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalesPriceController extends BaseController {
  Future<void> pull(String slug, int branchId) async {
    await genericPull<SalePricingsModel>(
      tableName: Tables.SalesPrice,
      slug: slug,
      apiEndPoint: "$branchId/SalePricings/ModifiedBetween",
      fromJson: (json, slug) => SalePricingsModel().fromJson(json, slug: slug),
      bulkInsert: (data) => SalePricingDatabase.bulkInsert(data),
      branchId: branchId,
      isBranch: true,
      baseUrl: ApiEndPoint.baseUrl,
    );
  }

  Future<void> GetAll(String slug, int branchId) async {
    SalePricingAreasController salePricingAreasController = Get.put(SalePricingAreasController());
    SalePricingBranchesController salePricingBranchesController = Get.put(SalePricingBranchesController());
    SalePricingCustomerCategoriesController salePricingCustomerCategoriesController = Get.put(SalePricingCustomerCategoriesController());
    SalePricingCustomerController salePricingCustomerController = Get.put(SalePricingCustomerController());
    SalePricingRegionsController salePricingRegionsController = Get.put(SalePricingRegionsController());
    SalePricingSubAreasController salePricingSubAreasController = Get.put(SalePricingSubAreasController());
    SalePricingTerritoriesController salePricingTerritoriesController = Get.put(SalePricingTerritoriesController());
    SalePricingZonesController salePricingZonesController = Get.put(SalePricingZonesController());
    SalesPriceDetailController salesPriceDetailController = Get.put(SalesPriceDetailController());
    await this.pull(slug, branchId);
    await salePricingAreasController.pull(slug, branchId);
    await salePricingBranchesController.pull(slug, branchId);
    await salePricingCustomerCategoriesController.pull(slug, branchId);
    await salePricingCustomerController.pull(slug, branchId);
    await salePricingRegionsController.pull(slug, branchId);
    await salePricingSubAreasController.pull(slug, branchId);
    await salePricingTerritoriesController.pull(slug, branchId);
    await salePricingZonesController.pull(slug, branchId);
    await salesPriceDetailController.pull(slug, branchId);
  }

  Future<SalePriceReportItem?> getSalePrice({
    required SalePriceFilter filter,
  }) async {
    final dateStr = filter.date.toIso8601String();
    final enableGeography = filter.enableGeography;

    final queryBuffer = StringBuffer();

    queryBuffer.writeln('''
    SELECT D.SalePricingId, D.ProductId, D.Price
    FROM ${Tables.SalesPriceDetail} D
    JOIN ${Tables.SalesPrice} S 
      ON D.SalePricingId = S.Id 
      AND S.IsActive = 1 
      AND S.Status = 20
        ''');

    // Geography-based joins
    if (enableGeography) {
      queryBuffer.writeln('''
      LEFT JOIN ${Tables.SalePricingBranches} B ON D.SalePricingId = B.SalePricingId
      LEFT JOIN ${Tables.SalePricingCustomerCategories} CG ON D.SalePricingId = CG.SalePricingId
      LEFT JOIN ${Tables.SalePricingCustomer} C ON D.SalePricingId = C.SalePricingId
      LEFT JOIN ${Tables.SalePricingRegions} R ON D.SalePricingId = R.SalePricingId
      LEFT JOIN ${Tables.SalePricingZones} Z ON D.SalePricingId = Z.SalePricingId
      LEFT JOIN ${Tables.SalePricingTerritories} T ON D.SalePricingId = T.SalePricingId
      LEFT JOIN ${Tables.SalePricingAreas} A ON D.SalePricingId = A.SalePricingId
      LEFT JOIN ${Tables.SalePricingSubAreas} SA ON D.SalePricingId = SA.SalePricingId
    ''');
    } else {
      queryBuffer.writeln('''
      LEFT JOIN ${Tables.SalePricingBranches} B ON D.SalePricingId = B.SalePricingId
      LEFT JOIN ${Tables.SalePricingCustomerCategories} CG ON D.SalePricingId = CG.SalePricingId
      LEFT JOIN ${Tables.SalePricingCustomer} C ON D.SalePricingId = C.SalePricingId
    ''');
    }

    queryBuffer.writeln('''
    WHERE 
      D.CompanySlug = ?
      AND S.CurrencyId = ?
      AND D.ProductId = ?
      AND (S.StartDate <= ? OR S.StartDate IS NULL)
      AND (S.EndDate >= ? OR S.EndDate IS NULL)
      AND (B.BranchId = ? OR B.BranchId IS NULL)
      AND (CG.CustomerCategoryId = ? OR CG.CustomerCategoryId IS NULL)
      AND (C.CustomerId = ? OR C.CustomerId IS NULL)
  ''');

    if (enableGeography) {
      queryBuffer.writeln('''
      AND (R.RegionId = ? OR R.RegionId IS NULL)
      AND (Z.ZoneId = ? OR Z.ZoneId IS NULL)
      AND (T.TerritoryId = ? OR T.TerritoryId IS NULL)
      AND (A.AreaId = ? OR A.AreaId IS NULL)
      AND (SA.SubAreaId = ? OR SA.SubAreaId IS NULL)
    ''');
    }

    queryBuffer.writeln('''
    ORDER BY D.Id DESC
    LIMIT 1;
  ''');

    final params = enableGeography
        ? [
            filter.compaluSlug,
            filter.currencyId,
            filter.productId,
            dateStr,
            dateStr,
            filter.branchId,
            filter.customerCategoryId,
            filter.customerId,
            filter.regionId,
            filter.zoneId,
            filter.territoryId,
            filter.areaId,
            filter.subAreaId,
          ]
        : [
            filter.compaluSlug,
            filter.currencyId,
            filter.productId,
            dateStr,
            dateStr,
            filter.branchId,
            filter.customerCategoryId,
            filter.customerId,
          ];
    String query = queryBuffer.toString();
    final db = await DatabaseHelper.instance.database;
    final result = await db.rawQuery(query, params);

    if (result.isNotEmpty) {
      return SalePriceReportItem.fromMap(result.first);
    }
    return null;
  }
}
