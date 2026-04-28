// ignore_for_file: deprecated_member_use
// Ignores warnings related to deprecated members used in this file.

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:flutter_application_1/screens/carscreen.dart';
// Imports the Cars screen where user is redirected after applying a promotion

import 'package:get/get.dart';
// GetX package used for navigation and passing arguments

/// PromotionScreen displays available promo offers.
/// StatelessWidget is used because promotions are fixed
/// and no changing internal state is required.
class PromotionScreen extends StatelessWidget {
  const PromotionScreen({super.key});

  /// List of available promotions
  /// Each promotion is stored as a map containing:
  /// title
  /// description
  /// promo code
  /// discount percentage
  final List<Map<String, dynamic>> promotions = const [
    {
      "title": "Weekend Deal",
      "description": "Get 20% off on weekend bookings",
      "code": "WEEKEND20",
      "discount_percent": 20,
    },

    {
      "title": "First Ride",
      "description": "New users get 10% off",
      "code": "FIRST500",
      "discount_percent": 10,
    },

    {
      "title": "Holiday Offer",
      "description": "Enjoy discounted rates this holiday",
      "code": "HOLIDAY15",
      "discount_percent": 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    /// Receives user data passed from previous screen
    /// If no data passed, defaults to empty map
    final user = Get.arguments ?? {};

    return Scaffold(
      /// Dark background theme
      backgroundColor: Colors.black,

      /// Top App Bar
      appBar: AppBar(
        title: const Text("Promotions"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// Displays promotions in a scrollable list
      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        /// Number of cards equals number of promotions
        itemCount: promotions.length,

        itemBuilder: (context, index) {
          /// Current promotion being built
          final promo = promotions[index];

          return Card(
            /// Card background color
            color: const Color(0xFF1C1C1E),

            /// Card shadow elevation
            elevation: 6,

            /// Red glowing shadow
            shadowColor: Colors.redAccent.withOpacity(0.4),

            /// Rounded card border styling
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
            ),

            /// Space between cards
            margin: const EdgeInsets.only(bottom: 16),

            child: Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Promotion title
                  Text(
                    promo["title"] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Promotion description
                  Text(
                    promo["description"] as String,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),

                  const SizedBox(height: 12),

                  /// Row containing promo code and apply button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Promo code text
                      Text(
                        "Code: ${promo["code"]}",
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      /// Apply promotion button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        onPressed: () {
                          // Navigate to CarsScreen
                          // Pass:
                          // Existing user data
                          // Discount flag
                          // Selected discount percentage
                          Get.to(
                            () => const CarsScreen(),
                            arguments: {
                              ...Map<String, dynamic>.from(user),

                              "discount": true,

                              "discount_percent": promo["discount_percent"],
                            },
                          );
                        },

                        child: const Text(
                          "Apply",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
