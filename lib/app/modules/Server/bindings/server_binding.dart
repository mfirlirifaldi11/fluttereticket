import 'package:get/get.dart';

import '../controllers/server_controller.dart';

class ServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServerController>(
      () => ServerController(),
    );
  }
}
