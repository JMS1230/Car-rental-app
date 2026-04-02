// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart'; // ✅ Use GetX for navigation

class ClientProfileScreen extends StatelessWidget {
  final String clientName = "Bruce Wayne";
  final String email = "bruce.wayne@gothamcity.com";
  final String phone = "+254 711 987 654";
  final String membership = "Premium Client";
  final String profileImage = "https://via.placeholder.com/150";

  const ClientProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(profileImage),
            ),

            const SizedBox(height: 16),

            // Name
            Text(
              clientName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            // Email, Phone, Membership
            Text(email, style: TextStyle(color: Colors.grey[400])),
            Text(phone, style: TextStyle(color: Colors.grey[400])),
            Text(
              "Membership: $membership",
              style: TextStyle(color: Colors.grey[400]),
            ),

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
                    leading: const Icon(
                      Icons.car_rental,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "My Bookings",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Navigate to client bookings screen
                    },
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(Icons.payment, color: Colors.redAccent),
                    title: const Text(
                      "Payment History",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Navigate to payment history screen
                    },
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(
                      Icons.support_agent,
                      color: Colors.redAccent,
                    ),
                    title: const Text(
                      "Support",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // Navigate to support screen
                    },
                  ),
                  Divider(color: Colors.grey[800]),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      // ✅ Logout and go to login screen
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
