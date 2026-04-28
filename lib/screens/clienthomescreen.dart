// ignore_for_file: deprecated_member_use
// Ignores warnings for deprecated members used in this file.

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// Package for curved bottom navigation bar

import 'package:flutter_application_1/screens/clientdashboard.dart';
// Imports dashboard screen

import 'package:flutter_application_1/screens/clientprofile.dart';
// Imports client profile screen

import 'package:get/get.dart';
// GetX package for navigation and arguments

/// =======================================
/// CLIENT HOME SCREEN
/// Main screen after login
/// Contains bottom navigation
/// =======================================
class Clienthomescreen extends StatefulWidget {
  const Clienthomescreen({super.key});

  @override
  State<Clienthomescreen> createState() => _ClienthomescreenState();
}

class _ClienthomescreenState extends State<Clienthomescreen> {
  /// Stores currently selected tab index
  int _selectedIndex = 0;

  /// Get user data passed from login
  final Map<String, dynamic> user = Get.arguments ?? {};

  /// Build screens lazily after user data is available
  /// Index:
  /// 0 -> Home
  /// 1 -> Dashboard
  /// 2 -> Profile
  late final List<Widget> _screens = [
    const HomePage(),

    const ClientDashboardScreen(),

    ClientProfileScreen(user: user),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Main background
      backgroundColor: Colors.black,

      /// =========================
      /// APP BAR
      /// =========================
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,

        title: const Text(
          "Car Rental System",

          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        /// Show logged-in user name
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),

            child: Center(
              child: Text(
                /// User fullname
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

      /// Displays selected tab screen
      body: _screens[_selectedIndex],

      /// =========================
      /// BOTTOM NAVIGATION
      /// =========================
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.black,

        color: Colors.redAccent,

        buttonBackgroundColor: Colors.redAccent,

        /// Navigation icons
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),

          Icon(Icons.dashboard, size: 30, color: Colors.white),

          Icon(Icons.person, size: 30, color: Colors.white),
        ],

        /// Current active tab
        index: _selectedIndex,

        /// Change screen when tapped
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

/// =======================================
/// HOME PAGE
/// First tab in bottom navigation
/// =======================================
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background image
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("spurs.jpg"),

              fit: BoxFit.cover,
            ),
          ),
        ),

        /// Dark overlay
        Container(color: Colors.black.withOpacity(0.6)),

        /// Center content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              /// Welcome message
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

              /// Back to login button
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
                  /// Navigate back to login
                  /// Removes previous routes
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
