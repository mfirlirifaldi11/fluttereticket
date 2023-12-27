import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../Login/controllers/login_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AttendanceController extends GetxController {
  final RxMap<String, dynamic> loggedInUserData = <String, dynamic>{}.obs;

  final RxString user_id = RxString('');
  final RxString date_attended = RxString('');
  final RxString time_in = RxString('');
  final RxString latitude = RxString('');
  final RxString longitude = RxString('');
  final RxString photoUrl = RxString('');
  final RxString time_out = RxString('');

  final RxBool isLoading = false.obs;

  final String baseUrl = 'http://195.35.8.180:3000';

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

  // List to store attendance records
  RxList<Map<String, dynamic>> attendanceList = <Map<String, dynamic>>[].obs;

  // Fetch all attendance records
  Future<void> fetchAllAttendance() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse('$baseUrl/attendance/'));

      if (response.statusCode == 200) {
        attendanceList.clear();
        attendanceList.addAll(
          (json.decode(response.body)['attendance'] as List)
              .cast<Map<String, dynamic>>(),
        );
        print(attendanceList);
      } else {
        print('Failed to fetch attendance: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching attendance: $error');
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch attendance for a specific user
  Future<void> fetchUserAttendance(int userId) async {
    isLoading.value = true;
    try {
      final response =
          await http.get(Uri.parse('$baseUrl/attendance/user/$userId'));

      if (response.statusCode == 200) {
        attendanceList.clear();
        attendanceList.addAll(
          (json.decode(response.body)['attendance'] as List)
              .cast<Map<String, dynamic>>(),
        );
      } else {
        print('Failed to fetch user attendance: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching user attendance: $error');
    } finally {
      isLoading.value = false;
    }
  }

  RxString selectedImagePath = RxString('');

  Future<void> selectPhoto() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        print(pickedFile.path);
      }
    } catch (error) {
      print('Error selecting photo: $error');
    }
  }

  Future<void> markTimeIn() async {
    try {
      isLoading(true);

      final userDetails = getUserDetails();
      if (userDetails == null) {
        Get.snackbar('Error', 'User details not available.');
        return;
      }

      final userId = userDetails['user_id'].toString();
      final now = DateTime.now();

      final date_attended = '${now.year}-${now.month}-${now.day}';
      final time_in = '${now.hour}:${now.minute}';

      if (userId.isEmpty ||
          date_attended.isEmpty ||
          time_in.isEmpty ||
          latitude.isEmpty ||
          longitude.isEmpty) {
        print('user_id: $userId');
        print('date_attended: $date_attended');
        print('time_in: $time_in');
        print('latitude: $latitude');
        print('longitude: $longitude');
        Get.snackbar('Error', 'Please fill in all required fields.');
        return;
      }

      final response = await yourRegistrationApiCall(
        userId,
        date_attended,
        time_in,
        latitude.value,
        longitude.value,
        selectedImagePath.value,
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Attendance successful',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            colorText: Colors.white);

        fetchAllAttendance();
      } else {
        Get.snackbar(
          'Error',
          'Attendance failed: ${response.statusCode} - ${response.body}',
        );
        print(response.body);
      }
    } catch (error) {
      Get.snackbar('Error', 'Error during Attendance: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> yourRegistrationApiCall(
    String user_id,
    String date_attended,
    String time_in,
    String latitude,
    String longitude,
    String imagePath, // Include the image path in the API call
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://195.35.8.180:3000/attendance/timein'),
      );

      // Remove the following line
      // request.headers['Content-Type'] = 'multipart/form-data';

      request.fields.addAll({
        'user_id': user_id,
        'date_attended': date_attended,
        'time_in': time_in,
        'latitude': latitude,
        'longitude': longitude,
      });

      if (imagePath.isNotEmpty) {
        Uint8List imageBytes = File(imagePath).readAsBytesSync();
        var photoFile = http.MultipartFile.fromBytes(
          'photo_url',
          imageBytes,
          filename: 'photo.jpg',
        );
        request.files.add(photoFile);
        print(photoFile);
      }

      var response = await request.send();
      return await http.Response.fromStream(response);
    } catch (error) {
      print('Error in API call: $error');
      throw error;
    }
  }

  Future<void> markTimeOut(String attendanceId) async {
    try {
      isLoading(true);

      print(attendanceId);

      final now = DateTime.now();
      final time_out = '${now.hour}:${now.minute}';

      print(time_out);

      final response = await yourUpdateTimeOutApiCall(attendanceId, time_out);

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Time out recorded successfully',
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 2),
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // Optionally, you can fetch updated attendance records after marking time out
        fetchAllAttendance();
      } else {
        print(
            'Failed to record time out: ${response.statusCode} - ${response.body}');
        Get.snackbar(
          'Error',
          'Failed to record time out: ${response.statusCode} - ${response.body}',
        );
        print(response.body);
      }
    } catch (error) {
      print(error);
      Get.snackbar('Error', 'Error recording time out: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> yourUpdateTimeOutApiCall(
    String attendanceId,
    String time_out,
  ) async {
    try {
      // Define your API endpoint for updating time_out
      final apiUrl =
          'http://195.35.8.180:3000/attendance/timeout/$attendanceId';

      print(apiUrl);

      // Make a POST request to update time_out
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'time_out': time_out}),
      );
      print(response);
      return response;
    } catch (error) {
      print('Error in update time_out API call: $error');
      throw error;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchAllAttendance();

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
    super.onReady();
    fetchAllAttendance();
  }

  @override
  void onClose() {
    super.onClose();
    fetchAllAttendance();
  }
}
