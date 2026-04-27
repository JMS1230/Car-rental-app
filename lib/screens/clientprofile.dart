// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/changepasswordscreen.dart';
import 'package:get/get.dart';

class ClientProfileScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const ClientProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final String clientName = user['fullname'] ?? 'Unknown';
    final String email = user['email'] ?? 'No email';
    final String phone = user['phone'] ?? 'No phone';
    final String membership = "Premium Client";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Client Profile"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.redAccent,
              child: Text(
                clientName.isNotEmpty ? clientName[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              clientName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(email, style: TextStyle(color: Colors.grey[400])),
            Text(phone, style: TextStyle(color: Colors.grey[400])),
            Text(
              "Membership: $membership",
              style: TextStyle(color: Colors.grey[400]),
            ),

            const SizedBox(height: 24),

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
                    leading: const Icon(
                      Icons.car_rental,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "My Bookings",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => Get.toNamed('/bookings', arguments: user),
                  ),

                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.redAccent),
                    title: const Text(
                      "Change Password",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () =>
                        Get.to(const ChangePasswordScreen(), arguments: user),
                  ),

                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () => Get.offAllNamed('/login'),
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
