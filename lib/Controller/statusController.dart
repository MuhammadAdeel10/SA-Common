import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/generated/locales.g.dart';

class StatusController extends BaseController {
  Rx<Status> status = Status.idle.obs;
  RxString message = "Please Wait...".obs;
  RxString errorTitle = "".obs;
  RxString errorMessage = "".obs;
  RxString routeName = "".obs;

  String _loaderText = LocaleKeys.common_pleaseWaitText.tr;
  String get loaderText => _loaderText;

  @protected
  void loaderTextMsg(String msgText) {
    _loaderText = msgText;
    update();
  }
}
