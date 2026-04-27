// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/carscreen.dart';
import 'package:flutter_application_1/screens/helpdeskscreen.dart';
import 'package:flutter_application_1/screens/promotionscreen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ClientDashboardScreen extends StatefulWidget {
  const ClientDashboardScreen({super.key});

  @override
  State<ClientDashboardScreen> createState() => _ClientDashboardScreenState();
}

class _ClientDashboardScreenState extends State<ClientDashboardScreen> {
  int availableCars = 0;

  @override
  void initState() {
    super.initState();
    fetchAvailableCarsCount();
  }

  Future<void> fetchAvailableCarsCount() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.103/flutterapi/get_cars2.php"),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1) {
          setState(() {
            availableCars = (data['cars'] as List).length;
          });
        }
      }
    } catch (_) {}
  }

  Widget clientDashboard({
    required String title,
    required String value,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      color: const Color(0xFF1C1C1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.redAccent),
              const SizedBox(height: 8),
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
    // ✅ Get user from arguments
    final user = Get.arguments ?? {};

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Client Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: clientStats.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            final stat = clientStats[index];
            return clientDashboard(
              title: stat["title"].toString(),
              value: stat["value"].toString(),
              icon: stat["icon"] as IconData,
              onTap: () {
                // ✅ Pass user forward
                if (stat["title"] == "Available Cars") {
                  Get.to(() => CarsScreen(), arguments: user);
                }
                if (stat["title"] == "Promotions") {
                  Get.to(() => const PromotionScreen());
                }
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
