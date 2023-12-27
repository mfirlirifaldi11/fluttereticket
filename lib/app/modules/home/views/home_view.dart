import 'package:eticket/app/modules/Server/views/server_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Attendance/views/attendance_view.dart';
import '../../Eticket/views/eticket_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());

  final RxInt selectedIndex = 0.obs;

  final List<Widget> pages = [
    ServerView(),
    EticketView(),
    Placeholder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Ticketing zonawifi.id"),
        actions: [
          IconButton(
            onPressed: () {
              _homeController.logout();
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
              label: 'Home',
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
