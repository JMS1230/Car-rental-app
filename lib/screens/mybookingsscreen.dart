// ignore_for_file: deprecated_member_use
// Ignores warnings related to deprecated methods used in this file.

import 'dart:convert';
// Used for converting JSON response from backend into Dart objects

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:get/get.dart';
// GetX for navigation and receiving passed arguments

import 'package:http/http.dart' as http;
// Used for making HTTP requests to backend

/// MyBookingsScreen shows all bookings made by the logged-in user
/// StatefulWidget is used because data changes after API call
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  /// Stores booking records fetched from backend
  List<Map<String, dynamic>> bookings = [];

  /// Controls loading spinner
  bool isLoading = true;

  /// Stores any error message
  String errorMessage = '';

  /// Gets user data passed from previous screen
  final Map<String, dynamic> user = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();

    /// Fetch bookings immediately when screen opens
    fetchBookings();
  }

  /// Fetch user's bookings from backend
  Future<void> fetchBookings() async {
    // Ensure user exists before fetching bookings
    if (user['id'] == null) {
      setState(() {
        errorMessage = 'User not logged in. Please log in again.';
        isLoading = false;
      });
      return;
    }

    try {
      /// Send GET request to backend with user ID
      final response = await http.get(
        Uri.parse(
          "http://10.61.228.97/flutterapi/get_bookings.php?user_id=${user['id']}",
        ),
      );

      /// If request successful
      if (response.statusCode == 200) {
        /// Decode response JSON
        final data = jsonDecode(response.body);

        /// If backend returned success
        if (data['code'] == 1) {
          setState(() {
            /// Convert booking list into Dart list
            bookings = List<Map<String, dynamic>>.from(data['bookings']);

            isLoading = false;
          });
        } else {
          /// Backend returned an error
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load bookings';
            isLoading = false;
          });
        }
      } else {
        /// HTTP response error
        setState(() {
          errorMessage = 'Server error';
          isLoading = false;
        });
      }
    } catch (e) {
      /// Connection or other unexpected error
      setState(() {
        errorMessage = 'Connection failed: $e';
        isLoading = false;
      });
    }
  }

  /// Returns status color depending on booking status
  Color getStatusColor(String status) {
    switch (status) {
      case "confirmed":
        return Colors.green;

      case "pending":
        return Colors.orange;

      case "cancelled":
        return Colors.red;

      default:
        return Colors.grey;
    }
  }

  /// Returns icon based on booking status
  IconData getStatusIcon(String status) {
    switch (status) {
      case "confirmed":
        return Icons.check_circle;

      case "pending":
        return Icons.hourglass_empty;

      case "cancelled":
        return Icons.cancel;

      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Dark theme background
      backgroundColor: Colors.black,

      /// Top App Bar
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// Body uses conditional rendering
      body: isLoading
          /// Show loading spinner while fetching
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            )
          /// Show error UI if there is an error
          : errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Error icon
                  const Icon(
                    Icons.error_outline,
                    color: Colors.redAccent,
                    size: 50,
                  ),

                  const SizedBox(height: 12),

                  /// Error message
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
                      /// Reset loading and retry
                      setState(() {
                        isLoading = true;
                        errorMessage = '';
                      });

                      fetchBookings();
                    },

                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          /// If no bookings exist
          : bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Empty state icon
                  Icon(Icons.car_rental, color: Colors.redAccent, size: 60),

                  SizedBox(height: 12),

                  /// Empty state text
                  Text(
                    "No bookings yet",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
          /// If bookings exist show list
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: bookings.length,

              itemBuilder: (context, index) {
                /// Current booking item
                final booking = bookings[index];

                /// Car name from brand + name column
                /// 'name' matches cars.name in PHP backend
                final String carName =
                    "${booking['brand'] ?? ''} ${booking['name'] ?? ''}".trim();

                /// Booking status
                final String status = booking['status'] ?? 'pending';

                /// Booking start date
                final String startDate = booking['start_date'] ?? '';

                /// Booking end date
                final String endDate = booking['end_date'] ?? '';

                /// Total booking price
                final String total = booking['total_price'] ?? '0';

                return Card(
                  /// Booking card styling
                  color: const Color(0xFF1C1C1E),

                  margin: const EdgeInsets.only(bottom: 12),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),

                    side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Row(
                      children: [
                        /// Car image section
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),

                          child:
                              booking['image_url'] != null &&
                                  booking['image_url'].toString().isNotEmpty
                              /// Load car image from URL
                              ? Image.network(
                                  booking['image_url'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,

                                  /// Fallback if image fails
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.directions_car,
                                    color: Colors.redAccent,
                                    size: 40,
                                  ),
                                )
                              /// Default icon if no image
                              : const Icon(
                                  Icons.directions_car,
                                  color: Colors.redAccent,
                                  size: 40,
                                ),
                        ),

                        const SizedBox(width: 16),

                        /// Booking details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Car name
                              Text(
                                carName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// Booking dates
                              Text(
                                "$startDate → $endDate",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                              ),

                              const SizedBox(height: 4),

                              /// Booking price
                              Text(
                                "Ksh $total",
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Status section
                        Column(
                          children: [
                            /// Status icon
                            Icon(
                              getStatusIcon(status),
                              color: getStatusColor(status),
                            ),

                            const SizedBox(height: 4),

                            /// Capitalized status text
                            Text(
                              status[0].toUpperCase() + status.substring(1),

                              style: TextStyle(
                                color: getStatusColor(status),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
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
