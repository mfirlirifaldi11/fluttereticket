import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final RxString username = RxString('');
  final RxString password = RxString('');
  final RxBool isLoading = false.obs;

  // Key for storing user data in SharedPreferences
  static const String userKey = 'user_data';

  // Properti untuk menyimpan informasi pengguna yang sudah login
  final RxMap<String, dynamic> loggedInUserData = <String, dynamic>{}.obs;

  // Check if the user is logged in based on local storage
  bool get isLoggedIn => loggedInUserData.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    // Load user data from local storage during initialization
    loadUserData();
  }

  Future<void> login() async {
    print('Sebelum : ${loggedInUserData}');
    try {
      isLoading(true);
      print('Sending login data...');

      if (username.isEmpty || password.isEmpty) {
        print('Please fill in all required fields.');
        return;
      }

      final response = await yourLoginApiCall(
        username.value,
        password.value,
      );

      if (response.statusCode == 200) {
        print('Login successful');

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('user') &&
            responseData['user'] != null &&
            responseData['user'] is Map<String, dynamic>) {
          final Map<String, dynamic> user = responseData['user'];

          if (user.containsKey('role_id') &&
              user['role_id'] != null &&
              user['role_id'] is int) {
            final int userRoleId = user['role_id'];

            saveUserData(user);

            navigateToDashboard(userRoleId.toString());
          } else {
            print('Invalid response format: missing or invalid "role_id"');
            handleLoginError();
          }
        } else {
          print('Invalid response format: missing or null "user"');
          handleLoginError();
        }
      } else {
        print('Login failed: ${response.statusCode} - ${response.body}');
        handleLoginError();
      }
    } catch (error) {
      print('Error during login: $error');
      handleLoginError();
    } finally {
      isLoading(false);
    }
  }

  Future<http.Response> yourLoginApiCall(
      String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://195.35.8.180:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      return response;
    } catch (error) {
      print('Error in login API call: $error');
      throw error;
    }
  }

  void saveUserData(Map<String, dynamic> userData) {
    loggedInUserData.value = userData;
    // Save user data to local storage
    saveUserDataLocally(userData);
    print('user login: $loggedInUserData');
  }

  void navigateToDashboard(String userRoleId) {
    switch (userRoleId) {
      case '1':
        Get.offAllNamed('/dashboard');
        break;
      case '2':
        Get.offAllNamed('/attendance');
        break;
      case '3':
        Get.offAllNamed('/home');
        break;
      default:
        print('Unknown user role ID: $userRoleId');
        handleLoginError();
    }
  }

  void handleLoginError() {
    Get.snackbar('Error', 'Login failed. Please check your credentials.');
  }

  void saveUserDataLocally(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(userKey, jsonEncode(userData));
  }

  void loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString(userKey);
    if (userDataString != null && userDataString.isNotEmpty) {
      final Map<String, dynamic> userData = json.decode(userDataString);
      loggedInUserData.value = userData;
    }
  }
}
