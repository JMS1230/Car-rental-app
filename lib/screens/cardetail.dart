// ignore_for_file: deprecated_member_use
// Suppresses warnings for deprecated Flutter APIs used in this file.

import 'package:flutter/material.dart';
// Flutter UI framework

import 'package:flutter_application_1/screens/bookingscreen.dart';
// Booking screen used when user clicks "Book Now"

import 'package:get/get.dart';
// GetX for navigation and passing data between screens

/// =======================================
/// CAR DETAILS SCREEN
/// Shows full details of a selected car
/// Allows user to proceed to booking
/// =======================================
class CarDetailsScreen extends StatelessWidget {
  /// Car data passed from previous screen
  final Map<String, dynamic> car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    /// Retrieve user data passed via GetX arguments
    final user = Map<String, dynamic>.from(Get.arguments ?? {});

    /// ==============================
    /// CAR DATA EXTRACTION
    /// ==============================

    /// Full car name (brand + model)
    final String name = "${car['brand'] ?? ''} ${car['model'] ?? ''}".trim();

    /// Daily rental price
    final String price = car['price_day']?.toString() ?? '0';

    /// Image URL of the car
    final String imageUrl = car['image_url']?.toString() ?? '';

    /// Car manufacturing year
    final String year = car['year']?.toString() ?? 'N/A';

    /// Number of seats
    final String seats = car['seats']?.toString() ?? 'N/A';

    /// Fuel type (Petrol/Diesel/etc.)
    final String fuel = car['fuel_type']?.toString() ?? 'N/A';

    /// Transmission type (Auto/Manual)
    final String transmission = car['transmission']?.toString() ?? 'N/A';

    /// Availability status (available/booked)
    final String status = car['status']?.toString() ?? 'available';

    return Scaffold(
      /// Dark theme background
      backgroundColor: Colors.black,

      /// ==============================
      /// APP BAR
      /// ==============================
      appBar: AppBar(
        title: Text(name),

        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// ==============================
      /// BODY
      /// ==============================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            /// ==============================
            /// CAR IMAGE SECTION
            /// ==============================
            ClipRRect(
              borderRadius: BorderRadius.circular(16),

              child: imageUrl.isNotEmpty
                  /// If image exists load from network
                  ? Image.network(
                      imageUrl,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,

                      errorBuilder: (context, error, stackTrace) => Container(
                        width: double.infinity,
                        height: 200,

                        color: const Color(0xFF1C1C1E),

                        child: const Icon(
                          Icons.directions_car,
                          color: Colors.redAccent,
                          size: 80,
                        ),
                      ),
                    )
                  /// Fallback image if empty
                  : Container(
                      width: double.infinity,
                      height: 200,

                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E),

                        borderRadius: BorderRadius.circular(16),
                      ),

                      child: const Icon(
                        Icons.directions_car,
                        color: Colors.redAccent,
                        size: 80,
                      ),
                    ),
            ),

            const SizedBox(height: 20),

            /// ==============================
            /// CAR NAME
            /// ==============================
            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            /// ==============================
            /// AVAILABILITY BADGE
            /// ==============================
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),

              decoration: BoxDecoration(
                color: status == 'available'
                    /// Green background if available
                    ? Colors.green.withOpacity(0.2)
                    /// Red background if booked
                    : Colors.red.withOpacity(0.2),

                borderRadius: BorderRadius.circular(20),

                border: Border.all(
                  color: status == 'available' ? Colors.green : Colors.red,
                ),
              ),

              child: Text(
                status == 'available' ? 'Available' : 'Booked',

                style: TextStyle(
                  color: status == 'available' ? Colors.green : Colors.red,

                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==============================
            /// PRICE DISPLAY
            /// ==============================
            Text(
              "Ksh $price / day",

              style: const TextStyle(
                fontSize: 22,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            /// ==============================
            /// CAR DETAILS CARD
            /// ==============================
            Card(
              color: const Color(0xFF1C1C1E),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),

                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [
                    /// Year
                    _detailRow(Icons.calendar_today, "Year", year),

                    const Divider(color: Colors.grey),

                    /// Seats
                    _detailRow(Icons.people, "Seats", seats),

                    const Divider(color: Colors.grey),

                    /// Fuel type
                    _detailRow(Icons.local_gas_station, "Fuel Type", fuel),

                    const Divider(color: Colors.grey),

                    /// Transmission
                    _detailRow(Icons.settings, "Transmission", transmission),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ==============================
            /// BOOK NOW BUTTON
            /// ==============================
            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: status == 'available'
                      ? Colors.redAccent
                      : Colors.grey,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                /// Only allow booking if available
                onPressed: status == 'available'
                    ? () {
                        /// Navigate to booking screen
                        /// Pass car + user data
                        Get.to(() => BookingScreen(car: car), arguments: user);
                      }
                    : null,

                child: Text(
                  status == 'available' ? "Book Now" : "Not Available",

                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// =======================================
  /// REUSABLE ROW WIDGET FOR DETAILS
  /// =======================================
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),

      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20),

          const SizedBox(width: 12),

          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),

          const Spacer(),

          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
