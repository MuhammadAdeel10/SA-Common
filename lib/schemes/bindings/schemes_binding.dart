import 'package:get/get.dart';

import '../controllers/schemes_controller.dart';

class SchemesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SchemesController>(
      () => SchemesController(),
    );
  }
}
