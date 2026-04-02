import 'package:flutter/material.dart';

void main() {
  runApp(StaffDashboardApp());
}

class StaffDashboardApp extends StatelessWidget {
  const StaffDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staff Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.redAccent,
      ),
      home: StaffDashboardScreen(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class StaffDashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> staffStats = [
    {"title": "Total Cars", "value": 120, "icon": Icons.directions_car},
    {"title": "Available Cars", "value": 85, "icon": Icons.check_circle},
    {"title": "Bookings Today", "value": 34, "icon": Icons.calendar_today},
    {"title": "Revenue", "value": "\$12,450", "icon": Icons.attach_money},
    {"title": "Pending Approvals", "value": 5, "icon": Icons.pending_actions},
    {"title": "Maintenance Alerts", "value": 3, "icon": Icons.build_circle},
    {"title": "Customer Requests", "value": 12, "icon": Icons.support_agent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: staffStats.length,
          itemBuilder: (context, index) {
            return DashboardCard(
              title: staffStats[index]["title"],
              value: staffStats[index]["value"].toString(),
              icon: staffStats[index]["icon"],
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

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1C1C1E),
      elevation: 6,
      // ignore: deprecated_member_use
      shadowColor: Colors.redAccent.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        // ignore: deprecated_member_use
        side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
    );
  }
}
