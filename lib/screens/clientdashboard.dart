// ignore_for_file: deprecated_member_use
// Ignores warnings related to deprecated members.

import 'dart:convert';
// Used to decode JSON responses from backend

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:flutter_application_1/screens/carscreen.dart';
// Imports available cars screen

import 'package:flutter_application_1/screens/helpdeskscreen.dart';
// Imports help desk screen

import 'package:flutter_application_1/screens/promotionscreen.dart';
// Imports promotions screen

import 'package:get/get.dart';
// GetX for navigation and arguments

import 'package:http/http.dart' as http;
// Used for making API requests

/// ====================================
/// CLIENT DASHBOARD SCREEN
/// ====================================
class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  /// Stores number of available cars
  int availableCars = 0;

  @override
  void initState() {
    super.initState();

    /// Load cars count when screen opens
    fetchAvailableCarsCount();
  }

  /// ====================================
  /// Fetch available cars from backend
  /// ====================================
  Future<void> fetchAvailableCarsCount() async {
    try {
      /// Send request to backend
      final response = await http.get(
        Uri.parse("http://10.61.228.97/flutterapi/get_cars2.php"),
      );

      /// Check successful response
      if (response.statusCode == 200) {
        /// Decode JSON response
        final data = jsonDecode(response.body);

        /// If backend returns success
        if (data['code'] == 1) {
          setState(() {
            /// Count cars returned
            availableCars = (data['cars'] as List).length;
          });
        }
      }
    } catch (_) {
      /// Error silently ignored here
    }
  }

  /// ====================================
  /// Reusable Dashboard Card Widget
  /// ====================================
  Widget clientDashboard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      /// Card styling
      color: const Color(0xFF1C1C1E),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

        side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
      ),

      child: InkWell(
        /// Tap action
        onTap: onTap,

        borderRadius: BorderRadius.circular(12),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              /// Card icon
              Icon(icon, size: 40, color: Colors.redAccent),

              const SizedBox(height: 8),

              /// Card title
              Text(
                title,

                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 4),

              /// Card subtitle/value
              Text(
                value,

                style: TextStyle(color: Colors.grey[400], fontSize: 14),

                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    /// Get logged-in user passed from previous route
    final user = Get.arguments ?? {};

    /// Dashboard cards data
    final List<Map<String, dynamic>> clientStats = [
      {
        "title": "Available Cars",

        "value": availableCars.toString(),

        "icon": Icons.directions_car,
      },

      {"title": "Promotions", "value": "2 Active", "icon": Icons.local_offer},

      {"title": "Support", "value": "Help Desk", "icon": Icons.support_agent},
    ];

    return Scaffold(
      /// Dark background
      backgroundColor: Colors.black,

      /// App Bar
      appBar: AppBar(
        title: const Text("Client Dashboard"),

        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// Main body
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        /// Grid layout for cards
        child: GridView.builder(
          /// Number of cards
          itemCount: clientStats.length,

          /// 2-column grid layout
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,

            crossAxisSpacing: 16,

            mainAxisSpacing: 16,
          ),

          itemBuilder: (context, index) {
            /// Current card data
            final stat = clientStats[index];

            return clientDashboard(
              title: stat["title"].toString(),

              value: stat["value"].toString(),

              icon: stat["icon"] as IconData,

              onTap: () {
                /// =================
                /// Navigation Actions
                /// =================

                /// Open Cars screen
                if (stat["title"] == "Available Cars") {
                  /// Pass user data
                  Get.to(() => CarsScreen(), arguments: user);
                }

                /// Open Promotions screen
                if (stat["title"] == "Promotions") {
                  Get.to(() => const PromotionScreen());
                }

                /// Open Help Desk screen
                if (stat["title"] == "Support") {
                  Get.to(() => const HelpDeskScreen());
                }
              },
            );
          },
        ),
      ),
    );
  }
}
