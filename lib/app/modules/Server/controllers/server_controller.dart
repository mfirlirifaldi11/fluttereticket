import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ServerController extends GetxController {
  final RxBool isLoading = false.obs;

  final RxList<Map<String, dynamic>> serverList = <Map<String, dynamic>>[].obs;

  Future<void> getServerList() async {
    try {
      isLoading(true);

      final apiUrl = Uri.parse('http://195.35.8.180:3000/server/list');
      print('Fetching data from: $apiUrl');

      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          // If the response is a list, assume it's the server list
          serverList.assignAll(jsonResponse.cast<Map<String, dynamic>>());
          print('Data fetched successfully: $serverList');
        } else if (jsonResponse is Map<String, dynamic> &&
            jsonResponse.containsKey('success')) {
          // If the response is an object with a "success" property, extract the "servers" property
          final List<dynamic> servers = jsonResponse['servers'];
          serverList.assignAll(servers.cast<Map<String, dynamic>>());
          print('Data fetched successfully: $serverList');
        } else {
          throw Exception(
              'Invalid JSON format - expected a list or an object with "success" and "servers" properties');
        }
      } else {
        throw Exception(
            'Failed to load server list. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error getting server list: $error');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch the server list when the controller is initialized
    getServerList();
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
