import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sa_common/company/Models/LicenseStatusModel.dart';
import 'package:sa_common/login/UserDatabase.dart';
import 'package:sa_common/login/UserModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/pref_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/BaseController.dart';
import '../../HttpService/Basehttp.dart';
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
  Future<List<CompanyModel>> GetAllCompanies() async {
    lstCompany = [];
    var response = await BaseClient().get(ApiEndPoint.getAllCompanies).catchError(
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

  Future<LicenseStatusModel?> GetLicense(String companySlg) async {
    var response = await BaseClient().get(companySlg + ApiEndPoint.licenseStatus).catchError(
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

  Future<List<AllActiveSubscriptionModel>> AllActiveSubscription(String companySlg) async {
    List<AllActiveSubscriptionModel> lstActive = [];
    var response = await BaseClient().get(companySlg + ApiEndPoint.allActiveSubscription).catchError(
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

  Future<bool> CheckStatus(CompanyModel model, {String? companyName = "", String? companyLogo = "", VoidCallback? openPage}) async {
    status.value = Status.loading;
    var prefs = await SharedPreferences.getInstance();
    prefs.setString(LocalStorageKey.companySlug, (model.slug ?? ""));
    var getLicense = await GetLicense(model.slug!);
    if (getLicense?.licenseStatus == null) {
      //hideLoading();
      status.value = Status.error;
      return false;
    }
    if (getLicense?.licenseStatus == 20 || getLicense?.licenseStatus == 40 || getLicense?.licenseStatus == 100) {
      //hideLoading();
      //DialogHelper.showErrorDialog(description: "Your license has expired!!");
      status.value = Status.error;
      message.value = "Your license has expired!!";
      return false;
    }

    var allActives = await AllActiveSubscription(model.slug!);

    SaveCompanySetting(model);

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
        status.value = Status.success;
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
        status.value = Status.success;
        //Get.toNamed(Routes.BRANCHES, arguments: [companyName, companyLogo]);
        openPage;
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

  Future<void> GetCompany() async {
    var companyId = Helper.requestContext.id;
    var response = await BaseClient().get(ApiEndPoint.getAllCompanies + "/${companyId}").catchError((error) {
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
      }
      await CompanySettingDatabase().newUpdate(companyModel);
      if (companySettings != null) {
        Helper.requestContext = companyModel;
      }
    }
  }

  Future<void> SaveCompanySetting(CompanyModel model) async {
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
      await CompanySettingDatabase().newUpdate(saveCompanySetting);
    }
    var companySettings = await CompanySettingDatabase().GetCompany();
    if (companySettings != null) {
      Helper.requestContext = companySettings;
    }
    Logger.InfoLog("Create Folder");
    var path = await Helper.createFolder("uploads/${model.slug}/");
    Logger.InfoLog("Path $path");
    if (Helper.requestContext.logo!.isNotEmpty) {
      var imageUrl = ApiEndPoint.ImageBaseUrl + model.logo!;
      Logger.InfoLog("Image Url $imageUrl");
      if (imageUrl.isNotEmpty) {
        Uri uri = Uri.parse(imageUrl);
        final imageData = await http.get(uri);
        var data = await File(join(path, imageUrl.split("/").last)).create(recursive: true);
        await data.writeAsBytes(imageData.bodyBytes);
      }
    }
  }

  Future<List<Branches>?> GetBranches() async {
    lstBranches = [];
    var prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt(LocalStorageKey.localUserId) as int;
    var user = await UserDatabase.instance.GetUserById(userId);
    var response = await BaseClient().get("${user.companyId}/" + ApiEndPoint.branches + "${user.userId}").catchError((error) {
      handleError(error);
      throw error;
    });
    if (response != null) {
      lstBranches = Branches().FromJson(response.body);
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
    openPage;
    // Get.delete<DashboardController>(force: true);
    // Get.to(
    //     () => DashboardView(
    //           isPull: true,
    //         ),
    //     arguments: [companyLogo]);
  }
}
