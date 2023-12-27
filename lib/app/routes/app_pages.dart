import 'package:get/get.dart';

import '../modules/Attendance/bindings/attendance_binding.dart';
import '../modules/Attendance/views/attendance_view.dart';
import '../modules/Dashboard/bindings/dashboard_binding.dart';
import '../modules/Dashboard/views/dashboard_view.dart';
import '../modules/Eticket/bindings/eticket_binding.dart';
import '../modules/Eticket/views/eticket_view.dart';
import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/Registration/bindings/registration_binding.dart';
import '../modules/Registration/views/registration_view.dart';
import '../modules/Server/bindings/server_binding.dart';
import '../modules/Server/views/server_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_view.dart';
import '../modules/wifi/bindings/wifi_binding.dart';
import '../modules/wifi/views/wifi_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => RegistrationView(),
      binding: RegistrationBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: _Paths.ETICKET,
      page: () => EticketView(),
      binding: EticketBinding(),
    ),
    GetPage(
      name: _Paths.SERVER,
      page: () => ServerView(),
      binding: ServerBinding(),
    ),
    GetPage(
      name: _Paths.WIFI,
      page: () => const WifiView(),
      binding: WifiBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => UserView(),
      binding: UserBinding(),
    ),
  ];
}
