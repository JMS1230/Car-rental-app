// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_application_1/screens/clientdashboard.dart';
import 'package:flutter_application_1/screens/clientprofile.dart';
import 'package:get/get.dart';

class Clienthomescreen extends StatefulWidget {
  const Clienthomescreen({super.key});

  @override
  State<Clienthomescreen> createState() => _ClienthomescreenState();
}

class _ClienthomescreenState extends State<Clienthomescreen> {
  int _selectedIndex = 0;

  // ✅ Get user passed from login
  final Map<String, dynamic> user = Get.arguments ?? {};

  // ✅ Build screens lazily so user is available
  late final List<Widget> _screens = [
    const HomePage(),
    const ClientDashboardScreen(),
    ClientProfileScreen(user: user),
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
        // ✅ Show user name in appbar
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                user['fullname'] ?? '',
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,
        color: Colors.redAccent,
        buttonBackgroundColor: Colors.redAccent,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.dashboard, size: 30, color: Colors.white),
          Icon(Icons.person, size: 30, color: Colors.white),
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
                  Get.offAllNamed('/login');
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
