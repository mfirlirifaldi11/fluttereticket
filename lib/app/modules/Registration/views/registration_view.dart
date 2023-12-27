import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/registration_controller.dart';

class RegistrationView extends StatelessWidget {
  final RegistrationController _registrationController =
      Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegistrationView'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<String>>(
          // Fetch roles directly in the build method
          future: _registrationController.fetchRolesFromDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Roles are loaded, build the form with the dropdown
              return Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      onChanged: (value) =>
                          _registrationController.username.value = value,
                      decoration: InputDecoration(labelText: 'Username'),
                    ),
                    TextFormField(
                      onChanged: (value) =>
                          _registrationController.password.value = value,
                      obscureText: true,
                      decoration: InputDecoration(labelText: 'Password'),
                    ),
                    TextFormField(
                      onChanged: (value) =>
                          _registrationController.fullName.value = value,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextFormField(
                      onChanged: (value) =>
                          _registrationController.email.value = value,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextFormField(
                      onChanged: (value) =>
                          _registrationController.phoneNumber.value = value,
                      decoration: InputDecoration(labelText: 'Phone Number'),
                    ),
                    DropdownButtonFormField(
                      value: _registrationController.selectedRole.value,
                      items: snapshot.data
                          ?.map((role) => DropdownMenuItem(
                                child: Text(role),
                                value: role,
                              ))
                          .toList(),
                      onChanged: (value) {
                        _registrationController.selectedRole.value =
                            value.toString();
                      },
                      decoration: InputDecoration(labelText: 'Role'),
                    ),
                    // Add the photo preview widget
                    SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: () async {
                        // Call the method to select photo
                        await _registrationController.selectPhoto();
                      },
                      child: Text('Select Photo'),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _registrationController.register();
                      },
                      child: Text('Register'),
                    ),
                    Obx(() {
                      if (_registrationController.isLoading.isTrue) {
                        return CircularProgressIndicator();
                      } else {
                        return SizedBox.shrink();
                      }
                    }),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
