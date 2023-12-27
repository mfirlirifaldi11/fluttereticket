import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wifi_controller.dart';

class WifiView extends GetView<WifiController> {
  const WifiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WifiView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'WifiView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
