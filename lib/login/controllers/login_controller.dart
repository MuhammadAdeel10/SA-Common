import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/company/Models/CompanySettingModel.dart';
import 'package:sa_common/company/controllers/company_controller.dart';
import 'package:sa_common/utils/CipherService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Controller/BaseController.dart';
import '../../HttpService/AppExceptions.dart';
import '../../HttpService/Basehttp.dart';
import '../../utils/ApiEndPoint.dart';
import '../../utils/DatabaseHelper.dart';
import '../../utils/Helper.dart';
import '../../utils/LocalStorageKey.dart';
import '../../utils/app_routes.dart';
import '../../utils/pref_utils.dart';
import '../UserDatabase.dart';
import '../UserModel.dart';

class LoginController extends BaseController {
  Type db = DatabaseHelper;
  var isObscurePassword = true.obs;
  RxBool isValid = false.obs;
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  CompanyController companyController = Get.put(CompanyController());
  //SynchronizationController synchronizationController = Get.put(SynchronizationController());

  Future<dynamic> login(String email, String password, {VoidCallback? errorDialogOpen, Future<CompanySettingModel?>? companySettingModel}) async {
    //synchronizationController.LoaderText('Please Wait..!');
    status.value = Status.loading;
    var hashPassword = CipherService.Encrypt(password);
    UserModel? checkUser = await UserDatabase.instance.getLogin(email.toLowerCase(), hashPassword);
    var prefs = await PrefUtils();
    var hasNetwork = await Helper.hasNetwork();
    if (hasNetwork) {
      var payloadMap = {UserFields.email: email, UserFields.password: password};
      var response = await BaseClient().post(ApiEndPoint.logIn, payloadMap).catchError((error) {
        handleError(error);
      });
      if (response != null) {
        var jsonDecode = json.decode(response.body);
        //var prefs = await SharedPreferences.getInstance();
        prefs.SetPreferencesString(LocalStorageKey.token, jsonDecode["token"]);
        var userId = jsonDecode["id"];
        var expiryInSeconds = jsonDecode["expires_in"];
        var userProfile = await GetUserProfile();
        UserModel? userResponse = checkUser;

        if (userResponse == null) {
          final user = UserModel(
            email: email,
            password: hashPassword,
            expiry: DateTime.now(),
            userId: userId,
          );
          if (userProfile != null) {
            user.fullName = userProfile.fullName;
            user.phoneNumber = userProfile.phoneNumber;
            user.imageUrl = userProfile.imageUrl;
            user.isActive = userProfile.isActive;
            user.isPrivacyMode = userProfile.isPrivacyMode;
          }
          userResponse = await UserDatabase.instance.create(user);
        } else {
          if (userProfile != null) {
            userResponse.fullName = userProfile.fullName;
            userResponse.phoneNumber = userProfile.phoneNumber;
            userResponse.imageUrl = userProfile.imageUrl;
            userResponse.isActive = userProfile.isActive;
            userResponse.isPrivacyMode = userProfile.isPrivacyMode;
          }
          await UserDatabase.instance.update(userResponse);
        }
        prefs.SetPreferencesInteger(LocalStorageKey.expiryInSeconds, expiryInSeconds ?? 0);
        prefs.SetPreferencesInteger(LocalStorageKey.localUserId, userResponse.id ?? 0);
        prefs.SetPreferencesString(LocalStorageKey.userId, userResponse.userId ?? "");

        status.value = Status.success;
        routeName.value = Routes.COMPANY;
        //Get.toNamed(Routes.COMPANY);
      }
      return response;
    } else {
      if (checkUser == null) {
        //hideLoading();
        status.value = Status.error;
        Helper.errorMsg("User Not Found", "", context);
        // DialogHelper.showErrorDialog(description: "User Not Found");
      } else if (DateTime.now().compareTo(checkUser.expiry!) > 0) {
        //hideLoading();
        status.value = Status.error;
        Helper.errorMsg("License Expired", "", context);
        // DialogHelper.showErrorDialog(description: "License Expired");
      } else {
        prefs.SetPreferencesString(LocalStorageKey.companySlug, (checkUser.companyId ?? ""));
        prefs.SetPreferencesInteger(LocalStorageKey.companyCount, 1);
        prefs.SetPreferencesInteger(LocalStorageKey.brachCount, 1);
        prefs.SetPreferencesInteger(LocalStorageKey.localUserId, checkUser.id ?? 0);
        prefs.SetPreferencesString(LocalStorageKey.userId, checkUser.userId ?? "");

        var companySetting = await companySettingModel;
        if (companySetting != null) {
          Helper.requestContext = companySetting;
        }
        status.value = Status.success;
        Helper.plainPassword = password;
        routeName.value = Routes.DASHBOARD;
        //Get.toNamed(Routes.DASHBOARD);
      }
    }
  }

  Future<UserModel?> GetUserProfile() async {
    //
    var response = await BaseClient().get("UserProfile").catchError((error) {
      handleError(error);
    });
    if (response != null && response.statusCode == 200) {
      var jsonDecode = json.decode(response.body);
      var model = UserModel.fromJson(jsonDecode, isProfile: true);
      return model;
    }
    return null;
  }

  Future<void> ForgotPassword(String email) async {
    //showLoading();
    status.value = Status.loading;

    var payloadMap = {
      "email": email,
    };
    await BaseClient().post(ApiEndPoint.forgotPassword, payloadMap).catchError((error) {
      handleError(error);
    });
  }

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> AutoLogIn(VoidCallback openChallengeLogInPopUp) async {
    var pref = PrefUtils();
    var token = pref.GetPreferencesString(LocalStorageKey.token);
    var plainPassword = Helper.plainPassword;
    if (token == "" && plainPassword != "") {
      var hasNetwork = await Helper.hasNetwork();
      if (hasNetwork) {
        var user = Helper.user;

        var payloadMap = {UserFields.email: user.email, UserFields.password: plainPassword};
        var response = await BaseClient().post(ApiEndPoint.logIn, payloadMap).catchError((error) {
          if (error is BadRequestException) {
            // Get.dialog(ChallengeLogInPopUp(context!),
            //     barrierDismissible: false);
            openChallengeLogInPopUp();
            // Helper.errorMsg(
            //     "Bad Request", message ?? "Something went wrong", context!);
          }
        });
        await CheckResponse(response);
      }
    }
  }

  Future<bool> ChallengePOpUp(String email, String password) async {
    if (email != "" && password != "") {
      Helper.errorMsg("LogIn", "Email or Password can not be empty", context);

      var hasNetwork = await Helper.hasNetwork();
      if (hasNetwork) {
        var payloadMap = {UserFields.email: email, UserFields.password: password};
        var response = await BaseClient().post(ApiEndPoint.logIn, payloadMap).catchError((error) {
          handleError(error);
          // Get.toNamed(Routes.LOGIN);
          return false;
        });
        if (response == null && response.statusCode != 200) {
          return false;
        }
        await CheckResponse(response);
        Get.back();
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> CheckResponse(response) async {
    var user = Helper.user;
    var pref = PrefUtils();
    if (response != null && response.statusCode == 200) {
      var jsonDecode = json.decode(response.body);

      pref.SetPreferencesString(LocalStorageKey.token, jsonDecode["token"]);
      pref.SetPreferencesInteger(LocalStorageKey.localUserId, user.id ?? 0);
      pref.SetPreferencesString(LocalStorageKey.userId, user.userId ?? "");
      pref.SetPreferencesString(LocalStorageKey.companySlug, user.companyId ?? "");
      var getAllCompanies = await companyController.GetAllCompanies();
      if (getAllCompanies.isNotEmpty) {
        pref.SetPreferencesInteger(LocalStorageKey.companyCount, getAllCompanies.length);
      }
      await companyController.GetBranches();
    }
  }

  Future<void> RefreshToken() async {
    if (await Helper.hasNetwork()) {
      var pref = PrefUtils();
      var token = pref.GetPreferencesString(LocalStorageKey.token);
      if (token.isNotEmpty && token != "") {
        var response = await BaseClient().post(ApiEndPoint.refreshToken, null).catchError((error) {
          handleError(error);
        });
        if (response != null && response.statusCode == 200) {
          {
            var jsonDecode = json.decode(response.body);
            var prefs = await SharedPreferences.getInstance();
            prefs.setString(LocalStorageKey.token, jsonDecode["token"]);
          }
        }
      }
    }
  }
}
