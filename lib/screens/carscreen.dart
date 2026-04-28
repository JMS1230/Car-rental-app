// ignore_for_file: deprecated_member_use
// Suppresses warnings for deprecated Flutter APIs used in this file.

import 'dart:convert';
// Used to convert JSON responses from backend into Dart objects

import 'package:flutter/material.dart';
// Flutter UI framework

import 'package:flutter_application_1/screens/cardetail.dart';
// Imports car details screen for navigation

import 'package:get/get.dart';
// GetX for navigation and passing data between screens

import 'package:http/http.dart' as http;
// Used for making HTTP requests to backend API

/// =======================================
/// CARS SCREEN
/// Displays list of available cars
/// Supports promo discount logic
/// =======================================
class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  /// List of cars fetched from backend
  List<Map<String, dynamic>> cars = [];

  /// Loading state indicator
  bool isLoading = true;

  /// Stores error message if API fails
  String errorMessage = '';

  @override
  void initState() {
    super.initState();

    /// Fetch cars when screen loads
    fetchCars();
  }

  /// =======================================
  /// FETCH CARS FROM BACKEND
  /// =======================================
  Future<void> fetchCars() async {
    try {
      /// API request to get cars
      final response = await http.get(
        Uri.parse("http://10.61.228.97/flutterapi/get_cars2.php"),
      );

      /// Check if request succeeded
      if (response.statusCode == 200) {
        /// Decode JSON response
        final data = jsonDecode(response.body);

        /// Check backend success code
        if (data['code'] == 1) {
          setState(() {
            /// Convert list of cars from API
            cars = List<Map<String, dynamic>>.from(data['cars']);

            isLoading = false;
          });
        } else {
          /// Backend returned failure message
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load cars';

            isLoading = false;
          });
        }
      } else {
        /// HTTP error response
        setState(() {
          errorMessage = 'Server error';
          isLoading = false;
        });
      }
    } catch (e) {
      /// Network or parsing error
      setState(() {
        errorMessage = 'Connection failed: $e';

        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// =======================================
    /// ARGUMENTS HANDLING
    /// =======================================
    final args = Map<String, dynamic>.from(Get.arguments ?? {});

    /// Check if promo is active
    final bool isPromo = args["discount"] ?? false;

    /// Discount percentage if any
    final int discountPercent = args["discount_percent"] ?? 0;

    /// Extract ONLY user data (remove promo fields)
    final Map<String, dynamic> user = Map<String, dynamic>.from(args)
      ..remove('discount')
      ..remove('discount_percent');

    return Scaffold(
      /// Dark theme background
      backgroundColor: Colors.black,

      /// =======================================
      /// APP BAR
      /// =======================================
      appBar: AppBar(
        title: const Text("Available Cars"),

        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,

        /// Promo banner displayed under AppBar
        bottom: isPromo
            ? PreferredSize(
                preferredSize: const Size(double.infinity, 28),

                child: Container(
                  width: double.infinity,

                  color: Colors.redAccent.withOpacity(0.15),

                  padding: const EdgeInsets.symmetric(vertical: 5),

                  child: Text(
                    "🎉 $discountPercent% promo applied to all prices!",

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      color: Colors.redAccent,

                      fontWeight: FontWeight.bold,

                      fontSize: 13,
                    ),
                  ),
                ),
              )
            : null,
      ),

      /// =======================================
      /// BODY CONTENT
      /// =======================================
      body: isLoading
          /// Loading state
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            )
          /// Error state UI
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 50,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    errorMessage,
                    style: const TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 16),

                  /// Retry button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),

                    onPressed: () {
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });

                      fetchCars();
                    },

                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          /// Empty list state
          : cars.isEmpty
          ? const Center(
              child: Text(
                "No cars available",
                style: TextStyle(color: Colors.white70),
              ),
            )
          /// Cars list
          : ListView.builder(
              itemCount: cars.length,

              itemBuilder: (context, index) {
                final car = cars[index];

                /// Convert price safely
                final double price =
                    double.tryParse(car['price_day'].toString()) ?? 0;

                /// Apply discount if promo active
                final double finalPrice = isPromo
                    ? price - (price * discountPercent / 100)
                    : price;

                return Card(
                  color: const Color(0xFF1C1C1E),

                  margin: const EdgeInsets.all(10),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),

                    side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    /// ===================
                    /// CAR IMAGE
                    /// ===================
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),

                      child:
                          car['image_url'] != null &&
                              car['image_url'].toString().isNotEmpty
                          ? Image.network(
                              car['image_url'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,

                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.directions_car,
                                color: Colors.redAccent,
                                size: 40,
                              ),
                            )
                          : const Icon(
                              Icons.directions_car,
                              color: Colors.redAccent,
                              size: 40,
                            ),
                    ),

                    /// ===================
                    /// CAR NAME
                    /// ===================
                    title: Text(
                      "${car['brand']} ${car['model']}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    /// ===================
                    /// PRICE DISPLAY
                    /// ===================
                    subtitle: isPromo
                        ? Row(
                            children: [
                              /// Original price (strikethrough)
                              Text(
                                "Ksh ${price.toStringAsFixed(0)}",

                                style: const TextStyle(
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 12,
                                ),
                              ),

                              const SizedBox(width: 6),

                              /// Discounted price
                              Text(
                                "Ksh ${finalPrice.toStringAsFixed(0)}/day (-$discountPercent%)",

                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "Ksh ${price.toStringAsFixed(0)}/day",

                            style: TextStyle(color: Colors.grey[400]),
                          ),

                    /// Arrow icon
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                      size: 16,
                    ),

                    /// Navigate to details screen
                    onTap: () {
                      Get.to(() => CarDetailsScreen(car: car), arguments: user);
                    },
                  ),
                );
              },
            ),
    );
  }
}
