import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/company/Models/LicenseStatusModel.dart';
import 'package:sa_common/login/UserDatabase.dart';
import 'package:sa_common/login/UserModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/app_routes.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/BaseController.dart';
import '../../Controller/statusController.dart';
import '../Database/company_setting_database.dart';
import '../Models/AllActiveSubscription.dart';
import '../Models/CompanySettingModel.dart';
import '../Models/companyModel.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

class CompanyController extends BaseController {
  List<CompanyModel> lstCompany = [];
  List<CompanySettingModel> lstCompanySetting = [];
  List<Branches> lstBranches = [];
  StatusController statusController = Get.put(StatusController());
  Future<List<CompanyModel>> GetAllCompanies(String baseUrl) async {
    lstCompany = [];
    var response = await baseClient.get(baseUrl, ApiEndPoint.getAllCompanies).catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      // var jsonDecode = json.decode(response.body);

      lstCompanySetting = CompanySettingModel().FromJson(response.body);

      lstCompany = CompanyModel().stringToList(response.body);
    }
    var pref = await SharedPreferences.getInstance();
    pref.setInt(LocalStorageKey.companyCount, lstCompany.length);
    return lstCompany;
  }

  Future<LicenseStatusModel?> GetLicense(String baseUrl, String companySlg) async {
    var response = await baseClient.get(baseUrl, companySlg + ApiEndPoint.licenseStatus).catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );
    if (response != null) {
      var jsonDecode = json.decode(response.body);
      var model = LicenseStatusModel.fromJson(jsonDecode);
      return model;
    }
    return null;
  }

  Future<List<AllActiveSubscriptionModel>> AllActiveSubscription(String baseUrl, String companySlg) async {
    List<AllActiveSubscriptionModel> lstActive = [];
    var response = await baseClient.get(baseUrl, companySlg + ApiEndPoint.allActiveSubscription).catchError(
      (error) {
        handleError(error);
        throw error;
      },
    );

    if (response != null) {
      var jsonDecode = json.decode(response.body);
      for (var element in jsonDecode) {
        if (element != null) {
          var model = AllActiveSubscriptionModel.fromJson(element);
          lstActive.add(model);
        }
      }
    }
    return lstActive;
  }

  Future<bool> CheckStatus(String baseUrl, String imageBaseUrl, CompanyModel model, {String? companyName = "", String? companyLogo = "", VoidCallback? openPage, BuildContext? context}) async {
    statusController.status.value = Status.loading;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalStorageKey.companySlug, (model.slug ?? ""));
    var getLicense = await GetLicense(baseUrl, model.slug!);
    if (getLicense?.licenseStatus == null) {
      //hideLoading();
      statusController.status.value = Status.error;
      return false;
    }
    if (getLicense?.licenseStatus == LicenseStatus.Deactivated.value || getLicense?.licenseStatus == LicenseStatus.AwaitingPayment.value || getLicense?.licenseStatus == LicenseStatus.Expired.value) {
      //hideLoading();
      //DialogHelper.showErrorDialog(description: "Your license has expired!!");
      statusController.status.value = Status.error;
      Helper.infoMsg("Your license has expired!", "", context);
      return false;
    }

    var allActives = await AllActiveSubscription(baseUrl, model.slug!);

    SaveCompanySetting(imageBaseUrl, model);

    if (allActives.length > 0) {
      final allActive = (allActives.length) > 0 ? allActives.first : null;

      // var prefs = await SharedPreferences.getInstance();
      var userId = prefs.get(LocalStorageKey.localUserId) as int;
      var UserData = await UserDatabase.instance.GetUserById(userId);
      if (model.branches?.length == 1) {
        var branch = model.branches?[0];
        //(model.branches!.length) > 0 ? model.branches!.first : null;
        int? branchId = branch?.id;
        var user = UserModel(
          id: UserData.id,
          email: UserData.email,
          password: UserData.password,
          expiry: DateTime.tryParse(allActive!.expiryDate!),
          companyId: model.slug,
          userId: UserData.userId,
          branchId: branchId,
          prefix: branch!.prefix!,
          fullName: UserData.fullName,
          phoneNumber: UserData.phoneNumber,
          imageUrl: UserData.imageUrl,
          isActive: UserData.isActive,
          isPrivacyMode: UserData.isPrivacyMode,
        );
        await UserDatabase.instance.update(user);
        //hideLoading();
        statusController.status.value = Status.success;
        prefs.setInt(LocalStorageKey.brachCount, model.branches!.length);

        // Get.toNamed(Routes.INVOICE);
        if (Helper.requestContext.defaultPOSCustomerId == 0) {
          var pref = PrefUtils();
          pref.ClearCustomerNameUpdate(1);
          pref.ClearCustomerNameUpdate(2);
          pref.ClearCustomerNameUpdate(3);
        }
        // Get.delete<DashboardController>(force: true);
        // Get.to(
        //     () => DashboardView(
        //           isPull: true,
        //         ),
        //     arguments: [companyLogo]);
        statusController.routeName.value = Routes.DASHBOARD;
        return true;
      } else {
        var user = UserModel(
          id: UserData.id,
          email: UserData.email,
          password: UserData.password,
          expiry: DateTime.tryParse(allActive!.expiryDate!),
          companyId: model.slug,
          userId: UserData.userId,
          fullName: UserData.fullName,
          phoneNumber: UserData.phoneNumber,
          imageUrl: UserData.imageUrl,
          isActive: UserData.isActive,
          isPrivacyMode: UserData.isPrivacyMode,
        );
        await UserDatabase.instance.update(user);
        //Pop Up Or Other Work ToDo
        //hideLoading();
        statusController.status.value = Status.success;
        statusController.routeName.value = Routes.BRANCHES;
        //Get.toNamed(Routes.BRANCHES, arguments: [companyName, companyLogo]);
      }
    }

    return true;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> GetCompany(String baseUrl) async {
    var companyId = Helper.requestContext.id;
    var response = await baseClient.get(baseUrl, ApiEndPoint.getAllCompanies + "/${companyId}").catchError((error) {
      handleError(error);
      throw error;
    });
    if (response != null) {
      var jsonDecode = json.decode(response.body);
      var companyModel = CompanySettingModel.fromMap(jsonDecode);
      var companySettings = await CompanySettingDatabase().GetCompany();
      if (companySettings != null) {
        companyModel.defaultPOSCustomerId = companySettings.defaultPOSCustomerId;
        companyModel.printerName = companySettings.printerName;
        companyModel.allowDuplicateProducts = companySettings.allowDuplicateProducts;
        companyModel.address1 = companySettings.address1;
        companyModel.address2 = companySettings.address2;
        companyModel.phone = companySettings.phone;
        companyModel.city = companySettings.city;
        companyModel.state = companySettings.state;
        companyModel.zip = companySettings.zip;
      }
      await CompanySettingDatabase().newUpdate(companyModel);
      if (companySettings != null) {
        Helper.requestContext = companyModel;
      }
    }
  }

  Future<CompanySettingModel?> SaveCompanySetting(String imageBaseUrl, CompanyModel model) async {
    var saveCompanySetting = lstCompanySetting.firstWhere((element) => element.slug == model.slug!);
    if (model.branches == null) {
      model.branches = [];
    }
    if (model.enableBranch == true) {
      if (model.branches != null && model.branches!.any((element) => true)) {
        for (var branch in model.branches!) {
          saveCompanySetting.defaultPOSCustomerId = branch.defaultPOSCustomerId ?? 0;
        }
      }
    } else {
      saveCompanySetting.defaultPOSCustomerId = saveCompanySetting.defaultPOSCustomerId;
    }

    var companySetting = await CompanySettingDatabase.Get(saveCompanySetting.id.toString());
    if (companySetting == null)
      await CompanySettingDatabase.dao.insert(saveCompanySetting);
    else {
      saveCompanySetting.printerName = companySetting.printerName;
      saveCompanySetting.allowDuplicateProducts = companySetting.allowDuplicateProducts;
      await CompanySettingDatabase().newUpdate(saveCompanySetting);
    }
    var companySettings = await CompanySettingDatabase().GetCompany();
    if (companySettings != null) {
      Helper.requestContext = companySettings;
      return companySettings;
    }
    Logger.InfoLog("Create Folder");
    var path = await Helper.createFolder("uploads/${model.slug}/");
    Logger.InfoLog("Path $path");
    if (Helper.requestContext.logo!.isNotEmpty) {
      var imageUrl = imageBaseUrl + model.logo!;
      Logger.InfoLog("Image Url $imageUrl");
      if (imageUrl.isNotEmpty) {
        Uri uri = Uri.parse(imageUrl);
        final imageData = await http.get(uri);
        var data = await File(join(path, imageUrl.split("/").last)).create(recursive: true);
        await data.writeAsBytes(imageData.bodyBytes);
      }
    }
    return null;
  }

  Future<List<Branches>?> GetBranches(String baseUrl) async {
    lstBranches = [];
    var prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(LocalStorageKey.localUserId) as int;
    var user = await UserDatabase.instance.GetUserById(userId);
    var response = await baseClient.get(baseUrl, "${user.companyId}/" + ApiEndPoint.branches + "${user.userId}").catchError((error) {
      handleError(error);
      throw error;
    });
    if (response != null) {
      lstBranches = Branches().FromJson(response.body);
      lstBranches = lstBranches.where((element) => element.isActive == true).toList();
      var pref = await SharedPreferences.getInstance();
      pref.setInt(LocalStorageKey.brachCount, lstBranches.length);
      return lstBranches;
    } else {
      return null;
    }
  }

  Future<void> SetBranch(int branchId, String prefix, int defaultPOSCustomerId, {String? companyLogo = "", VoidCallback? openPage}) async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.get(LocalStorageKey.localUserId) as int;
    var UserData = await UserDatabase.instance.GetUserById(userId);
    var user = UserModel(id: UserData.id, email: UserData.email, password: UserData.password, expiry: UserData.expiry, companyId: UserData.companyId, userId: UserData.userId, fullName: UserData.fullName, phoneNumber: UserData.phoneNumber, imageUrl: UserData.imageUrl, isActive: UserData.isActive, isPrivacyMode: UserData.isPrivacyMode, branchId: branchId, prefix: prefix);
    await UserDatabase.instance.update(user);

    Helper.requestContext.defaultPOSCustomerId = defaultPOSCustomerId;
    if (defaultPOSCustomerId == 0) {
      var pref = PrefUtils();
      pref.ClearCustomerNameUpdate(1);
      pref.ClearCustomerNameUpdate(2);
      pref.ClearCustomerNameUpdate(3);
    }
    CompanySettingDatabase().newUpdate(Helper.requestContext);
    statusController.routeName.value = Routes.DASHBOARD;

    // Get.delete<DashboardController>(force: true);
    // Get.to(
    //     () => DashboardView(
    //           isPull: true,
    //         ),
    //     arguments: [companyLogo]);
  }
}
