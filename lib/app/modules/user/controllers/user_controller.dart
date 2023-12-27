import 'package:get/get.dart';

import '../../Login/controllers/login_controller.dart';

class UserController extends GetxController {
  final RxMap<String, dynamic> loggedInUserData = <String, dynamic>{}.obs;

  // Fungsi untuk mendapatkan detail pengguna
  Map<String, dynamic>? getUserDetails() {
    // Gunakan data pengguna yang sudah login dari LoginController
    final Map<String, dynamic>? userFromLogin =
        Get.find<LoginController>().loggedInUserData?.value;

    // Gunakan data pengguna dari LoginController jika tersedia
    return userFromLogin!.isNotEmpty ? Map.from(userFromLogin) : null;
  }

  // Metode untuk menyimpan data pengguna saat login
  void saveUserData(Map<String, dynamic> userData) {
    loggedInUserData.assignAll(userData);

    print(userData);
  }

  // Metode untuk menambahkan nilai count
  void increment() {}

  @override
  void onInit() {
    // Dipanggil ketika controller pertama kali diinisialisasi
    super.onInit();

    // Ambil data pengguna dari LoginController saat inisialisasi
    final Map<String, dynamic>? userFromLogin =
        Get.find<LoginController>().loggedInUserData?.value;

    // Jika ada data pengguna dari LoginController, simpan ke loggedInUserData
    if (userFromLogin?.isNotEmpty == true) {
      loggedInUserData.assignAll(userFromLogin!);
    }
  }

  @override
  void onReady() {
    // Dipanggil ketika controller siap digunakan (setelah onInit)
    super.onReady();
  }

  @override
  void onClose() {
    // Dipanggil ketika controller dihapus dari widget tree
    super.onClose();
  }
}
