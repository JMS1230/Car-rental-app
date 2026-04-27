// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true;
  String errorMessage = '';

  final Map<String, dynamic> user = Get.arguments ?? {};

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    // ✅ Guard: ensure user is logged in
    if (user['id'] == null) {
      setState(() {
        errorMessage = 'User not logged in. Please log in again.';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.103/flutterapi/get_bookings.php?user_id=${user['id']}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1) {
          setState(() {
            bookings = List<Map<String, dynamic>>.from(data['bookings']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load bookings';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Server error';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Connection failed: $e';
        isLoading = false;
      });
    }
  }

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("My Bookings"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            )
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
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
          : bookings.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.car_rental, color: Colors.redAccent, size: 60),
                  SizedBox(height: 12),
                  Text(
                    "No bookings yet",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                // ✅ Fixed: changed 'model' to 'name' to match PHP cars.name column
                final String carName =
                    "${booking['brand'] ?? ''} ${booking['name'] ?? ''}".trim();
                final String status = booking['status'] ?? 'pending';
                final String startDate = booking['start_date'] ?? '';
                final String endDate = booking['end_date'] ?? '';
                final String total = booking['total_price'] ?? '0';

                return Card(
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child:
                              booking['image_url'] != null &&
                                  booking['image_url'].toString().isNotEmpty
                              ? Image.network(
                                  booking['image_url'],
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

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                carName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "$startDate → $endDate",
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 4),
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

                        Column(
                          children: [
                            Icon(
                              getStatusIcon(status),
                              color: getStatusColor(status),
                            ),
                            const SizedBox(height: 4),
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
