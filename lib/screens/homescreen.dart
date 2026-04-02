// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _selectedIndex = 0;

  // ✅ Only staff screens linked
  final List<Widget> _screens = const [
    HomePage(),
    StaffDashboardScreen(),
    StaffProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Car Rental System",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: _screens[_selectedIndex],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color: Colors.redAccent,
        buttonBackgroundColor: Colors.redAccent,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white), // Home
          Icon(
            Icons.dashboard,
            size: 30,
            color: Colors.white,
          ), // Staff Dashboard
          Icon(Icons.person, size: 30, color: Colors.white), // Staff Profile
        ],
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

//////////////////// HOME PAGE ////////////////////

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("spurs.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Container(color: Colors.black.withOpacity(0.6)),

        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Welcome to the Car Rental System",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 25),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//////////////////// STAFF DASHBOARD ////////////////////

class StaffDashboardScreen extends StatelessWidget {
  const StaffDashboardScreen({super.key});

  final List<Map<String, dynamic>> staffStats = const [
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        itemCount: staffStats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return DashboardCard(
            title: staffStats[index]["title"],
            value: staffStats[index]["value"].toString(),
            icon: staffStats[index]["icon"],
          );
        },
      ),
    );
  }
}

//////////////////// DASHBOARD CARD ////////////////////

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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.redAccent, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.redAccent),

            const SizedBox(height: 10),

            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

//////////////////// STAFF PROFILE ////////////////////

class StaffProfileScreen extends StatelessWidget {
  const StaffProfileScreen({super.key});

  final String staffName = "Jane Smith";
  final String email = "jane.smith@wayneenterprises.com";
  final String phone = "+254 700 123 456";
  final String role = "Fleet Manager";

  final String profileImage = "https://via.placeholder.com/150";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Staff Profile"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(profileImage),
            ),

            const SizedBox(height: 16),

            Text(
              staffName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            Text(email, style: const TextStyle(color: Colors.white70)),
            Text(phone, style: const TextStyle(color: Colors.white70)),
            Text("Role: $role", style: const TextStyle(color: Colors.white70)),

            const SizedBox(height: 25),

            Card(
              color: Colors.white.withOpacity(0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text(
                      "Edit Profile",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.assignment, color: Colors.orange),
                    title: const Text(
                      "Assigned Tasks",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.settings, color: Colors.green),
                    title: const Text(
                      "Settings",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {},
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
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
