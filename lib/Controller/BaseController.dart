import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/app_routes.dart';
import '../HttpService/AppExceptions.dart';

enum Status { idle, loading, success, error }

abstract class BaseController extends GetxController {
  BaseClient baseClient = BaseClient();
  BuildContext? context = Get.key.currentContext;

  @protected
  void handleError(
    error, {
    VoidCallback? goLoginPage,
  }) {
    //status.value = Status.error;
    Helper.dialogHide();
    if (error is BadRequestException) {
      var message = error.message;
      Helper.errorMsg("Bad Request", message ?? "Something went wrong", context!);
    } else if (error is ApiNotRespondingException) {
    } else if (error is ForbiddenException) {
      Helper.errorMsg("Unauthorized", "You are not authorized to access in this page", context!);
    } else if (error is UnAuthorizedException) {
      if (goLoginPage != null) {
        goLoginPage();
      }
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
      Helper.infoMsg('${error.message}', 'Session Expired', context!);
    } else if (error is NotFoundException) {
      Helper.errorMsg('Not Found', error.message ?? "Something went wrong", context!);
    } else if (error is LockException) {
      if (goLoginPage != null) {
        goLoginPage();
      }
      Get.offNamedUntil(Routes.LOGIN, (route) => false);
      Helper.infoMsg('Session Expired', 'You are already logged in another session', context!);
    } else {
      Helper.errorMsg("Error", "Something went wrong", context!);
    }
  }

  Future<void> genericPull<T>({required String baseUrl, required String tableName, required String slug, required String apiEndPoint, required Function(Map<String, dynamic> json, String slug) fromJson, required Future<void> Function(List<T> data) bulkInsert, int page = 1, int pageSize = 5000, bool isBranch = false, int? branchId}) async {
    try {
      var getSyncSetting = await SyncSettingDatabase.GetByTableName(tableName, slug: slug, branchId: branchId, isBranch: isBranch);
      DateTime syncDate = DateTime.now().toUtc();
      var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);

      var response = await this.baseClient.get(baseUrl, "$slug/$apiEndPoint/$syncDateString?page=$page&pageSize=$pageSize").catchError((error) {
        handleError(error);
      });

      if (response != null && response.statusCode == 200) {
        var decoded = json.decode(response.body);
        if (decoded.isNotEmpty) {
          var currentPage = decoded['page'];
          var totalPages = decoded['pages'];
          var results = decoded['results'];

          var dataList = List<T>.from(
            results.map((x) => fromJson(x, slug)),
          );

          await bulkInsert(dataList);

          if (currentPage < totalPages) {
            await genericPull<T>(baseUrl: baseUrl, tableName: tableName, slug: slug, apiEndPoint: apiEndPoint, fromJson: fromJson, bulkInsert: bulkInsert, page: currentPage + 1, pageSize: pageSize, branchId: branchId, isBranch: isBranch);
          }
        }

        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    } catch (ex) {
      Logger.ErrorLog("Error in genericPull for $tableName: $ex");
    }
  }
  // showLoading([String? message]) {
  //   DialogHelper.showLoading(message);
  // }

  // hideLoading() {
  //   DialogHelper.hideLoading();
  // }
}
