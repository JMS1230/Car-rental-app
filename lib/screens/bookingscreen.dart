// ignore_for_file: deprecated_member_use
// ↑ This disables Flutter warnings about deprecated APIs (not recommended long-term, but used for now)

import 'dart:convert'; // Used to convert JSON responses into Dart objects
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:get/get.dart'; // State management + navigation (GetX)
import 'package:http/http.dart'
    as http; // For making HTTP requests to backend API

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> car; // Car details passed from previous screen

  const BookingScreen({super.key, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  // Selected booking start date
  DateTime? startDate;

  // Selected booking end date
  DateTime? endDate;

  // Controls loading state (shows spinner while booking is processing)
  bool isLoading = false;

  // ✅ Retrieve user data passed from CarDetailsScreen via Get.arguments
  late final Map<String, dynamic> user = Map<String, dynamic>.from(
    Get.arguments ?? {},
  );

  /// FUNCTION: Opens date picker for selecting start or end date
  Future<void> pickDate(bool isStart) async {
    // Show calendar date picker dialog
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // default selected date
      firstDate: DateTime.now(), // cannot pick past dates
      lastDate: DateTime(2030), // max allowed date
      // Custom dark theme for date picker
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.redAccent, // selected date color
              surface: Color(0xFF1C1C1E), // background color
            ),
          ),
          child: child!,
        );
      },
    );

    // If user selected a date
    if (picked != null) {
      setState(() {
        // If selecting start date
        if (isStart) {
          startDate = picked;

          // If end date is before new start date → reset it
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          // If selecting end date
          endDate = picked;
        }
      });
    }
  }

  /// Calculates number of booking days
  int get totalDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays;
  }

  /// Calculates total booking price
  double get totalPrice {
    final pricePerDay =
        double.tryParse(widget.car['price_day']?.toString() ?? '0') ?? 0;
    return totalDays * pricePerDay;
  }

  /// FUNCTION: Sends booking request to backend API
  Future<void> confirmBooking() async {
    // ❗ Check if user is logged in
    if (user['id'] == null) {
      Get.snackbar(
        "Error",
        "User not logged in. Please log in again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ❗ Validate date selection
    if (startDate == null || endDate == null) {
      Get.snackbar(
        "Error",
        "Please select start and end date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ❗ Ensure valid date range
    if (totalDays <= 0) {
      Get.snackbar(
        "Error",
        "End date must be after start date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Show loading spinner
    setState(() => isLoading = true);

    try {
      // Send GET request to PHP backend
      final response = await http.get(
        Uri.parse(
          "http://10.61.228.97/flutterapi/create_booking.php"
          "?user_id=${user['id']}"
          "&car_id=${widget.car['id']}"
          "&start_date=${startDate.toString().split(' ')[0]}"
          "&end_date=${endDate.toString().split(' ')[0]}"
          "&total_price=$totalPrice",
        ),
      );

      // If request is successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // If backend returns success
        if (data['code'] == 1) {
          Get.snackbar(
            "Success",
            "Booking confirmed!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Navigate back to home and pass user data
          Get.offAllNamed('/client-home', arguments: user);
        } else {
          // Backend returned error message
          Get.snackbar(
            "Error",
            data['message'] ?? "Booking failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        // Server error
        Get.snackbar(
          "Server Error",
          "Please try again",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Network / connection error
      Get.snackbar(
        "Error",
        "Connection failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      // Stop loading spinner
      setState(() => isLoading = false);
    }
  }

  /// UI helper widget for showing summary rows
  Widget _summaryRow(String label, String value, {bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Text(
          value,
          style: TextStyle(
            color: highlight ? Colors.redAccent : Colors.grey[400],
            fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Combine brand + model into full car name
    final String carName =
        "${widget.car['brand'] ?? ''} ${widget.car['model'] ?? ''}".trim();

    return Scaffold(
      backgroundColor: Colors.black,

      // App bar showing selected car name
      appBar: AppBar(
        title: Text("Book $carName"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Car name display
            Text(
              carName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            // Price per day display
            Text(
              "Ksh ${widget.car['price_day']}/day",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            ),

            const SizedBox(height: 24),

            // Start date selector card
            Card(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: ListTile(
                title: const Text(
                  "Start Date",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  startDate == null
                      ? "Select date"
                      : startDate.toString().split(" ")[0],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: Colors.redAccent,
                ),
                onTap: () => pickDate(true),
              ),
            ),

            const SizedBox(height: 10),

            // End date selector card
            Card(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: ListTile(
                title: const Text(
                  "End Date",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  endDate == null
                      ? "Select date"
                      : endDate.toString().split(" ")[0],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: Colors.redAccent,
                ),
                onTap: () => pickDate(false),
              ),
            ),

            const SizedBox(height: 20),

            // Price summary section (only shows when dates are selected)
            if (totalDays > 0)
              Card(
                color: const Color(0xFF1C1C1E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _summaryRow("Days", "$totalDays days"),
                      const Divider(color: Colors.grey),
                      _summaryRow(
                        "Price/day",
                        "Ksh ${widget.car['price_day']}",
                      ),
                      const Divider(color: Colors.grey),
                      _summaryRow(
                        "Total Price",
                        "Ksh ${totalPrice.toStringAsFixed(0)}",
                        highlight: true,
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Confirm booking button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isLoading ? null : confirmBooking,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Confirm Booking",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
