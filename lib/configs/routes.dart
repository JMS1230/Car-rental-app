import 'package:flutter_application_1/screens/clientdashboard.dart';
import 'package:flutter_application_1/screens/clienthomescreen.dart';
import 'package:flutter_application_1/screens/clientprofile.dart';
import 'package:flutter_application_1/screens/homescreen.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/signup.dart';

import 'package:get/get.dart';

var routes = [
  // Auth routes
  GetPage(name: '/login', page: () => LoginScreen()),
  GetPage(name: '/signup', page: () => const Signup()),

  // Home
  GetPage(name: '/home', page: () => const Homescreen()),
  GetPage(name: '/client-home', page: () => const Clienthomescreen()),
  // Staff routes
  GetPage(name: '/staff-dashboard', page: () => StaffDashboardScreen()),
  GetPage(name: '/staff-profile', page: () => const StaffProfileScreen()),

  // Client route
  GetPage(name: '/client-dashboard', page: () => const ClientDashboardScreen()),
  GetPage(name: '/client-profile', page: () => const ClientProfileScreen()),
];
