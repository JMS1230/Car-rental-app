// ignore_for_file: deprecated_member_use
// Ignores warnings related to deprecated members.

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:flutter_application_1/screens/changepasswordscreen.dart';
// Imports Change Password screen

import 'package:get/get.dart';
// GetX package for navigation

/// ==============================
/// CLIENT PROFILE SCREEN
/// ==============================
/// Displays client profile information
/// and profile-related actions.
class ClientProfileScreen extends StatelessWidget {
  /// User data passed from previous screen
  final Map<String, dynamic> user;

  const ClientProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    /// Extract user details from passed map
    /// Defaults provided if data is missing
    final String clientName = user['fullname'] ?? 'Unknown';

    final String email = user['email'] ?? 'No email';

    final String phone = user['phone'] ?? 'No phone';

    /// Static membership level
    final String membership = "Premium Client";

    return Scaffold(
      /// Dark theme background
      backgroundColor: Colors.black,

      /// Top AppBar
      appBar: AppBar(
        title: const Text("Client Profile"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// Scrollable body
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            /// =========================
            /// PROFILE AVATAR
            /// Shows first letter of name
            /// =========================
            CircleAvatar(
              radius: 60,

              backgroundColor: Colors.redAccent,

              child: Text(
                /// First character of name
                /// if empty show ?
                clientName.isNotEmpty ? clientName[0].toUpperCase() : '?',

                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Client full name
            Text(
              clientName,

              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// Email
            Text(email, style: TextStyle(color: Colors.grey[400])),

            /// Phone
            Text(phone, style: TextStyle(color: Colors.grey[400])),

            /// Membership info
            Text(
              "Membership: $membership",

              style: TextStyle(color: Colors.grey[400]),
            ),

            const SizedBox(height: 24),

            /// =========================
            /// PROFILE MENU CARD
            /// =========================
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
                  /// =====================
                  /// MY BOOKINGS
                  /// =====================
                  ListTile(
                    leading: const Icon(
                      Icons.car_rental,
                      color: Colors.redAccent,
                    ),

                    title: const Text(
                      "My Bookings",

                      style: TextStyle(color: Colors.white),
                    ),

                    /// Navigate to bookings
                    /// pass user data
                    onTap: () => Get.toNamed('/bookings', arguments: user),
                  ),

                  Divider(color: Colors.grey[800]),

                  /// =====================
                  /// CHANGE PASSWORD
                  /// =====================
                  ListTile(
                    leading: const Icon(Icons.lock, color: Colors.redAccent),

                    title: const Text(
                      "Change Password",

                      style: TextStyle(color: Colors.white),
                    ),

                    /// Open change password screen
                    onTap: () =>
                        Get.to(const ChangePasswordScreen(), arguments: user),
                  ),

                  Divider(color: Colors.grey[800]),

                  /// =====================
                  /// LOGOUT
                  /// =====================
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.redAccent),

                    title: const Text(
                      "Logout",

                      style: TextStyle(color: Colors.white),
                    ),

                    /// Logout and remove
                    /// previous routes
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
