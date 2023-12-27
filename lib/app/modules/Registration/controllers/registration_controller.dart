import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  final RxString username = RxString('');
  final RxString password = RxString('');
  final RxString role = RxString('');
  final RxString fullName = RxString('');
  final RxString email = RxString('');
  final RxString phoneNumber = RxString('');
  final RxBool isLoading = false.obs;

  // New list to store available roles
  Future<List<String>> fetchRolesFromDatabase() async {
    try {
      final response = await http
          .get(Uri.parse('http://195.35.8.180:3000/roles/user_roles'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<String> roles =
            data.map((role) => role['role_name'].toString()).toList();
        return roles;
      } else {
        print('API Response Body: ${response.body}');
        print('API Response Status Code: ${response.statusCode}');
        throw Exception('Failed to load roles');
      }
    } catch (error) {
      print('Error fetching roles: $error');
      throw error;
    }
  }

  // Selected role value
  final RxList<String> availableRoles = <String>[].obs;
  final RxString selectedRole = RxString('admin');

  // New variable to store the selected image file
  RxString selectedImagePath = RxString('');

  Future<void> selectPhoto() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        print(pickedFile.path);
      }
    } catch (error) {
      print('Error selecting photo: $error');
    }
  }

  Future<void> register() async {
    try {
      isLoading(true);

      if (username.isEmpty ||
          password.isEmpty ||
          selectedRole.isEmpty ||
          fullName.isEmpty) {
        Get.snackbar('Error', 'Please fill in all required fields.');
        return;
      }

      final response = await yourRegistrationApiCall(
        username.value,
        password.value,
        selectedRole.value,
        fullName.value,
        email.value,
        phoneNumber.value,
        selectedImagePath
            .value, // Include the selected image path in the API call
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Registration successful');
      } else {
        Get.snackbar('Error',
            'Registration failed: ${response.statusCode} - ${response.body}');
        print(response.body);
      }
    } catch (error) {
      Get.snackbar('Error', 'Error during registration: $error');
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> yourRegistrationApiCall(
    String username,
    String password,
    String role,
    String fullName,
    String email,
    String phoneNumber,
    String imagePath, // Include the image path in the API call
  ) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://195.35.8.180:3000/auth/register'),
      );

      // Remove the following line
      // request.headers['Content-Type'] = 'multipart/form-data';

      request.fields.addAll({
        'username': username,
        'password': password,
        'role_name': role,
        'full_name': fullName,
        'email': email,
        'phone_number': phoneNumber,
      });
      print('Username: $username');
      print('Password: $password');

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
}
