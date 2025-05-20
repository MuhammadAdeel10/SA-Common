import 'package:get/get.dart';
import 'package:sa_common/sale_order/controller/sale_order_controller.dart';

class SaleOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SaleOrderController>(
      () => SaleOrderController(),
    );
  }
}
