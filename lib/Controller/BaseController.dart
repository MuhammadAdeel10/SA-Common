import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/utils/Helper.dart';
import '../HttpService/AppExceptions.dart';

enum Status { idle, loading, success, error }

abstract class BaseController extends GetxController {
  BuildContext? context = Get.key.currentContext;
  Rx<Status> status = Status.idle.obs;
  RxString message = "Please Wait...".obs;
  RxString errorTitle = "".obs;
  RxString errorMessage = "".obs;
  RxString routeName = "".obs;
  @protected
  void handleError(
    error, {
    VoidCallback? goLoginPage,
  }) {
    status.value = Status.error;
    if (Get.isDialogOpen!) {
      Get.back();
    }
    if (error is BadRequestException) {
      var message = error.message;
      Helper.errorMsg("Bad Request", message ?? "Something went wrong", context!);
    } else if (error is ApiNotRespondingException) {
    } else if (error is ForbiddenException) {
      Helper.errorMsg("Unauthorized", "You are not authorized to access in this page", context!);
    } else if (error is UnAuthorizedException) {
      goLoginPage;
      // Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(
      //   builder: (context) {
      //     PrefUtils().clearPreferencesData();
      //     return LoginView();
      //   },
      // ), (route) => false);
      Helper.infoMsg('${error.message}', 'Session Expired', context!);
    } else if (error is NotFoundException) {
      Helper.errorMsg('Not Found', error.message ?? "Something went wrong", context!);
    } else if (error is LockException) {
      goLoginPage;
      // Navigator.pushAndRemoveUntil(context!, MaterialPageRoute(
      //   builder: (context) {
      //     PrefUtils().clearPreferencesData();
      //     return LoginView();
      //   },
      // ), (route) => false);
      Helper.infoMsg('Session Expired', 'You are already logged in another session', context!);
    } else {
      Helper.errorMsg("Error", "Something went wrong", context!);
    }
  }

  // showLoading([String? message]) {
  //   DialogHelper.showLoading(message);
  // }

  // hideLoading() {
  //   DialogHelper.hideLoading();
  // }
}
