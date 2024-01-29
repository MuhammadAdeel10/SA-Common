import 'dart:async';
import 'package:path/path.dart';
import 'package:sa_common/SyncSetting/model.dart';
import 'package:sa_common/company/Models/CompanySettingModel.dart';
import 'package:sa_common/login/UserModel.dart';
import 'package:sa_common/schemes/models/POSInvoiceDetailTaxModel.dart';
import 'package:sa_common/schemes/models/POSInvoiceDiscountModel.dart';
import 'package:sa_common/schemes/models/ProductSalesTaxModel.dart';
import 'package:sa_common/schemes/models/SubAreasModel.dart';
import 'package:sa_common/schemes/models/ZonesModel.dart';
import 'package:sa_common/schemes/models/areasModel.dart';
import 'package:sa_common/schemes/models/cart_discount_model.dart';
import 'package:sa_common/schemes/models/cart_model.dart';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/schemes/models/posPaymentDetailModel.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/schemes/models/schemeCustomerCategoriesModel.dart';
import 'package:sa_common/schemes/models/schemeDetailsModel.dart';
import 'package:sa_common/schemes/models/schemeSalesGeographyModel.dart';
import 'package:sa_common/schemes/models/schemesModel.dart';
import 'package:sa_common/schemes/models/tax_model.dart';
import 'package:sa_common/synchronization/Models/AccountModel.dart';
import 'package:sa_common/synchronization/Models/CountryModel.dart';
import 'package:sa_common/synchronization/Models/CurrencyModel.dart';
import 'package:sa_common/synchronization/Models/CustomerCategoryModel.dart';
import 'package:sa_common/synchronization/Models/CustomerModel.dart';
import 'package:sa_common/synchronization/Models/DetailAGroupModel.dart';
import 'package:sa_common/synchronization/Models/DetailBGroupModel.dart';
import 'package:sa_common/synchronization/Models/MasterGroupModel.dart';
import 'package:sa_common/synchronization/Models/NumberSerialsModel.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';

import '../schemes/models/regionsModel.dart';
import '../schemes/models/schemeBranchesModel.dart';
import '../schemes/models/territoriesModel.dart';

class DatabaseHelper {
  String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
  String idTypeNoAutoIncrement = 'INTEGER PRIMARY KEY Not Null';
  String idGuidType = 'Guid PRIMARY KEY Not Null';
  String guidType = 'Guid Null';
  String textType = 'TEXT Null';
  String textTypeNotNull = 'TEXT Not Null';
  // String boolType = 'BOOLEAN Default false';
  String boolType = 'BOOLEAN NOT NULL DEFAULT 0 ';
  String integerType = 'INTEGER Null';
  String integerTypeNotNull = 'INTEGER Not Null';
  String dateTimeType = 'Datetime';
  String decimalType = 'DECIMAL(30, 10)';
  int version = 1;

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('POS.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    try {
      Logger.InfoLog("_initDB $filePath");
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);

      return await openDatabase(path, version: version, onCreate: createDB, onUpgrade: onUpgrade);
    } catch (ex) {
      Logger.ErrorLog("_initDB Exception $ex");
      throw ex;
    }
  }

  Future<void> createDB(Database db, int version) async {
    await db.execute('''
  CREATE TABLE ${Tables.user} ( 
  ${UserFields.id} $idType, 
  ${UserFields.email} $textType,
  ${UserFields.password} $textType,
  ${UserFields.expiry} $textType,
  ${UserFields.companyId} $textType,
  ${UserFields.branchId} $integerType,
  ${UserFields.branchPrefix} $textType,
  ${UserFields.phoneNumber} $textType,
  ${UserFields.fullName} $textType,
  ${UserFields.imageUrl} $textType,
  ${UserFields.isActive} $boolType CHECK(${UserFields.isActive} IN (0,1)),
  ${UserFields.isPrivacyMode} $boolType CHECK(${UserFields.isPrivacyMode} IN (0,1)),
  ${UserFields.userId} $guidType)''');

    await db.execute('''
    CREATE TABLE ${Tables.syncSetting} (
    ${SyncSettingFields.id} $idType,
    ${SyncSettingFields.tableName} $textTypeNotNull,
    ${SyncSettingFields.SyncDate} $dateTimeType,
    ${SyncSettingFields.branchId} $integerType,
    ${SyncSettingFields.companySlug} $textType,
    ${SyncSettingFields.IsSync} $boolType CHECK(${SyncSettingFields.IsSync} IN (0,1))
    )''');

    // await db.execute('''
    // CREATE TABLE ${Tables.productsCategories} (
    // ${ProductCategoryFields.id} $idTypeNoAutoIncrement,
    // ${ProductCategoryFields.name} $textType,
    // ${ProductCategoryFields.imageUrl} $textType,
    // ${ProductCategoryFields.companySlug} $textTypeNotNull,
    // ${ProductCategoryFields.isActive} $boolType CHECK(${ProductCategoryFields.isActive} IN (0,1)),
    // ${ProductCategoryFields.updatedOn} $dateTimeType,
    // ${ProductCategoryFields.parentCategoryId} int null references ${Tables.productsCategories}
    // (${ProductCategoryFields.id}))''');

    // await db.execute('''
    // CREATE TABLE ${Tables.units} (
    // ${UnitFields.id} $idTypeNoAutoIncrement,
    // ${UnitFields.name} $textTypeNotNull,
    // ${UnitFields.measure} $integerType,
    // ${UnitFields.symbol} $textType,
    // ${UnitFields.active} $boolType CHECK(${UnitFields.active} IN (0,1))
    // )''');

    await db.execute('''
    CREATE TABLE ${Tables.Tax} (
    ${TaxFields.id} $idTypeNoAutoIncrement,
    ${TaxFields.name} $textTypeNotNull,
    ${TaxFields.companySlug} $textTypeNotNull,
    ${TaxFields.abbreviation} $textTypeNotNull,
    ${TaxFields.rate} $decimalType,
    [${TaxFields.$in}] $boolType CHECK([${TaxFields.$in}] IN (0,1)),
    ${TaxFields.accountInId} $integerType,
    ${TaxFields.out} $boolType CHECK(${TaxFields.out} IN (0,1)),
    ${TaxFields.accountOutId} $integerType,
    ${TaxFields.updatedOn} $dateTimeType,
    ${TaxFields.isActive} $boolType CHECK(${TaxFields.isActive} IN (0,1))
    )''');

    await db.execute('''
      CREATE TABLE ${Tables.products} (
      ${ProductFields.id} $idTypeNoAutoIncrement,
      ${ProductFields.code} $textTypeNotNull,
      ${ProductFields.number} $textTypeNotNull,
      ${ProductFields.barcode} $textType,
      ${ProductFields.sku} $textType,
      ${ProductFields.name} $textTypeNotNull,
      ${ProductFields.description} $textType,
      ${ProductFields.shortName} $textType,
      ${ProductFields.productCategoryId} $integerType,
      ${ProductFields.brandName} $textType,
      ${ProductFields.symbol} $textType,
      ${ProductFields.purchasePrice} $decimalType,
      ${ProductFields.maximumRetailPrice} $decimalType,
      ${ProductFields.baseProductId} $integerType,
      ${ProductFields.basePackingId} $integerType,
      ${ProductFields.baseVariantId} $integerType,
      ${ProductFields.productType} $integerType,
      ${ProductFields.precision} $integerType,
      ${ProductFields.unitId} $integerType,
      ${ProductFields.salePrice} $decimalType,
      ${ProductFields.imageUrl} $textType,
      ${ProductFields.syncDate} $dateTimeType,
      ${ProductFields.companySlug} $textTypeNotNull,
      ${ProductFields.isActive} $boolType CHECK(${ProductFields.isActive} IN (0,1)),
      ${ProductFields.hasBatch} $boolType CHECK(${ProductFields.hasBatch} IN (0,1)),
      ${ProductFields.hasSerialNumber} $boolType CHECK(${ProductFields.hasSerialNumber} IN (0,1)),
      ${ProductFields.isSync} $boolType CHECK(${ProductFields.isSync} IN (0,1)),
      ${ProductFields.fractionalUnit} $boolType CHECK(${ProductFields.fractionalUnit} IN (0,1)),
      ${ProductFields.isMRPExclusiveTax} $boolType CHECK(${ProductFields.isMRPExclusiveTax} IN (0,1)),
      ${ProductFields.isOpening} $boolType CHECK(${ProductFields.isOpening} IN (0,1)),
      FOREIGN KEY (${ProductFields.productCategoryId}) REFERENCES ${Tables.productsCategories} (id),
      FOREIGN KEY (${ProductFields.unitId}) REFERENCES ${Tables.units} (id)
      )''');
    await db.execute('''
  CREATE TABLE ${Tables.Country} (
  ${CountryField.id} $idTypeNoAutoIncrement, 
  ${CountryField.name} $textTypeNotNull,
  ${CountryField.isDefault} $boolType CHECK(${CountryField.isDefault} IN (0,1)),
  ${CountryField.currencyId} $integerType,
  ${CountryField.isSync} $boolType CHECK(${CountryField.isSync} IN (0,1)),
  ${CountryField.syncDate} $dateTimeType)''');

    await db.execute('''
  CREATE TABLE ${Tables.Currency} (
  ${CurrencyField.id} $idTypeNoAutoIncrement, 
  ${CurrencyField.name} $textTypeNotNull,
  ${CurrencyField.isDefault} $boolType CHECK(${CurrencyField.isDefault} IN (0,1)),
  ${CurrencyField.code} $textType,
  ${CurrencyField.symbol} $textType,
  ${CurrencyField.companySlug} $textTypeNotNull)''');

    await db.execute('''
  CREATE TABLE ${Tables.CustomerCategory} (
  ${CustomerCategoryFields.id} $idTypeNoAutoIncrement, 
  ${CustomerCategoryFields.contactType} $integerType,
  ${CustomerCategoryFields.name} $textTypeNotNull,
  ${CustomerCategoryFields.companySlug} $textTypeNotNull,
  ${CustomerCategoryFields.sequenceName} $textType,
  ${CustomerCategoryFields.isSync} $boolType CHECK(${CustomerCategoryFields.isSync} IN (0,1)),
  ${CustomerCategoryFields.syncDate} $dateTimeType)''');
    //   await db.execute('''
    // CREATE TABLE ${Tables.SalesPersonSubAreas} (
    // ${SalesPersonSubAreasFields.id} $idTypeNoAutoIncrement,
    // ${SalesPersonSubAreasFields.salesPersonId} $integerType,
    // ${SalesPersonSubAreasFields.subAreaId} $integerType,
    // ${SalesPersonSubAreasFields.companySlug} $textTypeNotNull,
    // ${SalesPersonSubAreasFields.isSync} $boolType CHECK(${SalesPersonSubAreasFields.isSync} IN (0,1)),
    // ${SalesPersonSubAreasFields.syncDate} $dateTimeType)''');

    //   await db.execute('''
    // CREATE TABLE ${Tables.SubArea} (
    // ${SubAreaFields.id} $idTypeNoAutoIncrement,
    // ${SubAreaFields.name} $textTypeNotNull,
    // ${SubAreaFields.regionId} $integerType,
    // ${SubAreaFields.regionName} $textType,
    // ${SubAreaFields.territoryId} $integerType,
    // ${SubAreaFields.zoneId} $integerType,
    //  ${SubAreaFields.zoneName} $textType,
    // ${SubAreaFields.territoryName} $textType,
    // ${SubAreaFields.areaId} $integerType,
    // ${SubAreaFields.areaName} $textType,
    // ${SubAreaFields.companySlug} $textTypeNotNull,
    // ${SubAreaFields.isSync} $boolType CHECK(${SubAreaFields.isSync} IN (0,1)),
    // ${SubAreaFields.syncDate} $dateTimeType)''');

    await db.execute('''
  CREATE TABLE ${Tables.Customer} (
  ${CustomerFields.id} $idTypeNoAutoIncrement, 
  ${CustomerFields.idTemp} $integerType,
  ${CustomerFields.name} $textTypeNotNull,
  ${CustomerFields.contactType} $integerType,
  ${CustomerFields.code} $textType,
  ${CustomerFields.series} $integerType,
  ${CustomerFields.categoryName} $textType,
  ${CustomerFields.address1} $textType,
  ${CustomerFields.address2} $textType,
  ${CustomerFields.city} $textType,
  ${CustomerFields.contactPerson} $textType,
  ${CustomerFields.phone} $textType,
  ${CustomerFields.fax} $textType,
  ${CustomerFields.opening} $decimalType,
  ${CustomerFields.asOfDate} $dateTimeType,
  ${CustomerFields.creditLimit} $decimalType,
  ${CustomerFields.creditLimitDays} $integerType,
  ${CustomerFields.displayName} $textType,
  ${CustomerFields.printName} $textType,
  ${CustomerFields.cNIC} $textType,
  ${CustomerFields.email} $textType,
  ${CustomerFields.state} $textType,
  ${CustomerFields.zip} $textType,
  ${CustomerFields.outstandingBalance} $decimalType,
  ${CustomerFields.dateOfBirth} $dateTimeType,
  ${CustomerFields.sTN} $textType,
  ${CustomerFields.exchangeRate} $decimalType,
  ${CustomerFields.isNew} $boolType CHECK(${CustomerFields.isNew} IN (0,1)),
  ${CustomerFields.isDeleted} $boolType CHECK(${CustomerFields.isDeleted} IN (0,1)),
  ${CustomerFields.discountInPercent} $decimalType,
  ${CustomerFields.insertedDate} $textType,
  ${CustomerFields.isActive} $boolType CHECK(${CustomerFields.isActive} IN (0,1)),
  ${CustomerFields.textField1Value} $textType,
  ${CustomerFields.textField2Value} $textType,
  ${CustomerFields.customerCategoryId} $integerType,
  ${CustomerFields.countryId} $integerType,
  ${CustomerFields.CurrencyId} $integerType,
  ${CustomerFields.subAreaId} $integerType,
  ${CustomerFields.branchId} $integerType,
  ${CustomerFields.companySlug} $textTypeNotNull,
  ${CustomerFields.isSync} $boolType CHECK(${CustomerFields.isSync} IN (0,1)),
  ${CustomerFields.syncDate} $dateTimeType,
  FOREIGN KEY (${CustomerFields.customerCategoryId}) REFERENCES ${Tables.CustomerCategory} (id),
  FOREIGN KEY (${CustomerFields.countryId}) REFERENCES ${Tables.Country} (id),
  FOREIGN KEY (${CustomerFields.CurrencyId}) REFERENCES ${Tables.Currency} (id),
  FOREIGN KEY (${CustomerFields.subAreaId}) REFERENCES ${Tables.SubAreas} (id)
  )''');
    await db.execute('''
    CREATE TABLE ${Tables.MasterGroup} (
    ${MasterGroupField.id} $idTypeNoAutoIncrement,
    ${MasterGroupField.name} $textTypeNotNull,
    ${MasterGroupField.isDefault} $boolType CHECK(${MasterGroupField.isDefault} IN (0,1)),
    ${MasterGroupField.isActive} $boolType CHECK(${MasterGroupField.isActive} IN (0,1)),
    ${MasterGroupField.companySlug} $textTypeNotNull,
    ${MasterGroupField.isSync} $boolType CHECK(${MasterGroupField.isSync} IN (0,1)),
    ${MasterGroupField.syncDate} $dateTimeType)''');
    await db.execute('''
    CREATE TABLE ${Tables.DetailAGroup} (
    ${DetailAGroupField.id} $idTypeNoAutoIncrement,
    ${DetailAGroupField.name} $textTypeNotNull,
    ${DetailAGroupField.isDefault} $boolType CHECK(${DetailAGroupField.isDefault} IN (0,1)),
    ${DetailAGroupField.isActive} $boolType CHECK(${DetailAGroupField.isActive} IN (0,1)),
    ${DetailAGroupField.companySlug} $textTypeNotNull,
    ${DetailAGroupField.isSync} $boolType CHECK(${DetailAGroupField.isSync} IN (0,1)),
    ${DetailAGroupField.syncDate} $dateTimeType)''');
    await db.execute('''
    CREATE TABLE ${Tables.DetailBGroup} (
    ${DetailBGroupField.id} $idTypeNoAutoIncrement,
    ${DetailBGroupField.name} $textTypeNotNull,
    ${DetailBGroupField.isDefault} $boolType CHECK(${DetailBGroupField.isDefault} IN (0,1)),
    ${DetailBGroupField.isActive} $boolType CHECK(${DetailBGroupField.isActive} IN (0,1)),
    ${DetailBGroupField.companySlug} $textTypeNotNull,
    ${DetailBGroupField.isSync} $boolType CHECK(${DetailBGroupField.isSync} IN (0,1)),
    ${DetailBGroupField.syncDate} $dateTimeType)''');

    await db.execute('''
    CREATE TABLE ${Tables.accounts} (
    ${AccountField.id} $idTypeNoAutoIncrement,
    ${AccountField.code} $textType,
    ${AccountField.name} $textTypeNotNull,
    ${AccountField.description} $textType,
    ${AccountField.accountTypeId} $integerType,
    ${AccountField.includeHomeCurrency} $boolType CHECK(${AccountField.includeHomeCurrency} IN (0,1)),
    ${AccountField.accountClass} $integerType,
    ${AccountField.accountGroup} $integerType,
    ${AccountField.accountGroupName} $integerType,
    ${AccountField.systemAccount} $integerType,
    [${AccountField.order}] $integerTypeNotNull,
    ${AccountField.currencyId} $integerTypeNotNull,
    ${AccountField.isActive} $boolType CHECK(${AccountField.isActive} IN (0,1)),
    ${AccountField.hide} $boolType CHECK(${AccountField.hide} IN (0,1)),
    ${AccountField.companySlug} $textTypeNotNull,
    ${AccountField.isSync} $boolType CHECK(${AccountField.isSync} IN (0,1)),
    ${AccountField.syncDate} $dateTimeType)''');

    await db.execute('''
    CREATE TABLE ${Tables.POSCart} (
      ${CartFields.id} $idType,
      ${CartFields.companySlug} $textTypeNotNull,
      ${CartFields.productName} $textTypeNotNull,
      ${CartFields.qty} $integerTypeNotNull,
      ${CartFields.price} $decimalType,
      ${CartFields.screenType} $integerType,
      ${CartFields.productId} $integerType,
      ${CartFields.customerId} $integerType,
      ${CartFields.grossAmount} $decimalType,
      ${CartFields.netAmount} $decimalType,
      ${CartFields.totalTaxAmonut} $decimalType,
      ${CartFields.salesPersonId} $integerType,
      ${CartFields.discountType} $integerType,
      ${CartFields.discountInPercent} $decimalType,
      ${CartFields.discountInAmount} $decimalType,
      ${CartFields.pOSCashRegisterId} $integerType,
      ${CartFields.batchId} $integerType,
      ${CartFields.serialNumber} $textType,
      ${CartFields.isAppliedScheme} $boolType CHECK(${CartFields.isAppliedScheme} IN (0,1)),
      ${CartFields.isProductScheme} $boolType CHECK(${CartFields.isProductScheme} IN (0,1)),
      ${CartFields.fractionalUnit} $boolType CHECK(${CartFields.fractionalUnit} IN (0,1)),
      FOREIGN KEY (${CartFields.productId}) REFERENCES ${Tables.products} (id),
      FOREIGN KEY (${CartFields.customerId}) REFERENCES ${Tables.Customer} (id),
      FOREIGN KEY (${CartFields.salesPersonId}) REFERENCES ${Tables.SalesPerson} (id)
      )''');

    await db.execute('''
    CREATE TABLE ${Tables.POSCartDetail} (
      ${CartDiscountFields.id} $idType,
      ${CartDiscountFields.companySlug} $textTypeNotNull,
      ${CartDiscountFields.discountId} $integerTypeNotNull,
      ${CartDiscountFields.discountInPercent} $decimalType,
      ${CartDiscountFields.discountInAmount} $decimalType,
      ${CartDiscountFields.discountAmount} $decimalType,
      ${CartDiscountFields.discountInPrice} $decimalType,
      ${CartDiscountFields.cartId} $integerType,
      ${CartDiscountFields.discountType} $integerType,
      ${CartDiscountFields.schemeId} $integerType,
      ${CartDiscountFields.schemeDetailId} $integerType,
      FOREIGN KEY (${CartDiscountFields.cartId}) REFERENCES ${Tables.POSCart} (id) ON DELETE CASCADE,
      FOREIGN KEY (${CartDiscountFields.discountId}) REFERENCES ${Tables.Discount} (id)
      )''');

    await db.execute('''
      CREATE TABLE ${Tables.Discount} (
      ${DiscountField.id} $idTypeNoAutoIncrement,
      ${DiscountField.companySlug} $textTypeNotNull,
      ${DiscountField.name} $textTypeNotNull,
      ${DiscountField.abbreviation} $textTypeNotNull,
      ${DiscountField.isDefault} $boolType CHECK(${DiscountField.isDefault} IN (0,1)),
      ${DiscountField.isSync} $boolType CHECK(${DiscountField.isSync} IN (0,1)),
      ${DiscountField.syncDate} $dateTimeType
      )''');

    await db.execute('''
      CREATE TABLE ${Tables.CompanySetting} (
      ${CompanySettingField.id} $idGuidType,
      ${CompanySettingField.slug} $textTypeNotNull,
      ${CompanySettingField.name} $textTypeNotNull,
      ${CompanySettingField.fbrPosFeeAccountType} $integerType,
      ${CompanySettingField.defaultPOSCustomerId} $integerType,
      ${CompanySettingField.decimalPlaces} $integerType,
      ${CompanySettingField.homeCurrencyId} $integerType,
      ${CompanySettingField.allowDiscountOnPosProduct} $boolType CHECK(${CompanySettingField.allowDiscountOnPosProduct} IN (0,1)),
      ${CompanySettingField.allowPriceChangeForPosProduct} $boolType CHECK(${CompanySettingField.allowPriceChangeForPosProduct} IN (0,1)),
      ${CompanySettingField.allowRemovePosProductAfterScanning} $boolType CHECK(${CompanySettingField.allowRemovePosProductAfterScanning} IN (0,1)),
      ${CompanySettingField.allowOverallDiscountPos} $boolType CHECK(${CompanySettingField.allowOverallDiscountPos} IN (0,1)),
      ${CompanySettingField.manuallyManageEOD} $boolType CHECK(${CompanySettingField.manuallyManageEOD} IN (0,1)),
      ${CompanySettingField.enableFbrPos} $boolType CHECK(${CompanySettingField.enableFbrPos} IN (0,1)),
      ${CompanySettingField.enableFbrPosFee} $boolType CHECK(${CompanySettingField.enableFbrPosFee} IN (0,1)),
      ${CompanySettingField.enableSalesmansOnPos} $boolType CHECK(${CompanySettingField.enableSalesmansOnPos} IN (0,1)),
      ${CompanySettingField.isSalesmanRequiredOnPos} $boolType CHECK(${CompanySettingField.isSalesmanRequiredOnPos} IN (0,1)),
      ${CompanySettingField.enableSalesGeography} $boolType CHECK(${CompanySettingField.enableSalesGeography} IN (0,1)),
      ${CompanySettingField.enableMasterGroups} $boolType CHECK(${CompanySettingField.enableMasterGroups} IN (0,1)),
      ${CompanySettingField.enableDetailBGroups} $boolType CHECK(${CompanySettingField.enableDetailBGroups} IN (0,1)),
      ${CompanySettingField.enableDetailAGroups} $boolType CHECK(${CompanySettingField.enableDetailAGroups} IN (0,1)),
      ${CompanySettingField.masterGroupCaption} $textType,
      ${CompanySettingField.detailAGroupCaption} $textType,
      ${CompanySettingField.detailBGroupCaption} $textType,
      ${CompanySettingField.isSync} $boolType CHECK(${CompanySettingField.isSync} IN (0,1)),
      ${CompanySettingField.syncDate} $dateTimeType,
      ${CompanySettingField.printerName} $textType,
      ${CompanySettingField.logo} $textType,
      ${CompanySettingField.enableScheme} $boolType CHECK(${CompanySettingField.enableScheme} IN (0,1)),
      ${CompanySettingField.enableCustomerLoyaltyPoints} $boolType CHECK(${CompanySettingField.enableCustomerLoyaltyPoints} IN (0,1)),
      ${CompanySettingField.customerLoyaltyProgramCategories} $textType,
      ${CompanySettingField.customerLoyaltyDiscountAccountId} $integerType,
      ${CompanySettingField.customerLoyaltyAmountToPointsConversionRate} $decimalType,
      ${CompanySettingField.customerLoyaltyPointsToAmountConversionRate} $decimalType,
      ${CompanySettingField.customerLoyaltyCalculationType} $integerType
      )''');
    // await db.execute('''
    //   CREATE TABLE ${Tables.SalesPerson} (
    //   ${SalesPersonFiles.id} $idTypeNoAutoIncrement,
    //   ${SalesPersonFiles.companySlug} $textTypeNotNull,
    //   ${SalesPersonFiles.name} $textTypeNotNull,
    //   ${SalesPersonFiles.applicationUserId} $textType,
    //   ${SalesPersonFiles.cashAccountId} $integerType,
    //   ${SalesPersonFiles.receiveMoneySeries} $textType,
    //   ${SalesPersonFiles.saleOrderSeries} $textType,
    //   ${SalesPersonFiles.isOrderBooker} $boolType CHECK(${SalesPersonFiles.isOrderBooker} IN (0,1)),
    //   ${SalesPersonFiles.isDeliveryPerson} $boolType CHECK(${SalesPersonFiles.isDeliveryPerson} IN (0,1)),
    //   ${SalesPersonFiles.isSalesman} $boolType CHECK(${SalesPersonFiles.isSalesman} IN (0,1)),
    //   ${SalesPersonFiles.CanChangePrice} $boolType CHECK(${SalesPersonFiles.CanChangePrice} IN (0,1)),
    //   ${SalesPersonFiles.CanAddDiscount} $boolType CHECK(${SalesPersonFiles.CanAddDiscount} IN (0,1)),
    //   ${SalesPersonFiles.isSync} $boolType CHECK(${SalesPersonFiles.isSync} IN (0,1)),
    //   ${SalesPersonFiles.syncDate} $dateTimeType,
    //   ${SalesPersonFiles.branchId} $integerType,
    //   ${SalesPersonFiles.isActive} $boolType CHECK(${SalesPersonFiles.isActive} IN (0,1))
    //   )''');
    // await db.execute('''
    //   CREATE TABLE ${Tables.WareHouse} (
    //   ${WareHousesFiled.id} $idTypeNoAutoIncrement,
    //   ${WareHousesFiled.companySlug} $textTypeNotNull,
    //   ${WareHousesFiled.name} $textTypeNotNull,
    //   ${WareHousesFiled.isDefault} $boolType CHECK(${WareHousesFiled.isDefault} IN (0,1)),
    //   ${WareHousesFiled.isTransit} $boolType CHECK(${WareHousesFiled.isTransit} IN (0,1)),
    //   ${WareHousesFiled.isActive} $boolType CHECK(${WareHousesFiled.isActive} IN (0,1)),
    //   ${WareHousesFiled.branchId} $integerType,
    //   ${WareHousesFiled.updatedOn} $dateTimeType,
    //   ${WareHousesFiled.isSync} $boolType CHECK(${WareHousesFiled.isSync} IN (0,1)),
    //   ${WareHousesFiled.syncDate} $dateTimeType
    //   )''');

    // await db.execute('''
    //   CREATE TABLE ${Tables.CustomerLoyaltyPointBalance} (
    //   ${CustomerLoyaltyPointBalanceField.id} $idType,
    //   ${CustomerLoyaltyPointBalanceField.companySlug} $textTypeNotNull,
    //   ${CustomerLoyaltyPointBalanceField.customerId} $integerType,
    //   ${CustomerLoyaltyPointBalanceField.loyaltyPoints} $integerType,
    //   ${CustomerLoyaltyPointBalanceField.updatedOn} $dateTimeType
    //   )''');
    // await db.execute('''
    //   CREATE TABLE ${Tables.PosCashRegister} (
    //   ${PosCashRegisterFields.id} $idTypeNoAutoIncrement,
    //   ${PosCashRegisterFields.companySlug} $textTypeNotNull,
    //   ${PosCashRegisterFields.name} $textTypeNotNull,
    //   ${PosCashRegisterFields.prefix} $textType,
    //   ${PosCashRegisterFields.cashRegisterSessionId} $guidType,
    //   ${PosCashRegisterFields.userId} $guidType,
    //   ${PosCashRegisterFields.cashAccountId} $integerType,
    //   ${PosCashRegisterFields.creditCardBankAccountId} $integerType,
    //   ${PosCashRegisterFields.bankExpenseAccountId} $integerType,
    //   ${PosCashRegisterFields.bankChargesRate} $decimalType,
    //   ${PosCashRegisterFields.bankChargesAmount} $decimalType,
    //   ${PosCashRegisterFields.warehouseId} $integerType,
    //   ${PosCashRegisterFields.masterGroupId} $integerType,
    //   ${PosCashRegisterFields.posRefundSeries} $textType,
    //   ${PosCashRegisterFields.posInvoiceSeries} $textType,
    //   ${PosCashRegisterFields.posReturnSeries} $textType,
    //   ${PosCashRegisterFields.fbrPosRegistationNo} $integerType,
    //   ${PosCashRegisterFields.fbrCounterAuthToken} $textType,
    //   ${PosCashRegisterFields.enableFbrPosOnCounter} $boolType CHECK(${PosCashRegisterFields.enableFbrPosOnCounter} IN (0,1)),
    //   ${PosCashRegisterFields.comments} $textType,
    //   ${PosCashRegisterFields.difference} $decimalType,
    //   ${PosCashRegisterFields.isActive} $boolType CHECK(${PosCashRegisterFields.isActive} IN (0,1)),
    //   ${PosCashRegisterFields.updatedOn} $dateTimeType,
    //   ${PosCashRegisterFields.isSync} $boolType CHECK(${PosCashRegisterFields.isSync} IN (0,1)),
    //   ${PosCashRegisterFields.syncDate} $dateTimeType,
    //   ${PosCashRegisterFields.isReserved} $boolType CHECK(${PosCashRegisterFields.isReserved} IN (0,1)),
    //   ${PosCashRegisterFields.macAddress} $textType,
    //   ${PosCashRegisterFields.machineName} $textType,
    //   ${PosCashRegisterFields.branchId} $integerType,
    //   FOREIGN KEY (${PosCashRegisterFields.warehouseId}) REFERENCES ${Tables.WareHouse} (id),
    //   FOREIGN KEY (${PosCashRegisterFields.masterGroupId}) REFERENCES ${Tables.MasterGroup} (id),
    //   FOREIGN KEY (${PosCashRegisterFields.cashAccountId}) REFERENCES ${Tables.accounts} (id)
    //   )''');

    // await db.execute('''
    //   CREATE TABLE ${Tables.POSInvoice} (
    //   ${POSInvoiceFields.id} $idType,
    //   ${POSInvoiceFields.companySlug} $textTypeNotNull,
    //   ${POSInvoiceFields.saleQuotationId} $integerType,
    //   ${POSInvoiceFields.saleOrderId} $integerType,
    //   ${POSInvoiceFields.saleDeliveryId} $integerType,
    //   ${POSInvoiceFields.customerId} $integerType,
    //   ${POSInvoiceFields.currencyId} $integerType,
    //   ${POSInvoiceFields.exchangeRate} $decimalType,
    //   ${POSInvoiceFields.shippingAddress} $textType,
    //   ${POSInvoiceFields.billingAddress} $textType,
    //   ${POSInvoiceFields.number} $decimalType,
    //   ${POSInvoiceFields.date} $dateTimeType,
    //   ${POSInvoiceFields.dueDate} $dateTimeType,
    //   ${POSInvoiceFields.reference} $textType,
    //   ${POSInvoiceFields.accountId} $integerType,
    //   ${POSInvoiceFields.paymentReference} $textType,
    //   ${POSInvoiceFields.comments} $textType,
    //   ${POSInvoiceFields.grossAmount} $decimalType,
    //   ${POSInvoiceFields.taxAmount} $decimalType,
    //   ${POSInvoiceFields.discountPercent} $decimalType,
    //   ${POSInvoiceFields.discountAmount} $decimalType,
    //   ${POSInvoiceFields.otherCharges} $decimalType,
    //   ${POSInvoiceFields.netAmount} $decimalType,
    //   ${POSInvoiceFields.paidAmount} $decimalType,
    //   ${POSInvoiceFields.receivedAmount} $decimalType,
    //   ${POSInvoiceFields.status} $integerType,
    //   ${POSInvoiceFields.autoRoundOff} $decimalType,
    //   ${POSInvoiceFields.manualRoundOff} $decimalType,
    //   ${POSInvoiceFields.masterGroupId} $integerType,
    //   ${POSInvoiceFields.shippingCharges} $decimalType,
    //   ${POSInvoiceFields.amountToAllocate} $decimalType,
    //   ${POSInvoiceFields.cashRegisterSessionId} $guidType,
    //   ${POSInvoiceFields.isPOS} $boolType CHECK(${POSInvoiceFields.isPOS} IN (0,1)),
    //   ${POSInvoiceFields.posCashRegisterId} $integerType,
    //   ${POSInvoiceFields.changeReturnedAmount} $decimalType,
    //   ${POSInvoiceFields.amountBeforeDiscount} $decimalType,
    //   ${POSInvoiceFields.time} $dateTimeType,
    //   ${POSInvoiceFields.userId} $guidType,
    //   ${POSInvoiceFields.deliveryPersonId} $integerType,
    //   ${POSInvoiceFields.orderBookerId} $integerType,
    //   ${POSInvoiceFields.salesmanId} $integerType,
    //   ${POSInvoiceFields.unAllocatedAmount} $decimalType,
    //   ${POSInvoiceFields.series} $textType,
    //   ${POSInvoiceFields.subject} $textType,
    //   ${POSInvoiceFields.saleReturnedAmount} $decimalType,
    //   ${POSInvoiceFields.pOSInvoice} $integerType,
    //   ${POSInvoiceFields.narration} $textType,
    //   ${POSInvoiceFields.branchId} $integerType,
    //   ${POSInvoiceFields.fbrPosInvoiceNumber} $textType,
    //   ${POSInvoiceFields.fbrPosFee} $decimalType,
    //   ${POSInvoiceFields.createdOn} $dateTimeType,
    //   ${POSInvoiceFields.createdBy} $guidType,
    //   ${POSInvoiceFields.returnCashAmount} $decimalType,
    //   ${POSInvoiceFields.adjustedAmount} $decimalType,
    //   ${POSInvoiceFields.isFbrPOS} $boolType CHECK(${POSInvoiceFields.isFbrPOS} IN (0,1)),
    //   ${POSInvoiceFields.isSync} $boolType CHECK(${POSInvoiceFields.isSync} IN (0,1)),
    //   FOREIGN KEY (${POSInvoiceFields.accountId}) REFERENCES ${Tables.accounts} (id),
    //   FOREIGN KEY (${POSInvoiceFields.masterGroupId}) REFERENCES ${Tables.MasterGroup} (id),
    //   FOREIGN KEY (${POSInvoiceFields.currencyId}) REFERENCES ${Tables.Currency} (id),
    //   FOREIGN KEY (${POSInvoiceFields.posCashRegisterId}) REFERENCES ${Tables.PosCashRegister} (id),
    //   FOREIGN KEY (${POSInvoiceFields.salesmanId}) REFERENCES ${Tables.SalesPerson} (id)
    //   )''');

    // await db.execute('''
    //   CREATE TABLE ${Tables.POSInvoiceDetail} (
    //   ${POSInvoiceDetailFields.id} $idTypeNoAutoIncrement,
    //   ${POSInvoiceDetailFields.companySlug} $textTypeNotNull,
    //   ${POSInvoiceDetailFields.saleInvoiceId} $integerType,
    //   ${POSInvoiceDetailFields.productId} $integerType,
    //   ${POSInvoiceDetailFields.accountId} $integerType,
    //   ${POSInvoiceDetailFields.description} $textType,
    //   ${POSInvoiceDetailFields.quantity} $decimalType,
    //   ${POSInvoiceDetailFields.price} $decimalType,
    //   ${POSInvoiceDetailFields.discountInPercent} $decimalType,
    //   ${POSInvoiceDetailFields.grossAmount} $decimalType,
    //   ${POSInvoiceDetailFields.taxAmount} $decimalType,
    //   ${POSInvoiceDetailFields.discountAmount} $decimalType,
    //   ${POSInvoiceDetailFields.netAmount} $decimalType,
    //   ${POSInvoiceDetailFields.packingDetail} $textType,
    //   ${POSInvoiceDetailFields.detailBGroupId} $integerType,
    //   ${POSInvoiceDetailFields.detailAGroupId} $integerType,
    //   ${POSInvoiceDetailFields.quantityCalculation} $textType,
    //   ${POSInvoiceDetailFields.batchId} $integerType,
    //   ${POSInvoiceDetailFields.warehouseId} $integerType ,
    //   ${POSInvoiceDetailFields.serialNumber} $textType,
    //   ${POSInvoiceDetailFields.isMRPExclusiveTax} $boolType CHECK(${POSInvoiceDetailFields.isMRPExclusiveTax} IN (0,1)),
    //   ${POSInvoiceDetailFields.purchasePrice} $decimalType,
    //   ${POSInvoiceDetailFields.maximumRetailPrice} $decimalType,
    //   ${POSInvoiceDetailFields.consignmentId} $integerType,
    //   ${POSInvoiceDetailFields.branchId} $integerType,
    //   ${POSInvoiceDetailFields.isBonusProduct} $boolType CHECK(${POSInvoiceDetailFields.isBonusProduct} IN (0,1)),
    //   ${POSInvoiceDetailFields.tagPrice} $decimalType,
    //   ${POSInvoiceDetailFields.totalSavedAmount} $decimalType,
    //   ${POSInvoiceDetailFields.posPaymentMode} $integerType,
    //   ${POSInvoiceDetailFields.amount} $decimalType,
    //   FOREIGN KEY (${POSInvoiceDetailFields.accountId}) REFERENCES ${Tables.accounts} (id),
    //   FOREIGN KEY (${POSInvoiceDetailFields.detailAGroupId}) REFERENCES ${Tables.DetailAGroup} (id),
    //   FOREIGN KEY (${POSInvoiceDetailFields.detailBGroupId}) REFERENCES ${Tables.DetailBGroup} (id),
    //   FOREIGN KEY (${POSInvoiceDetailFields.productId}) REFERENCES ${Tables.products} (id),
    //   FOREIGN KEY (${POSInvoiceDetailFields.warehouseId}) REFERENCES ${Tables.WareHouse} (id),
    //   FOREIGN KEY (${POSInvoiceDetailFields.saleInvoiceId}) REFERENCES ${Tables.POSInvoice} (id) ON DELETE CASCADE
    //   )''');

    await db.execute('''
  CREATE TABLE ${Tables.POSInvoiceDetailDiscount} (
  ${POSInvoiceDetailDiscountFields.id} $idTypeNoAutoIncrement,
  ${POSInvoiceDetailDiscountFields.companySlug} $textTypeNotNull,
  ${POSInvoiceDetailDiscountFields.posInvoiceDetailId} $integerType,
  ${POSInvoiceDetailDiscountFields.discountId} $integerType,
  ${POSInvoiceDetailDiscountFields.discountInAmount} $decimalType,
  ${POSInvoiceDetailDiscountFields.discountInPrice} $decimalType,
  ${POSInvoiceDetailDiscountFields.discountInPercent} $decimalType,
  ${POSInvoiceDetailDiscountFields.discountAmount} $decimalType,
  ${POSInvoiceDetailDiscountFields.totalSavedAmount} $decimalType,
  ${POSInvoiceDetailDiscountFields.appliedOn} $integerType,
  ${POSInvoiceDetailDiscountFields.sort} $integerType,
  ${POSInvoiceDetailDiscountFields.schemeId} $integerType,
  ${POSInvoiceDetailDiscountFields.schemeDetailId} $integerType,
  ${POSInvoiceDetailDiscountFields.branchId} $integerType,
  ${POSInvoiceDetailDiscountFields.discountType} $integerType,
  FOREIGN KEY (${POSInvoiceDetailDiscountFields.posInvoiceDetailId}) REFERENCES ${Tables.POSInvoiceDetail} (id),
  FOREIGN KEY (${POSInvoiceDetailDiscountFields.discountId}) REFERENCES ${Tables.Discount} (id),
  FOREIGN KEY (${POSInvoiceDetailDiscountFields.schemeId}) REFERENCES ${Tables.Schemes} (id),
  FOREIGN KEY (${POSInvoiceDetailDiscountFields.schemeDetailId}) REFERENCES ${Tables.SchemeDetails} (id),
  FOREIGN KEY (${POSInvoiceDetailDiscountFields.posInvoiceDetailId}) REFERENCES ${Tables.POSInvoiceDetail} (id) ON DELETE CASCADE
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.NumberSerials} (
  ${NumberSerialsField.id} $idTypeNoAutoIncrement,
  ${NumberSerialsField.companySlug} $textTypeNotNull,
  ${NumberSerialsField.branchId} $integerType,
  ${NumberSerialsField.entityName} $textTypeNotNull,
  ${NumberSerialsField.series} $textTypeNotNull,
  ${NumberSerialsField.lastNumber} $textTypeNotNull, 
  ${NumberSerialsField.isDefault} $boolType CHECK(${NumberSerialsField.isDefault} IN (0,1)),
  ${NumberSerialsField.isSync} $boolType CHECK(${NumberSerialsField.isSync} IN (0,1)),
  ${NumberSerialsField.syncDate} $dateTimeType)''');

    await db.execute('''
  CREATE TABLE ${Tables.Regions} (
  ${RegionsField.id} $idTypeNoAutoIncrement,
  ${RegionsField.companySlug} $textTypeNotNull,
  ${RegionsField.name} $textTypeNotNull, 
  ${RegionsField.updatedOn} $dateTimeType, 
  ${RegionsField.isSync} $boolType CHECK(${RegionsField.isSync} IN (0,1)),
  ${RegionsField.syncDate} $dateTimeType)''');

    await db.execute('''
  CREATE TABLE ${Tables.Zones} (
  ${ZonesField.id} $idTypeNoAutoIncrement,
  ${ZonesField.companySlug} $textTypeNotNull,
  ${ZonesField.name} $textTypeNotNull, 
  ${ZonesField.updatedOn} $dateTimeType, 
  ${ZonesField.regionId} $integerType,
  ${ZonesField.isSync} $boolType CHECK(${ZonesField.isSync} IN (0,1)),
  ${ZonesField.syncDate} $dateTimeType,
  FOREIGN KEY (${ZonesField.regionId}) REFERENCES ${Tables.Regions} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.Territories} (
  ${TerritoriesField.id} $idTypeNoAutoIncrement,
  ${TerritoriesField.companySlug} $textTypeNotNull,
  ${TerritoriesField.name} $textTypeNotNull, 
  ${TerritoriesField.updatedOn} $dateTimeType, 
  ${TerritoriesField.regionId} $integerType,
  ${TerritoriesField.zoneId} $integerType,
  ${TerritoriesField.isSync} $boolType CHECK(${TerritoriesField.isSync} IN (0,1)),
  ${TerritoriesField.syncDate} $dateTimeType,
  FOREIGN KEY (${TerritoriesField.regionId}) REFERENCES ${Tables.Regions} (id),
  FOREIGN KEY (${TerritoriesField.zoneId}) REFERENCES ${Tables.Zones} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.Areas} (
  ${AreasField.id} $idTypeNoAutoIncrement,
  ${AreasField.companySlug} $textTypeNotNull,
  ${AreasField.name} $textTypeNotNull, 
  ${AreasField.updatedOn} $dateTimeType, 
  ${AreasField.regionId} $integerType,
  ${AreasField.zoneId} $integerType,
  ${AreasField.territoryId} $integerType,
  ${AreasField.isSync} $boolType CHECK(${AreasField.isSync} IN (0,1)),
  ${AreasField.syncDate} $dateTimeType,
  FOREIGN KEY (${AreasField.regionId}) REFERENCES ${Tables.Regions} (id),
  FOREIGN KEY (${AreasField.zoneId}) REFERENCES ${Tables.Zones} (id),
  FOREIGN KEY (${AreasField.territoryId}) REFERENCES ${Tables.Territories} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.SubAreas} (
  ${SubAreasField.id} $idTypeNoAutoIncrement,
  ${SubAreasField.companySlug} $textTypeNotNull,
  ${SubAreasField.name} $textTypeNotNull, 
  ${SubAreasField.updatedOn} $dateTimeType, 
  ${SubAreasField.regionId} $integerType,
  ${SubAreasField.zoneId} $integerType,
  ${SubAreasField.territoryId} $integerType,
  ${SubAreasField.areaId} $integerType,
  ${SubAreasField.branchId} $integerType,
  ${SubAreasField.isSync} $boolType CHECK(${SubAreasField.isSync} IN (0,1)),
  ${TerritoriesField.syncDate} $dateTimeType,
  FOREIGN KEY (${SubAreasField.regionId}) REFERENCES ${Tables.Regions} (id),
  FOREIGN KEY (${SubAreasField.territoryId}) REFERENCES ${Tables.Territories} (id),
  FOREIGN KEY (${SubAreasField.zoneId}) REFERENCES ${Tables.Zones} (id),
  FOREIGN KEY (${SubAreasField.areaId}) REFERENCES ${Tables.Areas} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.Schemes} (
  ${SchemesField.id} $idTypeNoAutoIncrement,
  ${SchemesField.companySlug} $textTypeNotNull,
  ${SchemesField.isSync} $boolType CHECK(${SchemesField.isSync} IN (0,1)),
  ${SchemesField.syncDate} $dateTimeType,
  ${SchemesField.updatedOn} $dateTimeType, 
  ${SchemesField.series} $textType, 
  ${SchemesField.number} $textType, 
  ${SchemesField.name} $textType, 
  ${SchemesField.schemeTypeId} $integerType,
  ${SchemesField.startDate} $dateTimeType,  
  ${SchemesField.endDate} $dateTimeType,  
  ${SchemesField.startTime} $dateTimeType,  
  ${SchemesField.endTime} $dateTimeType,  
  ${SchemesField.dayTypeId} $integerType,
  ${SchemesField.reference} $textType,
  ${SchemesField.dayType} $integerType,
  ${SchemesField.status} $integerType,
  ${SchemesField.isActive}  $boolType CHECK(${SchemesField.isActive} IN (0,1)),
  ${SchemesField.isTimeSensitiveScheme}  $boolType CHECK(${SchemesField.isTimeSensitiveScheme} IN (0,1)),
  ${SchemesField.discountId} $integerType,
  ${SchemesField.discountApplyOn} $integerType,
  ${SchemesField.enableMRPTax}  $boolType CHECK(${SchemesField.enableMRPTax} IN (0,1)),
  ${SchemesField.weekDays} $textType)''');

    await db.execute('''
  CREATE TABLE ${Tables.SchemeDetails} (
  ${DetailsSchemesField.id} $idTypeNoAutoIncrement,
  ${DetailsSchemesField.companySlug} $textTypeNotNull,
  ${DetailsSchemesField.isSync} $boolType CHECK(${DetailsSchemesField.isSync} IN (0,1)),
  ${DetailsSchemesField.syncDate} $dateTimeType,
  ${DetailsSchemesField.updatedOn} $dateTimeType, 
  ${DetailsSchemesField.schemeId} $integerType,
  ${DetailsSchemesField.invoiceAmount} $decimalType,
  ${DetailsSchemesField.discountRate} $decimalType,
  ${DetailsSchemesField.schemeProductId} $integerType,
  ${DetailsSchemesField.discountProductQuantity} $decimalType,
  ${DetailsSchemesField.discountProductAmount} $decimalType,
  ${DetailsSchemesField.productDiscountRate} $decimalType,
  ${DetailsSchemesField.bounsAmount} $decimalType,
  ${DetailsSchemesField.bounsProductId} $integerType,
  ${DetailsSchemesField.bounsProductQuantity} $decimalType,
  ${DetailsSchemesField.schemeProductQuantity} $decimalType,
  ${DetailsSchemesField.schemeProductAmount} $decimalType,
  ${DetailsSchemesField.schemeBounsQuantity} $decimalType,
  ${DetailsSchemesField.schemeProductCategoryId} $integerType,
  ${DetailsSchemesField.discountEffect} $integerType,
  ${DetailsSchemesField.bonusProductPrice} $decimalType,
  ${DetailsSchemesField.productDiscountAmount} $decimalType,
  FOREIGN KEY (${DetailsSchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.SchemeBranches} (
  ${BranchesSchemesField.id} $idTypeNoAutoIncrement,
  ${BranchesSchemesField.companySlug} $textTypeNotNull,
  ${BranchesSchemesField.isSync} $boolType CHECK(${BranchesSchemesField.isSync} IN (0,1)),
  ${BranchesSchemesField.syncDate} $dateTimeType,
  ${BranchesSchemesField.updatedOn} $dateTimeType, 
  ${BranchesSchemesField.schemeId} $integerType,
  ${BranchesSchemesField.branchId} $integerType,
  FOREIGN KEY (${BranchesSchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.SchemeCustomerCategories} (
  ${CustomerCategoriesSchemesField.id} $idTypeNoAutoIncrement,
  ${CustomerCategoriesSchemesField.companySlug} $textTypeNotNull,
  ${CustomerCategoriesSchemesField.isSync} $boolType CHECK(${CustomerCategoriesSchemesField.isSync} IN (0,1)),
  ${CustomerCategoriesSchemesField.syncDate} $dateTimeType,
  ${CustomerCategoriesSchemesField.updatedOn} $dateTimeType, 
  ${CustomerCategoriesSchemesField.schemeId} $integerType,
  ${CustomerCategoriesSchemesField.customerCategoryId} $integerType,
  FOREIGN KEY (${CustomerCategoriesSchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id)
  )''');

    await db.execute('''
  CREATE TABLE ${Tables.SchemesSalesGeography} (
  ${SalesGeographySchemesField.id} $idTypeNoAutoIncrement,
  ${SalesGeographySchemesField.companySlug} $textTypeNotNull,
  ${SalesGeographySchemesField.isSync} $boolType CHECK(${SalesGeographySchemesField.isSync} IN (0,1)),
  ${SalesGeographySchemesField.syncDate} $dateTimeType,
  ${SalesGeographySchemesField.updatedOn} $dateTimeType, 
  ${SalesGeographySchemesField.schemeId} $integerType,
  ${SalesGeographySchemesField.regionId} $integerType,
  ${SalesGeographySchemesField.zoneId} $integerType,
  ${SalesGeographySchemesField.territoryId} $integerType,
  ${SalesGeographySchemesField.areaId} $integerType,
  ${SalesGeographySchemesField.subAreaId} $integerType,
  FOREIGN KEY (${SalesGeographySchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id),
  FOREIGN KEY (${SalesGeographySchemesField.regionId}) REFERENCES ${Tables.Regions} (id),
  FOREIGN KEY (${SalesGeographySchemesField.zoneId}) REFERENCES ${Tables.Zones} (id),
  FOREIGN KEY (${SalesGeographySchemesField.areaId}) REFERENCES ${Tables.Areas} (id),
  FOREIGN KEY (${SalesGeographySchemesField.territoryId}) REFERENCES ${Tables.Territories} (id),
  FOREIGN KEY (${SalesGeographySchemesField.subAreaId}) REFERENCES ${Tables.SubAreas} (id)
)''');

    await db.execute('''
  CREATE TABLE ${Tables.POSInvoiceDetailTaxes} (
  ${POSInvoiceTaxField.id} $idTypeNoAutoIncrement,
  ${POSInvoiceTaxField.companySlug} $textTypeNotNull,
  ${POSInvoiceTaxField.isSync} $boolType CHECK(${POSInvoiceTaxField.isSync} IN (0,1)),
  ${POSInvoiceTaxField.syncDate} $dateTimeType,
  ${POSInvoiceTaxField.posInvoiceDetailId} $integerType,
  ${POSInvoiceTaxField.taxId} $integerType,
  ${POSInvoiceTaxField.appliedOn} $integerType,
  ${POSInvoiceTaxField.taxRate} $decimalType,
  ${POSInvoiceTaxField.taxAmount} $decimalType,
  ${POSInvoiceTaxField.sort} $integerType,
  ${POSInvoiceTaxField.branchId} $integerType,
  FOREIGN KEY (${POSInvoiceTaxField.taxId}) REFERENCES ${Tables.Tax} (id),
  FOREIGN KEY (${POSInvoiceTaxField.posInvoiceDetailId}) REFERENCES ${Tables.POSInvoiceDetail} (id) ON DELETE CASCADE
)''');

    await db.execute('''
  CREATE TABLE ${Tables.PosInvoicePayment} (
  ${PosPaymentField.id} $idType,
  ${PosPaymentField.posPaymentMode} $integerType,
  ${PosPaymentField.amount} $decimalType,
  ${PosPaymentField.cardNumber} $textType,
  ${PosPaymentField.creditNoteNumber} $textType,
  ${PosPaymentField.saleReturnNumber} $textType,
  ${PosPaymentField.creditNoteId} $integerType,
  ${PosPaymentField.saleReturnId} $integerType,
  ${PosPaymentField.branchId} $integerType,
  ${PosPaymentField.posInvoiceId} $integerType,
  ${PosPaymentField.companySlug} $textType,
  ${PosPaymentField.customerLoyaltyRedeemPoints} $integerType,
  FOREIGN KEY (${PosPaymentField.posInvoiceId}) REFERENCES ${Tables.POSInvoice} (id) ON DELETE CASCADE
)''');

    await db.execute('''
  CREATE TABLE ${Tables.ProductSalesTax} (
  ${ProductSalesTaxField.id} $idTypeNoAutoIncrement,
  ${ProductSalesTaxField.companySlug} $textTypeNotNull,
  ${ProductSalesTaxField.isSync} $boolType CHECK(${ProductSalesTaxField.isSync} IN (0,1)),
  ${ProductSalesTaxField.syncDate} $dateTimeType,
  ${ProductSalesTaxField.productId} $integerType, 
  ${ProductSalesTaxField.taxId} $integerType,
  ${ProductSalesTaxField.taxAmount} $decimalType,
  ${ProductSalesTaxField.appliedOn} $integerType,
  ${ProductSalesTaxField.sort} $integerType,
  ${ProductSalesTaxField.applicableToAllBranches} $boolType CHECK(${ProductSalesTaxField.applicableToAllBranches} IN (0,1)),
  FOREIGN KEY (${ProductSalesTaxField.productId}) REFERENCES ${Tables.products} (id),
  FOREIGN KEY (${ProductSalesTaxField.taxId}) REFERENCES ${Tables.Tax} (id)
)''');

//     await db.execute('''
//   CREATE TABLE ${Tables.Batches} (
//   ${BatchesField.id} $idTypeNoAutoIncrement,
//   ${BatchesField.companySlug} $textTypeNotNull,
//   ${BatchesField.isSync} $boolType CHECK(${BatchesField.isSync} IN (0,1)),
//   ${BatchesField.syncDate} $dateTimeType,
//   ${BatchesField.updatedOn} $dateTimeType,
//   ${BatchesField.productId} $integerType,
//   ${BatchesField.quantityInHand} $decimalType,
//   ${BatchesField.batchNumber} $textType,
//   ${BatchesField.expiryDate} $dateTimeType,
//   ${BatchesField.manufacturingDate} $dateTimeType,
//   ${BatchesField.stopPurchase} $boolType CHECK(${BatchesField.stopPurchase} IN (0,1)),
//   ${BatchesField.stopSale} $boolType CHECK(${BatchesField.stopSale} IN (0,1)),
//   ${BatchesField.isActive} $boolType CHECK(${BatchesField.isActive} IN (0,1)),
//   FOREIGN KEY (${BatchesField.productId}) REFERENCES ${Tables.products} (id)
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.ProductStocks} (
//   ${ProductSockField.id} $idTypeNoAutoIncrement,
//   ${ProductSockField.companySlug} $textTypeNotNull,
//   ${ProductSockField.isSync} $boolType CHECK(${ProductSockField.isSync} IN (0,1)),
//   ${ProductSockField.syncDate} $dateTimeType,
//   ${ProductSockField.updatedOn} $dateTimeType,
//   ${ProductSockField.productId} $integerType,
//   ${ProductSockField.warehouseId} $integerType,
//   ${ProductSockField.consignmentId} $integerType,
//   ${ProductSockField.batchId} $integerType,
//   ${ProductSockField.quantityInHand} $decimalType,
//   ${ProductSockField.serialNumber} $textType,
//   FOREIGN KEY (${ProductSockField.productId}) REFERENCES ${Tables.products} (id),
//   FOREIGN KEY (${ProductSockField.warehouseId}) REFERENCES ${Tables.WareHouse} (id),
//   FOREIGN KEY (${ProductSockField.batchId}) REFERENCES ${Tables.Batches} (id)
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.Transaction} (
//   ${TransactionFiled.id} $idTypeNoAutoIncrement,
//   ${TransactionFiled.companySlug} $textTypeNotNull,
//   ${TransactionFiled.isSync} $boolType CHECK(${TransactionFiled.isSync} IN (0,1)),
//   ${TransactionFiled.syncDate} $dateTimeType,
//   ${TransactionFiled.updatedOn} $dateTimeType,
//   ${TransactionFiled.date} $dateTimeType,
//   ${TransactionFiled.narration} $textType,
//   ${TransactionFiled.detailedNarration} $textType,
//   ${TransactionFiled.isOpening} $boolType CHECK(${TransactionFiled.isOpening} IN (0,1)),
//   ${TransactionFiled.isReverse} $boolType CHECK(${TransactionFiled.isReverse} IN (0,1)),
//   ${TransactionFiled.isVoid} $boolType CHECK(${TransactionFiled.isVoid} IN (0,1)),
//   ${TransactionFiled.masterGroupId} $integerType,
//   FOREIGN KEY (${TransactionFiled.masterGroupId}) REFERENCES ${Tables.MasterGroup} (id)
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.TransactionDetail} (
//   ${TransactionDetailFiled.id} $idTypeNoAutoIncrement,
//   ${TransactionDetailFiled.companySlug} $textTypeNotNull,
//   ${TransactionDetailFiled.isSync} $boolType CHECK(${TransactionFiled.isSync} IN (0,1)),
//   ${TransactionDetailFiled.syncDate} $dateTimeType,
//   ${TransactionDetailFiled.updatedOn} $dateTimeType,
//   ${TransactionDetailFiled.transactionId} $integerType,
//   ${TransactionDetailFiled.accountId} $integerType,
//   ${TransactionDetailFiled.credit} $decimalType,
//   ${TransactionDetailFiled.debit} $decimalType,
//   ${TransactionDetailFiled.debitGuest} $decimalType,
//   ${TransactionDetailFiled.creditGuest} $decimalType,
//   ${TransactionDetailFiled.detailAGroupId} $integerType,
//   ${TransactionDetailFiled.detailBGroupId} $integerType,
//   ${TransactionDetailFiled.description} $textType,
//   FOREIGN KEY (${TransactionDetailFiled.accountId}) REFERENCES ${Tables.accounts} (id),
//   FOREIGN KEY (${TransactionDetailFiled.detailAGroupId}) REFERENCES ${Tables.DetailAGroup} (id),
//   FOREIGN KEY (${TransactionDetailFiled.detailBGroupId}) REFERENCES ${Tables.DetailBGroup} (id),
//   FOREIGN KEY (${TransactionDetailFiled.transactionId}) REFERENCES ${Tables.Transaction} (id) ON DELETE CASCADE
// )''');
//     await db.execute('''
//   CREATE TABLE ${Tables.PosCashRegisterLog} (
//   ${PosCashRegisterLogFiled.id} $idType,
//   ${PosCashRegisterLogFiled.companySlug} $textTypeNotNull,
//   ${PosCashRegisterLogFiled.isSyncCheckIn} $boolType CHECK(${PosCashRegisterLogFiled.isSyncCheckIn} IN (0,1)),
//   ${PosCashRegisterLogFiled.isSyncCheckOut} $boolType CHECK(${PosCashRegisterLogFiled.isSyncCheckOut} IN (0,1)),
//   ${PosCashRegisterLogFiled.syncDate} $dateTimeType,
//   ${PosCashRegisterLogFiled.updatedOn} $dateTimeType,
//   ${PosCashRegisterLogFiled.createdOn} $dateTimeType,
//   ${PosCashRegisterLogFiled.createdBy} $integerType,
//   ${PosCashRegisterLogFiled.updatedBy} $integerType,
//   ${PosCashRegisterLogFiled.cashRegisterId} $integerType,
//   ${PosCashRegisterLogFiled.cashRegisterSessionId} $guidType,
//   ${PosCashRegisterLogFiled.userId} $guidType,
//   ${PosCashRegisterLogFiled.checkInTime} $dateTimeType,
//   ${PosCashRegisterLogFiled.checkOutTime} $dateTimeType,
//   ${PosCashRegisterLogFiled.branchId} $integerType,
//   FOREIGN KEY (${PosCashRegisterLogFiled.cashRegisterId}) REFERENCES ${Tables.PosCashRegister} (id)
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.PosSummary} (
//   ${POSSummeryFiled.id} $idType,
//   ${POSSummeryFiled.companySlug} $textTypeNotNull,
//   ${POSSummeryFiled.branchId} $integerType,
//   ${POSSummeryFiled.isSyncCheckIn} $boolType CHECK(${POSSummeryFiled.isSyncCheckIn} IN (0,1)),
//   ${POSSummeryFiled.isSyncCheckOut} $boolType CHECK(${POSSummeryFiled.isSyncCheckOut} IN (0,1)),
//   ${POSSummeryFiled.syncDate} $dateTimeType,
//   ${POSSummeryFiled.updatedOn} $dateTimeType,
//   ${POSSummeryFiled.createdOn} $dateTimeType,
//   ${POSSummeryFiled.createdBy} $guidType,
//   ${POSSummeryFiled.updatedBy} $guidType,
//   ${POSSummeryFiled.posCashRegisterId} $integerType,
//   ${POSSummeryFiled.cashRegisterSessionId} $guidType,
//   ${POSSummeryFiled.date} $dateTimeType,
//   ${POSSummeryFiled.counterName} $textType,
//   ${POSSummeryFiled.startTime} $dateTimeType,
//   ${POSSummeryFiled.endTime} $dateTimeType,
//   ${POSSummeryFiled.openingBalance} $decimalType,
//   ${POSSummeryFiled.cashShortOrExcess} $decimalType,
//   ${POSSummeryFiled.cashIn} $decimalType,
//   ${POSSummeryFiled.cashOut} $decimalType,
//   ${POSSummeryFiled.totalSales} $decimalType,
//   ${POSSummeryFiled.totalRefunds} $decimalType,
//   ${POSSummeryFiled.totalReturns} $decimalType,
//   ${POSSummeryFiled.totalReceivedAmount} $decimalType,
//   ${POSSummeryFiled.cashAmount} $decimalType,
//   ${POSSummeryFiled.cardAmount} $decimalType,
//   ${POSSummeryFiled.totalAdjustedAmount} $decimalType,
//   ${POSSummeryFiled.closingBalance} $decimalType,
//   ${POSSummeryFiled.totalCashAmount} $decimalType,
//   FOREIGN KEY (${POSSummeryFiled.posCashRegisterId}) REFERENCES ${Tables.PosCashRegister} (id)
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.TemplateDefinition} (
//   ${TemplateDefinitionFields.id} $idTypeNoAutoIncrement,
//  ${TemplateDefinitionFields.companySlug} $textTypeNotNull,
//   ${TemplateDefinitionFields.isSync} $boolType CHECK(${TemplateDefinitionFields.isSync} IN (0,1)),
//   ${TemplateDefinitionFields.syncDate} $dateTimeType,
//   ${TemplateDefinitionFields.source} $textType,
//   ${TemplateDefinitionFields.name} $textType,
//   ${TemplateDefinitionFields.value} $integerType,
//   ${TemplateDefinitionFields.title} $textType,
//   ${TemplateDefinitionFields.isCustom} $boolType CHECK(${TemplateDefinitionFields.isCustom} IN (0,1)),
//   ${TemplateDefinitionFields.isDefault} $boolType CHECK(${TemplateDefinitionFields.isDefault} IN (0,1)),
//   ${TemplateDefinitionFields.isActive} $boolType CHECK(${TemplateDefinitionFields.isActive} IN (0,1)),
//   ${TemplateDefinitionFields.showThumbnail} $boolType CHECK(${TemplateDefinitionFields.showThumbnail} IN (0,1)),
//   ${TemplateDefinitionFields.isSystem} $boolType CHECK(${TemplateDefinitionFields.isSystem} IN (0,1))
// )''');
//     await db.execute('''
//   CREATE TABLE ${Tables.TemplateDefinitionField} (
//   ${TemplateDefinitionFieldFields.id} $idTypeNoAutoIncrement,
//    ${TemplateDefinitionFieldFields.companySlug} $textTypeNotNull,
//   ${TemplateDefinitionFieldFields.isSync} $boolType CHECK(${TemplateDefinitionFieldFields.isSync} IN (0,1)),
//   ${TemplateDefinitionFieldFields.syncDate} $dateTimeType,
//   ${TemplateDefinitionFieldFields.templateDefinitionId} $integerType,
//   ${TemplateDefinitionFieldFields.title} $textType,
//   ${TemplateDefinitionFieldFields.section} $textType,
//   ${TemplateDefinitionFieldFields.name} $textType,
//   ${TemplateDefinitionFieldFields.show} $boolType CHECK(${TemplateDefinitionFieldFields.show} IN (0,1)),
//   ${TemplateDefinitionFieldFields.hasValue} $boolType CHECK(${TemplateDefinitionFieldFields.hasValue} IN (0,1)),
//   ${TemplateDefinitionFieldFields.valueCaption} $textType,
//   ${TemplateDefinitionFieldFields.value} $textType,
//   ${TemplateDefinitionFieldFields.sort} $integerType,
//   ${TemplateDefinitionFieldFields.selectable} $boolType CHECK(${TemplateDefinitionFieldFields.selectable} IN (0,1)),
//   ${TemplateDefinitionFieldFields.multiSelectable} $boolType CHECK(${TemplateDefinitionFieldFields.multiSelectable} IN (0,1)),
//   ${TemplateDefinitionFieldFields.editableLabel} $boolType CHECK(${TemplateDefinitionFieldFields.editableLabel} IN (0,1)),
//  FOREIGN KEY (${TemplateDefinitionFieldFields.templateDefinitionId}) REFERENCES ${Tables.TemplateDefinition} (id) ON DELETE CASCADE
// )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.SchemeInvoiceDiscount} (
//   ${SchemeInvoiceDiscountField.id} $idType,
//   ${SchemeInvoiceDiscountField.companySlug} $textTypeNotNull,
//   ${SchemeInvoiceDiscountField.branchId} $integerType,
//   ${SchemeInvoiceDiscountField.discountAmount} $decimalType,
//   ${SchemeInvoiceDiscountField.discountPercent} $decimalType,
//   ${SchemeInvoiceDiscountField.appliedOn} $integerType,
//   ${SchemeInvoiceDiscountField.sort} $integerType,
//   ${SchemeInvoiceDiscountField.discountType} $integerType,
//   ${SchemeInvoiceDiscountField.discountId} $integerType,
//   ${SchemeInvoiceDiscountField.schemeId} $integerType,
//   ${SchemeInvoiceDiscountField.masterGroupId} $integerType,
//   ${SchemeInvoiceDiscountField.currencyId} $integerType,
//   ${SchemeInvoiceDiscountField.narration} $textType,
//   ${SchemeInvoiceDiscountField.sourceCreatedOn} $dateTimeType,
//   ${SchemeInvoiceDiscountField.source} $textType,
//   ${SchemeInvoiceDiscountField.sourceId} $integerType
// )''');

//     await db.execute('''
//       CREATE TABLE ${Tables.SaleReturn} (
//       ${SaleReturnFields.id} $idType,
//       ${SaleReturnFields.companySlug} $textTypeNotNull,
//       ${SaleReturnFields.saleQuotationId} $integerType,
//       ${SaleReturnFields.saleOrderId} $integerType,
//       ${SaleReturnFields.saleInvoiceId} $integerType,
//       ${SaleReturnFields.saleDeliveryId} $integerType,
//       ${SaleReturnFields.customerId} $integerType,
//       ${SaleReturnFields.currencyId} $integerType,
//       ${SaleReturnFields.exchangeRate} $decimalType,
//       ${SaleReturnFields.shippingAddress} $textType,
//       ${SaleReturnFields.billingAddress} $textType,
//       ${SaleReturnFields.number} $decimalType,
//       ${SaleReturnFields.date} $dateTimeType,
//       ${SaleReturnFields.dueDate} $dateTimeType,
//       ${SaleReturnFields.reference} $textType,
//       ${SaleReturnFields.accountId} $integerType,
//       ${SaleReturnFields.paymentReference} $textType,
//       ${SaleReturnFields.comments} $textType,
//       ${SaleReturnFields.grossAmount} $decimalType,
//       ${SaleReturnFields.taxAmount} $decimalType,
//       ${SaleReturnFields.discountPercent} $decimalType,
//       ${SaleReturnFields.discountAmount} $decimalType,
//       ${SaleReturnFields.otherCharges} $decimalType,
//       ${SaleReturnFields.netAmount} $decimalType,
//       ${SaleReturnFields.paidAmount} $decimalType,
//       ${SaleReturnFields.receivedAmount} $decimalType,
//       ${SaleReturnFields.status} $integerType,
//       ${SaleReturnFields.autoRoundOff} $decimalType,
//       ${SaleReturnFields.manualRoundOff} $decimalType,
//       ${SaleReturnFields.masterGroupId} $integerType,
//       ${SaleReturnFields.shippingCharges} $decimalType,
//       ${SaleReturnFields.amountToAllocate} $decimalType,
//       ${SaleReturnFields.cashRegisterSessionId} $guidType,
//       ${SaleReturnFields.isPosReturn} $boolType CHECK(${SaleReturnFields.isPosReturn} IN (0,1)),
//       ${SaleReturnFields.posCashRegisterId} $integerType,
//       ${SaleReturnFields.changeReturnedAmount} $decimalType,
//       ${SaleReturnFields.time} $dateTimeType,
//       ${SaleReturnFields.userId} $guidType,
//       ${SaleReturnFields.deliveryPersonId} $integerType,
//       ${SaleReturnFields.orderBookerId} $integerType,
//       ${SaleReturnFields.salesmanId} $integerType,
//       ${SaleReturnFields.series} $textType,
//       ${SaleReturnFields.subject} $textType,
//       ${SaleReturnFields.saleReturnedAmount} $decimalType,
//       ${SaleReturnFields.pOSInvoice} $integerType,
//       ${SaleReturnFields.narration} $textType,
//       ${SaleReturnFields.branchId} $integerType,
//       ${SaleReturnFields.fbrPosInvoiceNumber} $textType,
//       ${SaleReturnFields.fbrPosFee} $decimalType,
//       ${SaleReturnFields.createdOn} $dateTimeType,
//       ${SaleReturnFields.createdBy} $guidType,
//      ${SaleReturnFields.autoSettle} $boolType CHECK(${SaleReturnFields.autoSettle} IN (0,1)),
//       ${SaleReturnFields.quantityCalculation} $textType,
//       ${SaleReturnFields.refundAmount} $decimalType,
//       ${SaleReturnFields.allocatedAmount} $decimalType,
//       ${SaleReturnFields.isFbrPOS} $boolType CHECK(${SaleReturnFields.isFbrPOS} IN (0,1)),
//       ${SaleReturnFields.isSync} $boolType CHECK(${SaleReturnFields.isSync} IN (0,1)),
//       FOREIGN KEY (${POSInvoiceFields.accountId}) REFERENCES ${Tables.accounts} (id),
//       FOREIGN KEY (${POSInvoiceFields.masterGroupId}) REFERENCES ${Tables.MasterGroup} (id),
//       FOREIGN KEY (${POSInvoiceFields.currencyId}) REFERENCES ${Tables.Currency} (id),
//       FOREIGN KEY (${POSInvoiceFields.posCashRegisterId}) REFERENCES ${Tables.PosCashRegister} (id),
//       FOREIGN KEY (${POSInvoiceFields.salesmanId}) REFERENCES ${Tables.SalesPerson} (id)
//       )''');

//     await db.execute('''
//       CREATE TABLE ${Tables.SaleReturnDetail} (
//       ${SaleReturnDetailFields.id} $idTypeNoAutoIncrement,
//       ${SaleReturnDetailFields.companySlug} $textTypeNotNull,
//       ${SaleReturnDetailFields.saleReturnId} $integerType,
//       ${SaleReturnDetailFields.productId} $integerType,
//       ${SaleReturnDetailFields.accountId} $integerType,
//       ${SaleReturnDetailFields.description} $textType,
//       ${SaleReturnDetailFields.quantity} $decimalType,
//       ${SaleReturnDetailFields.price} $decimalType,
//       ${SaleReturnDetailFields.discountInPercent} $decimalType,
//       ${SaleReturnDetailFields.grossAmount} $decimalType,
//       ${SaleReturnDetailFields.taxAmount} $decimalType,
//       ${SaleReturnDetailFields.discountAmount} $decimalType,
//       ${SaleReturnDetailFields.netAmount} $decimalType,
//       ${SaleReturnDetailFields.detailBGroupId} $integerType,
//       ${SaleReturnDetailFields.detailAGroupId} $integerType,
//       ${SaleReturnDetailFields.quantityCalculation} $textType,
//       ${SaleReturnDetailFields.batchId} $integerType,
//       ${SaleReturnDetailFields.warehouseId} $integerType ,
//       ${SaleReturnDetailFields.serialNumber} $textType,
//       ${SaleReturnDetailFields.isMRPExclusiveTax} $boolType CHECK(${POSInvoiceDetailFields.isMRPExclusiveTax} IN (0,1)),
//       ${SaleReturnDetailFields.purchasePrice} $decimalType,
//       ${SaleReturnDetailFields.maximumRetailPrice} $decimalType,
//       ${SaleReturnDetailFields.consignmentId} $integerType,
//       ${SaleReturnDetailFields.branchId} $integerType,
//       ${SaleReturnDetailFields.isBonusProduct} $boolType CHECK(${POSInvoiceDetailFields.isBonusProduct} IN (0,1)),
//       ${SaleReturnDetailFields.tagPrice} $decimalType,
//       ${SaleReturnDetailFields.totalSavedAmount} $decimalType,
//       ${SaleReturnDetailFields.amount} $decimalType,
//       FOREIGN KEY (${SaleReturnDetailFields.accountId}) REFERENCES ${Tables.accounts} (id),
//       FOREIGN KEY (${SaleReturnDetailFields.detailAGroupId}) REFERENCES ${Tables.DetailAGroup} (id),
//       FOREIGN KEY (${SaleReturnDetailFields.detailBGroupId}) REFERENCES ${Tables.DetailBGroup} (id),
//       FOREIGN KEY (${SaleReturnDetailFields.productId}) REFERENCES ${Tables.products} (id),
//       FOREIGN KEY (${SaleReturnDetailFields.warehouseId}) REFERENCES ${Tables.WareHouse} (id),
//       FOREIGN KEY (${SaleReturnDetailFields.saleReturnId}) REFERENCES ${Tables.SaleReturn} (id) ON DELETE CASCADE
//       )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.SaleReturnDetailDiscount} (
//   ${SaleReturnDetailDiscountFields.id} $idTypeNoAutoIncrement,
//   ${SaleReturnDetailDiscountFields.companySlug} $textTypeNotNull,
//   ${SaleReturnDetailDiscountFields.saleReturnDetailId} $integerType,
//   ${SaleReturnDetailDiscountFields.discountId} $integerType,
//   ${SaleReturnDetailDiscountFields.discountInAmount} $decimalType,
//   ${SaleReturnDetailDiscountFields.discountInPrice} $decimalType,
//   ${SaleReturnDetailDiscountFields.discountInPercent} $decimalType,
//   ${SaleReturnDetailDiscountFields.discountAmount} $decimalType,
//   ${SaleReturnDetailDiscountFields.totalSavedAmount} $decimalType,
//   ${SaleReturnDetailDiscountFields.appliedOn} $integerType,
//   ${SaleReturnDetailDiscountFields.sort} $integerType,
//   ${SaleReturnDetailDiscountFields.schemeId} $integerType,
//   ${SaleReturnDetailDiscountFields.schemeDetailId} $integerType,
//   ${SaleReturnDetailDiscountFields.branchId} $integerType,
//   ${SaleReturnDetailDiscountFields.discountType} $integerType,
//   FOREIGN KEY (${SaleReturnDetailDiscountFields.saleReturnDetailId}) REFERENCES ${Tables.SaleReturnDetail} (id),
//   FOREIGN KEY (${SaleReturnDetailDiscountFields.discountId}) REFERENCES ${Tables.Discount} (id),
//   FOREIGN KEY (${SaleReturnDetailDiscountFields.schemeId}) REFERENCES ${Tables.Schemes} (id),
//   FOREIGN KEY (${SaleReturnDetailDiscountFields.schemeDetailId}) REFERENCES ${Tables.SchemeDetails} (id),
//   FOREIGN KEY (${SaleReturnDetailDiscountFields.saleReturnDetailId}) REFERENCES ${Tables.SaleReturnDetail} (id) ON DELETE CASCADE
//   )''');

//     await db.execute('''
//   CREATE TABLE ${Tables.FundsTransfer} (
//   ${FundTransferFields.id} $idTypeNoAutoIncrement,
//   ${FundTransferFields.companySlug} $textTypeNotNull,
//   ${FundTransferFields.fromId} $integerType,
//   ${FundTransferFields.toId} $integerType,
//   ${FundTransferFields.amount} $decimalType,
//   ${FundTransferFields.cashRegisterSessionIdFrom} $guidType,
//   ${FundTransferFields.cashRegisterSessionIdTo} $guidType,
//   ${FundTransferFields.comments} $textType,
//   ${FundTransferFields.date} $dateTimeType,
//   ${FundTransferFields.number} $textType,
//   ${FundTransferFields.exchangeRate} $decimalType,
//   ${FundTransferFields.masterGroupId} $integerType,
//   ${FundTransferFields.currencyId} $integerType,
//   ${FundTransferFields.narration} $textType,
//   ${FundTransferFields.series} $textType,
//   ${FundTransferFields.status} $integerType,
//   ${FundTransferFields.reference} $textType,
//   ${FundTransferFields.updatedOn} $dateTimeType
// )''');
//     await db.execute('''
//   CREATE TABLE ${Tables.BranchProductTaxes} (
//   ${BranchProductTaxField.id} $idTypeNoAutoIncrement,
//   ${BranchProductTaxField.companySlug} $textTypeNotNull,
//   ${BranchProductTaxField.isSync} $boolType CHECK(${BranchProductTaxField.isSync} IN (0,1)),
//   ${BranchProductTaxField.syncDate} $dateTimeType,
//   ${BranchProductTaxField.productId} $integerType,
//   ${BranchProductTaxField.taxId} $integerType,
//   ${BranchProductTaxField.branchId} $integerType,
//   ${BranchProductTaxField.source} $textType
// )''');
//     await db.execute('''
//   CREATE TABLE ${Tables.EndOfTheDay} (
//   ${EndOfTheDayFields.id} $idTypeNoAutoIncrement,
//   ${EndOfTheDayFields.companySlug} $textTypeNotNull,
//   ${EndOfTheDayFields.endOfDayDate} $dateTimeType,
//   ${BranchProductTaxField.branchId} $integerType
// )''');
    await db.execute(''' 
    CREATE INDEX Products_id_IDX ON Products (id);
    CREATE INDEX Products_name_IDX ON Products (name);
    CREATE INDEX Products_code_IDX ON Products (code);
    CREATE INDEX Products_Slug_IDX ON Products (companySlug);
    CREATE INDEX Products_barcode_IDX ON Products (barcode); 
    CREATE INDEX Customers_name_IDX ON Customers (name);
    CREATE INDEX Customers_id_IDX ON Customers (id);
    CREATE INDEX Customers_code_IDX ON Customers (code);
    CREATE INDEX Customers_companySlug_IDX ON Customers (companySlug);
    CREATE INDEX Customers_phone_IDX ON Customers (phone);
    CREATE INDEX [AK_Schemes_companySlug_Id] ON Schemes  
(
	[companySlug] ASC,
	[Id] ASC
);
CREATE INDEX [IX_Schemes_DiscountId] ON [Schemes]
(
	[DiscountId] ASC
);
CREATE INDEX [IX_Schemes_Id] ON [Schemes]
(
	[Id] ASC
);
CREATE INDEX [AK_SchemeDetails_companySlug_Id] ON SchemeDetails  
(
	[companySlug] ASC,
	[Id] ASC
);
CREATE  INDEX [IX_SchemeDetails_CompanyId_BounsProductId] ON [SchemeDetails]
(
	[companySlug] ASC,
	[BounsProductId] ASC
);
CREATE INDEX [IX_SchemeDetails_CompanyId_SchemeId] ON [SchemeDetails]
(
	[companySlug] ASC,
	[SchemeId] ASC
);
CREATE INDEX [IX_SchemeDetails_CompanyId_SchemeProductId] ON [SchemeDetails]
(
	[companySlug] ASC,
	[SchemeProductId] ASC
);
CREATE  INDEX [IX_SchemeDetails_DiscountProductQuantity_SchemeId_SchemeProductId] ON [SchemeDetails]
(
	[DiscountProductQuantity] ASC
);
CREATE INDEX [IX_SchemeDetails_InvoiceAmount_schemeID] ON [SchemeDetails]
(
	[InvoiceAmount] ASC
);
CREATE INDEX IX_SchemeDetails_SchemeId_DiscountProductQuantity ON SchemeDetails
(
	[SchemeId] ASC,
	[DiscountProductQuantity] ASC
);
CREATE INDEX IX_SchemeDetails_SchemeProductCategoryId ON [SchemeDetails]
(
	[SchemeProductCategoryId] ASC
);
CREATE INDEX [IX_SchemeDetails_SchemeProductQuantity_SchemeId_SchemeProductId] ON [SchemeDetails]
(
	[SchemeProductQuantity] ASC
);
CREATE INDEX IX_SchemeDetails_Id ON [SchemeDetails]
(
	[Id] ASC
);
CREATE  INDEX [SchemeDetails_BonusAmount_SchemeId] ON [SchemeDetails]
(
	[BounsAmount] ASC
);
CREATE  INDEX [XI_SchemeDetails_InvoiceAmount_SchemeID] ON [SchemeDetails]
(
	[InvoiceAmount] ASC
);
    CREATE INDEX [AK_SchemeBranches_companySlug_Id] on[SchemeBranches]
(
	[companySlug] ASC,
	[Id] ASC
);
CREATE INDEX [IX_SchemeBranches_companySlug_BranchId] ON [SchemeBranches]
(
	[companySlug] ASC,
	[BranchId] ASC
);
CREATE INDEX [IX_SchemeBranches_companySlug_SchemeId] ON [SchemeBranches]
(
	[companySlug] ASC,
	[SchemeId] ASC
);
CREATE INDEX [PK_SchemeBranches] on [SchemeBranches]
(
	[Id] ASC
);
CREATE INDEX [AK_SchemeCustomerCategories_companySlug_Id] on [SchemeCustomerCategories] 
(
	[companySlug] ASC,
	[Id] ASC
);
CREATE INDEX [IX_SchemeCustomerCategories_companySlug_CustomerCategoryId] ON [SchemeCustomerCategories]
(
	[companySlug] ASC,
	[CustomerCategoryId] ASC
);
CREATE INDEX [IX_SchemeCustomerCategories_companySlug_SchemeId] ON [SchemeCustomerCategories]
(
	[companySlug] ASC,
	[SchemeId] ASC
);
CREATE INDEX  [PK_SchemeCustomerCategories] on [SchemeCustomerCategories]
(
	[Id] ASC
);
CREATE INDEX [IX_SchemeInvoiceDiscounts_CurrencyId] ON [SchemeInvoiceDiscounts]
(
	[CurrencyId] ASC
);
CREATE INDEX [IX_SchemeInvoiceDiscounts_DiscountId] ON [SchemeInvoiceDiscounts]
(
	[DiscountId] ASC
);
CREATE INDEX [IX_SchemeInvoiceDiscounts_MasterGroupId] ON [SchemeInvoiceDiscounts]
(
	[MasterGroupId] ASC
);
CREATE INDEX [IX_SchemeInvoiceDiscounts_SchemeId] ON [SchemeInvoiceDiscounts]
(
	[SchemeId] ASC
);
CREATE  INDEX [PK_SchemeInvoiceDiscounts] on [SchemeInvoiceDiscounts]
(
	[Id] ASC
);
CREATE INDEX [AK_SchemeSalesGeography_CompanySlug_Id] on [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[Id] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_AreaId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[AreaId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_RegionId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[RegionId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_SchemeId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[SchemeId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_SubAreaId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[SubAreaId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_TerritoryId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[TerritoryId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_CompanySlug_ZoneId] ON [SchemeSalesGeography]
(
	[CompanySlug] ASC,
	[ZoneId] ASC
);
CREATE INDEX [IX_SchemeSalesGeography_SchemeId] ON [SchemeSalesGeography]
(
	[SchemeId] ASC
);
CREATE INDEX  [PK_SchemeSalesGeography] on [SchemeSalesGeography]
(
	[Id] ASC
);
   CREATE INDEX  [PK_Id] on [PosCart]
(
	[id] ASC
);
 CREATE INDEX  [ProductId] on [PosCart]
(
	[ProductId] ASC
);
CREATE INDEX  [screenType] on [PosCart]
(
	[screenType] ASC
);
CREATE INDEX  [PK_PosCartDetailId] on [PosCartDetail]
(
	[id] ASC
);
CREATE INDEX  [cartId] on [PosCartDetail]
(
	[cartId] ASC
);
    ''');
  }

  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {}
  }
}

class CustomerLoyaltyPointBalanceField {}
