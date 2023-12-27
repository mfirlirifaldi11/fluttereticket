import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Loading indicator observable
  final RxBool isLoading = false.obs;

  // Function to handle the logout process
  Future<void> logout() async {
    try {
      isLoading(true);
      print('Logging out...');

      // Add any additional logout logic here

      // Navigate to the login page
      Get.offAllNamed('/login');
    } catch (error) {
      print('Error during logout: $error');
    } finally {
      isLoading(false);
    }
  }

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
