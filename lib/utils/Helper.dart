import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:sa_common/Controller/statusController.dart';
import 'package:sa_common/SalesPerson/database/salesPerson_database.dart';
import 'package:sa_common/SalesPerson/model/SalesPersonModel.dart';
import 'package:sa_common/company/Models/CompanySettingModel.dart';
import 'package:sa_common/login/UserDatabase.dart';
import 'package:sa_common/login/UserModel.dart';
import 'package:sa_common/schemes/Database/discount_database.dart';
import 'package:sa_common/schemes/models/ProductSalesTaxModel.dart';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/schemes/models/tax_model.dart';
import 'package:sa_common/synchronization/Database/BranchProductTax_database.dart';
import 'package:sa_common/synchronization/Models/BranchProductTaxModel.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/app_routes.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:toastification/toastification.dart';
import '../Controller/BaseController.dart';
import '../productCategory/product_categoriesDatabase.dart';
import '../productCategory/product_categories_model.dart';
import '../schemes/database/productSalesTax_database.dart';
import '../schemes/database/product_database.dart';
import '../schemes/database/tax_database.dart';
import '../synchronization/Database/EndOfTheDay_database.dart';
import '../synchronization/Database/currency_database.dart';
import '../synchronization/Models/EndOfTheDay_model.dart';
import 'LocalStorageKey.dart';

class Helper extends BaseController {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  static List<ProductModel> productsModel = [];
  static List<ProductModel> allProductModel = [];
  static List<ProductCategoryModel> productCategoriesModel = [];
  static List<TaxModel> taxModel = [];
  static List<BranchProductTaxModel> branchProductSalesTaxModel = [];
  static List<ProductSalesTaxModel> productSalesTaxModel = [];
  static List<DiscountModel> discounts = [];
  static EndOfTheDayModel? endOfTheDayModel = null;
  static UserModel user = UserModel();
  static String plainPassword = "";
  static String homeCurrency = "";
  static SalesPersonModel? salePerson = SalesPersonModel();
  static bool isEmailValid(String email) {
    bool emailValid = RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(email);
    return emailValid;
  }

  static bool AmountLengthCheck({
    int lengthValue = 12,
    bool allowNegative = false,
    bool allowZero = false,
    bool isEmptyAllowed = false,
    String? input,
    bool allowDecimal = true,
    int? decimalPlaces,
  }) {
    if (isEmptyAllowed && input == "") {
      return true;
    }
    decimalPlaces = decimalPlaces ?? Helper.requestContext.decimalPlaces;
    String numberPattern = '\\d{1,$lengthValue}';
    if (allowDecimal && decimalPlaces > 0) {
      numberPattern += '(\\.\\d{1,$decimalPlaces})?';
    }
    String pattern = '^${allowNegative ? '-?' : ''}$numberPattern\$';
    bool check = RegExp(pattern).hasMatch(input ?? "");
    return check;
  }

  static Color buttonColor(String colorCode) {
    String angularColorCode = colorCode;
    String hexColorCode = angularColorCode.substring(1);
    Color flutterColor = Color(int.parse(hexColorCode, radix: 16) + 0xFF000000);
    return flutterColor;
  }

  static Future<String> createFolder(String folderName) async {
    if (Platform.isWindows) {
      Directory current = Directory.current;
      final path = current.path + "/" + folderName;
      var checkDirectory = await Directory(path).exists();
      if (!checkDirectory) {
        Directory(path).create();
      }
      return path;
    }
    return "";
  }

  static String getCurrentPath() {
    return Directory.current.path;
  }

  static Future<bool> hasNetwork(String baseUrl) async {
    StatusController statusController = Get.put(StatusController());

    try {
      final result = await InternetAddress.lookup("example.com");
      Logger.InfoLog("hasNetwork  $result");
      var response = await http.get(Uri.parse("${baseUrl}"));
      Logger.InfoLog("Site  statusCode:${response.statusCode}");
      if (response.statusCode != 200) {
        statusController.status.value = Status.error;
        return false;
      }
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      statusController.status.value = Status.error;
      // if (Get.isDialogOpen!) {
      //   Get.back();
      // }
      Logger.ErrorLog("hasNetwork  $_");
      return false;
    }
  }

  static dialogHide() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static warningMsg(String title, String description, BuildContext? context) {
    toastification.show(backgroundColor: Color(0xFFF89406), context: context ?? Get.key.currentContext!, type: ToastificationType.warning, style: ToastificationStyle.fillColored, title: title, description: description, alignment: Alignment.topCenter, autoCloseDuration: const Duration(seconds: 4), borderRadius: BorderRadius.circular(10.0), closeOnClick: true, pauseOnHover: true, showProgressBar: false);
  }

  static infoMsg(String title, String description, BuildContext? context) {
    toastification.show(backgroundColor: Color(0xFF2F96B4), context: context ?? Get.key.currentContext!, type: ToastificationType.info, style: ToastificationStyle.fillColored, title: title, description: description, alignment: Alignment.topCenter, autoCloseDuration: const Duration(seconds: 4), borderRadius: BorderRadius.circular(10.0), closeOnClick: true, pauseOnHover: true, showProgressBar: false);
  }

  static successMsg(String title, String description, BuildContext? context) {
    toastification.show(backgroundColor: Color(0xFF51A351), context: context ?? Get.key.currentContext!, type: ToastificationType.success, style: ToastificationStyle.fillColored, title: title, description: description, alignment: Alignment.topCenter, autoCloseDuration: const Duration(seconds: 4), borderRadius: BorderRadius.circular(10.0), closeOnClick: true, pauseOnHover: true, showProgressBar: false);
  }

  static errorMsg(String title, String description, BuildContext? context) {
    toastification.show(backgroundColor: Color(0xFFBD362F), context: context ?? Get.key.currentContext!, type: ToastificationType.error, style: ToastificationStyle.fillColored, title: title, description: description, alignment: Alignment.topCenter, autoCloseDuration: const Duration(seconds: 4), borderRadius: BorderRadius.circular(10.0), closeOnClick: true, pauseOnHover: true, showProgressBar: false);
  }

  static String getFormateDate(_date) {
    if (_date == null || _date == "") {
      return "";
    }
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd-MM-yyyy');
    return outputFormat.format(inputDate);
  }

  static String getFormattedTime(String? _date) {
    if (_date == null || _date.isEmpty) {
      return "";
    }
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('hh:mm:ss a');
    return outputFormat.format(inputDate);
  }

  static String getFormateDateMonth(_date) {
    if (_date == null || _date == "") {
      return "";
    }
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('MM-dd-yyyy');
    return outputFormat.format(inputDate);
  }

  static String maskCardNumber(String cardNumber) {
    // Check if the card number is at least 8 digits long
    if (cardNumber.length >= 8) {
      final firstFour = cardNumber.substring(0, 4);
      final lastFour = cardNumber.substring(cardNumber.length - 4);
      final maskedDigits = '*' * (cardNumber.length - 8); // Mask the middle digits
      return '$firstFour$maskedDigits$lastFour';
    } else {
      // If the card number is too short, return it as is
      return cardNumber;
    }
  }

  static NumberFormat numberFormatter = NumberFormat('#,##0.00');
  static NumberFormat numberFormatterWithoutZero = NumberFormat('#,###');
  static NumberFormat numberFormatterWithoutComa = NumberFormat('###0.00');
  static var companyName = "";
  static CompanySettingModel requestContext = CompanySettingModel();

  static DateFormat dateFormatter = DateFormat('MM/dd/yyyy hh:mm a');

  // static DateFormat dateFormatter = DateFormat('MM/dd/yyyy hh:mm a');

  static DateFormat onlyDateFormatter = DateFormat('MM-dd-yyyy');
  static DateFormat onlyDateFormatterDateMonth = DateFormat('dd-MM-yyyy');
  static DateFormat onlyDateFormatterYearMonth = DateFormat('yyyy-MM-dd');
  static DateFormat onlyTimeFormatter = DateFormat.jm();

  static String DateTimeRemoveZ(DateTime date) {
    var dateString = date.toIso8601String();

    if (dateString.contains("Z")) {
      dateString = dateString.replaceAll("Z", "");
    }
    return dateString;
  }

  static DateTime OnlyDateToday() {
    var now = DateTime.now().toUtc();
    var date = DateTime(now.year, now.month, now.day);
    return date;
  }

  static Future<void> FillLists() async {
    var branchId = user.branchId;
    productsModel = await ProductDatabase().getProducts();
    allProductModel = await ProductDatabase.dao.SelectList("isActive = 1 and (productType = 10 or (productType = 40 and baseProductId is not null))") ?? [];
    productCategoriesModel = await ProductCategoryDatabase().getProductsCategories();
    taxModel = await TaxDatabase().getByCompanySlug();
    productSalesTaxModel = await ProductSalesTaxDatabase().getByCompanySlug();
    branchProductSalesTaxModel = await BranchProductTaxDatabase().getByCompanySlug();
    discounts = await DiscountDatabase().getByCompanySlug();
    salePerson = await SalesPersonDatabase.dao.SelectSingle("applicationUserId = '${user.userId}'  ");
    var getLastEndOfDay = await EndOfTheDayDatabase.dao.SelectSingle("branchId = $branchId order by endOfDayDate desc");
    var currencyModel = await CurrencyDatabase.dao.SelectSingle("Id = ${Helper.requestContext.currencyId}");
    if (currencyModel != null) {
      homeCurrency = !Helper.requestContext.currencySymbol ? currencyModel.code : currencyModel.symbol;
    } else {
      homeCurrency = "";
    }
    endOfTheDayModel = getLastEndOfDay;
  }

  static Future<void> UserData() async {
    var prefs = PrefUtils();
    var userId = prefs.GetPreferencesInteger(LocalStorageKey.localUserId);
    user = await UserDatabase.instance.GetUserById(userId);
  }

  static Future<String> GetDeviceId() async {
    var windowsInfo = await Helper.deviceInfoPlugin.windowsInfo;
    return windowsInfo.deviceId;
  }

  static Future<String> GetDeviceName() async {
    var windowsInfo = await Helper.deviceInfoPlugin.windowsInfo;
    return windowsInfo.computerName;
  }

  static num customRound(num value, {int? decimalPlaces}) {
    decimalPlaces ??= Helper.requestContext.decimalPlaces;
    decimalPlaces = max(0, decimalPlaces);

    num shift = pow(10, decimalPlaces);
    num roundedValue = (value * shift).round() / shift;

    // Check for cases where rounding leads to a value very close to an integer
    num epsilon = pow(10, -decimalPlaces - 1);
    num diff = (roundedValue - value).abs();

    if (diff < epsilon) {
      roundedValue = value.isNegative ? roundedValue - epsilon : roundedValue + epsilon;
    }

    // Format the result with the desired number of decimal places
    var returnAmount = roundedValue.toStringAsFixed(decimalPlaces);
    return num.parse(returnAmount == "" ? "0" : returnAmount);
  }

  static const _pageSize = 50;
  static Future<void> fetchPage<T>(
    int pageKey, {
    required Future<List<T>?> fetchFunction,
    required PagingController<int, T> pagingController,
  }) async {
    try {
      final newItems = await fetchFunction.then(
        (value) {
          final isLastPage = value!.length < _pageSize;
          if (isLastPage) {
            pagingController.appendLastPage(value);
          } else {
            final nextPageKey = pageKey + 1;
            pagingController.appendPage(value, nextPageKey);
          }
        },
      );
    } catch (error) {
      pagingController.error = error;
    }
  }

  static void logAndShowError(String title, String message, String errorLogMessage, BuildContext? context, [bool navigateToLogin = false]) {
    Logger.ErrorLog(errorLogMessage);
    if (navigateToLogin) {
      Helper.infoMsg('Session Expired', 'You are already logged in another session', null);
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
    } else {
      Helper.errorMsg(title, message, context);
    }
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static http.Response handleHttpResponse(http.Response response) {
    final statusCode = response.statusCode;
    final requestInfo = 'Url: ${response.request}';
    final errorLogMessage = '$requestInfo Server Exception with statusCode: $statusCode data: ${response.body}';
    BuildContext? context = Get.key.currentContext;

    switch (statusCode) {
      case 200:
        Logger.InfoLog('Data Push Server statusCode: $statusCode $requestInfo');
        break;

      case 401:
      case 427:
      case 423:
        logAndShowError('Session Expired', 'You are already logged in another session', errorLogMessage, context, true);
        break;

      case 500:
        logAndShowError('Server Error', 'Internal Server Error', errorLogMessage, context);
        break;

      case 400:
        logAndShowError('Server Message', response.body, errorLogMessage, context);
        break;

      default:
        Logger.InfoLog('Unhandled statusCode: $statusCode $requestInfo');
        break;
    }

    return response;
  }
}
