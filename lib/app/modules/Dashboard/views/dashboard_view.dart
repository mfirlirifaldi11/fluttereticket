import 'package:eticket/app/modules/Server/views/server_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Attendance/views/attendance_view.dart';
import '../../Eticket/views/eticket_view.dart';
import '../../user/views/user_view.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends StatelessWidget {
  final DashboardController _dashboardController =
      Get.put(DashboardController());

  final RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [
    ServerView(),
    AttendanceView(), // Ganti dengan AttendanceView()
    EticketView(),
    UserView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Ticketing zonawifi.id"),
        actions: [
          IconButton(
            onPressed: () {
              _dashboardController.logout();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() => pages[selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: selectedIndex.value,
          onTap: (index) {
            selectedIndex.value = index;
          },
          selectedItemColor: Colors.blue, // Warna ikon terpilih
          unselectedItemColor: Colors.grey, // Warna ikon tidak terpilih
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event),
              label: 'E-ticket',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'User Profile',
            ),
          ],
        ),
      ),
    );
  }
}
