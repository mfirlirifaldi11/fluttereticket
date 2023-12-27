import 'package:eticket/app/modules/Login/bindings/login_binding.dart';
import 'package:eticket/app/modules/Login/controllers/login_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
