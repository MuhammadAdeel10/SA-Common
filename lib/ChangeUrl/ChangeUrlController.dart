// lib/controllers/url_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/ChangeUrl/AppService.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/utils/Helper.dart';

class UrlController extends BaseController {
  final TextEditingController urlController = TextEditingController();
  final RxString currentUrl = ''.obs;
  final RxBool canSave = false.obs;

  final AppService _appService = Get.find();

  @override
  void onInit() {
    super.onInit();
    currentUrl.value = _appService.appUrl;
    urlController.text = currentUrl.value;

    urlController.addListener(() {
      canSave.value = urlController.text.trim() != currentUrl.value.trim();
    });
  }

  void saveUrl() async {
    String newUrl = urlController.text.trim();
    if (newUrl.isNotEmpty && canSave.value) {
      await _appService.setAppUrl(newUrl);
      currentUrl.value = newUrl;
      await Helper.SetBaseUrl();
      canSave.value = false;
      Get.back();
      Helper.successMsg("URL saved successfully", "", context);
    } else {
      Helper.errorMsg("Please enter a valid URL", "", context);
    }
  }
}
