import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/Controller/statusController.dart';
import 'package:sa_common/company/Database/company_setting_database.dart';
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
  StatusController statusController = Get.put(StatusController());
  //SynchronizationController synchronizationController = Get.put(SynchronizationController());

  Future<dynamic> login(String baseUrl, String email, String password, {VoidCallback? errorDialogOpen}) async {
    //synchronizationController.LoaderText('Please Wait..!');
    statusController.status.value = Status.loading;
    var hashPassword = CipherService.Encrypt(password);
    UserModel? checkUser = await UserDatabase.instance.getLogin(email.toLowerCase(), hashPassword);
    var prefs = await PrefUtils();
    var hasNetwork = await Helper.hasNetwork(baseUrl);
    if (hasNetwork) {
      var payloadMap = {UserFields.email: email, UserFields.password: password};
      var response = await BaseClient().post(baseUrl, ApiEndPoint.logIn, payloadMap).catchError((error) {
        handleError(error);
      });
      if (response != null) {
        var jsonDecode = json.decode(response.body);
        //var prefs = await SharedPreferences.getInstance();
        prefs.SetPreferencesString(LocalStorageKey.token, jsonDecode["token"]);
        var userId = jsonDecode["id"];
        var expiryInSeconds = jsonDecode["expires_in"];
        var userProfile = await GetUserProfile(baseUrl);
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

        statusController.status.value = Status.success;
        statusController.routeName.value = Routes.COMPANY;
        //Get.toNamed(Routes.COMPANY);
      }
      return response;
    } else {
      if (checkUser == null) {
        //hideLoading();
        statusController.status.value = Status.error;
        Helper.errorMsg("User Not Found", "", context);
        // DialogHelper.showErrorDialog(description: "User Not Found");
      } else if (DateTime.now().compareTo(checkUser.expiry!) > 0) {
        //hideLoading();
        statusController.status.value = Status.error;
        Helper.errorMsg("License Expired", "", context);
        // DialogHelper.showErrorDialog(description: "License Expired");
      } else {
        prefs.SetPreferencesString(LocalStorageKey.companySlug, (checkUser.companyId ?? ""));
        prefs.SetPreferencesInteger(LocalStorageKey.companyCount, 1);
        prefs.SetPreferencesInteger(LocalStorageKey.brachCount, 1);
        prefs.SetPreferencesInteger(LocalStorageKey.localUserId, checkUser.id ?? 0);
        prefs.SetPreferencesString(LocalStorageKey.userId, checkUser.userId ?? "");

        var companySetting = await CompanySettingDatabase().GetCompany();

        if (companySetting != null) {
          Helper.requestContext = companySetting;
        }

        statusController.status.value = Status.success;
        Helper.plainPassword = password;
        statusController.routeName.value = Routes.DASHBOARD;
        //Get.toNamed(Routes.DASHBOARD);
      }
    }
  }

  Future<UserModel?> GetUserProfile(String baseUrl) async {
    //
    var response = await BaseClient().get(baseUrl, "UserProfile").catchError((error) {
      handleError(error);
    });
    if (response != null && response.statusCode == 200) {
      var jsonDecode = json.decode(response.body);
      var model = UserModel.fromJson(jsonDecode, isProfile: true);
      return model;
    }
    return null;
  }

  Future<void> ForgotPassword(String baseUrl, String email) async {
    //showLoading();
    statusController.status.value = Status.loading;

    var payloadMap = {
      "email": email,
    };
    var response = await BaseClient().postWithoutAuthorizationToken(baseUrl, ApiEndPoint.forgotPassword, payloadMap).catchError((error) {
      handleError(error);
    });

    if (response != null && response.statusCode == 200) {
      statusController.status.value = Status.success;
      Helper.successMsg("Reset Password", "Reset password instructions have been sent to your email", context);
    } else {
      statusController.status.value = Status.error;
    }
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

  Future<void> AutoLogIn(String baseUrl, VoidCallback openChallengeLogInPopUp) async {
    var pref = PrefUtils();
    var token = pref.GetPreferencesString(LocalStorageKey.token);
    var plainPassword = Helper.plainPassword;
    if (token == "" && plainPassword != "") {
      var hasNetwork = await Helper.hasNetwork(baseUrl);
      if (hasNetwork) {
        var user = Helper.user;

        var payloadMap = {UserFields.email: user.email, UserFields.password: plainPassword};
        var response = await BaseClient().post(baseUrl, ApiEndPoint.logIn, payloadMap).catchError((error) {
          if (error is BadRequestException) {
            // Get.dialog(ChallengeLogInPopUp(context!),
            //     barrierDismissible: false);
            openChallengeLogInPopUp();
            // Helper.errorMsg(
            //     "Bad Request", message ?? "Something went wrong", context!);
          }
        });
        await CheckResponse(baseUrl, response);
      }
    }
  }

  Future<bool> ChallengePOpUp(String baseUrl, String email, String password) async {
    if (email != "" && password != "") {
      Helper.errorMsg("LogIn", "Email or Password can not be empty", context);

      var hasNetwork = await Helper.hasNetwork(baseUrl);
      if (hasNetwork) {
        var payloadMap = {UserFields.email: email, UserFields.password: password};
        var response = await BaseClient().post(baseUrl, ApiEndPoint.logIn, payloadMap).catchError((error) {
          handleError(error);
          Get.toNamed(Routes.LOGIN);
          return false;
        });
        if (response == null && response.statusCode != 200) {
          return false;
        }
        await CheckResponse(baseUrl, response);
        Get.back();
        return true;
      }
      return false;
    }
    return false;
  }

  Future<void> CheckResponse(String baseUrl, response) async {
    var user = Helper.user;
    var pref = PrefUtils();
    if (response != null && response.statusCode == 200) {
      var jsonDecode = json.decode(response.body);

      pref.SetPreferencesString(LocalStorageKey.token, jsonDecode["token"]);
      pref.SetPreferencesInteger(LocalStorageKey.localUserId, user.id ?? 0);
      pref.SetPreferencesString(LocalStorageKey.userId, user.userId ?? "");
      pref.SetPreferencesString(LocalStorageKey.companySlug, user.companyId ?? "");
      var getAllCompanies = await companyController.GetAllCompanies(baseUrl);
      if (getAllCompanies.isNotEmpty) {
        pref.SetPreferencesInteger(LocalStorageKey.companyCount, getAllCompanies.length);
      }
      await companyController.GetBranches(baseUrl);
    }
  }

  Future<void> RefreshToken(String baseUrl) async {
    if (await Helper.hasNetwork(baseUrl)) {
      var pref = PrefUtils();
      var token = pref.GetPreferencesString(LocalStorageKey.token);
      if (token.isNotEmpty && token != "") {
        var response = await BaseClient().post(baseUrl, ApiEndPoint.refreshToken, null).catchError((error) {
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
