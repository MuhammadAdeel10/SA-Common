import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SalesPerson/database/salesPerson_database.dart';
import 'package:sa_common/attachments/Database/attachmenstDatabase.dart';
import 'package:sa_common/attachments/controller/attachmentsController.dart';
import 'package:sa_common/attachments/model/AttachmentsModel.dart';
import 'package:sa_common/cart/controller/cart_controller.dart';
import 'package:sa_common/cart/database/cart_database.dart';
import 'package:sa_common/cart/model/cart_model.dart';
import 'package:sa_common/generated/locales.g.dart';
import 'package:sa_common/login/UserDatabase.dart';
import 'package:sa_common/productDetails/productDetailsController.dart';
import 'package:sa_common/sale_order/database/sale_order_database.dart';
import 'package:sa_common/sale_order/database/sale_order_detail_database.dart';
import 'package:sa_common/sale_order/database/sale_order_detail_tax_database.dart';
import 'package:sa_common/sale_order/model/sale_order_detail_model.dart';
import 'package:sa_common/sale_order/model/sale_order_discount.dart';
import 'package:sa_common/sale_order/model/sale_order_model.dart';
import 'package:sa_common/schemes/controllers/schemes_controller.dart';
import 'package:sa_common/schemes/models/SchemeInvoiceDiscountDtoModel.dart';
import 'package:sa_common/schemes/models/SchemeInvoiceDiscountModel.dart';
import 'package:sa_common/schemes/models/invoiceModel.dart';
import 'package:sa_common/synchronization/Database/currency_database.dart';
import 'package:sa_common/synchronization/Database/customer_database.dart';
import 'package:sa_common/synchronization/Database/masterGroup_database.dart';
import 'package:sa_common/synchronization/Models/CurrencyModel.dart';
import 'package:sa_common/synchronization/Models/CustomerModel.dart';
import 'package:sa_common/synchronization/Models/MasterGroupModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/app_routes.dart';
import 'package:sa_common/utils/constants.dart';
import 'package:sa_common/utils/pref_utils.dart';
// import 'package:sa_common/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class SaleOrderController extends BaseController {
  RxBool isDropDownOpen = false.obs;
  RxBool isCollapse = true.obs;
  RxString deliveryDate = "".obs;
  RxString nowDate = "".obs;
  RxString customerName = "".obs;
  RxInt? orderBookerId;
  Rx outstandingBalance = Rx(0);
  Rx creditLimit = Rx(0);
  Rx availableBalance = Rx(0);
  var customerNameController = TextEditingController().obs;
  var referenceController = TextEditingController().obs;
  var subjectController = TextEditingController().obs;
  var commentsController = TextEditingController().obs;
  var exchangeRateController = TextEditingController().obs;
  var discountInAmountController = TextEditingController().obs;
  var shippingChargesController = TextEditingController().obs;
  var discountInPercentController = TextEditingController().obs;
  var masterGroupController = TextEditingController().obs;
  SchemesController schemesController = Get.put(SchemesController());
  ProductDetailController productDetaillController = Get.put(ProductDetailController());
  var updatedOnCheck;
  var isProcessing = false.obs;
  var currencySymbol = "".obs;
  RxString serverNumberSaleOrder = "".obs;
  List<CurrencyModel> currencies = [];
  RxString symbol = "".obs;
  var masterList;
  var offlineSearchList;
  List<SaleOrderModel>? initialPaymentList = [];
  final PagingController<int, SaleOrderModel> pagingController = PagingController(firstPageKey: 1, invisibleItemsThreshold: 1);
  List<SaleOrderDetailsModel> saleOrderDetailsList = [];
  var isDetailsLoading = false.obs;
  AttachmentsController attachmentsController = Get.put(AttachmentsController());
  CartController cartController = Get.find();
  num? withHoldingTaxPercent;
  num? withHoldingTaxAmount;
  double? discountAmount;
  double? discountPercent;
  double? shippingCharges;
  double? taxAmount;
  bool isVisitMarked = false;
  int customerId = 0;
  int customerCurrencyId = 0;
  RxString number = "".obs;

  num NetAmount({required int customerCurrencyId}) {
    var netAmount = Helper.cartList.fold<num>(0, (previousValue, element) => previousValue + (customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (element.grossAmount / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : element.grossAmount));
    var tax = Helper.cartList.fold<num>(0, (previousValue, element) => previousValue + (customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (element.totalTaxAmonut! / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : element.totalTaxAmonut ?? 0));
    var lineItemDiscount = Helper.cartList.fold<num>(0, (previousValue, element) => previousValue + (customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (element.discountInAmount == null ? 0 : element.discountInAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : element.discountInAmount ?? 0));
    var shippingCharges = num.tryParse(shippingChargesController.value.text) ?? 0;

    if (netAmount > 0) {
      var discountAmount = num.tryParse(discountInAmountController.value.text == "" ? "0" : discountInAmountController.value.text) ?? 0;
      netAmount = netAmount - discountAmount;
    }
    netAmount = (netAmount + tax + shippingCharges + (withHoldingTaxAmount == null ? 0 : withHoldingTaxAmount as double)) - lineItemDiscount;
    cartController.taxes.value = tax;
    return netAmount;
  }

  String NetAmountCalculation(CartController cartController, {required int customerCurrencyId}) {
    return "${Helper.numberFormatter.format(customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (NetAmount(customerCurrencyId: customerCurrencyId) * num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : NetAmount(customerCurrencyId: customerCurrencyId) - cartController.schemeDiscountAmount.value)}";
  }

  Future<CurrencyModel> getCurrency(int customerCurrencyId) async {
    var currency = await CurrencyDatabase.dao.find(customerCurrencyId);
    currencySymbol.value = currency.symbol;
    return currency;
  }

  @override
  void onInit() {
    super.onInit();
    deliveryDate.value = Helper.getFormateDate(DateTime.now().toString());
    nowDate.value = Helper.getFormateDate(DateTime.now().toString());
  }

  Future<List<MasterGroupModel>> GetMaster() async {
    var masterGroups = await MasterGroupDatabase.dao.getByCompanySlug();

    return masterGroups;
  }

  Future<num> getOutStandingBalance(int customerId) async {
    var user = Helper.user;
    var response = await baseClient.get(ApiEndPoint.baseUrl, "${user.companyId}/${user.branchId}/Customers/$customerId/Balance").catchError(
      (error) {
        outstandingBalance.value = 0.0;
        availableBalance.value = 0.0;
        creditLimit.value = 0.0;
      },
    );

    if (response != null && response.statusCode == 200) {
      num outstandingBalance = num.parse(response.body);
      return outstandingBalance;
    }

    return 0.0;
  }

  getSaleOrderDetails(int id, {required int customerId, required int customerCurrencyId, required bool isForPrint}) async {
    if (!(await Helper.hasNetwork(ApiEndPoint.baseUrl))) {
      Helper.errorMsg(LocaleKeys.noInternetConnectionText.tr, "", context);
    }
    isDetailsLoading.value = true;
    var response = await BaseClient()
        .get(
      ApiEndPoint.baseUrl,
      "${Helper.user.companyId}/${Helper.user.branchId}/saleOrders/$id",
    )
        .catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var customer;
      var masterGroup;
      var decode = json.decode(response.body);
      number.value = decode['number'] ?? 0;
      discountAmount = decode['discountAmount'] ?? 0;
      discountPercent = decode['discountPercent'] ?? 0;
      shippingCharges = decode['shippingCharges'] ?? 0;
      taxAmount = decode["taxAmount"];
      var date = decode['date'];
      var reference = decode['reference'];
      var subject = decode['subject'];
      var comments = decode['comments'];
      double exchangeRate = decode['exchangeRate'];
      var checkCustomer = decode['customer'];
      var currencyId = decode['currencyId'];
      var deliveryDateLive = decode['deliveryDate'];
      var attachments = decode['attachments'];
      var checkMaster = decode['masterGroup'];
      updatedOnCheck = decode['updatedOn'];
      var saleOrderDiscounts = decode['saleOrderDiscounts'];
      serverNumberSaleOrder.value = decode['number'];
      var saleOrderDetails = decode['saleOrderDetails'];
      withHoldingTaxAmount = decode['withHoldingTaxAmount'];
      withHoldingTaxPercent = decode['withHoldingTaxPercent'];
      this.customerId = decode['customerId'];
      saleOrderDetailsList = List<SaleOrderDetailsModel>.from(saleOrderDetails.map((x) => SaleOrderDetailsModel().fromJson(x)));
      if (!isForPrint) {
        if (saleOrderDiscounts.isNotEmpty) {
          cartController.schemeDiscountPercent.value = saleOrderDiscounts.fold<num>(0, (num previousValue, element) => previousValue + (element['discountPercent'] ?? 0));
          cartController.schemeDiscountAmount.value = saleOrderDiscounts.fold<num>(0, (num previousValue, element) => previousValue + (element['discountAmount'] ?? 0));
        }
        if (checkMaster != null) {
          masterGroup = MasterGroupModel().fromJson(decode['masterGroup'], slug: Helper.user.companyId);
          masterGroupController.value.text = masterGroup.name;
          Helper.masterIdSaleOrder.value = masterGroup.id;
        }
        attachmentsController.attachmentsMaster = List<AttachmentsModel>.from(attachments.map((x) => AttachmentsModel().fromJson(x, slug: Helper.user.companyId)));
        if (checkCustomer != null) {
          customer = CustomerModel().fromJson(decode['customer'], slug: Helper.user.companyId);
          customerNameController.value.text = customer.name;
          creditLimit.value = customer.creditLimit;
          getOutStandingBalance(customer.id!).then((res) {
            outstandingBalance.value = res;
            availableBalance.value = (creditLimit.value - outstandingBalance.value);
          });
          print(customerNameController.value.text);
        }

        deliveryDate.value = Helper.getFormateDate(deliveryDateLive);
        nowDate.value = Helper.getFormateDate(date);
        this.customerCurrencyId = currencyId ?? 0;
        discountInAmountController.value.text = discountAmount.toString();
        discountInPercentController.value.text = discountPercent.toString();
        shippingChargesController.value.text = shippingCharges.toString();
        subjectController.value.text = subject ?? "";
        referenceController.value.text = reference ?? "";
        commentsController.value.text = comments ?? "";
        exchangeRateController.value.text = exchangeRate.toString();
        isDetailsLoading.value = false;
        update();
      }
      isDetailsLoading.value = false;

      return saleOrderDetailsList;
    }
  }

  Future<List<SaleOrderModel>?> PullCustomerPortal(String slug, int branchId, {int? page, required int customerId}) async {
    var response = await BaseClient().post(ApiEndPoint.baseUrl, "$slug/${branchId}/saleOrders/Search?page=$page&size=50&orderBy=date&ascending=false", {
      "customerId": [customerId]
    }).catchError(
      (error) {
        handleError(error);
      },
    );
    var orderList;

    if (response != null) {
      var decode = json.decode(response.body);
      if (decode.length > 0) {
        var orders = decode['results'];
        orderList = List<SaleOrderModel>.from(orders.map((x) => SaleOrderModel().fromJson(x, slug: slug)));
      }
      return orderList;
    }
    return null;
  }

  Future<List<SaleOrderModel>?> Pull(String slug, int branchId, {int? page}) async {
    var response = Helper.requestContext.enableSalesGeography == true
        ? await BaseClient().get(ApiEndPoint.baseUrl, "$slug/${branchId}/saleOrders/BySalesPerson?page=$page&size=50&orderBy=date&ascending=false").catchError(
            (error) {
              handleError(error);
            },
          )
        : await BaseClient().post(
            ApiEndPoint.baseUrl,
            "$slug/${branchId}/saleOrders/Search?page=$page&size=50&orderBy=date&ascending=false",
            {
              "orderBookerId": [Helper.salePerson?.id]
            },
          ).catchError(
            (error) {
              handleError(error);
            },
          );
    var orderList;

    if (response != null) {
      var decode = json.decode(response.body);
      if (decode.length > 0) {
        var orders = decode['results'];
        orderList = List<SaleOrderModel>.from(orders.map((x) => SaleOrderModel().fromJson(x, slug: slug)));
      }
      return orderList;
    }
    return null;
  }

  Future<List<SaleOrderModel>?> saleOrderListData({int? page, String? search}) async {
    try {
      PrefUtils pref = PrefUtils();
      var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
      List<SaleOrderModel> initialPaymentList = [];
      if (!(await Helper.hasNetwork(ApiEndPoint.baseUrl))) {
        initialPaymentList = await SaleOrderDatabase.saleOrderListData() ?? [];
        if (search == "") {
          return initialPaymentList.toList();
        } else {
          await SearchOffline(search);
          return offlineSearchList;
        }
      } else {
        if (search == "") {
          initialPaymentList = await SaleOrderDatabase.saleOrderListData() ?? [];
          var lastPaymentList = await Pull(slug, Helper.user.branchId ?? 0, page: page);
          if (page == 1) {
            if (initialPaymentList.isNotEmpty) {
              lastPaymentList?.insertAll(0, initialPaymentList);
            }
          }
          return lastPaymentList;
        } else {
          await SearchOnline(search);
          return masterList;
        }
      }
    } catch (e) {
      throw e;
    }
  }

  void sortByDateDesc(List<SaleOrderModel> list) {
    list.sort((a, b) {
      final aDate = a.date;
      final bDate = b.date;
      if (aDate == null && bDate == null) {
        return (b.id ?? 0).compareTo(a.id ?? 0);
      }
      if (aDate == null) return 1;
      if (bDate == null) return -1;

      final dateComparison = bDate.compareTo(aDate);

      if (dateComparison != 0) {
        return dateComparison;
      }
      return (b.id ?? 0).compareTo(a.id ?? 0);
    });
  }

  Future<List<SaleOrderModel>?> saleOrderListDataCustomerPortal({
    int? page,
    String? search,
    required int customerId,
  }) async {
    try {
      PrefUtils pref = PrefUtils();
      var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
      List<SaleOrderModel> localList = [];

      // Function to sort by nullable date (nulls go last)

      // Check for network
      if (!(await Helper.hasNetwork(ApiEndPoint.baseUrl))) {
        localList = await SaleOrderDatabase.saleOrderListDataCustomerPortal(customerId: customerId) ?? [];

        if (search?.isEmpty ?? true) {
          sortByDateDesc(localList);
          return localList;
        } else {
          await SearchOfflineCustomerPortal(search!, customerId: customerId);
          sortByDateDesc(offlineSearchList);
          return offlineSearchList;
        }
      } else {
        final actualCustomerId = customerId == 0 ? (Helper.user.customerId ?? 0) : customerId;

        if (search?.isEmpty ?? true) {
          localList = await SaleOrderDatabase.saleOrderListDataCustomerPortal(customerId: actualCustomerId) ?? [];
          List<SaleOrderModel>? apiList = await PullCustomerPortal(slug, Helper.user.branchId ?? 0, page: page, customerId: actualCustomerId);

          if (page == 1 && localList.isNotEmpty) {
            apiList ??= [];
            apiList.addAll(localList);
          }

          sortByDateDesc(apiList ?? []);
          return apiList;
        } else {
          await SearchOnlineCustomerPortal(search!, customerId: actualCustomerId);
          sortByDateDesc(masterList);
          return masterList;
        }
      }
    } catch (e) {
      log("SaleOrderController $e");
      throw e;
    }
  }

  Future<List<SaleOrderModel>?> SearchOfflineCustomerPortal(String? search, {required int customerId}) async {
    initialPaymentList = await SaleOrderDatabase.saleOrderListDataCustomerPortal(customerId: customerId);
    offlineSearchList = initialPaymentList?.where(
      (element) {
        return element.number == search;
      },
    ).toList();
    return offlineSearchList;
  }

  Future<List<SaleOrderModel>?> SearchOnlineCustomerPortal(String? search, {required int customerId}) async {
    var response;
    PrefUtils pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    String api = "$slug/${Helper.user.branchId}${ApiEndPoint.saleOrderSearch}";

    response = await this.baseClient.post(ApiEndPoint.baseUrl, api, {"number": search}).catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var decode = json.decode(response.body);
      var results = decode['results'];
      masterList = List<SaleOrderModel>.from(results.map((x) => SaleOrderModel().fromJson(x, slug: Helper.user.companyId)));
      await SearchOfflineCustomerPortal(search, customerId: customerId);
      if (offlineSearchList != null) {
        masterList.insertAll(0, offlineSearchList);
      }
      return masterList;
    }
    return null;
  }

  Future<List<SaleOrderModel>?> SearchOffline(
    String? search,
  ) async {
    var customerSearchId = await CustomerDatabase.dao.SelectSingle("name like '%$search%' ");
    var onlineSearchCustomerId = customerSearchId?.id;
    initialPaymentList = await SaleOrderDatabase.saleOrderListData();
    offlineSearchList = initialPaymentList?.where(
      (element) {
        return element.customerId == onlineSearchCustomerId;
      },
    ).toList();
    return offlineSearchList;
  }

  Future<List<SaleOrderModel>?> SearchOnline(String? search) async {
    var customerSearchId = await CustomerDatabase.dao.SelectSingle("name like '%$search%' ");
    var onlineSearchCustomerId = customerSearchId?.id;
    var response;
    PrefUtils pref = PrefUtils();
    var slug = pref.GetPreferencesString(LocalStorageKey.companySlug);
    final bodyList = [onlineSearchCustomerId];
    String api = "$slug/${Helper.user.branchId}${ApiEndPoint.saleOrderSearch}";

    if (onlineSearchCustomerId != null) {
      response = await this.baseClient.post(ApiEndPoint.baseUrl, api, {"customerId": bodyList}).catchError(
        (error) {
          handleError(error);
        },
      );
    } else {
      response = await this.baseClient.post(ApiEndPoint.baseUrl, api, {"number": search}).catchError(
        (error) {
          handleError(error);
        },
      );
    }

    if (response != null) {
      var decode = json.decode(response.body);
      var results = decode['results'];
      masterList = List<SaleOrderModel>.from(results.map((x) => SaleOrderModel().fromJson(x, slug: Helper.user.companyId)));
      await SearchOffline(search);
      if (offlineSearchList != null) {
        masterList.insertAll(0, offlineSearchList);
      }
      return masterList;
    }
    return null;
  }

  GetAllCurrencies() async {
    currencies = await CurrencyDatabase.dao.getAll();
  }

  FetchCurrencySymbolById(int id) {
    var perfectMatch = currencies.firstWhereOrNull((element) => element.id == id);

    if (perfectMatch != null) {
      var currencyCheck = !Helper.requestContext.currencySymbol ? perfectMatch.code : perfectMatch.symbol;
      return currencyCheck;
    } else {
      return null;
    }
  }

  Future<SaleOrderModel?> updateSaleOrderRecord(int saleOrderId, List<CartModel> cartModels, SchemeInvoiceModel model, num? discount, BuildContext context, {required int customerId, required int customerCurrencyId, required VoidCallback showLoading, required VoidCallback hideLoading, SaleOrderStatus status = SaleOrderStatus.Approved}) async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.get(LocalStorageKey.localUserId) as int;
    var userData = await UserDatabase.instance.GetUserById(userId);
    var currencyModel = await CurrencyDatabase().GetDefaultCurrency();
    CartController cartController = Get.put(CartController());
    List<SaleOrderDiscountsModel> discounts = [];
    List<AttachmentsModel>? attachmentsResponseSaleOrder = [];

    for (var cartModel in cartModels) {
      if (cartModel.cartDiscounts != null) {
        for (var cartDiscount in cartModel.cartDiscounts!) {
          var map = cartDiscount.toMap();
          var dis = SaleOrderDiscountsModel.fromMap(map, slug: model.companySlug);
          dis.branchId = userData.branchId;
          dis.id = 0;
          dis.saleOrderDetailId = cartModel.id;
          dis.discountId = cartDiscount.discountId;
          dis.appliedOn = DiscountAppliedOn.GrossAmount;
          dis.schemeId = cartDiscount.schemeId;
          if (dis.discountType == DiscountType.Price) {
            dis.discountAmount = cartDiscount.discountInAmount ?? 0;
            dis.discountInAmount = 0;
          } else if (dis.discountType == DiscountType.Percent) {
            dis.discountInAmount = 0;
          } else {
            dis.discountInAmount = cartDiscount.discountInAmount ?? 0;
            dis.discountAmount = cartDiscount.discountAmount ?? 0;
          }
          dis.discountInPercent = cartDiscount.discountInPercent ?? 0;
          dis.discountInPrice = cartDiscount.discountInPrice ?? 0;
          dis.schemeDetailId = cartDiscount.schemeDetailId;

          if (dis.discountType == DiscountType.Percent) {
            num totalAmount = cartModel.price * cartModel.qty;
            dis.totalSavedAmount = totalAmount - cartModel.grossAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          } else if (dis.discountType == DiscountType.Amount) {
            dis.totalSavedAmount = cartDiscount.discountInAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          }
          discounts.add(dis);
        }
      }
    }
    SaleOrderModel? saleOrder = SaleOrderModel();
    saleOrder.discountAmount = num.parse(discountInAmountController.value.text == "" ? "0" : discountInAmountController.value.text);
    saleOrder.discountPercent = num.parse(discountInPercentController.value.text == "" ? "0" : discountInPercentController.value.text);
    saleOrder.shippingCharges = num.parse(shippingChargesController.value.text == "" ? "0" : shippingChargesController.value.text);
    saleOrder.branchId = userData.branchId;
    saleOrder.status = status.value;
    saleOrder.companySlug = userData.companyId;
    saleOrder.customerId = customerId;
    var salePerson = await SalesPersonDatabase.dao.SelectSingle("applicationUserId = '${Helper.user.userId}' ");
    if (salePerson != null) saleOrder.orderBookerId = salePerson.id;
    saleOrder.reference = referenceController.value.text;
    saleOrder.subject = subjectController.value.text;
    saleOrder.comments = commentsController.value.text;
    saleOrder.currencyId = customerCurrencyId;
    saleOrder.exchangeRate = num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text);
    saleOrder.taxAmount = model.taxAmount ?? 0;
    saleOrder.invoicesCount = 0;
    saleOrder.number = serverNumberSaleOrder.value;
    saleOrder.id = saleOrderId;
    saleOrder.deliveriesCount = 0;
    saleOrder.masterGroupId = Helper.masterIdSaleOrder.value == 0 ? null : Helper.masterIdSaleOrder.value;
    saleOrder.updatedOn = updatedOnCheck;
    saleOrder.withHoldingTaxAmount = withHoldingTaxAmount;
    saleOrder.withHoldingTaxPercent = withHoldingTaxPercent;
    saleOrder.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? model.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) : model.grossAmount;
    saleOrder.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (model.netAmount / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0)) : (model.netAmount - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0));
    saleOrder.date = DateFormat('dd-MM-yyyy').parse(nowDate.value);
    saleOrder.deliveryDate = DateFormat('dd-MM-yyyy').parse(deliveryDate.value);
    saleOrder.isAppliedScheme = model.isAppliedScheme ?? false;
    saleOrder.netAmount = Helper.customRound(saleOrder.netAmount ?? 0.0, decimalPlaces: Helper.requestContext.decimalPlaces).toDouble();
    List<SaleOrderDetailsModel> existingDetails = saleOrderDetailsList;
    List<SaleOrderDetailsModel> newDetails = [];
    for (var invoiceDetail in model.invoiceDetails) {
      SaleOrderDetailsModel saleOrderDetail;

      if (invoiceDetail.id != null) {
        saleOrderDetail = existingDetails.firstWhere((detail) => detail.id == invoiceDetail.id, orElse: () => SaleOrderDetailsModel());
      } else {
        saleOrderDetail = SaleOrderDetailsModel();
        saleOrderDetail.id = 0;
      }

      if (invoiceDetail.id == saleOrderDetail.id) {
        saleOrderDetail.id = invoiceDetail.id;
      } else {
        saleOrderDetail.id = 0;
      }
      saleOrderDetail.discounts ??= [];
      saleOrderDetail.discounts?.clear();
      if (saleOrderDetail.id == 0) {
        saleOrderDetail.discounts?.addAll(discounts.where((element) => element.saleOrderDetailId == invoiceDetail.id));
      } else {
        saleOrderDetail.discounts?.addAll(discounts.where((element) => element.saleOrderDetailId == saleOrderDetail.id));
      }
      saleOrderDetail.branchId = userData.branchId ?? 0;
      saleOrderDetail.productId = invoiceDetail.productId ?? 0;
      saleOrderDetail.price = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.price! / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : invoiceDetail.price ?? 0;
      saleOrderDetail.companySlug = model.companySlug;
      saleOrderDetail.discountInPercent = invoiceDetail.discountInPercent;
      saleOrderDetail.discountAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.discountAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.discountAmount ?? 0;
      saleOrderDetail.taxAmount = invoiceDetail.taxAmount ?? 0;
      saleOrderDetail.isMRPExclusiveTax = invoiceDetail.isMRPExclusiveTax ?? false;
      saleOrderDetail.quantity = invoiceDetail.quantity ?? 0;
      saleOrderDetail.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.grossAmount ?? 0;
      saleOrderDetail.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.netAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.netAmount ?? 0;
      saleOrderDetail.isBonusProduct = invoiceDetail.isBonusProduct ?? false;
      saleOrderDetail.accountId = invoiceDetail.accountId;
      saleOrderDetail.remainingQuantity = 0;
      saleOrderDetail.saleOrderId = saleOrderId;
      saleOrderDetail.maximumRetailPrice = invoiceDetail.maximumRetailPrice ?? 0.0;
      saleOrderDetail.purchasePrice = invoiceDetail.purchasePrice ?? 0.0;

      saleOrderDetail.taxes ??= [];
      var savedTaxes = await SaleOrderDetailTaxesDatabase.dao.SelectList("saleOrderDetailId = ${invoiceDetail.id}");

      if (savedTaxes != null) {
        saleOrderDetail.taxes = (savedTaxes + cartController.taxesList).map((tax) {
          tax.id = 0;
          return tax;
        }).toList();
      } else {
        saleOrderDetail.taxes = cartController.taxesList.map((tax) {
          tax.id = 0;
          return tax;
        }).toList();
      }

      var matchingElement = cartModels.firstWhereOrNull(
        (element) => element.productId == invoiceDetail.productId,
      );

      if (matchingElement != null) {
        saleOrderDetail.description = matchingElement.description;
      }

      newDetails.add(saleOrderDetail);
    }

    List<SchemeInvoiceDiscountModel> schemeInvoiceDiscounts = [];
    SchemeInvoiceDiscountModel schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();

    for (var discount in model.invoiceDiscounts.where((element) => (element.discountAmount ?? 0).abs() > 0 && element.discountType == DiscountInvoiceType.Scheme)) {
      schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();
      schemeInvoiceDiscountModel.appliedOn = discount.appliedOn;
      schemeInvoiceDiscountModel.branchId = userData.branchId;
      schemeInvoiceDiscountModel.companySlug = userData.companyId;
      schemeInvoiceDiscountModel.currencyId = currencyModel?.id;
      schemeInvoiceDiscountModel.discountAmount = discount.discountAmount?.abs();
      schemeInvoiceDiscountModel.discountPercent = discount.discountPercent;
      schemeInvoiceDiscountModel.schemeId = discount.schemeId;
      schemeInvoiceDiscountModel.discountType = discount.discountType;
      schemeInvoiceDiscountModel.narration = "SaleOrder: ${saleOrder.number}";
      schemeInvoiceDiscountModel.sort = 0;
      schemeInvoiceDiscountModel.source = "SaleOrder";
      schemeInvoiceDiscountModel.sourceCreatedOn = DateTime.now().toUtc();
      schemeInvoiceDiscountModel.discountId = discount.discountId;
      schemeInvoiceDiscounts.add(schemeInvoiceDiscountModel);
    }

    if (schemeInvoiceDiscounts.isNotEmpty) {
      saleOrder.saleOrderDiscounts ??= [];
      for (var schemeDiscount in schemeInvoiceDiscounts) {
        var schemeInvoiceDiscountDto = SchemeInvoiceDiscountDto.fromMap(schemeDiscount.toMap());
        schemeInvoiceDiscountDto.Id = 0;
        schemeInvoiceDiscountDto.sourceId = 0;
        saleOrder.saleOrderDiscounts?.add(schemeInvoiceDiscountDto);
      }
    }

    await attachmentsController.DelteAttachmentsOnline();
    await attachmentsController.OnlineAttachmentsPush(saleOrderId, AttachmentsSource.SaleOrder.name).then(
      (value) {
        attachmentsResponseSaleOrder = value;
      },
    );

    saleOrder.attachments = attachmentsResponseSaleOrder;

    var body = {
      ...saleOrder.toJson(),
      "saleOrderDetails": newDetails.map((detail) => detail.toJson(isOnline: true)).toList(),
      "saleOrderDiscounts": saleOrder.saleOrderDiscounts?.map((detail) => detail.toMap()).toList() ?? [],
    };
    print(body);
    String endPoint = "";

    if (Helper.appId == GlobalConstant.orderBookerAppId) {
      endPoint = ApiEndPoint.saleOrderRevise;
    } else {
      endPoint = "/SaleOrders/${saleOrderId}";
    }

    Uri url = Uri.parse("${ApiEndPoint.baseUrl}${Helper.user.companyId}/${Helper.user.branchId}$endPoint");
    PrefUtils pref = PrefUtils();
    String token = pref.GetPreferencesString(LocalStorageKey.token);
    var header = this.baseClient.GetHeader(token: token);
    try {
      showLoading;
      var jsonBody = json.encode(body);
      var res = await http.put(url, body: jsonBody, headers: header);
      hideLoading;
      print(res);
      switch (res.statusCode) {
        case 200 || 201:
          print(jsonDecode(res.body));
          Helper.successMsg("Sale Order Updated", "", context);
          log("Response Server : ${res.body}, Status code ${res.statusCode}");
          log("Data push to server successful");
          break;
        case 427:
          log("Response Server : ${res.body}, Status code ${res.statusCode}");
          Get.offNamedUntil(Routes.LOGIN, (route) => false);
        case 500:
          Helper.errorMsg("Internal Server Error", "Some thing went wrong", context);
          log("Response Server : ${res.body}, Status code ${res.statusCode}");
          break;
        case 401:
          log("Response Server : ${res.body}, Status code ${res.statusCode}");
          Get.offNamedUntil(Routes.LOGIN, (route) => false);
        case 423:
          log("${res.request} " 'Server Exception with statusCode: ${res.statusCode}' + " data:" + res.body);
          Helper.infoMsg('Session Expired', 'You are already logged in another session', null);
          Get.offNamedUntil(Routes.LOGIN, (route) => false);
        case 400:
          Helper.errorMsg("Error", "${res.body}", null);
          log("Response Server : ${res.body}, Status code ${res.statusCode}");
          break;
      }
    } catch (e) {
      Helper.errorMsg(LocaleKeys.serviceError_somethingWentWrong, "", context);
    }
    update();
    return null;
  }

  Future<SaleOrderModel?> updateSaleOrder(int saleOrderId, List<CartModel> cartModels, SchemeInvoiceModel model, num? discount, BuildContext context, {required int customerId, required int customerCurrencyId, required VoidCallback hideLoading, SaleOrderStatus status = SaleOrderStatus.Approved}) async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.get(LocalStorageKey.localUserId) as int;
    var userData = await UserDatabase.instance.GetUserById(userId);
    var currencyModel = await CurrencyDatabase().GetDefaultCurrency();
    List<SaleOrderDiscountsModel> discounts = [];

    for (var cartModel in cartModels) {
      if (cartModel.cartDiscounts != null) {
        for (var cartDiscount in cartModel.cartDiscounts!) {
          var map = cartDiscount.toMap();
          var dis = SaleOrderDiscountsModel.fromMap(map, slug: model.companySlug);
          dis.id = cartDiscount.id;
          dis.branchId = userData.branchId;
          dis.appliedOn = DiscountAppliedOn.GrossAmount;
          dis.saleOrderDetailId = cartModel.id;
          dis.schemeId = cartDiscount.schemeId;
          dis.discountAmount = cartDiscount.discountInAmount ?? 0;
          dis.discountInAmount = cartDiscount.discountInAmount ?? 0;
          dis.discountInPercent = cartDiscount.discountInPercent ?? 0;
          dis.discountInPrice = cartDiscount.discountInPrice ?? 0;
          dis.schemeDetailId = cartDiscount.schemeDetailId;

          if (dis.discountType == DiscountType.Percent) {
            num totalAmount = cartModel.price * cartModel.qty;
            dis.totalSavedAmount = totalAmount - cartModel.grossAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          } else if (dis.discountType == DiscountType.Amount) {
            dis.totalSavedAmount = cartDiscount.discountInAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          }
          discounts.add(dis);
        }
      }
    }

    SaleOrderModel? saleOrder = await SaleOrderDatabase.dao.SelectSingle("id = $saleOrderId");

    if (saleOrder == null) {
      throw Exception("SaleOrder not found");
    }

    var responseCurrencyId = saleOrder.currencyId;
    saleOrder.discountAmount = num.parse(discountInAmountController.value.text == "" ? "0" : discountInAmountController.value.text);
    saleOrder.discountPercent = num.parse(discountInPercentController.value.text == "" ? "0" : discountInPercentController.value.text);
    saleOrder.branchId = userData.branchId;
    saleOrder.status = status.value;
    saleOrder.companySlug = userData.companyId;
    saleOrder.customerId = customerId;
    var salePerson = await SalesPersonDatabase.dao.SelectSingle("applicationUserId = '${Helper.user.userId}' ");
    if (salePerson != null) saleOrder.orderBookerId = salePerson.id;
    saleOrder.reference = referenceController.value.text;
    saleOrder.subject = subjectController.value.text;
    saleOrder.comments = commentsController.value.text;
    saleOrder.shippingCharges = int.tryParse(shippingChargesController.value.text) ?? 0;
    saleOrder.masterGroupId = Helper.masterIdSaleOrder.value == 0 ? null : Helper.masterIdSaleOrder.value;
    saleOrder.currencyId = customerCurrencyId;
    saleOrder.exchangeRate = num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text);
    saleOrder.updatedOn = updatedOnCheck;
    saleOrder.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? model.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) : model.grossAmount;
    saleOrder.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (model.netAmount / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0)) : (model.netAmount - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0));
    saleOrder.date = DateFormat('dd-MM-yyyy').parse(nowDate.value);
    saleOrder.deliveryDate = DateFormat('dd-MM-yyyy').parse(deliveryDate.value);
    saleOrder.isAppliedScheme = model.isAppliedScheme ?? false;
    saleOrder.netAmount = Helper.customRound(saleOrder.netAmount ?? 0.0, decimalPlaces: Helper.requestContext.decimalPlaces).toDouble();

    List<SaleOrderDetailsModel> existingDetails = await SaleOrderDetailDatabase.Get(saleOrder.id!);
    List<SaleOrderDetailsModel> newDetails = [];
    for (var invoiceDetail in model.invoiceDetails) {
      SaleOrderDetailsModel saleOrderDetail;

      if (invoiceDetail.id != null) {
        saleOrderDetail = existingDetails.firstWhere((detail) => detail.id == invoiceDetail.id, orElse: () => SaleOrderDetailsModel());
      } else {
        saleOrderDetail = SaleOrderDetailsModel();
        saleOrderDetail.id = null;
      }
      saleOrderDetail.branchId = userData.branchId ?? 0;
      saleOrderDetail.productId = invoiceDetail.productId ?? 0;
      saleOrderDetail.price = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.price! / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : invoiceDetail.price ?? 0;
      saleOrderDetail.companySlug = model.companySlug;
      saleOrderDetail.discountInPercent = invoiceDetail.discountInPercent;
      saleOrderDetail.discountAmount = 1 != 0 && 1 != Helper.requestContext.currencyId ? (invoiceDetail.discountAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text)) : invoiceDetail.discountAmount ?? 0;
      saleOrderDetail.taxAmount = (invoiceDetail.taxAmount ?? 0);
      saleOrderDetail.isMRPExclusiveTax = invoiceDetail.isMRPExclusiveTax ?? false;
      saleOrderDetail.quantity = invoiceDetail.quantity ?? 0;
      saleOrderDetail.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.grossAmount ?? 0;
      saleOrderDetail.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.netAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.netAmount ?? 0;
      saleOrderDetail.isBonusProduct = invoiceDetail.isBonusProduct ?? false;
      saleOrderDetail.accountId = invoiceDetail.accountId;
      saleOrderDetail.branchId = invoiceDetail.batchId;
      saleOrderDetail.remainingQuantity = 0;
      saleOrderDetail.isInitial = true;

      if (customerCurrencyId != responseCurrencyId) {
        await SaleOrderDetailDatabase().deletebyFilter("isInitial = 1 and saleOrderId = ${saleOrder.id}");
      }
      saleOrderDetail.maximumRetailPrice = invoiceDetail.maximumRetailPrice ?? 0.0;
      saleOrderDetail.purchasePrice = invoiceDetail.purchasePrice ?? 0.0;
      var taxes = await SaleOrderDetailTaxesDatabase.dao.SelectList("saleOrderDetailId = ${invoiceDetail.id}");

      saleOrderDetail.taxes ??= [];
      saleOrderDetail.taxes?.addAll(taxes ?? []);
      var matchingElement = cartModels.firstWhereOrNull(
        (element) => element.productId == invoiceDetail.productId,
      );

      if (matchingElement != null) {
        saleOrderDetail.description = matchingElement.description;
      }

      newDetails.add(saleOrderDetail);
    }

    List<SaleOrderDetailsModel> detailsToRemove = existingDetails.where((existingDetail) {
      return model.invoiceDetails.every((invoiceDetail) => invoiceDetail.id != existingDetail.id);
    }).toList();

// Remove details from the database if they are not in invoice details
    for (var detail in detailsToRemove) {
      await SaleOrderDetailDatabase.dao.deleteById(detail.id!);
    }

    if (newDetails.isEmpty) {
      Helper.errorMsg("Cart can not be empty", "", context);
    }

    List<SchemeInvoiceDiscountModel> schemeInvoiceDiscounts = [];
    SchemeInvoiceDiscountModel schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();

    for (var discount in model.invoiceDiscounts.where((element) => (element.discountAmount ?? 0).abs() > 0 && element.discountType == DiscountInvoiceType.Scheme)) {
      schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();
      schemeInvoiceDiscountModel.appliedOn = discount.appliedOn;
      schemeInvoiceDiscountModel.branchId = userData.branchId;
      schemeInvoiceDiscountModel.companySlug = userData.companyId;
      schemeInvoiceDiscountModel.currencyId = currencyModel?.id;
      schemeInvoiceDiscountModel.discountAmount = discount.discountAmount?.abs();
      schemeInvoiceDiscountModel.discountPercent = discount.discountPercent;
      schemeInvoiceDiscountModel.schemeId = discount.schemeId;
      schemeInvoiceDiscountModel.discountType = discount.discountType;
      schemeInvoiceDiscountModel.narration = "SaleOrder: ${saleOrder.number}";
      schemeInvoiceDiscountModel.sort = 0;
      schemeInvoiceDiscountModel.source = "SaleOrder";
      schemeInvoiceDiscountModel.sourceCreatedOn = DateTime.now().toUtc();
      schemeInvoiceDiscountModel.discountId = discount.discountId;
      schemeInvoiceDiscounts.add(schemeInvoiceDiscountModel);
    }

    var response = await SaleOrderDatabase.updateRecord(saleOrder, newDetails, discounts, schemeInvoiceDiscount: schemeInvoiceDiscounts, attachments: attachmentsController.attachmentsMaster, hideLoading: hideLoading);
    if (attachmentsController.attachmentsToBeDeletedId.isNotEmpty) {
      for (var attaches in attachmentsController.attachmentsToBeDeletedId) {
        AttachmentsDatabase.dao.deleteById(attaches.id ?? 0);
        File files = File(attaches.path ?? "");
        files.delete();
      }
    }
    attachmentsController.attachmentsMaster.clear();
    Helper.successMsg("Sale Order Updated", "", context);
    update();
    return response;
  }

  Future<SaleOrderModel?> createSaleOrder(List<CartModel> cartModels, SchemeInvoiceModel model, num? discount, BuildContext context, {required int customerId, required int customerCurrencyId, required VoidCallback hideLoading, SaleOrderStatus status = SaleOrderStatus.Approved}) async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.get(LocalStorageKey.localUserId) as int;
    var userData = await UserDatabase.instance.GetUserById(userId);
    var currencyModel = await CurrencyDatabase().GetDefaultCurrency();
    List<SaleOrderDiscountsModel> discounts = [];

    for (var cartModel in cartModels) {
      if (cartModel.cartDiscounts != null) {
        for (var cartDiscount in cartModel.cartDiscounts!) {
          var map = cartDiscount.toMap();
          var dis = SaleOrderDiscountsModel.fromMap(map, slug: model.companySlug);
          dis.id = null;
          dis.branchId = userData.branchId;
          dis.appliedOn = DiscountAppliedOn.GrossAmount;
          dis.saleOrderDetailId = cartModel.id;
          dis.schemeId = cartDiscount.schemeId;
          dis.discountInAmount = cartDiscount.discountInAmount ?? 0;
          dis.discountInPercent = cartDiscount.discountInPercent ?? 0;
          dis.discountAmount = cartDiscount.discountInAmount ?? 0;
          dis.discountInPrice = cartDiscount.discountInPrice ?? 0;
          dis.schemeDetailId = cartDiscount.schemeDetailId;

          if (dis.discountType == DiscountType.Percent) {
            num totalAmount = cartModel.price * cartModel.qty;
            dis.totalSavedAmount = totalAmount - cartModel.grossAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          } else if (dis.discountType == DiscountType.Amount) {
            dis.totalSavedAmount = cartDiscount.discountInAmount;
            dis.discountAmount = (dis.totalSavedAmount ?? 0) * 2;
          }
          discounts.add(dis);
        }
      }
    }

    SaleOrderModel saleOrder = SaleOrderModel();
    SaleOrderDetailsModel? saleOrderDetail;
    List<SaleOrderDetailsModel> detail = [];
    String number = "";

    if (currencyModel != null) {
      saleOrder.currencyId = currencyModel.id;
    }

    var salePerson = await SalesPersonDatabase.dao.SelectSingle("applicationUserId = '${Helper.user.userId}' ");
    saleOrder.discountAmount = num.parse(discountInAmountController.value.text == "" ? "0" : discountInAmountController.value.text);
    saleOrder.discountPercent = num.parse(discountInPercentController.value.text == "" ? "0" : discountInPercentController.value.text);
    saleOrder.branchId = userData.branchId;
    saleOrder.status = status.value;
    saleOrder.companySlug = userData.companyId;
    saleOrder.customerId = customerId == 0 ? Helper.user.customerId : customerId;
    if (salePerson != null) saleOrder.orderBookerId = salePerson.id;
    saleOrder.reference = referenceController.value.text;
    saleOrder.subject = subjectController.value.text;
    saleOrder.comments = commentsController.value.text;
    saleOrder.shippingCharges = int.tryParse(shippingChargesController.value.text) ?? 0;
    saleOrder.masterGroupId = Helper.masterIdSaleOrder.value == 0 ? null : Helper.masterIdSaleOrder.value;
    saleOrder.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? model.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) : model.grossAmount;
    saleOrder.currencyId = customerCurrencyId;
    saleOrder.exchangeRate = num.parse(exchangeRateController.value.text == "" ? "1" : exchangeRateController.value.text);
    saleOrder.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (model.netAmount / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text) - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0)) : (model.netAmount - (saleOrder.discountAmount ?? 0) + (saleOrder.shippingCharges ?? 0));
    saleOrder.number = number;
    saleOrder.date = DateFormat('dd-MM-yyyy').parse(nowDate.value);
    saleOrder.deliveryDate = DateFormat('dd-MM-yyyy').parse(deliveryDate.value);
    saleOrder.isAppliedScheme = model.isAppliedScheme ?? false;
    saleOrder.netAmount = Helper.customRound(saleOrder.netAmount ?? 0.0, decimalPlaces: Helper.requestContext.decimalPlaces).toDouble();

    for (var invoiceDetail in model.invoiceDetails) {
      saleOrderDetail = SaleOrderDetailsModel();
      saleOrderDetail.id = invoiceDetail.id;
      saleOrderDetail.branchId = userData.branchId ?? 0;
      saleOrderDetail.productId = invoiceDetail.productId ?? 0;
      saleOrderDetail.price = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.price! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.price ?? 0;
      saleOrderDetail.companySlug = model.companySlug;
      saleOrderDetail.discountInPercent = invoiceDetail.discountInPercent;
      saleOrderDetail.discountAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.discountAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.discountAmount ?? 0;
      saleOrderDetail.taxAmount = (invoiceDetail.taxAmount ?? 0);
      saleOrderDetail.isMRPExclusiveTax = invoiceDetail.isMRPExclusiveTax ?? false;
      saleOrderDetail.quantity = invoiceDetail.quantity ?? 0;
      saleOrderDetail.grossAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.grossAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.grossAmount ?? 0;
      saleOrderDetail.netAmount = customerCurrencyId != 0 && customerCurrencyId != Helper.requestContext.currencyId ? (invoiceDetail.netAmount! / num.parse(exchangeRateController.value.text == "" ? "1" : this.exchangeRateController.value.text)) : invoiceDetail.netAmount ?? 0;
      saleOrderDetail.isBonusProduct = invoiceDetail.isBonusProduct ?? false;
      saleOrderDetail.accountId = invoiceDetail.accountId;
      saleOrderDetail.branchId = invoiceDetail.batchId;
      saleOrderDetail.remainingQuantity = 0;
      saleOrderDetail.maximumRetailPrice = invoiceDetail.maximumRetailPrice ?? 0.0;
      saleOrderDetail.purchasePrice = invoiceDetail.purchasePrice ?? 0.0;
      saleOrderDetail.isInitial = true;
      var taxes = await SaleOrderDetailTaxesDatabase.dao.SelectList("saleOrderDetailId = ${invoiceDetail.id}");
      saleOrderDetail.taxes ??= [];
      saleOrderDetail.taxes?.addAll(taxes ?? []);

      var matchingElement = cartModels.firstWhereOrNull(
        (element) => element.productId == invoiceDetail.productId,
      );

      if (matchingElement != null) {
        saleOrderDetail.description = matchingElement.description;
      }

      detail.add(saleOrderDetail);
    }

    List<SchemeInvoiceDiscountModel> schemeInvoiceDiscounts = [];
    SchemeInvoiceDiscountModel schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();

    for (var discount in model.invoiceDiscounts.where((element) => (element.discountAmount ?? 0).abs() > 0 && element.discountType == DiscountInvoiceType.Scheme)) {
      schemeInvoiceDiscountModel = SchemeInvoiceDiscountModel();
      schemeInvoiceDiscountModel.appliedOn = discount.appliedOn;
      schemeInvoiceDiscountModel.branchId = userData.branchId;
      schemeInvoiceDiscountModel.companySlug = userData.companyId;
      schemeInvoiceDiscountModel.currencyId = currencyModel?.id;
      schemeInvoiceDiscountModel.discountAmount = discount.discountAmount?.abs();
      schemeInvoiceDiscountModel.discountPercent = discount.discountPercent;
      schemeInvoiceDiscountModel.schemeId = discount.schemeId;
      schemeInvoiceDiscountModel.discountType = discount.discountType;
      schemeInvoiceDiscountModel.narration = "SaleOrder: ${saleOrder.number}";
      schemeInvoiceDiscountModel.sort = 0;
      schemeInvoiceDiscountModel.source = "SaleOrder";
      schemeInvoiceDiscountModel.sourceCreatedOn = DateTime.now().toUtc();
      schemeInvoiceDiscountModel.discountId = discount.discountId;
      schemeInvoiceDiscounts.add(schemeInvoiceDiscountModel);
    }

    var response = await SaleOrderDatabase.NewInsert(saleOrder, detail, discounts, schemeInvoiceDiscount: schemeInvoiceDiscounts, attachments: attachmentsController.attachments, hideLoading: hideLoading);
    return response;
  }

  Future<void> Delete(SaleOrderModel saleOrder) async {
    try {
      Helper.showLoading();
      if (saleOrder.number == null || saleOrder.number!.isEmpty) {
        await SaleOrderDatabase.dao.deleteById(saleOrder.id!);
      } else {
        await DeleteServer(saleOrder.id!);
      }
    } catch (ex) {
      log("$ex");
    } finally {
      Helper.dialogHide();
    }
  }

  Future<void> DeleteServer(int id) async {
    //
    var api = "${Helper.user.companyId}/${Helper.user.branchId}/SaleOrders/$id";
    var response = await this.baseClient.delete(ApiEndPoint.baseUrl, api).catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      //
    }
  }

  Future<void> DeleteCart(int? saleOrderId) async {
    if (saleOrderId != null) {
      await CartDatabase().DeleteAll();
      Helper.cartList.value = [];
      cartController.cartItemCount.value = 0;
      Helper.customerId.value = 0;
    }
  }
}
