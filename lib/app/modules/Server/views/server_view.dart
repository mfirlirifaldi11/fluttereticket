import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/server_controller.dart';

class ServerView extends GetView<ServerController> {
  final ServerController _serverController = Get.put(ServerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () {
          if (controller.isLoading.value) {
            // Tampilkan loading indicator jika sedang memuat data
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // Tampilkan daftar server jika data sudah dimuat
            return buildServerList(controller.serverList);
          }
        },
      ),
    );
  }

  Widget buildServerList(List<Map<String, dynamic>> serverList) {
    return ListView.builder(
      itemCount: serverList.length,
      itemBuilder: (context, index) {
        final server = serverList[index];
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(server['name'] ?? 'No name'),
            subtitle: Text(server['address'] ?? 'No address'),
            onTap: () {
              // Aksi yang ingin Anda lakukan ketika item diklik
              // Misalnya, pindah ke halaman detail server
            },
          ),
        );
      },
    );
  }
}
