import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';

class UserView extends StatelessWidget {
  final UserController _userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        centerTitle: true,
      ),
      body: Obx(() {
        final userDetails = _userController.getUserDetails();

        print('UserDetails: $userDetails');

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage(
                  'http://195.35.8.180:3000/uploads/profile/${userDetails!['photo_url'] ?? 'default.jpg'}',
                ),
              ),
              SizedBox(height: 16),
              Text(
                userDetails!['full_name'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                userDetails['email'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8),
              Text(
                userDetails['phone_number'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add logic for editing the profile here
                },
                child: Text('Edit Profile'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
