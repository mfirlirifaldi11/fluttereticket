import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/eticket_controller.dart';

class EticketView extends StatelessWidget {
  final EticketController _eticketController = Get.put(EticketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.mitraId.value = value,
                  decoration: InputDecoration(labelText: 'Mitra ID'),
                ),
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.teknisiId.value = value,
                  decoration: InputDecoration(labelText: 'Teknisi ID'),
                ),
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.serviceType.value = value,
                  decoration: InputDecoration(labelText: 'Service Type'),
                ),
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.dateRequested.value = value,
                  decoration: InputDecoration(labelText: 'Date Requested'),
                ),
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.timeRequested.value = value,
                  decoration: InputDecoration(labelText: 'Time Requested'),
                ),
                TextFormField(
                  onChanged: (value) => _eticketController.status.value = value,
                  decoration: InputDecoration(labelText: 'Status'),
                ),
                TextFormField(
                  onChanged: (value) =>
                      _eticketController.feedback.value = value,
                  decoration: InputDecoration(labelText: 'Feedback'),
                ),
                TextFormField(
                  onChanged: (value) => _eticketController.rating.value = value,
                  decoration: InputDecoration(labelText: 'Rating'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _eticketController.postTicket();
                  },
                  child: Text('Post E-ticket'),
                ),
                Obx(() {
                  if (_eticketController.isLoading.isTrue) {
                    return CircularProgressIndicator();
                  } else {
                    return SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
