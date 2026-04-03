import 'package:flutter_application_1/screens/clientdashboard.dart';
import 'package:flutter_application_1/screens/clienthomescreen.dart';
import 'package:flutter_application_1/screens/clientprofile.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/signup.dart';
import 'package:flutter_application_1/screens/carscreen.dart';
import 'package:flutter_application_1/screens/cardetail.dart';
import 'package:flutter_application_1/screens/bookingscreen.dart';
import 'package:get/get.dart';

var routes = [
  // Auth routes
  GetPage(name: '/login', page: () => LoginScreen()),
  GetPage(name: '/signup', page: () => const Signup()),

  // Home
  GetPage(name: '/client-home', page: () => const Clienthomescreen()),
  // Staff routes

  // Client route
  GetPage(name: '/client-dashboard', page: () => const ClientDashboardScreen()),
  GetPage(name: '/client-profile', page: () => const ClientProfileScreen()),
  GetPage(name: '/cars', page: () => CarsScreen()),
  GetPage(
    name: '/car-details',
    page: () => CarDetailsScreen(car: {}),
  ),
  GetPage(
    name: '/booking',
    page: () => BookingScreen(car: {}),
  ),
];
