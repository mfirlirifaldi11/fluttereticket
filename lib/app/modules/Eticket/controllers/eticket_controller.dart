import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class EticketController extends GetxController {
  final RxString mitraId = ''.obs;
  final RxString teknisiId = ''.obs;
  final RxString serviceType = ''.obs;
  final RxString dateRequested = ''.obs;
  final RxString timeRequested = ''.obs;
  final RxString status = ''.obs;
  final RxString feedback = ''.obs;
  final RxString rating = ''.obs;

  final RxBool isLoading = false.obs;

  Future<void> postTicket() async {
    try {
      isLoading(true);

      final apiUrl = 'http://195.35.8.180:3000/tickets/create';

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json'
        }, // Specify JSON content type
        body: jsonEncode({
          'mitraId': mitraId.value,
          'teknisiId': teknisiId.value,
          'serviceType': serviceType.value,
          'dateRequested': dateRequested.value,
          'timeRequested': timeRequested.value,
          'status': status.value,
          'feedback': feedback.value,
          'rating': rating.value,
        }),
      );

      if (response.statusCode == 200) {
        // Ticket posted successfully
        print('Ticket posted successfully');
        // You can perform additional actions after a successful ticket post if needed
      } else {
        // Error posting ticket
        print(
            'Error posting ticket: ${response.statusCode} - ${response.body}');
      }
    } catch (error) {
      print('Error posting ticket: $error');
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
