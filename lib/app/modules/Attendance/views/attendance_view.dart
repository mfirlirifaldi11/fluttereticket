import 'package:eticket/app/modules/Attendance/controllers/attendance_controller.dart';
import 'package:eticket/app/modules/Attendance/views/attendance_detail_view.dart';
import 'package:eticket/app/modules/Attendance/views/attendance_form_view.dart';
import 'package:eticket/app/modules/Login/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceView extends StatelessWidget {
  final AttendanceController _attendanceController =
      Get.put(AttendanceController());
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance List'),
        actions: [
          IconButton(
            onPressed: () {
              // Call the method to fetch the latest attendance records
              _attendanceController.fetchAllAttendance();
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Obx(
        () {
          if (_attendanceController.isLoading.value) {
            return Center(child: CircularProgressIndicator());
          } else if (_attendanceController.attendanceList.isEmpty) {
            return Center(child: Text('No attendance records found.'));
          } else {
            return ListView.builder(
              itemCount: _attendanceController.attendanceList.length,
              itemBuilder: (context, index) {
                var attendance = _attendanceController.attendanceList[index];
                bool isTimeOutNull = attendance['time_out'] == null;

                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailAttendanceView(attendance: attendance));
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('User ID: ${attendance['user_id']}'),
                      subtitle: Text(
                          'Date Attended: ${attendance['date_attended']}  Time in : ${attendance['time_in']}  Time Out : ${attendance['time_out']}'),
                      trailing: isTimeOutNull
                          ? ElevatedButton(
                              onPressed: () {
                                // Call a function to update timeout
                                _updateTimeout(
                                    context, attendance['attendance_id']);
                              },
                              child: Text('Absent Out'),
                            )
                          : null, // Set to null if time_out is not null
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Check if the user is logged in
          final bool isLoggedIn = _loginController.loggedInUserData.isNotEmpty;

          if (isLoggedIn) {
            // If user is logged in, show the attendance form as a bottom sheet
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) => AttendanceFormView(),
            );
          } else {
            // If user is not logged in, show a snackbar
            Get.snackbar(
              'Error',
              'You need to log in to input attendance.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Function to update timeout
  void _updateTimeout(BuildContext context, int attendanceId) {
    // You can show a dialog or navigate to another screen to input the timeout
    // For simplicity, let's show a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Absent Out'),
          content: Text('Implement your timeout update logic here.'),
          actions: [
            TextButton(
              onPressed: () {
                // Call a function to update the timeout in the controller
                _attendanceController.markTimeOut(attendanceId.toString());
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Out'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
