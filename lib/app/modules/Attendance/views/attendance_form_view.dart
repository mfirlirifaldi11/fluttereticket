import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:date_time_picker/date_time_picker.dart';
import '../controllers/attendance_controller.dart';

class AttendanceFormView extends StatelessWidget {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());
  final Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AttendanceView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                initialValue: DateTime.now().toString(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101),
                icon: Icon(Icons.event),
                dateLabelText: 'Date Attended',
                timeLabelText: 'Time In',
                enabled: false,
              ),
              ElevatedButton(
                onPressed: () async {
                  await _attendanceController.selectPhoto();
                },
                child: Text('Select Photo'),
              ),
              Obx(() {
                return _attendanceController.selectedImagePath.isNotEmpty
                    ? Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        child: Image.file(
                          File(_attendanceController.selectedImagePath.value),
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container();
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _getLocation();
                  print('Latitude: ${_attendanceController.latitude}');
                  print('Longitude: ${_attendanceController.longitude}');
                },
                child: Text('Get Location'),
              ),
              ElevatedButton(
                onPressed: () {
                  _attendanceController.markTimeIn();
                  Get.back();
                },
                child: Text('Mark Time In'),
              ),
              Obx(() {
                if (_attendanceController.isLoading.isTrue) {
                  return CircularProgressIndicator();
                } else {
                  return SizedBox.shrink();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      final locationData = await location.getLocation();
      _attendanceController.latitude.value =
          locationData.latitude!.toStringAsFixed(6);
      _attendanceController.longitude.value =
          locationData.longitude!.toStringAsFixed(6);
    } catch (error) {
      print('Error getting location: $error');
    }
  }
}
