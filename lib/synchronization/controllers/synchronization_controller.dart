// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sa_common/schemes/controllers/product_controller.dart';
// import '../../Controller/BaseController.dart';
// import '../../SyncSetting/Database.dart';
// import '../../SyncSetting/model.dart';
// import '../../company/Database/company_setting_database.dart';
// import '../../company/controllers/company_controller.dart';
// import '../../schemes/Database/PosInvoiceDetailTaxes_database.dart';
// import '../../schemes/controllers/areas_controller.dart';
// import '../../schemes/controllers/regions_controller.dart';
// import '../../schemes/controllers/schemes_controller.dart';
// import '../../schemes/controllers/subAreas_controller.dart';
// import '../../schemes/controllers/tax_Controller.dart';
// import '../../schemes/controllers/territories_controller.dart';
// import '../../schemes/controllers/zones_controller .dart';
// import '../../schemes/models/SchemeInvoiceDiscountDtoModel.dart';
// import '../../synchronization/controllers/country_controller.dart';
// import '../../synchronization/controllers/currency_controller.dart';
// import '../../synchronization/controllers/customerCategory_controller.dart';
// import '../../synchronization/controllers/detailAGroup_controller.dart';
// import '../../utils/Helper.dart';
// import '../../utils/Logger.dart';
// import '../../utils/TablesName.dart';
// import '../Database/customer_database.dart';
// import '../Models/CustomerModel.dart';
// import 'account_controller.dart';
// import 'package:http/http.dart' as http;
// import 'customerLoyaltyPointBalance_controller.dart';
// import 'detailBGroup_controller.dart';
// import 'masterGroup_controller.dart';
// import 'numberSerial_controller.dart';

// class SynchronizationController extends BaseController {
//   var isLoading = true.obs;
//   String _loaderText = "Please Wait";

//   String get loaderText => _loaderText;

//   void LoaderText(String msgText) {
//     _loaderText = msgText;
//     update();
//   }

//   ProductCategoriesController productCategoriesController =
//       Get.put(ProductCategoriesController());
//   UnitController unitController = Get.put(UnitController());
//   TaxController taxController = Get.put(TaxController());
//   ProductController productController = Get.put(ProductController());

//   CountryController countryController = Get.put(CountryController());
//   CurrencyController currencyController = Get.put(CurrencyController());
//   CustomerCategoryController customerCategoryController =
//       Get.put(CustomerCategoryController());
//   CustomerController customerController = Get.put(CustomerController());

//   MasterGroupController masterGroupController =
//       Get.put(MasterGroupController());
//   DetailAGroupController detailAGroupController =
//       Get.put(DetailAGroupController());
//   DetailBGroupController detailBGroupController =
//       Get.put(DetailBGroupController());

//   AccountController accountController = Get.put(AccountController());
//   CartController cartController = Get.put(CartController());
//   SalesPersonController salesPersonController =
//       Get.put(SalesPersonController());
//   PosCashRegisterController posCashRegisterController =
//       Get.put(PosCashRegisterController());
//   WareHousesController wareHousesController = Get.put(WareHousesController());
//   RegionsController regionsController = Get.put(RegionsController());
//   ZonesController zonesController = Get.put(ZonesController());
//   AreasController areasController = Get.put(AreasController());
//   SubAreasController subareasController = Get.put(SubAreasController());
//   TerritoriesController territoriesController =
//       Get.put(TerritoriesController());
//   SchemesController schemesController = Get.put(SchemesController());
//   NumberSerialController numberSerialController =
//       Get.put(NumberSerialController());

//   BatchesController batchesController = Get.put(BatchesController());
//   ProductStocksController productStocksController =
//       Get.put(ProductStocksController());
//   TransactionController transactionController =
//       Get.put(TransactionController());
//   TemplateDefinitionController templateDefinitionController =
//       Get.put(TemplateDefinitionController());
//   CustomerLoyaltyPointBalanceController customerLoyaltyPointBalanceController =
//       Get.put(CustomerLoyaltyPointBalanceController());
//   CompanyController companyController = Get.put(CompanyController());
//   EndOfTheDayController endOfTheDayController =
//       Get.put(EndOfTheDayController());

//   Future<void> syncFromServerData() async {
//     try {
//       await Helper.UserData();
//       var user = Helper.user;
//       await companyController.GetCompany();
//       var companySetting = await CompanySettingDatabase().GetCompany();
//       LoaderText("Downloading Units");
//       DialogHelper.showLoading();
//       await unitController.GetAllUnits(user.companyId!, user.branchId!);
//       LoaderText("Downloading Tax");
//       await taxController.GetAllTax(user.companyId!, user.branchId!);
//       LoaderText("Downloading Product Categories");
//       await productCategoriesController.GetAllProductCategories(
//           user.companyId!);
//       await productCategoriesController.DeleteProductCategories(
//           user.companyId!);
//       LoaderText("Downloading Products");
//       await productController.GetAllProduct(user.companyId!, user.branchId!, 1);
//       await productController.DeleteProduct(user.companyId!, user.branchId!);
//       LoaderText("Downloading Countries");
//       await countryController.Pull(user.companyId!, user.branchId!);
//       LoaderText("Downloading Currencies");
//       await currencyController.Pull(user.companyId!, user.branchId!);
//       LoaderText("Downloading Customer Categories");
//       await customerCategoryController.Pull(user.companyId!, user.branchId!);
//       await customerCategoryController.Delete(user.companyId!, user.branchId!);
//       LoaderText("Downloading Customers");
//       await customerController.Pull(user.companyId!, user.branchId!);
//       await customerController.Delete(user.companyId!, user.branchId!);
//       if (companySetting!.enableMasterGroups) {
//         LoaderText("${companySetting.masterGroupCaption}");
//         await masterGroupController.Pull(user.companyId!, user.branchId!);
//         await masterGroupController.Delete(user.companyId!, user.branchId!);
//       }
//       if (companySetting.enableDetailAGroups) {
//         LoaderText("${companySetting.detailAGroupCaption}");
//         await detailAGroupController.Pull(user.companyId!, user.branchId!);
//         await detailAGroupController.Delete(user.companyId!, user.branchId!);
//       }
//       if (companySetting.enableDetailBGroups) {
//         LoaderText("${companySetting.detailBGroupCaption}");
//         await detailBGroupController.Pull(user.companyId!);
//         await detailBGroupController.Delete(user.companyId!);
//       }
//       LoaderText("Downloading Accounts");
//       await accountController.Pull(user.companyId!, user.branchId!);
//       await accountController.Delete(user.companyId!, user.branchId!);
//       LoaderText("Downloading Discounts");
//       await cartController.DiscountPull(user.companyId!);
//       await cartController.DiscountDelete(user.companyId!);
//       LoaderText("Downloading Sales Person");
//       await salesPersonController.Pull(user.companyId!, user.branchId!);
//       await salesPersonController.Delete(user.companyId!);
//       LoaderText("Downloading Warehouses");
//       await wareHousesController.pull(user.companyId!);
//       LoaderText("Downloading Pos Cash Register");
//       await posCashRegisterController.Pull(user.companyId!, user.branchId!);
//       LoaderText("Downloading Regions");
//       await regionsController.Pull(user.companyId!);
//       LoaderText("Downloading Zones");
//       await zonesController.Pull(user.companyId!);
//       LoaderText("Downloading Areas");
//       await areasController.Pull(user.companyId!);
//       LoaderText("Downloading Subareas");
//       await subareasController.Pull(user.companyId!);
//       LoaderText("Downloading Territories");
//       await territoriesController.Pull(user.companyId!);
//       LoaderText("Downloading Schemes");
//       await schemesController.Pull(user.companyId!, user.branchId!);
//       LoaderText("Downloading Template Definition");
//       await templateDefinitionController.Pull(user.companyId!);
//       // if (companySetting.enableCustomerLoyaltyPoints) {
//       //   LoaderText("Customer Loyalty Points");
//       //   await customerLoyaltyPointBalanceController.Pull(user.companyId!);
//       // }
//       LoaderText("Please Wait");
//       endOfTheDayController.GetLastEndOfTheDayLocal();
//       var syncDb = SyncSettingDatabase.dao;

//       var syncDate = await syncDb.SelectSingle(
//           '''tableName = '${Tables.POSInvoice}' and branchId = ${user.branchId} ''');

//       if (syncDate == null) {
//         var sync = SyncSettingModel(
//             tableName: Tables.POSInvoice,
//             branchId: user.branchId,
//             companySlug: user.companyId,
//             syncDate: DateTime.now(),
//             isSync: true);
//         await syncDb.insert(sync);
//       }
//       // DialogHelper.showLoading("Downloading Batches");
//       // await batchesController.Pull(user.companyId!);
//       // DialogHelper.showLoading("Downloading ProductStocks");
//       // await productStocksController.Pull(user.companyId!, user.branchId!);
//       // DialogHelper.showLoading("Downloading Transactions");
//       // await transactionController.Pull(user.companyId!, user.branchId!);
//       await Helper.FillLists();
//       DialogHelper.hideLoading();
//       isLoading.value = false;
//     } catch (ex) {
//       isLoading.value = true;
//       DialogHelper.hideLoading();
//       Logger.ErrorLog("All Sync $ex");
//       // // Get.toNamed(Routes.LOGIN);
//       // Get.snackbar(
//       //   'Session Expired',
//       //   'You are already logged in another session',
//       //   duration: Duration(seconds: 3),
//       // );
//       throw ex;
//     }
//   }

//   Future<void> PushPOSCashRegister() async {
//     try {
//       Logger.InfoLog("POSCashRegister push to server from local start");
//       String deviceId = await Helper.GetDeviceId();
//       var posCashLog = await PosCashRegisterDatabase.dao
//           .SelectSingle("macAddress = '$deviceId' and isActive = 1 ");
//       if (posCashLog != null) {
//         var posSummaries = await PosSummeryDatabase.dao.SelectList(
//             "posCashRegisterId = ${posCashLog.id} and cashRegisterSessionId is not null");
//         var posCashRegisterLog = await PosCashRegisterLogDatabase.dao.SelectList(
//             "cashRegisterId = ${posCashLog.id} and cashRegisterSessionId is not null and userId is not null");
//         print("posCashRegisterLog $posCashRegisterLog");
//         print("Summery $posSummaries");
//       }
//     } catch (ex) {
//       Logger.InfoLog(
//           "POSCashRegister push to server from local catch exception");
//     }
//   }

//   Future<bool> PushInvoice(POSSummeryModel summeryModel, UserModel user,
//       Map<String, String> header) async {
//     try {
//       Logger.InfoLog("Invoice push to server from local start");
//       var posInvoices = await POSInvoiceDatabase.dao.SelectList(
//           "cashRegisterSessionId = '${summeryModel.cashRegisterSessionId}' and isSync = 0");
//       if (posInvoices == null) {
//         Logger.InfoLog("Invoice push to server from no invoice found");
//         return true;
//       }

//       List<Map<String, dynamic>> lstModel = [];
//       // List<SalesInvoiceModel> lstModel = [];
//       SalesInvoiceModel model =
//           SalesInvoiceModel(invoiceDetails: [], posPaymentDetails: []);
//       List<SalesInvoiceDetailModel> detailModel = [];

//       for (var posInvoice in posInvoices) {
//         model = SalesInvoiceModel(invoiceDetails: [], posPaymentDetails: []);
//         detailModel = [];
//         var invoiceDetails = await POSInvoiceDetailDatabase.dao
//             .SelectList("saleInvoiceId = ${posInvoice.id} order by id desc");
//         if (invoiceDetails == null) {
//           Logger.InfoLog("POS Invoice Details no invoice found");
//           return false;
//         }
//         var posInvoicePayment =
//             await POSInvoicePaymentDatabase.Get(posInvoice.id!);

//         var schemeDiscounts = await schemeInvoiceDiscountDatabase.dao
//             .SelectList("sourceId = ${posInvoice.id}");

//         for (var posInvoiceDetail in invoiceDetails) {
//           var salesInvoiceDetail = SalesInvoiceDetailModel.fromMap(
//               posInvoiceDetail.toMap(),
//               slug: user.companyId);
//           salesInvoiceDetail.branchId = user.branchId;

//           var salesInvoiceDetailDiscount =
//               await POSInvoiceDetailDiscountDatabase.dao
//                   .SelectList("posInvoiceDetailId = ${posInvoiceDetail.id}");
//           if (salesInvoiceDetailDiscount != null)
//             salesInvoiceDetail.discounts = salesInvoiceDetailDiscount;

//           var posInvoiceDetailTaxes = await PosInvoiceDetailTaxesDatabase.dao
//               .SelectList("posInvoiceDetailId = ${posInvoiceDetail.id}");
//           if (posInvoiceDetailTaxes != null) {
//             if (salesInvoiceDetail.taxes == null) {
//               salesInvoiceDetail.taxes = [];
//             }
//             salesInvoiceDetail.taxes?.addAll(posInvoiceDetailTaxes);
//           }

//           detailModel.add(salesInvoiceDetail);
//         }
//         if (schemeDiscounts != null) {
//           if (model.invoiceDiscounts == null) {
//             model.invoiceDiscounts = [];
//           }
//           for (var schemeDiscount in schemeDiscounts) {
//             var schemeInvoiceDiscountDto =
//                 SchemeInvoiceDiscountDto.fromMap(schemeDiscount.toMap());
//             schemeInvoiceDiscountDto.Id = 0;
//             model.invoiceDiscounts?.add(schemeInvoiceDiscountDto);
//           }
//         }
//         if (model.invoiceDiscounts == null) {
//           model.invoiceDiscounts = [];
//         }
//         model.invoiceDetails.addAll(detailModel);
//         model.posPaymentDetails.addAll(posInvoicePayment);
//         model.fbrPosInvoiceNumber = posInvoice.fbrPosInvoiceNumber ?? "";
//         model.number = posInvoice.number;
//         model.series = posInvoice.series;
//         model.id = posInvoice.id;
//         model.accountId = posInvoice.accountId;
//         model.amountToAllocate = posInvoice.amountToAllocate;
//         model.billingAddress = posInvoice.billingAddress.toString();
//         model.branchId = posInvoice.branchId ?? 0;
//         model.cashRegisterSessionId = posInvoice.cashRegisterSessionId;
//         model.changeReturnedAmount = posInvoice.changeReturnedAmount;
//         model.comments = posInvoice.comments.toString();
//         model.currencyId = posInvoice.currencyId ?? 0;
//         model.customerId = posInvoice.customerId;
//         model.date = posInvoice.date;
//         model.discountAmount = posInvoice.discountAmount ?? 0;
//         model.discountPercent = posInvoice.discountPercent ?? 0;
//         model.dueDate = posInvoice.dueDate;
//         model.exchangeRate = posInvoice.exchangeRate ?? 0;
//         model.fbrPosFee = posInvoice.fbrPosFee ?? 0;
//         model.grossAmount = posInvoice.grossAmount ?? 0;
//         model.manualRoundOff = posInvoice.manualRoundOff ?? 0;
//         model.masterGroupId = posInvoice.masterGroupId;
//         model.narration = posInvoice.narration.toString();
//         model.netAmount = posInvoice.netAmount;
//         model.otherCharges = posInvoice.otherCharges ?? 0;
//         model.paidAmount = posInvoice.paidAmount ?? 0;
//         model.paymentReference = posInvoice.paymentReference.toString();
//         model.posCashRegisterId = posInvoice.posCashRegisterId;
//         model.posInvoiceId = posInvoice.pOSInvoice ?? 0;
//         model.receivedAmount = posInvoice.receivedAmount;
//         model.reference = posInvoice.reference.toString();
//         // model.saleInvoiceDiscounts = []; //Check And Send #TODO
//         model.saleOrderId = posInvoice.saleOrderId;
//         model.saleQuotationId = posInvoice.saleQuotationId;
//         model.saleReturnedAmount = posInvoice.saleReturnedAmount ?? 0;
//         model.salesmanId = posInvoice.salesmanId;
//         model.series = posInvoice.series.toString();
//         model.shippingAddress = posInvoice.shippingAddress.toString();
//         model.shippingCharges = posInvoice.shippingCharges ?? 0;
//         model.subject = posInvoice.subject.toString();
//         model.taxAmount = posInvoice.taxAmount ?? 0;
//         model.time = posInvoice.time;
//         model.unAllocatedAmount = posInvoice.unAllocatedAmount ?? 0;
//         model.userId = posInvoice.userId;
//         model.isSaleReturn = posInvoice.isPOS == true ? false : true;
//         model.isDesktop = true;

//         var modelMap = model.toMap();
//         lstModel.add(modelMap);
//       }

//       Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//           "${user.companyId}/" +
//           "${user.branchId}" +
//           ApiEndPoint.bulkUpdate);

//       for (var map in lstModel) {
//         int id = map["id"];
//         var payments = await POSInvoicePaymentDatabase.dao
//             .SelectList("posInvoiceId = $id");
//         if (payments != null) {
//           map['posPaymentDetails'] = payments;
//         }
//         var body = json.encode(map);
//         print(body);
//         Logger.InfoLog("Invoice push to server from local body $body");
//         var res = await http.post(url, body: body, headers: header);
//         BuildContext? context = Get.key.currentContext;
//         if (res.statusCode == 200) {
//           Logger.InfoLog(
//               "Response Server : ${res.body}, Status code ${res.statusCode}");
//           int id = map["id"];
//           bool isSaleReturn = map["isSaleReturn"];
//           if (isSaleReturn == true) {
//             var jsonDecode = json.decode(res.body);
//             var saleReturnId = jsonDecode["saleReturnId"];
//             var saleReturnNumber = jsonDecode["saleReturnNumber"];
//             var posPayments = await POSInvoicePaymentDatabase.dao
//                 .SelectList("saleReturnId = $id");
//             if (posPayments != null) {
//               for (var posPayment in posPayments) {
//                 posPayment.saleReturnId = saleReturnId;
//                 posPayment.saleReturnNumber = saleReturnNumber;
//                 await POSInvoicePaymentDatabase.dao.update(posPayment);
//               }
//             }
//           }
//           await POSInvoiceDatabase.SyncUpdate(id);
//           await SyncSettingDatabase.SalesInvoiceSync();

//           Logger.InfoLog("Data push to server successful");
//           //Success
//         } else if (res.statusCode == 427) {
//           Logger.ErrorLog(
//               "Response Server : ${res.body}, Status code ${res.statusCode}");
//           Get.deleteAll(force: true);
//           Get.toNamed(Routes.LOGIN);
//           DialogHelper.hideLoading();
//           return false;
//           //Lock Another userUse Token
//         } else if (res.statusCode == 500) {
//           DialogHelper.hideLoading();
//           Helper.errorMsg(
//               "Internal Server Error", "Some thing went wrong", context);
//           Logger.ErrorLog(
//               "Response Server : ${res.body}, Status code ${res.statusCode}");

//           //Internal Server Error
//         } else if (res.statusCode == 401) {
//           DialogHelper.hideLoading();
//           Logger.ErrorLog(
//               "Response Server : ${res.body}, Status code ${res.statusCode}");
//           // Get.reload(force: true);
//           Get.deleteAll(force: true);
//           Get.toNamed(Routes.LOGIN);

//           return false;
//           //UnAuthorized
//         } else if (res.statusCode == 423) {
//           Logger.ErrorLog("${res.request} " +
//               'Server Exception with statusCode: ${res.statusCode}' +
//               " data:" +
//               res.body);
//           // Get.reload(force: true);
//           Helper.infoMsg('Session Expired',
//               'You are already logged in another session', null);
//           Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(
//             builder: (context) {
//               PrefUtils().clearPreferencesData();
//               // Get.reloadAll(force: true);
//               // Get.deleteAll(force: true);
//               return LoginView();
//             },
//           ), (route) => false);
//           DialogHelper.hideLoading();
//           return false;
//           //UnAuthorized
//         } else if (res.statusCode == 400) {
//           DialogHelper.hideLoading();
//           Helper.errorMsg("Error", "${res.body}", null);
//           // Get.snackbar(
//           //   "Server Error",
//           //   "${res.body}",
//           //   snackPosition: SnackPosition.TOP,
//           // );
//           Logger.InfoLog(
//               "Response Server : ${res.body}, Status code ${res.statusCode}");
//         }
//       }
//       var posLogs = await PosCashRegisterLogDatabase.dao.SelectSingle(
//           "cashRegisterSessionId = '${summeryModel.cashRegisterSessionId}' and checkOutTime is not null");
//       if (posLogs == null) {
//         return false;
//       } else {
//         return true;
//       }
//     } catch (ex) {
//       Logger.InfoLog("Invoice push to server from local catch exception $ex");
//       return false;
//     }
//   }

//   Future<void> CustomerPush(List<CustomerModel> localCustomers) async {
//     for (var localCustomer in localCustomers) {
//       var localId = localCustomer.id;
//       localCustomer.id = 0;

//       var response = await BaseClient().post(
//           "${localCustomer.companySlug}/${localCustomer.branchId}/customers",
//           localCustomer);

//       if (response != null) {
//         if (response.statusCode == 201) {
//           var modelRes = CustomerModel.fromMap(json.decode(response.body));
//           var posInvoices =
//               await POSInvoiceDatabase.dao.SelectList("customerId = $localId");
//           if (posInvoices != null) {
//             await POSInvoiceDatabase.BulkUpdateCustomer(
//                 modelRes.id, localId, localCustomer.companySlug);
//           }
//           await CustomerDatabase.dao.deleteById(localId ?? 0);
//           modelRes.branchId = localCustomer.branchId;
//           await CustomerDatabase.dao.insert(modelRes);
//         }
//         //
//       }
//     }
//   }

//   Future<void> DataPushToServer() async {
//     LoginController loginController = Get.put(LoginController());
//     await loginController.AutoLogIn();
//     var localCustomers = await CustomerDatabase.dao.SelectList("IsNew = 1");
//     if (localCustomers != null) {
//       await CustomerPush(localCustomers);
//     }
//     Logger.InfoLog("Data push to server from local start");
//     PrefUtils pref = PrefUtils();
//     var userId = pref.GetPreferencesInteger(LocalStorageKey.localUserId);
//     if (userId > 0) {
//       var user = Helper.user;
//       var posSummaries = await PosSummeryDatabase.dao.SelectList(
//           '''${POSSummeryFiled.cashRegisterSessionId} is not null and ${POSSummeryFiled.isSyncCheckOut} = 0 ''');
//       if (posSummaries == null) {
//         Logger.InfoLog("POSSummaries not found");
//         return;
//       }

//       Map<String, String> header;
//       for (var summery in posSummaries) {
//         if (summery.createdBy == user.userId) {
//           header = GetHeader(pref.GetPreferencesString(LocalStorageKey.token));
//         } else {
//           var token = await Login(summery.createdBy.toString());
//           header = GetHeader(token);
//         }
//         if (summery.isSyncCheckIn == true && summery.isSyncCheckOut == false) {
//           var invoice = await PushInvoice(summery, user, header);
//           if (invoice) {
//             await CheckOutServer(summery, user, header);
//           }
//         } else if (summery.isSyncCheckIn == false &&
//             summery.isSyncCheckOut == false) {
//           var checkIn = await CheckInServer(summery, user, header);
//           if (checkIn) {
//             summery.isSyncCheckIn = true;
//             await PosSummeryDatabase.dao.update(summery);
//             // summery.endTime = null;
//             summery.cashAmount = 0.0;
//             summery.totalSales = 0.0;
//             summery.totalReceivedAmount = 0.0;
//             var jsonEncode = json.encode(summery);
//             Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//                 "${user.companyId}/" +
//                 "${user.branchId}" +
//                 "/PosSummary");
//             var response =
//                 await http.post(url, body: jsonEncode, headers: header);
//             var checkResponse = ResponseStatus(response);
//             if (checkResponse.statusCode == 200) {
//               var invoice = await PushInvoice(summery, user, header);
//               if (invoice) {
//                 await CheckOutServer(summery, user, header);
//               }
//             }
//           }
//         }
//       }
//     }
//   }

//   Future<String> Login(String userId) async {
//     var user = await UserDatabase.instance.GetUserByGuid(userId);
//     String token = "";
//     var payloadMap = {
//       UserFields.email: user.email,
//       UserFields.password: CipherService.Decrypt(user.password)
//     };
//     var response = await BaseClient()
//         .post(ApiEndPoint.logIn, payloadMap)
//         .catchError((error) {
//       handleError(error);
//     });
//     if (response != null && response.statusCode == 200) {
//       var jsonDecode = json.decode(response.body);
//       token = jsonDecode["token"];
//     }
//     return token;
//   }

//   Future<bool> CheckInServer(POSSummeryModel summeryModel, UserModel user,
//       Map<String, String> header) async {
//     try {
//       var posLogs = await PosCashRegisterLogDatabase.dao.SelectSingle(
//           "cashRegisterSessionId = '${summeryModel.cashRegisterSessionId}' ");
//       if (posLogs == null) {
//         return false;
//       }
//       var posCashRegistration = await PosCashRegisterDatabase.dao
//           .find(summeryModel.posCashRegisterId!);
//       var posCashPush = POSCashPush.fromMap(posCashRegistration.toMap());
//       posCashPush.checkInTime = posLogs.checkInTime;
//       posCashPush.cashRegisterSessionId = posLogs.cashRegisterSessionId;
//       posCashPush.isDesktop = true;

//       posCashRegistration.cashRegisterSessionId = posLogs.cashRegisterSessionId;
//       Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//           "${user.companyId}/" +
//           "${user.branchId}" +
//           "/PosCashRegisters/${posCashRegistration.id}/CheckInCashRegister");
//       var jsonEncode = json.encode(posCashPush.toMap());
//       var response = await http.put(url, body: jsonEncode, headers: header);
//       var checkResponse = ResponseStatus(response);
//       if (checkResponse.statusCode == 200) {
//         posLogs.isSyncCheckIn = true;
//         await PosCashRegisterLogDatabase.dao.update(posLogs);

//         return true;
//       } else {
//         return false;
//       }
//     } catch (ex) {
//       return false;
//     }
//   }

//   Future<bool> OnlyCheckIn(UserModel user) async {
//     var pref = PrefUtils();
//     var userGuid = user.userId;
//     var header = GetHeader(pref.GetPreferencesString(LocalStorageKey.token));
//     var posCash =
//         await PosCashRegisterDatabase.dao.SelectSingle("userId = '$userGuid'");
//     if (posCash == null) {
//       return false;
//     }
//     var summery = await PosSummeryDatabase.dao.SelectSingle(
//         "cashRegisterSessionId = '${posCash.cashRegisterSessionId}' ");
//     if (summery == null) {
//       return false;
//     }
//     if (summery.isSyncCheckIn == true) {
//       return true;
//     }

//     var posLogs = await PosCashRegisterLogDatabase.dao.SelectSingle(
//         "cashRegisterSessionId = '${posCash.cashRegisterSessionId}' ");
//     if (posLogs == null) {
//       return false;
//     }

//     var posCashPush = POSCashPush.fromMap(posCash.toMap());
//     posCashPush.checkInTime = posLogs.checkInTime;
//     posCashPush.cashRegisterSessionId = posLogs.cashRegisterSessionId;
//     posCashPush.isDesktop = true;
//     Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//         "${user.companyId}/" +
//         "${user.branchId}" +
//         "/PosCashRegisters/${posCash.id}/CheckInCashRegister");
//     var jsonEncode = json.encode(posCashPush.toMap());
//     var response = await http.put(url, body: jsonEncode, headers: header);
//     var checkResponse = ResponseStatus(response);
//     if (checkResponse.statusCode == 200) {
//       posLogs.isSyncCheckIn = true;
//       await PosCashRegisterLogDatabase.dao.update(posLogs);

//       // summery.endTime = null;
//       summery.cashAmount = 0.0;
//       summery.totalSales = 0.0;
//       summery.totalReceivedAmount = 0.0;
//       var jsonEncode = json.encode(summery);
//       Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//           "${user.companyId}/" +
//           "${user.branchId}" +
//           "/PosSummary");
//       var response = await http.post(url, body: jsonEncode, headers: header);
//       var checkResponse = ResponseStatus(response);
//       if (checkResponse.statusCode == 200) {
//         summery.isSyncCheckIn = true;
//         await PosSummeryDatabase.dao.update(summery);
//         return true;
//       }
//     }
//     return false;
//   }

//   Future<bool> CheckOutServer(POSSummeryModel summeryModel, UserModel user,
//       Map<String, String> header) async {
//     try {
//       var posLogs = await PosCashRegisterLogDatabase.dao.SelectSingle(
//           "cashRegisterSessionId = '${summeryModel.cashRegisterSessionId}' ");
//       if (posLogs == null) {
//         return false;
//       }
//       if (posLogs.checkOutTime == null) {
//         return false;
//       }
//       var posCashRegistration = await PosCashRegisterDatabase.dao
//           .find(summeryModel.posCashRegisterId!);
//       var posCashPush = POSCashPush.fromMap(posCashRegistration.toMap());
//       posCashPush.checkOutTime = posLogs.checkOutTime;
//       posCashPush.cashRegisterSessionId = posLogs.cashRegisterSessionId;
//       posCashPush.isDesktop = true;
//       posCashPush.difference = summeryModel.cashShortOrExcess;
//       posCashPush.totalCashAmount = summeryModel.closingBalance;
//       posCashRegistration.cashRegisterSessionId = posLogs.cashRegisterSessionId;
//       Uri url = Uri.parse("${ApiEndPoint.baseUrl}" +
//           "${user.companyId}/" +
//           "${user.branchId}" +
//           "/PosCashRegisters/${posCashRegistration.id}/CheckOutCashRegister");
//       var jsonEncode = json.encode(posCashPush.toMap());
//       var response = await http.put(url, body: jsonEncode, headers: header);
//       var checkResponse = ResponseStatus(response);
//       if (checkResponse.statusCode == 200) {
//         posLogs.isSyncCheckOut = true;
//         summeryModel.isSyncCheckOut = true;
//         await PosCashRegisterLogDatabase.dao.update(posLogs);
//         await PosSummeryDatabase.dao.update(summeryModel);

//         return true;
//       } else {
//         return false;
//       }
//     } catch (ex) {
//       return false;
//     }
//   }

//   http.Response ResponseStatus(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//         Logger.InfoLog('Data Push Server statusCode: ${response.statusCode} ' +
//             'Url: ${response.request}');
//         return response;
//       case 401:
//       case 427:
//       case 423:
//         {
//           BuildContext? context = Get.key.currentContext;
//           Logger.ErrorLog("${response.request} " +
//               'Server Exception with statusCode: ${response.statusCode}' +
//               " data:" +
//               response.body);
//           // Get.reload(force: true);
//           Helper.infoMsg('Session Expired',
//               'You are already logged in another session', null);
//           Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(
//             builder: (context) {
//               PrefUtils().clearPreferencesData();
//               // Get.reloadAll(force: true);
//               // Get.deleteAll(force: true);
//               return LoginView();
//             },
//           ), (route) => false);
//           DialogHelper.hideLoading();
//           return response;
//         }
//       case 500:
//         {
//           Logger.ErrorLog("${response.request} " +
//               'Server Exception with statusCode: ${response.statusCode}' +
//               " data:" +
//               response.body);

//           DialogHelper.hideLoading();
//           return response;
//         }
//       case 400:
//         {
//           Logger.ErrorLog("${response.request} " +
//               'Server Exception with statusCode: ${response.statusCode}' +
//               " data:" +
//               response.body);
//           Helper.errorMsg("Server Message", response.body, context);

//           DialogHelper.hideLoading();
//           return response;
//         }
//       default:
//         return response;
//     }
//   }

//   Map<String, String> GetHeader(String token) {
//     Map<String, String> userHeader = {
//       "Content-type": "application/json",
//       "Accept": "application/json",
//       "X-APP-Id": "68414BC4-41D6-45E0-A71F-048D2DBD4CD0",
//       "Authorization": "Bearer " + token
//     };
//     return userHeader;
//   }
// }
