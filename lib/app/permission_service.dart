// permission_service.dart

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      // Permission granted, proceed with location services
    } else {
      // Permission denied, handle accordingly
    }
  }

  // Add more permission-related methods as needed
}
