import 'package:get/get.dart';

import '../controllers/salesPerson_controller.dart';

class SalesPersonBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesPersonController>(
      () => SalesPersonController(),
    );
  }
}
