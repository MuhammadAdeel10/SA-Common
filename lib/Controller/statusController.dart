import 'package:get/get.dart';
import 'package:sa_common/Controller/BaseController.dart';

class StatusController extends BaseController {
  Rx<Status> status = Status.idle.obs;
  RxString message = "Please Wait...".obs;
  RxString errorTitle = "".obs;
  RxString errorMessage = "".obs;
  RxString routeName = "".obs;
}
