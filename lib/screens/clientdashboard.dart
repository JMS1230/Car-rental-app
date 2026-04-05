// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/carscreen.dart';
import 'package:flutter_application_1/screens/helpdeskscreen.dart';
import 'package:flutter_application_1/screens/promotionscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Client Dashboard App',
      theme: ThemeData(primarySwatch: Colors.red),
      home: const ClientDashboardScreen(),
    );
  }
}

class ClientDashboardScreen extends StatelessWidget {
  const ClientDashboardScreen({super.key});

  final List<Map<String, dynamic>> clientStats = const [
    {"title": "Available Cars", "value": 85, "icon": Icons.directions_car},
    {"title": "Promotions", "value": "2 Active", "icon": Icons.local_offer},
    {"title": "Support", "value": "Help Desk", "icon": Icons.support_agent},
  ];

  @override
  Widget build(BuildContext context) {
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

            return DashboardCard(
              title: stat["title"].toString(),
              value: stat["value"].toString(),
              icon: stat["icon"] as IconData,
              onTap: () {
                // ✅ EXISTING (UNCHANGED)
                if (stat["title"] == "Available Cars") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CarsScreen()),
                  );
                }

                // ✅ NEW: Promotions Navigation
                if (stat["title"] == "Promotions") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PromotionScreen()),
                  );
                }
                if (stat["title"] == "Support") {
                  // Navigate to Help Desk Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HelpDeskScreen()),
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1C1C1E),
        elevation: 6,
        shadowColor: Colors.redAccent.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
