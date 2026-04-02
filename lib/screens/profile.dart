// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ Use GetX for navigation

class StaffProfileScreen extends StatelessWidget {
  final String staffName = "Jane Smith";
  final String email = "jane.smith@wayneenterprises.com";
  final String phone = "+254 700 123 456";
  final String role = "Fleet Manager";
  final String profileImage = "https://via.placeholder.com/150";

  const StaffProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Staff Profile"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(profileImage),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              staffName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // Email, Phone, Role
            Text(email, style: TextStyle(color: Colors.grey[400])),
            Text(phone, style: TextStyle(color: Colors.grey[400])),
            Text("Role: $role", style: TextStyle(color: Colors.grey[400])),

            const SizedBox(height: 24),

            // Profile Actions
            Card(
              color: const Color(0xFF1C1C1E),
              elevation: 6,
              shadowColor: Colors.redAccent.withOpacity(0.4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.redAccent),
                    title: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(
                      Icons.assignment,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "Assigned Tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(
                      Icons.settings,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "Settings",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: GestureDetector(
                      child: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onTap: () {
                      // ✅ Logout and go to login screen, clear stack
                      Get.offNamed('/login');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
