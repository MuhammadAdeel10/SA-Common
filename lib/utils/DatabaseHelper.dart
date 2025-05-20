import 'dart:async';
import 'dart:developer';
import 'package:path/path.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingAreasModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingBranchesModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomerCategoriesModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomersModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingRegionsModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingSubAreasModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingTerritoriesModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingZonesModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceDetailModel.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceModel.dart';
import 'package:sa_common/SalesPerson/model/SalesPersonModel.dart';
import 'package:sa_common/SalesPerson/model/TravelLogModel.dart';
import 'package:sa_common/SalesPerson/model/trip_model.dart';
import 'package:sa_common/SyncSetting/model.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/cart/model/cart_discount_model.dart';
import 'package:sa_common/cart/model/cart_model.dart';
import 'package:sa_common/company/Models/CompanySettingModel.dart';
import 'package:sa_common/login/UserModel.dart';
import 'package:sa_common/productStock/productStock_model.dart';
import 'package:sa_common/sale_order/model/sale_order_detail_model.dart';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/sale_order/model/sale_order_model.dart';
import 'package:sa_common/schemes/models/ProductSalesTaxModel.dart';
import 'package:sa_common/schemes/models/SubAreasModel.dart';
import 'package:sa_common/schemes/models/ZonesModel.dart';
import 'package:sa_common/schemes/models/areasModel.dart';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/schemes/models/product_images_mode.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/schemes/models/schemeCustomerCategoriesModel.dart';
import 'package:sa_common/schemes/models/schemeDetailsModel.dart';
import 'package:sa_common/schemes/models/schemeSalesGeographyModel.dart';
import 'package:sa_common/schemes/models/schemesModel.dart';
import 'package:sa_common/schemes/models/subAreaSalesPersonsModel.dart';
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
import 'package:sa_common/synchronization/Models/WarehouseModel.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/TablesName.dart';
import 'package:sqflite/sqflite.dart';
import '../productCategory/product_categories_model.dart';
import '../schemes/models/invoiceDetailTaxModel.dart';
import '../schemes/models/SchemeInvoiceDiscountModel.dart';
import '../schemes/models/regionsModel.dart';
import '../schemes/models/schemeBranchesModel.dart';
import '../schemes/models/territoriesModel.dart';
import '../synchronization/Models/BranchProductTaxModel.dart';
import '../synchronization/Models/EndOfTheDay_model.dart';
import '../synchronization/Models/unit_model.dart';

abstract class DBHelper {
  Future<Database> initDB(String filePath);
  Future<void> createDB(Database db, int version);
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion);
}

class DatabaseHelper implements DBHelper {
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
  int version = 35;
  String dataBaseName = "";

  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;

  DatabaseHelper.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB(dataBaseName);
    return _database!;
  }

  @override
  Future<Database> initDB(String filePath) async {
    try {
      final path;
      Logger.InfoLog("_initDB $filePath");
      // if (Platform.isWindows) {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, filePath);
      // } else {
      //   final dbPath = await getApplicationDocumentsDirectory();
      //   path = join(dbPath.path, filePath);
      // }

      return await openDatabase(path, version: version, onCreate: createDB, onUpgrade: onUpgrade);
    } catch (ex) {
      Logger.ErrorLog("_initDB Exception $ex");
      throw ex;
    }
  }

  @override
  Future<void> createDB(Database db, int version) async {
    try {
      Batch batch = db.batch();

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.user} ( 
  ${UserFields.id} $idType, 
  ${UserFields.email} $textType,
  ${UserFields.password} $textType,
  ${UserFields.expiry} $textType,
  ${UserFields.companyId} $textType,
  ${UserFields.branchId} $integerType,
  ${UserFields.customerId} $integerType,
  ${UserFields.branchPrefix} $textType,
  ${UserFields.phoneNumber} $textType,
  ${UserFields.fullName} $textType,
  ${UserFields.imageUrl} $textType,
  ${UserFields.isActive} $boolType CHECK(${UserFields.isActive} IN (0,1)),
  ${UserFields.isPrivacyMode} $boolType CHECK(${UserFields.isPrivacyMode} IN (0,1)),
  ${UserFields.userId} $guidType)''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.syncSetting} (
    ${SyncSettingFields.id} $idType,
    ${SyncSettingFields.tableName} $textTypeNotNull,
    ${SyncSettingFields.SyncDate} $dateTimeType,
    ${SyncSettingFields.branchId} $integerType,
    ${SyncSettingFields.companySlug} $textType,
    ${SyncSettingFields.IsSync} $boolType CHECK(${SyncSettingFields.IsSync} IN (0,1))
    )''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.productsCategories} (
    ${ProductCategoryFields.id} $idTypeNoAutoIncrement,
    ${ProductCategoryFields.name} $textType,
    ${ProductCategoryFields.imageUrl} $textType,
    ${ProductCategoryFields.companySlug} $textTypeNotNull,
    ${ProductCategoryFields.isActive} $boolType CHECK(${ProductCategoryFields.isActive} IN (0,1)),
    ${ProductCategoryFields.updatedOn} $dateTimeType,
    ${ProductCategoryFields.parentCategoryId} int null references ${Tables.productsCategories}
    (${ProductCategoryFields.id}))''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.units} (
    ${UnitFields.id} $idTypeNoAutoIncrement,
    ${UnitFields.name} $textTypeNotNull,
    ${UnitFields.measure} $integerType,
    ${UnitFields.symbol} $textType,
    ${UnitFields.active} $boolType CHECK(${UnitFields.active} IN (0,1))
    )''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.Tax} (
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

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.SubAreaSalesPersons} (
    ${SubAreaSalesPersonsFields.id} $idTypeNoAutoIncrement,
    ${SubAreaSalesPersonsFields.companySlug} $textTypeNotNull,
    ${SubAreaSalesPersonsFields.subAreaName} $textType,
    ${SubAreaSalesPersonsFields.salesPersonId} $integerType,
    ${SubAreaSalesPersonsFields.subAreaId} $integerType,
    ${SubAreaSalesPersonsFields.branchId} $integerType
    )''');

      batch.execute('''
      CREATE TABLE IF NOT EXISTS  ${Tables.products} (
      ${ProductFields.id} $idTypeNoAutoIncrement,
      ${ProductFields.code} $textTypeNotNull,
      ${ProductFields.number} $textTypeNotNull,
      ${ProductFields.barcode} $textType,
      ${ProductFields.sku} $textType,
      ${ProductFields.name} $textTypeNotNull,
      ${ProductFields.description} $textType,
      ${ProductFields.catalogContent} $textType,
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
      ${ProductFields.isForSale} $boolType CHECK(${ProductFields.isForSale} IN (0,1)),
      ${ProductFields.fractionalUnit} $boolType CHECK(${ProductFields.fractionalUnit} IN (0,1)),
      ${ProductFields.isMRPExclusiveTax} $boolType CHECK(${ProductFields.isMRPExclusiveTax} IN (0,1)),
      ${ProductFields.isOpening} $boolType CHECK(${ProductFields.isOpening} IN (0,1)),
      FOREIGN KEY (${ProductFields.productCategoryId}) REFERENCES ${Tables.productsCategories} (id),
      FOREIGN KEY (${ProductFields.unitId}) REFERENCES ${Tables.units} (id)
      )''');
      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Country} (
  ${CountryField.id} $idTypeNoAutoIncrement, 
  ${CountryField.name} $textTypeNotNull,
  ${CountryField.isDefault} $boolType CHECK(${CountryField.isDefault} IN (0,1)),
  ${CountryField.currencyId} $integerType,
  ${CountryField.isSync} $boolType CHECK(${CountryField.isSync} IN (0,1)),
  ${CountryField.syncDate} $dateTimeType)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.productImages} (
  ${ProductImagesFields.id} $idTypeNoAutoIncrement,
  ${ProductImagesFields.companySlug} $textTypeNotNull,
  ${ProductImagesFields.imageUrl} $textTypeNotNull,
  ${ProductImagesFields.productId} $integerType
  )''');
      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Currency} (
  ${CurrencyField.id} $idTypeNoAutoIncrement, 
  ${CurrencyField.name} $textTypeNotNull,
  ${CurrencyField.isDefault} $boolType CHECK(${CurrencyField.isDefault} IN (0,1)),
  ${CurrencyField.code} $textType,
  ${CurrencyField.symbol} $textType,
  ${CurrencyField.companySlug} $textTypeNotNull)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.CustomerCategory} (
  ${CustomerCategoryFields.id} $idTypeNoAutoIncrement, 
  ${CustomerCategoryFields.contactType} $integerType,
  ${CustomerCategoryFields.name} $textTypeNotNull,
  ${CustomerCategoryFields.companySlug} $textTypeNotNull,
  ${CustomerCategoryFields.sequenceName} $textType,
  ${CustomerCategoryFields.isSync} $boolType CHECK(${CustomerCategoryFields.isSync} IN (0,1)),
  ${CustomerCategoryFields.syncDate} $dateTimeType)''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.Customer} (
    ${CustomerFields.id} $idTypeNoAutoIncrement,
    ${CustomerFields.idTemp} $integerType,
    ${CustomerFields.name} $textTypeNotNull,
    ${CustomerFields.base64ImageString} $textType,
    ${CustomerFields.imageUrl} $textType,
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
    ${CustomerFields.longitude} $decimalType,
    ${CustomerFields.latitude} $decimalType,
    ${CustomerFields.isNew} $boolType CHECK(${CustomerFields.isNew} IN (0,1)),
    ${CustomerFields.isEdit} $boolType CHECK(${CustomerFields.isEdit} IN (0,1)),
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
      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.MasterGroup} (
    ${MasterGroupField.id} $idTypeNoAutoIncrement,
    ${MasterGroupField.name} $textTypeNotNull,
    ${MasterGroupField.isDefault} $boolType CHECK(${MasterGroupField.isDefault} IN (0,1)),
    ${MasterGroupField.isActive} $boolType CHECK(${MasterGroupField.isActive} IN (0,1)),
    ${MasterGroupField.companySlug} $textTypeNotNull,
    ${MasterGroupField.isSync} $boolType CHECK(${MasterGroupField.isSync} IN (0,1)),
    ${MasterGroupField.syncDate} $dateTimeType)''');
      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.DetailAGroup} (
    ${DetailAGroupField.id} $idTypeNoAutoIncrement,
    ${DetailAGroupField.name} $textTypeNotNull,
    ${DetailAGroupField.isDefault} $boolType CHECK(${DetailAGroupField.isDefault} IN (0,1)),
    ${DetailAGroupField.isActive} $boolType CHECK(${DetailAGroupField.isActive} IN (0,1)),
    ${DetailAGroupField.companySlug} $textTypeNotNull,
    ${DetailAGroupField.isSync} $boolType CHECK(${DetailAGroupField.isSync} IN (0,1)),
    ${DetailAGroupField.syncDate} $dateTimeType)''');
      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.DetailBGroup} (
    ${DetailBGroupField.id} $idTypeNoAutoIncrement,
    ${DetailBGroupField.name} $textTypeNotNull,
    ${DetailBGroupField.isDefault} $boolType CHECK(${DetailBGroupField.isDefault} IN (0,1)),
    ${DetailBGroupField.isActive} $boolType CHECK(${DetailBGroupField.isActive} IN (0,1)),
    ${DetailBGroupField.companySlug} $textTypeNotNull,
    ${DetailBGroupField.isSync} $boolType CHECK(${DetailBGroupField.isSync} IN (0,1)),
    ${DetailBGroupField.syncDate} $dateTimeType)''');

      batch.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.accounts} (
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

      batch.execute('''
      CREATE TABLE IF NOT EXISTS  ${Tables.Discount} (
      ${DiscountField.id} $idTypeNoAutoIncrement,
      ${DiscountField.companySlug} $textTypeNotNull,
      ${DiscountField.name} $textTypeNotNull,
      ${DiscountField.abbreviation} $textTypeNotNull,
      ${DiscountField.isDefault} $boolType CHECK(${DiscountField.isDefault} IN (0,1)),
      ${DiscountField.isSync} $boolType CHECK(${DiscountField.isSync} IN (0,1)),
      ${DiscountField.syncDate} $dateTimeType
      )''');

      batch.execute('''
      CREATE TABLE IF NOT EXISTS  ${Tables.CompanySetting} (
      ${CompanySettingField.id} $idGuidType,
      ${CompanySettingField.slug} $textTypeNotNull,
      ${CompanySettingField.name} $textTypeNotNull,
      ${CompanySettingField.fbrPosFeeAccountType} $integerType,
      ${CompanySettingField.defaultPOSCustomerId} $integerType,
      ${CompanySettingField.decimalPlaces} $integerType,
      ${CompanySettingField.currencyId} $integerType,
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
      ${CompanySettingField.enableNarration} $boolType CHECK(${CompanySettingField.enableNarration} IN (0,1)),
      ${CompanySettingField.enableDetailAGroups} $boolType CHECK(${CompanySettingField.enableDetailAGroups} IN (0,1)),
      ${CompanySettingField.currencySymbol} $boolType CHECK(${CompanySettingField.currencySymbol} IN (0,1)),
      ${CompanySettingField.allowDuplicateProducts} $boolType CHECK(${CompanySettingField.allowDuplicateProducts} IN (0,1)),
      ${CompanySettingField.masterGroupCaption} $textType,
      ${CompanySettingField.detailAGroupCaption} $textType,
      ${CompanySettingField.detailBGroupCaption} $textType,
      ${CompanySettingField.isSync} $boolType CHECK(${CompanySettingField.isSync} IN (0,1)),
      ${CompanySettingField.syncDate} $dateTimeType,
      ${CompanySettingField.printerName} $textType,
      ${CompanySettingField.logo} $textType,
      ${CompanySettingField.allowNegativeStock} $boolType CHECK(${CompanySettingField.allowNegativeStock} IN (0,1)),
      ${CompanySettingField.enableScheme} $boolType CHECK(${CompanySettingField.enableScheme} IN (0,1)),
      ${CompanySettingField.enableCustomerLoyaltyPoints} $boolType CHECK(${CompanySettingField.enableCustomerLoyaltyPoints} IN (0,1)),
      ${CompanySettingField.customerLoyaltyProgramCategories} $textType,
      ${CompanySettingField.customerLoyaltyDiscountAccountId} $integerType,
      ${CompanySettingField.customerLoyaltyAmountToPointsConversionRate} $decimalType,
      ${CompanySettingField.customerLoyaltyPointsToAmountConversionRate} $decimalType,
      ${CompanySettingField.OrderDateFilter} $integerType,
      ${CompanySettingField.customerLoyaltyCalculationType} $integerType,
      ${CompanySettingField.textField1Value} $textType,
      ${CompanySettingField.textField2Value} $textType,
      ${CompanySettingField.textField1Caption} $textType,
      ${CompanySettingField.textField2Caption} $textType,
      ${CompanySettingField.address1} $textType,
      ${CompanySettingField.address2} $textType,
      ${CompanySettingField.city} $textType,
      ${CompanySettingField.state} $textType,
      ${CompanySettingField.zip} $textType,
      ${CompanySettingField.phone} $textType,
      ${CompanySettingField.countryId} $integerType,
      ${CompanySettingField.enableSalePricing} $boolType CHECK(${CompanySettingField.enableSalePricing} IN (0,1))
      )''');

      batch.execute('''
      CREATE TABLE IF NOT EXISTS  ${Tables.SalesPerson} (
      ${SalesPersonFiles.id} $idTypeNoAutoIncrement,
      ${SalesPersonFiles.companySlug} $textTypeNotNull,
      ${SalesPersonFiles.name} $textTypeNotNull,
      ${SalesPersonFiles.applicationUserId} $textType,
      ${SalesPersonFiles.cashAccountId} $integerType,
      ${SalesPersonFiles.receiveMoneySeries} $textType,
      ${SalesPersonFiles.saleOrderSeries} $textType,
      ${SalesPersonFiles.isOrderBooker} $boolType CHECK(${SalesPersonFiles.isOrderBooker} IN (0,1)),
      ${SalesPersonFiles.isDeliveryPerson} $boolType CHECK(${SalesPersonFiles.isDeliveryPerson} IN (0,1)),
      ${SalesPersonFiles.isSalesman} $boolType CHECK(${SalesPersonFiles.isSalesman} IN (0,1)),
      ${SalesPersonFiles.CanChangePrice} $boolType CHECK(${SalesPersonFiles.CanChangePrice} IN (0,1)),
      ${SalesPersonFiles.CanAddDiscount} $boolType CHECK(${SalesPersonFiles.CanAddDiscount} IN (0,1)),
      ${SalesPersonFiles.isSync} $boolType CHECK(${SalesPersonFiles.isSync} IN (0,1)),
      ${SalesPersonFiles.syncDate} $dateTimeType,
      ${SalesPersonFiles.branchId} $integerType,
      ${SalesPersonFiles.employeeId} $integerType,
      ${SalesPersonFiles.isActive} $boolType CHECK(${SalesPersonFiles.isActive} IN (0,1))
      )''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.NumberSerials} (
  ${NumberSerialsField.id} $idTypeNoAutoIncrement,
  ${NumberSerialsField.companySlug} $textTypeNotNull,
  ${NumberSerialsField.branchId} $integerType,
  ${NumberSerialsField.entityName} $textTypeNotNull,
  ${NumberSerialsField.series} $textTypeNotNull,
  ${NumberSerialsField.lastNumber} $textTypeNotNull, 
  ${NumberSerialsField.isDefault} $boolType CHECK(${NumberSerialsField.isDefault} IN (0,1)),
  ${NumberSerialsField.isSync} $boolType CHECK(${NumberSerialsField.isSync} IN (0,1)),
  ${NumberSerialsField.syncDate} $dateTimeType)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Regions} (
  ${RegionsField.id} $idTypeNoAutoIncrement,
  ${RegionsField.companySlug} $textTypeNotNull,
  ${RegionsField.name} $textTypeNotNull, 
  ${RegionsField.updatedOn} $dateTimeType, 
  ${RegionsField.isSync} $boolType CHECK(${RegionsField.isSync} IN (0,1)),
  ${RegionsField.syncDate} $dateTimeType)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Zones} (
  ${ZonesField.id} $idTypeNoAutoIncrement,
  ${ZonesField.companySlug} $textTypeNotNull,
  ${ZonesField.name} $textTypeNotNull, 
  ${ZonesField.updatedOn} $dateTimeType, 
  ${ZonesField.regionId} $integerType,
  ${ZonesField.isSync} $boolType CHECK(${ZonesField.isSync} IN (0,1)),
  ${ZonesField.syncDate} $dateTimeType,
  FOREIGN KEY (${ZonesField.regionId}) REFERENCES ${Tables.Regions} (id)
  )''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Territories} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Areas} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SubAreas} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.Schemes} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SchemeDetails} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SchemeBranches} (
  ${BranchesSchemesField.id} $idTypeNoAutoIncrement,
  ${BranchesSchemesField.companySlug} $textTypeNotNull,
  ${BranchesSchemesField.isSync} $boolType CHECK(${BranchesSchemesField.isSync} IN (0,1)),
  ${BranchesSchemesField.syncDate} $dateTimeType,
  ${BranchesSchemesField.updatedOn} $dateTimeType, 
  ${BranchesSchemesField.schemeId} $integerType,
  ${BranchesSchemesField.branchId} $integerType,
  FOREIGN KEY (${BranchesSchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id)
  )''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SchemeCustomerCategories} (
  ${CustomerCategoriesSchemesField.id} $idTypeNoAutoIncrement,
  ${CustomerCategoriesSchemesField.companySlug} $textTypeNotNull,
  ${CustomerCategoriesSchemesField.isSync} $boolType CHECK(${CustomerCategoriesSchemesField.isSync} IN (0,1)),
  ${CustomerCategoriesSchemesField.syncDate} $dateTimeType,
  ${CustomerCategoriesSchemesField.updatedOn} $dateTimeType, 
  ${CustomerCategoriesSchemesField.schemeId} $integerType,
  ${CustomerCategoriesSchemesField.customerCategoryId} $integerType,
  FOREIGN KEY (${CustomerCategoriesSchemesField.schemeId}) REFERENCES ${Tables.Schemes} (id)
  )''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SchemesSalesGeography} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.POSInvoiceDetailTaxes} (
  ${LineItemTaxField.id} $idTypeNoAutoIncrement,
  ${LineItemTaxField.companySlug} $textTypeNotNull,
  ${LineItemTaxField.isSync} $boolType CHECK(${LineItemTaxField.isSync} IN (0,1)),
  ${LineItemTaxField.syncDate} $dateTimeType,
  ${LineItemTaxField.posInvoiceDetailId} $integerType,
  ${LineItemTaxField.taxId} $integerType,
  ${LineItemTaxField.appliedOn} $integerType,
  ${LineItemTaxField.taxRate} $decimalType,
  ${LineItemTaxField.taxAmount} $decimalType,
  ${LineItemTaxField.sort} $integerType,
  ${LineItemTaxField.branchId} $integerType,
  ${LineItemTaxField.saleOrderDetailId} $integerType,
  FOREIGN KEY (${LineItemTaxField.taxId}) REFERENCES ${Tables.Tax} (id),
  FOREIGN KEY (${LineItemTaxField.posInvoiceDetailId}) REFERENCES ${Tables.POSInvoiceDetail} (id) ON DELETE CASCADE
)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.ProductSalesTax} (
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

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.ProductStocks} (
  ${ProductSockField.id} $idTypeNoAutoIncrement,
  ${ProductSockField.companySlug} $textTypeNotNull,
  ${ProductSockField.isSync} $boolType CHECK(${ProductSockField.isSync} IN (0,1)),
  ${ProductSockField.syncDate} $dateTimeType,
  ${ProductSockField.updatedOn} $dateTimeType,
  ${ProductSockField.productId} $integerType,
  ${ProductSockField.warehouseId} $integerType,
  ${ProductSockField.consignmentId} $integerType,
  ${ProductSockField.batchId} $integerType,
  ${ProductSockField.quantityInHand} $decimalType,
  ${ProductSockField.serialNumber} $textType,
  FOREIGN KEY (${ProductSockField.productId}) REFERENCES ${Tables.products} (id),
  FOREIGN KEY (${ProductSockField.warehouseId}) REFERENCES ${Tables.WareHouse} (id),
  FOREIGN KEY (${ProductSockField.batchId}) REFERENCES ${Tables.Batches} (id)
)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.SchemeInvoiceDiscount} (
  ${SchemeInvoiceDiscountField.id} $idType,
  ${SchemeInvoiceDiscountField.companySlug} $textTypeNotNull,
  ${SchemeInvoiceDiscountField.branchId} $integerType,
  ${SchemeInvoiceDiscountField.discountAmount} $decimalType,
  ${SchemeInvoiceDiscountField.discountPercent} $decimalType,
  ${SchemeInvoiceDiscountField.appliedOn} $integerType,
  ${SchemeInvoiceDiscountField.sort} $integerType,
  ${SchemeInvoiceDiscountField.discountType} $integerType,
  ${SchemeInvoiceDiscountField.discountId} $integerType,
  ${SchemeInvoiceDiscountField.schemeId} $integerType,
  ${SchemeInvoiceDiscountField.masterGroupId} $integerType,
  ${SchemeInvoiceDiscountField.currencyId} $integerType,
  ${SchemeInvoiceDiscountField.narration} $textType,
  ${SchemeInvoiceDiscountField.sourceCreatedOn} $dateTimeType,
  ${SchemeInvoiceDiscountField.source} $textType,
  ${SchemeInvoiceDiscountField.sourceId} $integerType
)''');

      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.BranchProductTaxes} (
  ${BranchProductTaxField.id} $idTypeNoAutoIncrement,
  ${BranchProductTaxField.companySlug} $textTypeNotNull,
  ${BranchProductTaxField.isSync} $boolType CHECK(${BranchProductTaxField.isSync} IN (0,1)),
  ${BranchProductTaxField.syncDate} $dateTimeType,
  ${BranchProductTaxField.productId} $integerType,
  ${BranchProductTaxField.taxId} $integerType,
  ${BranchProductTaxField.branchId} $integerType,
  ${BranchProductTaxField.source} $textType
)''');
      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.EndOfTheDay} (
  ${EndOfTheDayFields.id} $idTypeNoAutoIncrement,
  ${EndOfTheDayFields.companySlug} $textTypeNotNull,
  ${EndOfTheDayFields.endOfDayDate} $dateTimeType,
  ${BranchProductTaxField.branchId} $integerType
)''');
      batch.execute('''
  CREATE TABLE IF NOT EXISTS  ${Tables.TravelLogs} (
  ${TravelLogFiles.id} $idTypeNoAutoIncrement,
  ${TravelLogFiles.companySlug} $textTypeNotNull,
  ${TravelLogFiles.branchId} $integerType,
  ${TravelLogFiles.tripId} $integerType,
  ${TravelLogFiles.isSync} $boolType CHECK(${ProductSockField.isSync} IN (0,1)),
  ${TravelLogFiles.syncDate} $dateTimeType,
  ${TravelLogFiles.serverDateTime} $dateTimeType,
  ${TravelLogFiles.locationDateTime} $dateTimeType,
  ${TravelLogFiles.applicationUserId} $dateTimeType,
  ${TravelLogFiles.altitude} $decimalType,
  ${TravelLogFiles.heading} $decimalType,
  ${TravelLogFiles.speed} $decimalType,
  ${TravelLogFiles.altitudeAccuracy} $decimalType,
  ${TravelLogFiles.longitude} $decimalType,
  ${TravelLogFiles.latitude} $decimalType,
  ${TravelLogFiles.isIdle} $boolType CHECK(${TravelLogFiles.isIdle} IN (0,1))
)''');

      await db.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.saleOrderCart} (
      ${CartFields.id} $idType,
      ${CartFields.companySlug} $textTypeNotNull,
      ${CartFields.productName} $textTypeNotNull,
      ${CartFields.description} $textType,
      ${CartFields.qty} $integerTypeNotNull,
      ${CartFields.price} $decimalType,
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
      ${CartFields.purchasePrice} $decimalType,
      ${CartFields.maximumRetailPrice} $decimalType,
      ${CartFields.isAppliedScheme} $boolType CHECK(${CartFields.isAppliedScheme} IN (0,1)),
      ${CartFields.isNew} $boolType CHECK(${CartFields.isNew} IN (0,1)),
      ${CartFields.isMRPExclusiveTax} $boolType CHECK(${CartFields.isMRPExclusiveTax} IN (0,1)),
      ${CartFields.isProductScheme} $boolType CHECK(${CartFields.isProductScheme} IN (0,1)),
      ${CartFields.fractionalUnit} $boolType CHECK(${CartFields.fractionalUnit} IN (0,1)),
      FOREIGN KEY (${CartFields.productId}) REFERENCES ${Tables.products} (id),
      FOREIGN KEY (${CartFields.customerId}) REFERENCES ${Tables.Customer} (id),
      FOREIGN KEY (${CartFields.salesPersonId}) REFERENCES ${Tables.SalesPerson} (id)
      )''');

      await db.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.saleOrderCartDetail} (
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
      ${CartDiscountFields.isSync} $boolType CHECK(${CartDiscountFields.isSync} IN (0,1)),      
      FOREIGN KEY (${CartDiscountFields.cartId}) REFERENCES ${Tables.saleOrderCartDetail} (id) ON DELETE CASCADE,
      FOREIGN KEY (${CartDiscountFields.discountId}) REFERENCES ${Tables.Discount} (id)
      )''');

      await db.execute('''
    CREATE TABLE IF NOT EXISTS  ${Tables.Attachments} (
    ${AttachmentsModelFields.id} $idTypeNoAutoIncrement,
    ${AttachmentsModelFields.companySlug} $textTypeNotNull,
    ${AttachmentsModelFields.date} $dateTimeType,
    ${AttachmentsModelFields.updatedOn} $dateTimeType,
    ${AttachmentsModelFields.attachInEmail} $textType,
    ${AttachmentsModelFields.path} $textTypeNotNull,
    ${AttachmentsModelFields.name} $textType,
    ${AttachmentsModelFields.source} $textTypeNotNull,
    ${AttachmentsModelFields.sourceId} $integerType
  )''');

      batch.execute('''
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
    ''');

      batch.execute(CreateWarehouseTableQuery());
      batch.execute(CreateTripsTableQuery());
      batch.execute(CreateSaleOrderTableQuery());
      batch.execute(CreateSaleOrderDetailTableQuery());
      batch.execute(CreateSaleOrderDetailDiscountTableQuery());
      batch.execute(CreateSaleOrderDetailTaxTableQuery());

      batch.execute(CreateSalePricingAreasModelTableQuery());
      batch.execute(CreateSalePricingBranchTableQuery());
      batch.execute(CreateSalePricingCustomerCategoryTableQuery());
      batch.execute(CreateSalePricingCustomerTableQuery());
      batch.execute(CreateSalePricingRegionsTableQuery());
      batch.execute(CreateSalePricingSubAreasTableQuery());
      batch.execute(CreateSalePricingTerritoriesTableQuery());
      batch.execute(CreateSalePricingZonesTableQuery());
      batch.execute(CreateSalePricingDetaisTableQuery());
      batch.execute(CreateSalePricingTableQuery());

      await batch.commit();
    } catch (ex) {
      log("DB $ex");
    }
  }

  @override
  Future<void> onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await addColumnIfNotExists(db, Tables.products, ProductFields.isForSale, boolType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.allowDuplicateProducts, boolType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.OrderDateFilter, integerType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.textField1Value, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.textField2Value, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.textField1Caption, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.textField2Caption, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.address1, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.address2, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.city, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.state, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.zip, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.countryId, integerType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.phone, textType);
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.enableNarration, boolType);
      await addColumnIfNotExists(db, Tables.Customer, CustomerFields.latitude, decimalType);
      await addColumnIfNotExists(db, Tables.Customer, CustomerFields.base64ImageString, textType);
      await addColumnIfNotExists(db, Tables.Customer, CustomerFields.imageUrl, textType);
      await addColumnIfNotExists(db, Tables.Customer, CustomerFields.longitude, decimalType);
      await addColumnIfNotExists(db, Tables.TravelLogs, TravelLogFiles.isIdle, boolType);
      await addColumnIfNotExists(db, Tables.Trips, TripFiles.updatedOn, textType);
      await addColumnIfNotExists(db, Tables.Trips, TripFiles.tripId, integerType);
      await addColumnIfNotExists(db, Tables.Trips, TripFiles.isNew, boolType);
      await addColumnIfNotExists(db, Tables.Trips, TripFiles.isEdit, boolType);
      await addColumnIfNotExists(db, Tables.SalesPerson, SalesPersonFiles.employeeId, integerType);
      await db.execute(CreateWarehouseTableQuery());
      await db.execute(CreateTripsTableQuery());
      await addColumnIfNotExists(db, Tables.CompanySetting, CompanySettingField.enableSalePricing, boolType);

      await db.execute(CreateTripsTableQuery());
      await db.execute(CreateSaleOrderTableQuery());
      await db.execute(CreateSaleOrderDetailTableQuery());
      await db.execute(CreateSaleOrderDetailDiscountTableQuery());
      await db.execute(CreateSaleOrderDetailTaxTableQuery());

      await db.execute(CreateSalePricingAreasModelTableQuery());
      await db.execute(CreateSalePricingBranchTableQuery());
      await db.execute(CreateSalePricingCustomerCategoryTableQuery());
      await db.execute(CreateSalePricingCustomerTableQuery());
      await db.execute(CreateSalePricingRegionsTableQuery());
      await db.execute(CreateSalePricingSubAreasTableQuery());
      await db.execute(CreateSalePricingTerritoriesTableQuery());
      await db.execute(CreateSalePricingZonesTableQuery());
      await db.execute(CreateSalePricingDetaisTableQuery());
      await db.execute(CreateSalePricingTableQuery());
    }
  }

  Future<void> addColumnIfNotExists(Database db, String tableName, String columnName, String columnType) async {
    final result = await db.rawQuery('PRAGMA table_info($tableName)');
    bool columnExists = result.any((column) => column['name'] == columnName);

    if (!columnExists) {
      await db.execute('ALTER TABLE $tableName ADD COLUMN $columnName $columnType');
    }
  }

  String CreateWarehouseTableQuery() {
    return '''
    CREATE TABLE IF NOT EXISTS ${Tables.WareHouse} (
      ${WarehouseField.id} $idTypeNoAutoIncrement,
      ${WarehouseField.companySlug} $textTypeNotNull,
      ${WarehouseField.name} $textTypeNotNull,
      ${WarehouseField.isDefault} $boolType CHECK(${WarehouseField.isDefault} IN (0,1)),
      ${WarehouseField.isTransit} $boolType CHECK(${WarehouseField.isTransit} IN (0,1)),
      ${WarehouseField.isActive} $boolType CHECK(${WarehouseField.isActive} IN (0,1)),
      ${WarehouseField.branchId} $integerType,
      ${WarehouseField.updatedOn} $dateTimeType,
      ${WarehouseField.isSync} $boolType CHECK(${WarehouseField.isSync} IN (0,1)),
      ${WarehouseField.address1} $textType,
      ${WarehouseField.address2} $textType,
      ${WarehouseField.zip} $textType,
      ${WarehouseField.state} $textType,
      ${WarehouseField.city} $textType,
      ${WarehouseField.contactPerson} $textType,
      ${WarehouseField.countryId} $integerType,
      ${WarehouseField.phone} $textType,
      ${WarehouseField.fax} $textType,
      ${WarehouseField.email} $textType);
     ''';
  }

  String CreateTripsTableQuery() {
    return '''
    CREATE TABLE IF NOT EXISTS ${Tables.Trips} (
     ${TripFiles.id} $idTypeNoAutoIncrement,
     ${TripFiles.companySlug} $textTypeNotNull,
     ${TripFiles.branchId} $integerType,
     ${TripFiles.tripId} $integerType,
     ${TripFiles.isSync} $boolType CHECK(${TripFiles.isSync} IN (0,1)),
     ${TripFiles.isNew} $boolType CHECK(${TripFiles.isNew} IN (0,1)),
     ${TripFiles.isEdit} $boolType CHECK(${TripFiles.isEdit} IN (0,1)),
     ${TripFiles.syncDate} $dateTimeType,
     ${TripFiles.startDate} $dateTimeType,
     ${TripFiles.updatedOn} $textType,
     ${TripFiles.endDate} $dateTimeType,
     ${TripFiles.applicationUserId} $textType,
     ${TripFiles.travelStatus} $integerType);
     ''';
  }

  String CreateSaleOrderTableQuery() {
    return '''
    CREATE TABLE IF NOT EXISTS ${Tables.saleOrder} (
      ${SaleOrderModelField.id} $idType,
      ${SaleOrderModelField.companySlug} $textTypeNotNull,
      ${SaleOrderModelField.saleQuotationId} $integerType,
      ${SaleOrderModelField.saleOrderId} $integerType,
      ${SaleOrderModelField.saleDeliveryId} $integerType,
      ${SaleOrderModelField.customerId} $integerType,
      ${SaleOrderModelField.currencyId} $integerType,
      ${SaleOrderModelField.exchangeRate} $decimalType,
      ${SaleOrderModelField.shippingAddress} $textType,
      ${SaleOrderModelField.billingAddress} $textType,
      ${SaleOrderModelField.number} $decimalType,
      ${SaleOrderModelField.date} $dateTimeType,
      ${SaleOrderModelField.deliveryDate} $dateTimeType,
      ${SaleOrderModelField.reference} $textType,
      ${SaleOrderModelField.accountId} $integerType,
      ${SaleOrderModelField.paymentReference} $textType,
      ${SaleOrderModelField.comments} $textType,
      ${SaleOrderModelField.grossAmount} $decimalType,
      ${SaleOrderModelField.taxAmount} $decimalType,
      ${SaleOrderModelField.discountPercent} $decimalType,
      ${SaleOrderModelField.discountAmount} $decimalType,
      ${SaleOrderModelField.otherCharges} $decimalType,
      ${SaleOrderModelField.netAmount} $decimalType,
      ${SaleOrderModelField.paidAmount} $decimalType,
      ${SaleOrderModelField.receivedAmount} $decimalType,
      ${SaleOrderModelField.status} $integerType,
      ${SaleOrderModelField.autoRoundOff} $decimalType,
      ${SaleOrderModelField.manualRoundOff} $decimalType,
      ${SaleOrderModelField.masterGroupId} $integerType,
      ${SaleOrderModelField.shippingCharges} $decimalType,
      ${SaleOrderModelField.time} $dateTimeType,
      ${SaleOrderModelField.userId} $guidType,
      ${SaleOrderModelField.deliveryPersonId} $integerType,
      ${SaleOrderModelField.orderBookerId} $integerType,
      ${SaleOrderModelField.salesmanId} $integerType,
      ${SaleOrderModelField.series} $textType,
      ${SaleOrderModelField.subject} $textType,
      ${SaleOrderModelField.narration} $textType,
      ${SaleOrderModelField.branchId} $integerType,
      ${SaleOrderModelField.createdOn} $dateTimeType,
      ${SaleOrderModelField.createdBy} $guidType,
      ${SaleOrderModelField.deliveriesCount} $integerType,
      ${SaleOrderModelField.invoicesCount} $integerType,
      ${SaleOrderModelField.isAppliedScheme} $boolType CHECK(${SaleOrderModelField.isAppliedScheme} IN (0,1)),
      ${SaleOrderModelField.isSync} $boolType CHECK(${SaleOrderModelField.isSync} IN (0,1)),
      ${SaleOrderModelField.isNew} $boolType CHECK(${SaleOrderModelField.isNew} IN (0,1)),
      ${SaleOrderModelField.isEdit} $boolType CHECK(${SaleOrderModelField.isEdit} IN (0,1)),
      ${SaleOrderModelField.updatedOn} $dateTimeType,
      ${SaleOrderModelField.isDeleted} $boolType CHECK(${SaleOrderModelField.isDeleted} IN (0,1)),
      FOREIGN KEY (${SaleOrderModelField.accountId}) REFERENCES ${Tables.accounts} (id),
      FOREIGN KEY (${SaleOrderModelField.masterGroupId}) REFERENCES ${Tables.MasterGroup} (id),
      FOREIGN KEY (${SaleOrderModelField.currencyId}) REFERENCES ${Tables.Currency} (id),
      FOREIGN KEY (${SaleOrderModelField.salesmanId}) REFERENCES ${Tables.SalesPerson} (id)
      )''';
  }

  String CreateSaleOrderDetailTableQuery() {
    return '''
    CREATE TABLE IF NOT EXISTS ${Tables.saleOrderDetail} (
      ${SaleOrderDetailField.id} $idTypeNoAutoIncrement,
      ${SaleOrderDetailField.companySlug} $textTypeNotNull,
      ${SaleOrderDetailField.saleOrderId} $integerType,
      ${SaleOrderDetailField.productId} $integerType,
      ${SaleOrderDetailField.accountId} $integerType,
      ${SaleOrderDetailField.description} $textType,
      ${SaleOrderDetailField.quantity} $decimalType,
      ${SaleOrderDetailField.price} $decimalType,
      ${SaleOrderDetailField.discountInPercent} $decimalType,
      ${SaleOrderDetailField.grossAmount} $decimalType,
      ${SaleOrderDetailField.taxAmount} $decimalType,
      ${SaleOrderDetailField.discountAmount} $decimalType,
      ${SaleOrderDetailField.netAmount} $decimalType,
      ${SaleOrderDetailField.packingDetail} $textType,
      ${SaleOrderDetailField.detailBGroupId} $integerType,
      ${SaleOrderDetailField.detailAGroupId} $integerType,
      ${SaleOrderDetailField.quantityCalculation} $textType,
      ${SaleOrderDetailField.batchId} $integerType,
      ${SaleOrderDetailField.remainingQuantity} $integerType ,
      ${SaleOrderDetailField.serialNumber} $textType,
      ${SaleOrderDetailField.isMRPExclusiveTax} $boolType CHECK(${SaleOrderDetailField.isMRPExclusiveTax} IN (0,1)),
      ${SaleOrderDetailField.purchasePrice} $decimalType,
      ${SaleOrderDetailField.maximumRetailPrice} $decimalType,
      ${SaleOrderDetailField.consignmentId} $integerType,
      ${SaleOrderDetailField.branchId} $integerType,
      ${SaleOrderDetailField.isBonusProduct} $boolType CHECK(${SaleOrderDetailField.isBonusProduct} IN (0,1)),
      ${SaleOrderDetailField.tagPrice} $decimalType,
      ${SaleOrderDetailField.totalSavedAmount} $decimalType,      
      ${SaleOrderDetailField.posPaymentMode} $integerType,      
      ${SaleOrderDetailField.amount} $decimalType,
      ${SaleOrderDetailField.isInitial} $boolType CHECK(${SaleOrderDetailField.isInitial} IN (0,1)),      
      FOREIGN KEY (${SaleOrderDetailField.accountId}) REFERENCES ${Tables.accounts} (id),
      FOREIGN KEY (${SaleOrderDetailField.detailAGroupId}) REFERENCES ${Tables.DetailAGroup} (id),
      FOREIGN KEY (${SaleOrderDetailField.detailBGroupId}) REFERENCES ${Tables.DetailBGroup} (id),
      FOREIGN KEY (${SaleOrderDetailField.productId}) REFERENCES ${Tables.products} (id),
      FOREIGN KEY (${SaleOrderDetailField.saleOrderId}) REFERENCES ${Tables.saleOrder} (id) ON DELETE CASCADE)''';
  }

  String CreateSaleOrderDetailDiscountTableQuery() {
    return '''
   CREATE TABLE IF NOT EXISTS ${Tables.saleOrderDiscount} (
  ${SaleOrderDiscountsField.id} $idTypeNoAutoIncrement,
  ${SaleOrderDiscountsField.companySlug} $textTypeNotNull,
  ${SaleOrderDiscountsField.saleOrderDetailId} $integerType,
  ${SaleOrderDiscountsField.discountId} $integerType,
  ${SaleOrderDiscountsField.discountInPrice} $decimalType,
  ${SaleOrderDiscountsField.discountInPercent} $decimalType,
  ${SaleOrderDiscountsField.discountInAmount} $decimalType,
  ${SaleOrderDiscountsField.discountAmount} $decimalType,
  ${SaleOrderDiscountsField.totalSavedAmount} $decimalType,
  ${SaleOrderDiscountsField.appliedOn} $integerType,
  ${SaleOrderDiscountsField.sort} $integerType,
  ${SaleOrderDiscountsField.schemeId} $integerType,
  ${SaleOrderDiscountsField.schemeDetailId} $integerType,
  ${SaleOrderDiscountsField.branchId} $integerType,
  ${SaleOrderDiscountsField.discountType} $integerType,
  FOREIGN KEY (${SaleOrderDiscountsField.saleOrderDetailId}) REFERENCES ${Tables.saleOrderDetail} (id),
  FOREIGN KEY (${SaleOrderDiscountsField.discountId}) REFERENCES ${Tables.Discount} (id),
  FOREIGN KEY (${SaleOrderDiscountsField.schemeId}) REFERENCES ${Tables.Schemes} (id),
  FOREIGN KEY (${SaleOrderDiscountsField.schemeDetailId}) REFERENCES ${Tables.SchemeDetails} (id),
  FOREIGN KEY (${SaleOrderDiscountsField.saleOrderDetailId}) REFERENCES ${Tables.saleOrderDetail} (id) ON DELETE CASCADE
  )''';
  }

  String CreateSaleOrderDetailTaxTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.saleOrderDetailTax} (
  ${LineItemTaxField.id} $idTypeNoAutoIncrement,
  ${LineItemTaxField.companySlug} $textTypeNotNull,
  ${LineItemTaxField.isSync} $boolType CHECK(${LineItemTaxField.isSync} IN (0,1)),
  ${LineItemTaxField.syncDate} $dateTimeType,
  ${LineItemTaxField.saleOrderDetailId} $integerType,
  ${LineItemTaxField.taxId} $integerType,
  ${LineItemTaxField.appliedOn} $integerType,
  ${LineItemTaxField.taxRate} $decimalType,
  ${LineItemTaxField.taxAmount} $decimalType,
  ${LineItemTaxField.sort} $integerType,
  ${LineItemTaxField.branchId} $integerType,
  ${LineItemTaxField.posInvoiceDetailId} $integerType,
  FOREIGN KEY (${LineItemTaxField.taxId}) REFERENCES ${Tables.Tax} (id),
  FOREIGN KEY (${LineItemTaxField.saleOrderDetailId}) REFERENCES ${Tables.saleOrderDetail} (id) ON DELETE CASCADE
)''';
  }

  String CreateSalePricingAreasModelTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingAreas} (
  ${SalePricingAreaFields.id} $idTypeNoAutoIncrement,
  ${SalePricingAreaFields.companySlug} $textTypeNotNull,
  ${SalePricingAreaFields.isSync} $boolType CHECK(${SalePricingAreaFields.isSync} IN (0,1)),
  ${SalePricingAreaFields.syncDate} $dateTimeType,
  ${SalePricingAreaFields.salePricingId} $integerType,
  ${SalePricingAreaFields.areaId} $integerType
)''';
  }

  String CreateSalePricingBranchTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingBranches} (
  ${SalePricingBranchFields.id} $idTypeNoAutoIncrement,
  ${SalePricingBranchFields.companySlug} $textTypeNotNull,
  ${SalePricingBranchFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingBranchFields.syncDate} $dateTimeType,
  ${SalePricingBranchFields.salePricingId} $integerType,
  ${SalePricingBranchFields.branchId} $integerType
)''';
  }

  String CreateSalePricingCustomerCategoryTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingCustomerCategories} (
  ${SalePricingCustomerCategoryFields.id} $idTypeNoAutoIncrement,
  ${SalePricingCustomerCategoryFields.companySlug} $textTypeNotNull,
  ${SalePricingCustomerCategoryFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingCustomerCategoryFields.syncDate} $dateTimeType,
  ${SalePricingCustomerCategoryFields.salePricingId} $integerType,
  ${SalePricingCustomerCategoryFields.customerCategoryId} $integerType
)''';
  }

  String CreateSalePricingCustomerTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingCustomer} (
  ${SalePricingCustomerFields.id} $idTypeNoAutoIncrement,
  ${SalePricingCustomerFields.companySlug} $textTypeNotNull,
  ${SalePricingCustomerFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingCustomerFields.syncDate} $dateTimeType,
  ${SalePricingCustomerFields.salePricingId} $integerType,
  ${SalePricingCustomerFields.customerId} $integerType
)''';
  }

  String CreateSalePricingRegionsTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingRegions} (
  ${SalePricingRegionsFields.id} $idTypeNoAutoIncrement,
  ${SalePricingRegionsFields.companySlug} $textTypeNotNull,
  ${SalePricingRegionsFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingRegionsFields.syncDate} $dateTimeType,
  ${SalePricingRegionsFields.salePricingId} $integerType,
  ${SalePricingRegionsFields.regionId} $integerType
)''';
  }

  String CreateSalePricingSubAreasTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalePricingSubAreas} (
  ${SalePricingSubAreasFields.id} $idTypeNoAutoIncrement,
  ${SalePricingSubAreasFields.companySlug} $textTypeNotNull,
  ${SalePricingSubAreasFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingSubAreasFields.syncDate} $dateTimeType,
  ${SalePricingSubAreasFields.salePricingId} $integerType,
  ${SalePricingSubAreasFields.subAreaId} $integerType
)''';
  }

  String CreateSalePricingTerritoriesTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS ${Tables.SalePricingTerritories} (
  ${SalePricingTerritoriesFields.id} $idTypeNoAutoIncrement,
  ${SalePricingTerritoriesFields.companySlug} $textTypeNotNull,
  ${SalePricingTerritoriesFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingTerritoriesFields.syncDate} $dateTimeType,
  ${SalePricingTerritoriesFields.salePricingId} $integerType,
  ${SalePricingTerritoriesFields.territoryId} $integerType
)''';
  }

  String CreateSalePricingZonesTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS ${Tables.SalePricingZones} (
  ${SalePricingZonesFields.id} $idTypeNoAutoIncrement,
  ${SalePricingZonesFields.companySlug} $textTypeNotNull,
  ${SalePricingZonesFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingZonesFields.syncDate} $dateTimeType,
  ${SalePricingZonesFields.salePricingId} $integerType,
  ${SalePricingZonesFields.zoneId} $integerType
)''';
  }

  String CreateSalePricingDetaisTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS ${Tables.SalesPriceDetail} (
  ${SalePricingDetailFields.id} $idTypeNoAutoIncrement,
  ${SalePricingDetailFields.companySlug} $textTypeNotNull,
  ${SalePricingDetailFields.isSync} $boolType CHECK(${SalePricingBranchFields.isSync} IN (0,1)),
  ${SalePricingDetailFields.syncDate} $dateTimeType,
  ${SalePricingDetailFields.salePricingId} $integerType,
  ${SalePricingDetailFields.productId} $integerType,
  ${SalePricingDetailFields.price} $decimalType
)''';
  }

  String CreateSalePricingTableQuery() {
    return '''
  CREATE TABLE IF NOT EXISTS  ${Tables.SalesPrice} (
  ${SalePricingFields.id} $idTypeNoAutoIncrement,
  ${SalePricingFields.companySlug} $textTypeNotNull,
  ${SalePricingFields.isSync} $boolType CHECK(${SalePricingFields.isSync} IN (0,1)),
  ${SalePricingFields.syncDate} $dateTimeType,
  ${SalePricingFields.series} $textType,
  ${SalePricingFields.number} $textType,
  ${SalePricingFields.name} $textType,
  ${SalePricingFields.startDate} $dateTimeType,
  ${SalePricingFields.endDate} $dateTimeType,
  ${SalePricingFields.currencyId} $integerType,
  ${SalePricingFields.isActive} $boolType CHECK(${SalePricingFields.isActive} IN (0,1)),
  ${SalePricingFields.reference} $textType,
  ${SalePricingFields.forFranchise} $boolType CHECK(${SalePricingFields.forFranchise} IN (0,1)),
  ${SalePricingFields.isReverted} $boolType CHECK(${SalePricingFields.isReverted} IN (0,1)),
  ${SalePricingFields.isApplied} $boolType CHECK(${SalePricingFields.isApplied} IN (0,1)),
  ${SalePricingFields.status} $integerType

)''';
  }
}
