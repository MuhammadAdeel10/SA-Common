import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import '../../Controller/BaseController.dart';
import '../../HttpService/Basehttp.dart';
import '../../SyncSetting/Database.dart';
import '../../company/Models/CompanySettingModel.dart';
import '../../login/UserModel.dart';
import '../../synchronization/Database/currency_database.dart';
import '../../synchronization/Database/customer_database.dart';
import '../../utils/ApiEndPoint.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/Enums.dart';
import '../../utils/Helper.dart';
import '../../utils/Logger.dart';
import '../../utils/TablesName.dart';
import '../Database/productSalesTax_database.dart';
import '../Database/product_database.dart';
import '../Database/schemes_database.dart';
import '../Database/subArea_database.dart';
import '../Database/tax_database.dart';
import '../models/POSInvoiceDetailTaxModel.dart';
import '../models/POSInvoiceDiscountModel.dart';
import '../models/SPModels/SchemeInvoiceBonusItemModel.dart';
import '../models/SPModels/SchemeInvoiceBonusParamsModel.dart';
import '../models/SPModels/SchemeInvoiceDiscountItemModel.dart';
import '../models/SPModels/SchemeInvoiceDiscountParamsModel.dart';
import '../models/SPModels/SchemeItemModel.dart';
import '../models/SPModels/SchemeProductBonusItemModel.dart';
import '../models/SPModels/SchemeProductBonusParamsModel.dart';
import '../models/SPModels/SchemeProductCategoryBonusParamsModel.dart';
import '../models/SPModels/SchemeProductCategoryDiscountItemModel.dart';
import '../models/SPModels/SchemeProductCategoryDiscountParamsModel.dart';
import '../models/SPModels/schemeParamModel.dart';
import '../models/SchemeInvoiceDiscountDtoModel.dart';
import '../models/posInvoiceModel.dart';
import '../models/schemeGetModel.dart';
import 'package:collection/collection.dart';

import '../models/schemePosInvoiceDetailModel.dart';
import '../models/tax_model.dart';

class SchemesController extends BaseController {
  Future<void> Pull(String baseUrl, String slug, int branchId, {int page = 1}) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.Schemes, slug: slug, branchId: branchId, isBranch: true);
    DateTime syncDate = DateTime.now().toUtc();
    var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);
    var response = await BaseClient()
        .get(
      baseUrl,
      "$slug/$branchId${ApiEndPoint.schemes}"
      "${syncDateString}"
      "?page=${page}&pageSize=5000",
    )
        .catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var decode = json.decode(response.body);
      //as List<Map<String, dynamic>>;
      if (decode.length > 0) {
        var currentPage = decode['page'];
        var totalPages = decode['pages'];
        var schemes = decode['results'];
        var pullData = List<SchemeGetModel>.from(schemes.map((x) => SchemeGetModel.fromMap(x, slug: slug)));

        await SchemesDatabase.bulkWithMasterDetailInsert(pullData);
        if (currentPage <= totalPages) {
          print("Pages" + "$currentPage");
          await Pull(baseUrl, slug, branchId, page: currentPage + 1);
        }
      }
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<SchemePOSInvoiceModel> MapCartToInvoice(int screenType, int customerId, {List<dynamic>? cartModelList}) async {
    var user = Helper.user;

    SchemePOSInvoiceModel schemeModel = SchemePOSInvoiceModel(posInvoiceDetails: [], posInvoiceDiscounts: []);

    List<POSInvoiceDetailDiscountModel> discounts = [];
    var currencyModel = await CurrencyDatabase().GetDefaultCurrency();

    if (currencyModel != null) {
      schemeModel.currencyId = currencyModel.id;
    }

    schemeModel.customerId = customerId;
    schemeModel.companySlug = user.companyId;
    var cartModel = cartModelList;

    schemeModel.amountBeforeDiscount = cartModel?.fold(0, (num previousValue, element) => previousValue + element.qty * element.price).toDouble();

    List<POSInvoiceTaxModel> taxesAll = [];
    for (var element in cartModel!.where((element) => element.isAppliedScheme == false)) {
      var detail = SchemePOSInvoiceDetailModel();
      discounts = [];
      taxesAll = [];

      detail.id = element.id;
      detail.productId = element.productId;
      detail.grossAmount = element.grossAmount;
      detail.netAmount = element.netAmount;
      detail.price = element.price;
      detail.serialNumber = element.serialNumber;
      detail.batchId = element.batchId;
      detail.quantity = element.qty;
      if (element.cartDiscounts != null) {
        for (var cartDiscount in element.cartDiscounts!) {
          var map = cartDiscount.toMap();
          var discountDiscount = POSInvoiceDetailDiscountModel.fromMap(map, slug: user.companyId);
          discountDiscount.branchId = user.branchId;
          discounts.add(discountDiscount);
        }
      }
      detail.discounts = discounts;
      //Branch wise tax condition
      var salesTax = Helper.productSalesTaxModel.where((element) => element.productId == detail.productId);
      var allBrachTaxes = Helper.branchProductSalesTaxModel.where((element) => element.branchId == Helper.user.branchId).toList();

      var product = Helper.allProductModel.where((element) => element.id == detail.productId).toList();
      if (salesTax.any((element) => element.applicableToAllBranches == true || allBrachTaxes.any((element) => element.productId == detail.productId || product.any((p0) => p0.baseProductId == element.productId)))) {
        // if (Helper.productSalesTaxModel
        //         .any((element) => element.productId == detail.productId) &&
        //     Helper.productSalesTaxModel
        //         .any((element) => element.applicableToAllBranches == true)) {
        var productTax = Helper.productSalesTaxModel;
        var productSalesTaxes = productTax.where((element) => element.productId == detail.productId);
        for (var productSalesTax in productSalesTaxes) {
          var tax = Helper.taxModel.firstWhere((element) => element.id == productSalesTax.taxId);
          num taxAmount = (detail.netAmount ?? 0) * tax.rate / 100;
          POSInvoiceTaxModel posInvoiceTaxModel = POSInvoiceTaxModel();
          posInvoiceTaxModel.appliedOn = productSalesTax.appliedOn;
          posInvoiceTaxModel.sort = productSalesTax.sort;
          posInvoiceTaxModel.taxId = productSalesTax.taxId;
          posInvoiceTaxModel.taxRate = tax.rate;
          posInvoiceTaxModel.id = productSalesTax.id;
          posInvoiceTaxModel.posInvoiceDetailId = 0;
          posInvoiceTaxModel.taxAmount = taxAmount;
          posInvoiceTaxModel.companySlug = user.companyId;
          posInvoiceTaxModel.branchId = user.branchId;
          taxesAll.add(posInvoiceTaxModel);
        }
      }
      if (detail.taxes == null) {
        detail.taxes = [];
      }
      detail.taxes?.addAll(taxesAll);
      schemeModel.posInvoiceDetails.add(detail);
    }
    var date = Helper.OnlyDateToday();
    if (Helper.requestContext.manuallyManageEOD == true) {
      var endOfTheDay = Helper.endOfTheDayModel;
      if (endOfTheDay != null) {
        // date = endOfTheDay.endOfDayDate?.add(Duration(days: 1)) ??
        //     Helper.OnlyDateToday();
        var now = DateTime.now();
        schemeModel.time = endOfTheDay.endOfDayDate
            ?.add(Duration(
              days: 1,
              hours: now.hour,
              minutes: now.minute,
              seconds: now.second,
              milliseconds: now.millisecond,
            ))
            .toUtc();

        schemeModel.date = endOfTheDay.endOfDayDate?.add(Duration(days: 1)) ?? date;
      } else {
        schemeModel.time = DateTime.now().toUtc();
        schemeModel.date = date;
      }
    } else {
      schemeModel.time = DateTime.now().toUtc();
      schemeModel.date = date;
    }

    var scheme = await GetPosInvoiceScheme(schemeModel, user, callback: SchemeCalculateAmount);
    return scheme;
  }

  Future<SchemePOSInvoiceModel> GetPosInvoiceScheme(SchemePOSInvoiceModel model, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    try {
      var db = await DatabaseHelper.instance.database;
      CompanySettingModel companySetting = Helper.requestContext;
      // showLoading();
      // Logger.WarningLog("dateTime 1 ${DateTime.now().toIso8601String()}");
      print("GetPosInvoiceScheme Main Method Start ${DateTime.now().toIso8601String()}");
      RemovePosInvoiceScheme(model);
      model.posInvoiceDiscounts.removeWhere((x) => x.discountType == DiscountInvoiceType.Scheme);

      if (Helper.requestContext.enableScheme) {
        await GetProductDiscountScheme(model, db, companySetting, user, callback: callback);
        await GetProductBonusScheme(model, db, companySetting, user, callback: callback);

        await GetProductCategoryDiscountScheme(model, db, companySetting, user, callback: callback);
        await GetProductCategoryBonusScheme(model, db, companySetting, user, callback: callback);

        await GetInvoiceBonusScheme(model, db, companySetting, user, callback: callback);

        await GetInvoiceDiscountScheme(model, db, companySetting, user, callback: callback);
      }
      print("GetPosInvoiceScheme Main Method Start ${DateTime.now().toIso8601String()}");
      if (callback != null) {
        callback(model);
      }

      return model;
    } catch (ex) {
      Logger.ErrorLog('Scheme $ex');
      throw ex;
    }
  }

  void RemovePosInvoiceScheme(SchemePOSInvoiceModel posInvoice) {
    posInvoice.posInvoiceDetails.removeWhere((x) => x.isBonusProduct == true);
    posInvoice.posInvoiceDiscounts.removeWhere((x) => x.discountType == DiscountInvoiceType.Scheme);
    posInvoice.posInvoiceDetails.forEach((x) => x.discounts?.where((o) => o.schemeId == null));
  }

  SchemePOSInvoiceModel SchemeCalculateAmount(SchemePOSInvoiceModel model) {
    var taxDb = Helper.taxModel;
    var productDb = Helper.allProductModel;

    // var productIds = model.posInvoiceDetails.map((e) => e.productId).toList();

    // var products = ( productDb.getAll())
    //     .where((element) =>
    //         productIds != null ? productIds.contains(element.id) : false)
    //     .toList();

    for (var item in model.posInvoiceDetails) {
      item.grossAmount = item.quantity! * item.price!;
      if (item.discounts == null) {
        item.discounts = [];
      }
      for (var detailDiscount in item.discounts!) {
        switch (detailDiscount.discountType) {
          case DiscountType.Percent:
            detailDiscount.discountAmount = (item.grossAmount! * detailDiscount.discountInPercent!) / 100;
            break;
          case DiscountType.Amount:
            detailDiscount.discountAmount = detailDiscount.discountInAmount;
            break;
          case DiscountType.Price:
            detailDiscount.discountAmount = item.grossAmount! - (item.quantity! * detailDiscount.discountInPrice!);
            break;
        }
      }

      item.discountAmount = item.discounts?.fold(0, (previousValue, element) => previousValue! + element.discountAmount);
      TaxModel? tax = null;

      if (item.taxes == null) {
        item.taxes = [];
      }
      var salesTax = Helper.productSalesTaxModel.where((element) => element.productId == item.productId);
      var allBrachTaxes = Helper.branchProductSalesTaxModel.where((element) => element.branchId == Helper.user.branchId).toList();

      var product = Helper.allProductModel.where((element) => element.id == item.productId).toList();
      if (salesTax.any((element) => element.applicableToAllBranches == true || allBrachTaxes.any((element) => element.productId == item.productId || product.any((p0) => p0.baseProductId == element.productId)))) {
        for (var detailTax in item.taxes!.where((t) => t.appliedOn != SaleTaxAppliedOn.Compound)) {
          if (tax == null || tax.id != detailTax.taxId) {
            // tax = taxDb.find(detailTax.taxId!);
            tax = taxDb.firstWhere((element) => element.id == detailTax.taxId!);
            detailTax.taxId = tax.id;
          }
          var appliedOn = item.grossAmount;
          detailTax.taxRate = tax.rate;

          switch (detailTax.appliedOn) {
            case SaleTaxAppliedOn.SalePrice:
              appliedOn = item.quantity! * item.price!;
              detailTax.taxAmount = (appliedOn - item.discountAmount!) * detailTax.taxRate! / 100;
              break;
            case SaleTaxAppliedOn.PurchasePrice:
              // var product = productDb.find(item.productId!);
              var product = productDb.firstWhere((element) => element.id == item.productId);
              appliedOn = item.quantity! * product.purchasePrice;
              detailTax.taxAmount = appliedOn * detailTax.taxRate! / 100;
              break;
            case SaleTaxAppliedOn.MaximumRetailPrice:
              // var product = productDb.find(item.productId!);
              var product = productDb.firstWhere((element) => element.id == item.productId);
              appliedOn = item.quantity! * product.maximumRetailPrice;
              if (product.isMRPExclusiveTax) {
                detailTax.taxAmount = appliedOn * detailTax.taxRate! / 100;
              } else {
                detailTax.taxAmount = appliedOn - (appliedOn / ((detailTax.taxRate! / 100) + 1));
              }
              break;
            case SaleTaxAppliedOn.Compound:
              break;
            case null:
              break;
          }
        }
        var compound = (item.grossAmount! - item.discountAmount!) + item.taxes!.where((t) => t.appliedOn != SaleTaxAppliedOn.Compound).fold(0, (previousValue, element) => previousValue + (element.taxAmount ?? 0));

        for (var detailTax in item.taxes!.where((t) => t.appliedOn == SaleTaxAppliedOn.Compound)) {
          if (tax == null || tax.id != detailTax.taxId) {
            // tax = taxDb.find(detailTax.taxId!);
            tax = taxDb.firstWhere((element) => element.id == detailTax.taxId!);
          }
          detailTax.taxRate = tax.rate;
          detailTax.taxAmount = compound * detailTax.taxRate! / 100;
          compound += (detailTax.taxAmount ?? 0);
        }

        // if (salesTax.any((element) => element.applicableToAllBranches)) {
        item.taxAmount = item.taxes?.fold(0, (previousValue, element) => previousValue! + (element.taxAmount ?? 0));
        // }
      }
      num netAmount = item.grossAmount! - item.discountAmount!;

      item.netAmount = netAmount;
    }
    num totalGrossAmount = model.posInvoiceDetails.fold(0.0, (previousValue, element) => previousValue + element.grossAmount!) - model.posInvoiceDetails.fold(0, (previousValue, element) => previousValue + element.discountAmount!);
    var totalTaxAmount = model.posInvoiceDetails.fold(0.0, (previousValue, element) => previousValue + (element.taxAmount ?? 0));

    num totalDiscountAmount = 0;
    if (model.discountPercent != null && (model.discountPercent ?? 0) > 0) {
      totalDiscountAmount = (totalGrossAmount * model.discountPercent!) / 100;
    } else {
      if (model.discountAmount == null && (model.discountPercent ?? 0) > 0) totalDiscountAmount = model.discountAmount!;
    }

    num totalSchemeDiscount = model.posInvoiceDiscounts.where((w) => w.discountType == DiscountInvoiceType.Scheme).fold(0, (previousValue, element) => previousValue + element.discountAmount!);

    num totalNetAmount = (totalGrossAmount + totalTaxAmount) - (totalDiscountAmount + totalSchemeDiscount);

    model.grossAmount = totalGrossAmount;
    model.taxAmount = totalTaxAmount;
    model.discountAmount = totalDiscountAmount;
    // var roundedTotal = totalNetAmount.round();
    var roundedTotal = Helper.customRound(totalNetAmount, decimalPlaces: Helper.requestContext.decimalPlaces);
    model.autoRoundOff = roundedTotal - totalNetAmount;
    model.netAmount = roundedTotal + (model.manualRoundOff ?? 0) + (model.fbrPosFee ?? 0);
    return model;
  }

  Future<SchemePOSInvoiceModel> GetProductDiscountScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetProductDiscountScheme Start ${DateTime.now().toIso8601String()}");
    for (var posInvoiceDetail in posInvoice.posInvoiceDetails.where((e) => e.isBonusProduct == false)) {
      var qty = posInvoiceDetail.quantity?.abs();
      List<SchemeItemModel> discProductSchemeData = (await GetSchemeDiscount(posInvoiceDetail.productId!, posInvoice.currencyId!, qty!, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();
      if (posInvoiceDetail.discounts == null) {
        posInvoiceDetail.discounts = [];
      }
      // if (posInvoiceDetail.discounts!.length > 0) {
      if (posInvoiceDetail.discounts!.isNotEmpty) {
        // posInvoiceDetail.discounts!.removeWhere((element) {
        //   return element.schemeId != null;
        // });
        posInvoiceDetail.discounts!.removeWhere((discount) => discount.schemeId != null);
      }
      if (posInvoiceDetail.discountType != null) {
        posInvoiceDetail.discountType = posInvoiceDetail.discountType;
      }
      // ignore: unnecessary_null_comparison
      if (discProductSchemeData != null && discProductSchemeData.any((element) => true)) {
        posInvoice.isAppliedScheme = true;
        for (var item in discProductSchemeData) {
          // var discount = discountService.Get(item.DiscountId); // object Not Mapped
          var data = POSInvoiceDetailDiscountModel(
              discountInPercent: item.DiscountRate,
              schemeId: item.SchemeId,
              discountId: item.DiscountId ?? 0,
              discountType: item.DiscountAmount > 0 ? DiscountType.Amount : DiscountType.Percent,
              schemeDetailId: item.SchemeDetailId,
              discountInAmount: ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount,
              discountAmount: item.DiscountAmount > 0 ? ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount : ((posInvoiceDetail.grossAmount ?? 0) * (item.DiscountRate ?? 0)) / 100);
          posInvoiceDetail.discounts!.add(data);
        }
        posInvoiceDetail.discountAmount = posInvoiceDetail.discounts?.fold<num>(0, (previousValue, element) => previousValue + element.discountAmount);
        posInvoiceDetail.netAmount = posInvoiceDetail.netAmount! - posInvoiceDetail.discountAmount!;
      }
    }
    Logger.InfoLog("GetProductDiscountScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeItemModel>?> GetSchemeDiscount(int productId, int currencyId, num quantity, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeDiscount Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = SchemeParamModel(
      productId: productId,
      currencyId: currencyId,
      date: date,
      branchId: user.branchId,
      quantity: quantity,
    );
    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeDiscountSP(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeDiscount Start ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<List<SchemeItemModel>> GetSchemeDiscountSP(SchemeParamModel params, CompanySettingModel? companySetting, Database db) async {
    Logger.InfoLog("GetSchemeDiscountSP Start ${DateTime.now().toIso8601String()}");
    var dayId = params.date?.weekday;
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';
    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);
    var batch = db.batch();
    batch.execute(''' create table if not exists schemeTableProduct (
		SchemeId int,
		SchemeDetailId int,
		DiscountId int,
		DiscountRate decimal(30, 10),
		DiscountEffect int,
    DiscountAmount decimal(30, 10),
    DiscountProductQuantity decimal(30, 10));
create table if not exists ProductIds (
Id int,
BaseVariantId int,BaseProductId int);

insert into ProductIds SELECT Id, BaseProductId, BaseVariantId from Products WHERE id = ${params.productId} and companySlug = '${companySetting?.slug}';
create table if not exists DiscountProductQuantity (
SchemeId int,
DiscountId int,
DiscountProductQuantity decimal(10,30));

INSERT into DiscountProductQuantity SELECT D.SchemeId, S.DiscountId, MAX(D.DiscountProductQuantity) AS DiscountProductQuantity
	FROM SchemeDetails D
	INNER JOIN ProductIds P ON D.SchemeProductId = P.Id OR (D.SchemeProductId = P.BaseProductId AND P.BaseVariantId IS NOT NULL) 
	INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND Status = 20
	LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
	WHERE S.companySlug = '${companySetting?.slug}'
		AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND (Date(S.StartDate) <= '${date}' OR S.StartDate IS NULL)
		AND (Date(S.EndDate) >= '${date}' OR S.EndDate IS NULL)

     and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
    
		AND (D.DiscountProductQuantity <= ${params.quantity})
		AND (instr(S.WeekDays, $dayId) > 0)
		AND (S.SchemeTypeId = 20)
	  GROUP BY D.SchemeId, S.DiscountId ''');

    if (companySetting?.enableSalesGeography == true) {
      batch.execute('''Insert into schemeTableProduct
	  SELECT D.SchemeId, D.Id AS SchemeDetailId, M.DiscountId, D.ProductDiscountRate AS DiscountRate ,DiscountEffect,D.ProductDiscountAmount AS DiscountAmount, D.DiscountProductQuantity
	  FROM SchemeDetails D
		INNER JOIN ProductIds P ON D.SchemeProductId = P.Id OR (D.SchemeProductId = P.BaseProductId AND P.BaseVariantId IS NOT NULL)
		INNER JOIN DiscountProductQuantity M ON D.SchemeId = M.SchemeId AND D.DiscountProductQuantity = M.DiscountProductQuantity
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId = ${params.regionId} OR R.RegionId IS NULL)		
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)		
		AND (R.TerritoryId = ${params.territoryId} OR R.TerritoryId IS NULL)		
		AND (R.AreaId = ${params.areaId} OR R.AreaId IS NULL)		
		AND (R.SubAreaId = ${params.subAreaId} OR R.SubAreaId IS NULL) ''');
    } else {
      batch.execute('''Insert into schemeTableProduct
	SELECT D.SchemeId, D.Id AS SchemeDetailId, M.DiscountId, D.ProductDiscountRate AS DiscountRate,DiscountEffect,D.ProductDiscountAmount AS DiscountAmount, D.DiscountProductQuantity
	  FROM SchemeDetails D
		INNER JOIN ProductIds P ON D.SchemeProductId = P.Id OR (D.SchemeProductId = P.BaseProductId AND P.BaseVariantId IS NOT NULL)
		INNER JOIN DiscountProductQuantity M ON D.SchemeId = M.SchemeId AND D.DiscountProductQuantity = M.DiscountProductQuantity
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId		
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))''');
    }
    await batch.commit();
    var resSchemeTable = (await db.rawQuery('''select * from schemeTableProduct where DiscountEffect =  1 '''));

    var discountEffect = resSchemeTable.map((e) => e["DiscountEffect"]).toList();

    var response = await db.rawQuery('''select * from schemeTableProduct ''');
    List<SchemeItemModel> result = [];
    if (response.length > 0) {
      result = List.generate(response.length, (i) => SchemeItemModel.fromMap(response[i]));
    }

    if (discountEffect.length > 0) {
      await db.execute('''delete from schemeTableProduct where DiscountEffect = 0;
      ''');
    }
    db.execute('''Delete from ProductIds;
      Delete from DiscountProductQuantity;
      Delete from schemeTableProduct;''');
    Logger.InfoLog("GetSchemeDiscountSP Start ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<SchemePOSInvoiceModel> GetProductBonusScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetProductBonusScheme Start ${DateTime.now().toIso8601String()}");
    List<SchemePOSInvoiceDetailModel> posInvoiceDetailSchemes = [];
    var detailList = posInvoice.posInvoiceDetails.toList();
    for (var posInvoiceDetail in detailList.where((w) => w.isBonusProduct == false)) {
      var qty = posInvoiceDetail.quantity?.abs() ?? 0;
      List<SchemeProductBonusItemModel> bonusProductSchemeData = (await GetSchemeProductBonus(posInvoiceDetail.productId!, posInvoice.currencyId!, qty, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();

      bool isBonusProductSchemeData = bonusProductSchemeData.any((element) => true);

      if (isBonusProductSchemeData) {
        for (var item in bonusProductSchemeData) {
          posInvoiceDetailSchemes = [];
          posInvoice.isAppliedScheme = true;
          var bonusQty = ((posInvoiceDetail.quantity ?? 0) ~/ (item.ProductQuantity ?? 0)).floor() * (item.Quantity ?? 0);

          var data = new SchemePOSInvoiceDetailModel(
            discountType: DiscountType.Percent.value,
            productId: item.ProductId,
            price: item.ProductPrice ?? 0,
            quantity: bonusQty,
            isBonusProduct: true,
            taxes: [],
            discounts: [],
          );
          var productSalesTax = await ProductSalesTaxDatabase().GetByProductId(item.ProductId!);

          if (productSalesTax.isNotEmpty && productSalesTax.length > 0) {
            List<POSInvoiceTaxModel> taxes = [];
            for (var tax in productSalesTax) {
              var Tax = await TaxDatabase.dao.find(tax.taxId!);
              taxes.add(new POSInvoiceTaxModel(
                appliedOn: SaleTaxAppliedOn.values.firstWhereOrNull((element) => element.value == tax.appliedOn),
                taxId: tax.taxId,
                taxRate: Tax.rate,
              ));
            }
            data.taxes!.addAll(taxes);
          }
          posInvoiceDetailSchemes.add(data);
        }
        posInvoice.posInvoiceDetails.addAll(posInvoiceDetailSchemes);
      }
    }
    Logger.InfoLog("GetProductBonusScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeProductBonusItemModel>?> GetSchemeProductBonus(int productId, int currencyId, num quantity, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeProductBonus Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = new SchemeProductBonusParamsModel(
      productId: productId,
      currencyId: currencyId,
      date: date,
      branchId: user.branchId,
      quantity: quantity,
    );
    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeProductBonusSp(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeProductBonus End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<List<SchemeProductBonusItemModel>> GetSchemeProductBonusSp(SchemeProductBonusParamsModel params, CompanySettingModel? companySetting, Database db) async {
    Logger.InfoLog("GetSchemeProductBonusSp Start ${DateTime.now().toIso8601String()}");
    var dayId = params.date?.weekday;
    List<Map<String, Object?>> response = [];
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';
    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);
    await db.execute(''' create table if not exists ProductIdss (
          Id int,
          BaseProductId int);
  create table if not exists MaxSchemeProductQuantity (
          SchemeId int,
          DiscountId int,
          SchemeProductQuantity decimal(10,30));
  insert into ProductIdss SELECT Id, BaseProductId from Products WHERE id = ${params.productId} and companySlug = '${companySetting?.slug}';
  INSERT into MaxSchemeProductQuantity SELECT D.SchemeId, S.DiscountId, MAX(D.SchemeProductQuantity) AS SchemeProductQuantity 	
	  FROM SchemeDetails D
		INNER JOIN ProductIdss P ON D.SchemeProductId = P.Id
		INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND Status = 20
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
	  WHERE S.companySlug = '${companySetting?.slug}'
		AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND (Date(S.StartDate) <= '${date}' OR S.StartDate IS NULL)
		AND (Date(S.EndDate) >= '${date}' OR S.EndDate IS NULL)
    and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
		AND (D.SchemeProductQuantity <= ${params.quantity})
		AND (S.SchemeTypeId = 40 )
		AND (instr(S.WeekDays, $dayId) > 0)
	GROUP BY D.SchemeId, S.DiscountId
	 ''');
    if (companySetting?.enableSalesGeography == true) {
      response = await db.rawQuery(''' SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId, D.BounsProductId as ProductId, PD.Name as ProductName, D.SchemeProductQuantity AS ProductQuantity, D.SchemeBounsQuantity AS Quantity , D.BonusProductPrice as ProductPrice
	  FROM SchemeDetails D
		INNER JOIN ProductIdss P ON D.SchemeProductId = P.Id
		INNER JOIN MaxSchemeProductQuantity M ON D.SchemeId = M.SchemeId AND D.SchemeProductQuantity = M.SchemeProductQuantity
		INNER JOIN Products PD on Pd.Id = D.BounsProductId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId = ${params.regionId} OR R.RegionId IS NULL)		
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)		
		AND (R.TerritoryId = ${params.territoryId} OR R.TerritoryId IS NULL)		
		AND (R.AreaId = ${params.areaId} OR R.AreaId IS NULL)		
		AND (R.SubAreaId = ${params.subAreaId} OR R.SubAreaId IS NULL) ''');
    } else {
      response = await db.rawQuery('''SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId, D.BounsProductId as ProductId, PD.Name as ProductName, D.SchemeProductQuantity AS ProductQuantity, D.SchemeBounsQuantity AS Quantity , D.BonusProductPrice as ProductPrice
	  FROM SchemeDetails D
		INNER JOIN ProductIdss P ON D.SchemeProductId = P.Id
		INNER JOIN MaxSchemeProductQuantity M ON D.SchemeId = M.SchemeId AND D.SchemeProductQuantity = M.SchemeProductQuantity
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		INNER JOIN Products PD on Pd.Id = D.BounsProductId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))''');
    }
    await db.execute('''Delete from ProductIdss;
                  Delete from MaxSchemeProductQuantity ''');
    Logger.InfoLog("GetSchemeProductBonusSp End ${DateTime.now().toIso8601String()}");
    return List.generate(response.length, (i) => SchemeProductBonusItemModel.fromMap(response[i]));
  }

  Future<SchemePOSInvoiceModel> GetProductCategoryDiscountScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetProductCategoryDiscountScheme Start ${DateTime.now().toIso8601String()}");
    for (var detail in posInvoice.posInvoiceDetails) {
      var product = await ProductDatabase.dao.find(detail.productId!);
      detail.product = product;
    }
    //This function copied by chatGPT
    var groupedInvoiceProductCategories = groupBy(posInvoice.posInvoiceDetails.where((w) => (w.quantity ?? 0) > 0 && w.isBonusProduct == false && w.product?.productCategoryId != null), (x) => x.product?.productCategoryId)
        .entries
        .map((entry) => {
              'productCategoryId': entry.key,
              'quantity': entry.value.map((q) => q.quantity).reduce((a, b) => (a ?? 0) + (b ?? 0)),
            })
        .toList();

    for (var group in groupedInvoiceProductCategories) {
      var productCategoryId = group["productCategoryId"]?.toInt();
      var quantity = group["quantity"];
      List<SchemeProductCategoryDiscountItemModel> schemeData = (await GetSchemeProductCategoryDiscount(productCategoryId!, posInvoice.currencyId!, quantity, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();
      for (var posInvoiceDetail in posInvoice.posInvoiceDetails.where((w) => w.isBonusProduct == false && w.product?.productCategoryId != null)) {
        if (productCategoryId == posInvoiceDetail.product?.productCategoryId) {
          if (posInvoiceDetail.discounts == null) {
            posInvoiceDetail.discounts = [];
          }
          if (schemeData.isNotEmpty) {
            posInvoice.isAppliedScheme = true;
            for (var item in schemeData) {
              var data = POSInvoiceDetailDiscountModel(
                  discountInPercent: item.DiscountRate,
                  discountType: item.DiscountAmount > 0 ? DiscountType.Amount : DiscountType.Percent,
                  schemeId: item.SchemeId,
                  discountId: item.DiscountId ?? 0,
                  schemeDetailId: item.SchemeDetailId,
                  discountInAmount: ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount,
                  discountAmount: item.DiscountAmount > 0 ? ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount : ((posInvoiceDetail.grossAmount ?? 0) * (item.DiscountRate ?? 0)) / 100

                  // discount = discount,
                  );
              posInvoiceDetail.discountInPercent = item.DiscountRate;
              posInvoiceDetail.discounts?.add(data);
            }
            posInvoiceDetail.discountAmount = posInvoiceDetail.discounts?.map((s) => s.discountAmount).fold(0, (previousValue, currentValue) => (previousValue ?? 0) + currentValue);
            posInvoiceDetail.netAmount = posInvoiceDetail.netAmount! - posInvoiceDetail.discountAmount!;
          }
          posInvoiceDetail.product = await ProductDatabase.dao.find(posInvoiceDetail.productId!);
        }
      }
    }
    // var groupedReturnProductCategories = groupBy(
    //         posInvoice.posInvoiceDetails.where((w) =>
    //             (w.quantity ?? 0) > 0 &&
    //             w.isBonusProduct == false &&
    //             w.product?.productCategoryId != null),
    //         (x) => x.product?.productCategoryId)
    //     .entries
    //     .map((entry) => {
    //           'productCategoryId': entry.key,
    //           'quantity': entry.value
    //               .map((q) => q.quantity)
    //               .reduce((a, b) => (a ?? 0) + (b ?? 0)),
    //         })
    //     .toList();
    var groupedReturnProductCategories = groupBy(posInvoice.posInvoiceDetails.where((w) => (w.quantity?.abs() ?? 0) > 0 && w.isBonusProduct == false && w.product?.productCategoryId != null), (x) => x.product?.productCategoryId)
        .entries
        .map((entry) => {
              'productCategoryId': entry.key,
              'quantity': entry.value.map((q) => q.quantity).reduce((a, b) => (a ?? 0) + (b ?? 0)),
            })
        .toList();

    for (var group in groupedReturnProductCategories) {
      var productCategoryId = group["productCategoryId"]?.toInt();
      var quantity = group["quantity"]?.abs();
      List<SchemeProductCategoryDiscountItemModel> schemeData = (await GetSchemeProductCategoryDiscount(productCategoryId!, posInvoice.currencyId!, quantity, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();
      for (var posInvoiceDetail in posInvoice.posInvoiceDetails.where((w) => w.isBonusProduct == false && (w.quantity ?? 0) < 0 && w.product?.productCategoryId != null)) {
        if (productCategoryId == posInvoiceDetail.product?.productCategoryId) {
          if (posInvoiceDetail.discounts == null) {
            posInvoiceDetail.discounts = [];
          }
          if (schemeData.isNotEmpty) {
            posInvoice.isAppliedScheme = true;
            for (var item in schemeData) {
              var data = POSInvoiceDetailDiscountModel(
                  discountInPercent: item.DiscountRate,
                  discountInAmount: ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount,
                  discountType: item.DiscountAmount > 0 ? DiscountType.Amount : DiscountType.Percent,
                  schemeId: item.SchemeId,
                  discountId: item.DiscountId ?? 0,
                  schemeDetailId: item.SchemeDetailId,
                  discountAmount: item.DiscountAmount > 0 ? ((posInvoiceDetail.quantity ?? 0) ~/ item.DiscountProductQuantity) * item.DiscountAmount : ((posInvoiceDetail.grossAmount ?? 0) * (item.DiscountRate ?? 0)) / 100

                  // discount = discount,
                  );
              posInvoiceDetail.discountInPercent = item.DiscountRate;
              posInvoiceDetail.discounts?.add(data);
            }

            posInvoiceDetail.discountAmount = posInvoiceDetail.discounts?.map((s) => s.discountAmount).fold<num>(0, (previousValue, currentValue) => previousValue + currentValue);
            posInvoiceDetail.netAmount = posInvoiceDetail.netAmount! - posInvoiceDetail.discountAmount!;
          }
          posInvoiceDetail.product = await ProductDatabase.dao.find(posInvoiceDetail.productId!);
        }
      }
    }
    Logger.InfoLog("GetProductCategoryDiscountScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeProductCategoryDiscountItemModel>?> GetSchemeProductCategoryDiscount(int productCategoryId, int currencyId, num? quantity, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeProductCategoryDiscount Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = new SchemeProductCategoryDiscountParamsModel(
      productCategoryId: productCategoryId,
      currencyId: currencyId,
      date: date,
      branchId: user.branchId,
      quantity: quantity,
    );
    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeProductCategoryDiscountSP(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeProductCategoryDiscount End ${DateTime.now().toIso8601String()}");
    if (result != null) {
      return result;
    }
    return null;
  }

  Future<List<SchemeProductCategoryDiscountItemModel>?> GetSchemeProductCategoryDiscountSP(SchemeProductCategoryDiscountParamsModel params, CompanySettingModel? companySetting, Database db) async {
    Logger.InfoLog("GetSchemeProductCategoryDiscountSP Start ${DateTime.now().toIso8601String()}");
    var now = DateTime.now();
    var dayId = now.weekday;
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';
    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);
    var batch = db.batch();
    batch.execute('''create table if not exists SchemeTableProductCategory (
		SchemeId int,
		SchemeDetailId int,
		DiscountId int,
		DiscountRate decimal(30, 10),
		DiscountEffect int,
		ProductCategoryId int,
    DiscountAmount decimal(30, 10),
    DiscountProductQuantity decimal(30, 10)
    );
    
    create table if not exists MaxDiscountProductQuantity (
		SchemeId int,
		SchemeProductCategoryId int,
		DiscountId int,
		DiscountProductQuantity decimal(30, 10));

insert into MaxDiscountProductQuantity SELECT D.SchemeId, D.SchemeProductCategoryId AS ProductCategoryId, S.DiscountId, MAX(D.DiscountProductQuantity) AS DiscountProductQuantity 
	FROM SchemeDetails D
		INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND Status = 20 --(Approved status)
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
	WHERE D.SchemeProductCategoryId = ${params.productCategoryId}
		AND S.companySlug = '${companySetting?.slug}'
		AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND (Date(S.StartDate) <= '${date}' OR S.StartDate IS NULL)
		AND (Date(S.EndDate) >= '${date}' OR S.EndDate IS NULL)
    and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
		AND (D.DiscountProductQuantity <= ${params.quantity})
		AND (instr(S.WeekDays, $dayId) > 0)
		AND (S.SchemeTypeId = 50)
	GROUP BY D.SchemeId,  D.SchemeProductCategoryId, S.DiscountId
    ''');
    if (companySetting?.enableSalesGeography == true) {
      batch.execute('''Insert into SchemeTableProductCategory
	SELECT D.SchemeId, D.Id AS SchemeDetailId, M.DiscountId, D.ProductDiscountRate AS DiscountRate ,DiscountEffect, M.SchemeProductCategoryId,D.ProductDiscountAmount AS DiscountAmount, D.DiscountProductQuantity 
	FROM SchemeDetails D
		INNER JOIN MaxDiscountProductQuantity M ON D.SchemeId = M.SchemeId AND D.SchemeProductCategoryId = M.SchemeProductCategoryId AND D.DiscountProductQuantity = M.DiscountProductQuantity
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ((CG.CustomerCategoryId =  ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId =  ${params.regionId} OR R.RegionId IS NULL)		
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)		
		AND (R.TerritoryId =  ${params.territoryId} OR R.TerritoryId IS NULL)		
		AND (R.AreaId =  ${params.areaId} OR R.AreaId IS NULL)		
		AND (R.SubAreaId =  ${params.subAreaId} OR R.SubAreaId IS NULL)''');
    } else {
      batch.execute('''Insert into SchemeTableProductCategory
	SELECT D.SchemeId, D.Id AS SchemeDetailId, M.DiscountId, D.ProductDiscountRate AS DiscountRate,DiscountEffect, M.SchemeProductCategoryId,D.ProductDiscountAmount AS DiscountAmount, D.DiscountProductQuantity 
	FROM SchemeDetails D
		INNER JOIN MaxDiscountProductQuantity M ON D.SchemeId = M.SchemeId AND D.SchemeProductCategoryId = M.SchemeProductCategoryId AND D.DiscountProductQuantity = M.DiscountProductQuantity
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
	WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL)) ''');
    }
    await batch.commit();

    var resSchemeTable = (await db.rawQuery('''select * from SchemeTableProductCategory where DiscountEffect =  1 '''));

    var discountEffect = resSchemeTable.map((e) => e["DiscountEffect"]).toList();

    if (discountEffect.length > 0) {
      batch.execute('''delete from SchemeTableProductCategory where DiscountEffect = 0;
      
      ''');
    }
    var response = await db.rawQuery('''select * from SchemeTableProductCategory''');

    db.execute('''Delete from MaxDiscountProductQuantity;
                  Delete from SchemeTableProductCategory ''');

    var result = List.generate(response.length, (i) => SchemeProductCategoryDiscountItemModel.fromMap(response[i]));
    Logger.InfoLog("GetSchemeProductCategoryDiscountSP End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<SchemePOSInvoiceModel> GetProductCategoryBonusScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetProductCategoryBonusScheme Start ${DateTime.now().toIso8601String()}");
    for (var detail in posInvoice.posInvoiceDetails) {
      var product = await ProductDatabase.dao.find(detail.productId!);
      detail.product = product;
    }

    var groupedInvoiceProductCategories = groupBy(posInvoice.posInvoiceDetails.where((w) => w.quantity! > 0 && w.isBonusProduct == false && w.product?.productCategoryId != null), (x) => x.product?.productCategoryId)
        .entries
        .map((entry) => {
              'productCategoryId': entry.key,
              'quantity': entry.value.map((q) => q.quantity).reduce((a, b) => a! + b!),
            })
        .toList();
    for (var group in groupedInvoiceProductCategories) {
      var productCategoryId = group["productCategoryId"]?.toInt();
      var quantity = group["quantity"];
      List<SchemeProductBonusItemModel> bonusProductCategorySchemeData = (await GetSchemeProductCategoryBonus(productCategoryId!, posInvoice.currencyId!, quantity!, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();
      if (bonusProductCategorySchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        for (var item in bonusProductCategorySchemeData) {
          var bonusQty = (quantity ~/ item.ProductQuantity!) * item.Quantity!;
          var data = new SchemePOSInvoiceDetailModel(
            discountType: DiscountType.Percent.value,
            productId: item.ProductId,
            price: item.ProductPrice != null ? item.ProductPrice : 0,
            quantity: bonusQty,
            isBonusProduct: true,
            taxes: [],
            discounts: [],
          );
          data.product = await ProductDatabase.dao.find(item.ProductId!);
          var productSalesTax = await ProductSalesTaxDatabase().GetByProductId(item.ProductId!);
          data.product?.saleTaxes = productSalesTax;

          if (data.product != null && data.product!.saleTaxes!.isNotEmpty) {
            List<POSInvoiceTaxModel> taxes = [];
            for (var tax in data.product!.saleTaxes!) {
              var Tax = await TaxDatabase.dao.find(tax.taxId!);
              taxes.add(new POSInvoiceTaxModel(
                appliedOn: SaleTaxAppliedOn.values.firstWhere((element) => element.value == tax.appliedOn),
                taxId: tax.taxId,
                taxRate: Tax.rate,
              ));
            }
            data.taxes?.addAll(taxes);
          }
          posInvoice.posInvoiceDetails.add(data);
        }
      }
    }

    var groupedReturnProductCategories = groupBy(posInvoice.posInvoiceDetails.where((w) => w.quantity! < 0 && w.isBonusProduct == false && w.product?.productCategoryId != null), (x) => x.product?.productCategoryId)
        .entries
        .map((entry) => {
              'productCategoryId': entry.key,
              'quantity': entry.value.map((q) => q.quantity).reduce((a, b) => a! + b!),
            })
        .toList();
    for (var group in groupedReturnProductCategories) {
      var productCategoryId = group["productCategoryId"]?.toInt();
      var qty = group["quantity"]?.abs();
      List<SchemeProductBonusItemModel> bonusProductCategorySchemeData = (await GetSchemeProductCategoryBonus(productCategoryId!, posInvoice.currencyId!, qty!, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId))!.toList();
      if (bonusProductCategorySchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        for (var item in bonusProductCategorySchemeData) {
          var qtyAdd = group["quantity"];
          var bonusQty = ((qtyAdd ?? 0) ~/ (item.ProductQuantity ?? 0)) * item.Quantity!;
          var data = new SchemePOSInvoiceDetailModel(
            productId: item.ProductId,
            price: item.ProductPrice != null ? item.ProductPrice : 0,
            quantity: bonusQty,
            isBonusProduct: true,
            taxes: [],
            discounts: [],
          );
          data.product = await ProductDatabase.dao.find(item.ProductId!);
          var productSalesTax = await ProductSalesTaxDatabase().GetByProductId(item.ProductId!);
          data.product?.saleTaxes = productSalesTax;
          if (data.product != null && data.product!.saleTaxes!.isNotEmpty) {
            List<POSInvoiceTaxModel> taxes = [];
            for (var tax in data.product!.saleTaxes!) {
              var Tax = await TaxDatabase.dao.find(tax.taxId!);
              taxes.add(new POSInvoiceTaxModel(
                appliedOn: SaleTaxAppliedOn.values.firstWhere((element) => element.value == tax.appliedOn),
                taxId: tax.taxId,
                taxRate: Tax.rate,
              ));
            }
            data.taxes?.addAll(taxes);
          }
          posInvoice.posInvoiceDetails.add(data);
        }
      }
    }
    Logger.InfoLog("GetProductCategoryBonusScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeProductBonusItemModel>?> GetSchemeProductCategoryBonus(int productCategoryId, int currencyId, num quantity, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeProductCategoryBonus Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = new SchemeProductCategoryBonusParams();
    parameters.productCategoryId = productCategoryId;
    parameters.currencyId = currencyId;
    parameters.date = date;
    parameters.branchId = user.branchId;
    parameters.quantity = quantity;
    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeProductCategoryBonusSp(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeProductCategoryBonus End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<List<SchemeProductBonusItemModel>> GetSchemeProductCategoryBonusSp(SchemeProductCategoryBonusParams params, CompanySettingModel? companySetting, Database db) async {
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';
    Logger.InfoLog("GetSchemeProductCategoryBonusSp Start ${DateTime.now().toIso8601String()}");
    var dayId = (params.date?.weekday);
    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);
    await db.execute('''
create table if not exists MaxSchemeProductQuantities (SchemeId int, SchemeProductCategoryId int, SchemeProductQuantity int);

insert into MaxSchemeProductQuantities SELECT D.SchemeId, D.SchemeProductCategoryId AS ProductCategoryId, MAX(D.SchemeProductQuantity) AS SchemeProductQuantity
	FROM SchemeDetails D
		INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND Status = 20
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
	WHERE D.SchemeProductCategoryId = ${params.productCategoryId}
		AND S.companySlug = '${companySetting?.slug}'
		AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND (Date(S.StartDate) <= '${date}' OR S.StartDate IS NULL)
		AND (Date(S.EndDate) >= '${date}' OR S.EndDate IS NULL)
      and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
		AND (D.SchemeProductQuantity <= ${params.quantity})
		AND (instr(S.WeekDays, $dayId) > 0)
		AND (s.SchemeTypeId = 60)
	GROUP BY D.SchemeId, D.SchemeProductCategoryId
''');

    List<Map<String, Object?>> response = [];
    if (companySetting?.enableSalesGeography == true) {
      response = await db.rawQuery('''SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId,
        D.BounsProductId as ProductId, PD.Name as ProductName, D.SchemeProductQuantity AS ProductQuantity,
        D.SchemeBounsQuantity AS Quantity , D.BonusProductPrice as ProductPrice
	FROM SchemeDetails D
		INNER JOIN MaxSchemeProductQuantities M ON D.SchemeId = M.SchemeId 
    AND D.SchemeProductCategoryId = M.SchemeProductCategoryId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
		Inner join Products PD on Pd.Id = D.BounsProductId
	WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId = ${params.regionId} OR R.RegionId IS NULL)
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)
		AND (R.TerritoryId = ${params.territoryId} OR R.TerritoryId IS NULL)
		AND (R.AreaId = ${params.areaId} OR R.AreaId IS NULL)
		AND (R.SubAreaId = ${params.subAreaId} OR R.SubAreaId IS NULL)''');
    } else {
      response = await db.rawQuery('''
        SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId, D.BounsProductId as ProductId, PD.Name as ProductName, D.SchemeProductQuantity AS ProductQuantity, D.SchemeBounsQuantity AS Quantity , D.BonusProductPrice as ProductPrice
	FROM SchemeDetails D
		INNER JOIN MaxSchemeProductQuantities M ON D.SchemeId = M.SchemeId 
    AND D.SchemeProductCategoryId = M.SchemeProductCategoryId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		Inner join Products PD on Pd.Id = D.BounsProductId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL)) ''');
    }
    await db.execute('''Delete from MaxSchemeProductQuantities''');
    Logger.InfoLog("GetSchemeProductCategoryBonusSp End ${DateTime.now().toIso8601String()}");
    return List.generate(response.length, (i) => SchemeProductBonusItemModel.fromMap(response[i]));
  }

  Future<SchemePOSInvoiceModel> GetInvoiceBonusScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetInvoiceBonusScheme Start ${DateTime.now().toIso8601String()}");
    try {
      var invoiceAmount = posInvoice.posInvoiceDetails.where((w) => (w.quantity ?? 0) > 0).fold<num>(0, (sum, s) => sum + ((s.grossAmount ?? 0) + (s.taxAmount ?? 0) - (s.discountAmount ?? 0)));

      var returnAmount = posInvoice.posInvoiceDetails.where((w) => w.quantity! < 0).map((s) => (s.grossAmount ?? 0) + (s.taxAmount ?? 0) - (s.discountAmount ?? 0)).fold<num>(0, (sum, value) => sum + value);

      var returnNetAmount = returnAmount.abs();
      var sign = returnAmount.sign;
      if (invoiceAmount > returnNetAmount) {
        invoiceAmount += (posInvoice.fbrPosFee ?? 0);
      } else {
        returnAmount = returnAmount + (posInvoice.fbrPosFee ?? 0);
        returnNetAmount -= (posInvoice.fbrPosFee ?? 0);
      }
      var bonusInvoiceSchemeData = (await GetSchemeInvoiceBonus(invoiceAmount, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId));
      if (bonusInvoiceSchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        for (var item in bonusInvoiceSchemeData) {
          var data = new SchemePOSInvoiceDetailModel(
            discountType: DiscountType.Percent.value,
            productId: item.ProductId,
            price: item.ProductPrice != null ? item.ProductPrice : 0,
            quantity: item.Quantity,
            grossAmount: item.Quantity! * (item.ProductPrice != null ? item.ProductPrice! : 0),
            netAmount: item.Quantity! * (item.ProductPrice != null ? item.ProductPrice! : 0),
            isBonusProduct: true,
            taxes: [],
            discounts: [],
          );
          data.product = await ProductDatabase.dao.find(item.ProductId!);
          data.product?.saleTaxes = await ProductSalesTaxDatabase().GetByProductId(item.ProductId!);
          if (data.product != null && data.product!.saleTaxes!.isNotEmpty) {
            List<POSInvoiceTaxModel> taxes = [];
            for (var tax in data.product!.saleTaxes!) {
              var Tax = await TaxDatabase.dao.find(tax.taxId!);
              taxes.add(new POSInvoiceTaxModel(
                appliedOn: SaleTaxAppliedOn.values.firstWhere((element) => element.value == tax.appliedOn),
                taxRate: Tax.rate,
                taxId: tax.taxId,
              ));
            }
            data.taxes?.addAll(taxes);
          }
          posInvoice.posInvoiceDetails.add(data);
        }
      }

      bonusInvoiceSchemeData = (await GetSchemeInvoiceBonus(returnNetAmount, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId)).toList();
      if (bonusInvoiceSchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        for (var item in bonusInvoiceSchemeData) {
          var qty = item.Quantity! * sign;
          var data = new SchemePOSInvoiceDetailModel(
            discountType: DiscountType.Percent.value,
            productId: item.ProductId,
            price: item.ProductPrice != null ? item.ProductPrice : 0,
            quantity: qty,
            grossAmount: qty * (item.ProductPrice != null ? item.ProductPrice : 0)!,
            netAmount: qty * (item.ProductPrice != null ? item.ProductPrice : 0)!,
            isBonusProduct: true,
            taxes: [],
            discounts: [],
          );
          data.product = await ProductDatabase.dao.find(item.ProductId!);
          data.product?.saleTaxes = await ProductSalesTaxDatabase().GetByProductId(item.ProductId!);
          if (data.product != null && data.product!.saleTaxes!.isNotEmpty) {
            List<POSInvoiceTaxModel> taxes = [];
            for (var tax in data.product!.saleTaxes!) {
              var Tax = await TaxDatabase.dao.find(tax.taxId!);
              taxes.add(new POSInvoiceTaxModel(
                appliedOn: SaleTaxAppliedOn.values.firstWhere((element) => element.value == tax.appliedOn),
                taxRate: Tax.rate,
                taxId: tax.taxId,
              ));
            }
            data.taxes?.addAll(taxes);
          }
          posInvoice.posInvoiceDetails.add(data);
        }
      }
    } catch (ex) {
      throw ex;
    }
    Logger.InfoLog("GetInvoiceBonusScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeInvoiceBonusItem>> GetSchemeInvoiceBonus(num amount, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeInvoiceBonus Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = new SchemeInvoiceBonusParams(
      date: date,
      branchId: user.branchId,
      amount: amount,
    );
    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeInvoiceBonusSp(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeInvoiceBonus End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<List<SchemeInvoiceBonusItem>> GetSchemeInvoiceBonusSp(SchemeInvoiceBonusParams params, CompanySettingModel? companySetting, Database db) async {
    Logger.InfoLog("GetSchemeInvoiceBonusSp Start ${DateTime.now().toIso8601String()}");
    var dayId = (params.date?.weekday);

    List<Map<String, Object?>> response = [];
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';

    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);

    await db.execute('''create table if not EXISTS  MaxInoviceDiscount (
    SchemeDetailId int,
    SchemeId int,
    DiscountId int,
    BounsAmount decimal (30,10));

insert into MaxInoviceDiscount SELECT D.Id As SchemeDetailId, D.SchemeId, S.DiscountId, MAX(D.BounsAmount) AS BounsAmount
	FROM SchemeDetails D
		INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND Status = 20
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
	WHERE (S.companySlug = '${companySetting?.slug}')
		AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
		AND ('${date}' is null OR
		 ((DATE(S.startDate) <= '${date}' OR S.StartDate IS NULL)
		AND (DATE(S.EndDate) >= '${date}' OR S.EndDate IS NULL)))
     and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
		AND (D.BounsAmount <= ${params.amount})
		AND (INSTR(S.WeekDays, '$dayId') > 0)
		AND (S.SchemeTypeId = 30)
	  GROUP BY D.Id, D.SchemeId, S.DiscountId 
  ''');
    if (companySetting?.enableSalesGeography == true) {
      response = await db.rawQuery('''SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId, D.BounsProductId as ProductId, P.Name as ProductName, D.BounsProductQuantity AS Quantity , D.BonusProductPrice as ProductPrice
	FROM SchemeDetails D
		INNER JOIN MaxInoviceDiscount M ON D.SchemeId = M.SchemeId and D.Id =  M.SchemeDetailId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
		Inner Join Products P on P.Id = D.BounsProductId
	WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId = ${params.regionId} OR R.RegionId IS NULL)		
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)		
		AND (R.TerritoryId = ${params.territoryId} OR R.TerritoryId IS NULL)		
		AND (R.AreaId = ${params.areaId} OR R.AreaId IS NULL)		
		AND (R.SubAreaId = ${params.subAreaId} OR R.SubAreaId IS NULL) ''');
    } else {
      response = await db.rawQuery(''' 
      SELECT DISTINCT D.Id AS SchemeDetailId, D.SchemeId, D.BounsProductId as ProductId, P.Name as ProductName, D.BounsProductQuantity AS Quantity, D.BonusProductPrice as ProductPrice
	  FROM SchemeDetails D
		INNER JOIN MaxInoviceDiscount M ON D.SchemeId = M.SchemeId and D.Id =  M.SchemeDetailId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		Inner Join Products P on P.Id = D.BounsProductId
	  WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL)) ''');
    }
    await db.execute('''Delete from MaxInoviceDiscount''');

    var result = List.generate(response.length, (i) => SchemeInvoiceBonusItem.fromMap(response[i]));
    Logger.InfoLog("GetSchemeInvoiceBonusSp End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<SchemePOSInvoiceModel> GetInvoiceDiscountScheme(SchemePOSInvoiceModel posInvoice, Database db, CompanySettingModel? companySetting, UserModel user, {Function(SchemePOSInvoiceModel)? callback = null}) async {
    Logger.InfoLog("GetInvoiceDiscountScheme Start ${DateTime.now().toIso8601String()}");
    num saleInvoiceDiscount = 0.0;
    num saleReturnDiscount = 0.0;
    var invoiceAmount = posInvoice.posInvoiceDetails.where((w) => w.quantity! > 0).fold<num>(0, (sum, s) => sum + ((s.grossAmount ?? 0) - (s.discountAmount ?? 0)));

    var returnAmount = posInvoice.posInvoiceDetails.where((w) => w.quantity! < 0).map((s) => (s.grossAmount ?? 0) - (s.discountAmount ?? 0)).fold<num>(0, (sum, value) => sum + value);
    if (posInvoice.discountPercent != null && posInvoice.discountPercent! > 0) {
      posInvoice.posInvoiceDiscounts.removeWhere((x) => x.discountType == DiscountInvoiceType.Normal);
      saleInvoiceDiscount = (invoiceAmount * posInvoice.discountPercent!) / 100;
      saleReturnDiscount = (returnAmount * posInvoice.discountPercent!) / 100;
    } else {
      if (posInvoice.discountAmount != null && posInvoice.discountAmount! > 0) {
        posInvoice.posInvoiceDiscounts.removeWhere((x) => x.discountType == DiscountInvoiceType.Normal);
        saleInvoiceDiscount = posInvoice.discountAmount!;
        saleReturnDiscount = posInvoice.discountAmount!;
      }
    }
    num returnNetAmount = returnAmount.abs();
    // num sign = retrunAmount.sign;
    if (invoiceAmount > 0) {
      List<SchemeInvoiceDiscountItem> discInvoiceSchemeData = (await GetSchemeInvoiceDiscount(invoiceAmount, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId)).toList();
      if (discInvoiceSchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        num discountRate = 0.0;
        num discountAmount = 0.0;
        if (saleInvoiceDiscount > 0) {
          posInvoice.posInvoiceDiscounts.add(SchemeInvoiceDiscountDto(
            discountType: DiscountInvoiceType.Normal,
            discountPercent: posInvoice.discountPercent,
            discountAmount: saleInvoiceDiscount,
            sourceId: posInvoice.id,
          ));
        }
        if (discInvoiceSchemeData.any((w) => w.DiscountEffect == DiscountEffectTypes.Overwrite)) {
          var discInvoiceScheme = discInvoiceSchemeData[0];
          discountRate = discInvoiceScheme.DiscountRate!;
          discountAmount = (invoiceAmount * discountRate) / 100;

          posInvoice.posInvoiceDiscounts.add(new SchemeInvoiceDiscountDto(
            discountType: DiscountInvoiceType.Scheme,
            discountPercent: discInvoiceScheme.DiscountRate,
            discountAmount: discountAmount,
            sourceId: posInvoice.id,
            schemeId: discInvoiceScheme.SchemeId,
            discountId: discInvoiceScheme.DiscountId,
          ));
        } else {
          posInvoice.posInvoiceDiscounts.addAll(discInvoiceSchemeData.map((discount) => SchemeInvoiceDiscountDto()
            ..discountType = DiscountInvoiceType.Scheme
            ..discountPercent = discount.DiscountRate
            ..discountAmount = (invoiceAmount * (discount.DiscountRate ?? 0)) / 100
            ..sourceId = posInvoice.id
            ..schemeId = discount.SchemeId
            ..discountId = discount.DiscountId));
        }
      }
    }
    if (returnNetAmount > 0) {
      List<SchemeInvoiceDiscountItem> discInvoiceSchemeData = (await GetSchemeInvoiceDiscount(returnNetAmount, db, companySetting, user, date: posInvoice.date, customerId: posInvoice.customerId)).toList();

      if (discInvoiceSchemeData.isNotEmpty) {
        posInvoice.isAppliedScheme = true;
        num discountRate = 0.0;
        num discountAmount = 0.0;
        if (saleReturnDiscount.abs() > 0) {
          posInvoice.posInvoiceDiscounts.add(SchemeInvoiceDiscountDto()
            ..discountType = DiscountInvoiceType.Normal
            ..discountPercent = posInvoice.discountPercent
            ..discountAmount = saleReturnDiscount
            ..sourceId = posInvoice.id);
        }
        if (discInvoiceSchemeData.any((w) => w.DiscountEffect == DiscountEffectTypes.Overwrite)) {
          var discInvoiceScheme = discInvoiceSchemeData[0];
          discountRate = discInvoiceScheme.DiscountRate!;
          discountAmount = (returnAmount * discountRate) / 100;
          posInvoice.posInvoiceDiscounts.add(SchemeInvoiceDiscountDto(
            discountType: DiscountInvoiceType.Scheme,
            discountPercent: discInvoiceScheme.DiscountRate,
            discountAmount: discountAmount,
            sourceId: posInvoice.id,
            schemeId: discInvoiceScheme.SchemeId,
            discountId: discInvoiceScheme.DiscountId,
          ));
        } else {
          posInvoice.posInvoiceDiscounts.addAll(discInvoiceSchemeData.map(
            (discount) => SchemeInvoiceDiscountDto(
              discountType: DiscountInvoiceType.Scheme,
              discountPercent: discount.DiscountRate,
              discountAmount: (returnAmount * discount.DiscountRate!) / 100,
              sourceId: posInvoice.id,
              schemeId: discount.SchemeId,
              discountId: discount.DiscountId,
            ),
          ));
        }
      }
    }
    Logger.InfoLog("GetInvoiceDiscountScheme End ${DateTime.now().toIso8601String()}");
    if (callback != null) {
      callback(posInvoice);
    }
    return posInvoice;
  }

  Future<List<SchemeInvoiceDiscountItem>> GetSchemeInvoiceDiscount(num amount, Database db, CompanySettingModel? companySetting, UserModel user, {DateTime? date = null, int? customerId = null}) async {
    Logger.InfoLog("GetSchemeInvoiceDiscount Start ${DateTime.now().toIso8601String()}");
    if (date == null) {
      date = DateTime.now().toUtc();
    }
    var parameters = new SchemeInvoiceDiscountParams(
      date: date,
      branchId: user.branchId,
      amount: amount,
    );

    if (customerId != null && customerId != 0) {
      var customer = await CustomerDatabase.dao.find(customerId);
      if (customer.subAreaId != null) {
        var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
        parameters.regionId = subArea.regionId;
        parameters.zoneId = subArea.zoneId;
        parameters.territoryId = subArea.territoryId;
        parameters.areaId = subArea.areaId;
        parameters.subAreaId = customer.subAreaId;
      }
      if (customer.customerCategoryId != null) parameters.customerCategoryId = customer.customerCategoryId;
      parameters.customerId = customer.id;
    }
    var result = await this.GetSchemeInvoiceDiscountSp(parameters, companySetting, db);
    Logger.InfoLog("GetSchemeInvoiceDiscount End ${DateTime.now().toIso8601String()}");
    return result;
  }

  Future<List<SchemeInvoiceDiscountItem>> GetSchemeInvoiceDiscountSp(SchemeInvoiceDiscountParams params, CompanySettingModel? companySetting, Database db) async {
    Logger.InfoLog("GetSchemeInvoiceDiscountSp Start ${DateTime.now().toIso8601String()}");
    var dayId = (params.date?.weekday);
    var utcTime = DateTime.now().toUtc();
    String utcTimeString = '${utcTime.hour.toString().padLeft(2, '0')}:${utcTime.minute.toString().padLeft(2, '0')}:${utcTime.second.toString().padLeft(2, '0')}.${utcTime.millisecond.toString().padLeft(6, '0')}Z';

    DateTime date = DateTime(params.date!.year, params.date!.month, params.date!.day);

    await db.execute(''' CREATE TABLE IF NOT EXISTS SchemeTable (
    SchemeId INTEGER,
    SchemeDetailId INTEGER,
    InvoiceAmount DECIMAL(30, 10),
    DiscountRate DECIMAL(30, 10),
    DiscountId INTEGER,
    DiscountEffect INTEGER
);

create table if not EXISTS  MaxInoviceDiscounts (
    SchemeId int,
    SchemeDetailId int,
    DiscountId int,
    InvoiceAmount decimal (30,10));

Insert into MaxInoviceDiscounts
SELECT dtl.SchemeId, dtl.SchemeDetailId, dtl.DiscountId, dtl.InvoiceAmount
FROM (
    SELECT D.SchemeId, D.Id AS SchemeDetailId, S.DiscountId, D.InvoiceAmount,
        ROW_NUMBER() OVER(PARTITION BY D.SchemeId ORDER BY D.InvoiceAmount DESC) AS rowId
    FROM SchemeDetails D
    INNER JOIN Schemes S ON D.SchemeId = S.Id AND S.IsActive = 1 AND S.Status = 20
    LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
    WHERE S.companySlug = '${companySetting?.slug}'
        AND (B.BranchId = ${params.branchId} OR B.BranchId IS NULL)
        AND ('${date}' IS NULL OR
            (Date(S.StartDate) <= '${date}' OR S.StartDate IS NULL)
        AND (Date(S.EndDate) >= '${date}' OR S.EndDate IS NULL))
       and (
			S.IsTimeSensitiveScheme = 0
			or 
			(
				(TIME(S.startTime) <=  '$utcTimeString')
				AND 
				(TIME(S.endTime) >= '$utcTimeString')
			)
		)
        AND (D.InvoiceAmount <= ${params.amount})
        AND (instr(S.WeekDays, $dayId) > 0)
        AND (S.SchemeTypeId = 10)
) dtl
WHERE rowId = 1;
''');
    if (companySetting?.enableSalesGeography == true) {
      await db.execute(''' Insert into SchemeTable
	SELECT DISTINCT D.SchemeId, D.Id AS SchemeDetailId, D.InvoiceAmount AS InvoiceAmount,D.DiscountRate, M.DiscountId, DiscountEffect 
	FROM SchemeDetails D
		INNER JOIN MaxInoviceDiscounts M ON D.SchemeId = M.SchemeId and D.Id =  M.SchemeDetailId
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
		LEFT JOIN SchemeSalesGeography R ON D.SchemeId = R.SchemeId
	WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL))
		AND (R.RegionId = ${params.regionId} OR R.RegionId IS NULL)		
		AND (R.ZoneId = ${params.zoneId} OR R.ZoneId IS NULL)		
		AND (R.TerritoryId = ${params.territoryId} OR R.TerritoryId IS NULL)		
		AND (R.AreaId = ${params.areaId} OR R.AreaId IS NULL)		
		AND (R.SubAreaId = ${params.subAreaId} OR R.SubAreaId IS NULL) ''');
    } else {
      await db.execute(''' Insert into SchemeTable
	SELECT DISTINCT D.SchemeId, D.Id AS SchemeDetailId, D.InvoiceAmount AS InvoiceAmount, D.DiscountRate, M.DiscountId, DiscountEffect
	FROM SchemeDetails D
		INNER JOIN MaxInoviceDiscounts M ON D.SchemeId = M.SchemeId and D.Id =  M.SchemeDetailId 
		LEFT JOIN SchemeBranches B ON D.SchemeId = B.SchemeId
		LEFT JOIN SchemeCustomerCategories CG ON D.SchemeId = CG.SchemeId
	WHERE (B.BranchId = ${params.branchId} OR B.BranchId IS NULL) 
		AND ((CG.CustomerCategoryId = ${params.customerCategoryId} OR CG.CustomerCategoryId IS NULL)) ''');
    }
    var resSchemeTable = (await db.rawQuery('''select * from SchemeTable where DiscountEffect =  1 '''));

    var discountEffect = resSchemeTable.map((e) => e["DiscountEffect"]).toList();
    var response = await db.rawQuery('''select * from SchemeTable ''');
    var result = List.generate(response.length, (i) => SchemeInvoiceDiscountItem.fromMap(response[i]));

    if (discountEffect.length > 0) {
      await db.execute('''delete from SchemeTable where DiscountEffect = 0;
      ''');
    }
    await db.execute('''Delete from MaxInoviceDiscounts;
      Delete from SchemeTable;
      ''');
    Logger.InfoLog("GetSchemeInvoiceDiscountSp End ${DateTime.now().toIso8601String()}");
    return result;
  }

  void UpdateBatches(SchemePOSInvoiceModel posInvoice, List<SchemePOSInvoiceDetailModel> existingDetails) {
    var newDetails = posInvoice.posInvoiceDetails.where((x) => x.batchId == null || x.serialNumber!.isNotEmpty).toList();
    if (newDetails.isNotEmpty && existingDetails.isNotEmpty) {
      for (var item in newDetails) {
        var existingItem = existingDetails.firstWhere((w) => w.productId == item.productId);

        if (item.product!.hasBatch!) {
          item.batchId = existingItem.batchId;
        }
        if (item.product!.hasSerialNumber!) {
          item.serialNumber = existingItem.serialNumber;
        }
      }
    }
  }
}
