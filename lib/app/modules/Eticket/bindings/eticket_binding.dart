import 'package:get/get.dart';

import '../controllers/eticket_controller.dart';

class EticketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EticketController>(
      () => EticketController(),
    );
  }
}
