// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  const BookingScreen({super.key, required this.car});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool isLoading = false;

  final Map<String, dynamic> user = Get.arguments ?? {};

  Future<void> pickDate(bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.redAccent,
              surface: Color(0xFF1C1C1E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
          if (endDate != null && endDate!.isBefore(startDate!)) {
            endDate = null;
          }
        } else {
          endDate = picked;
        }
      });
    }
  }

  int get totalDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays;
  }

  double get totalPrice {
    final pricePerDay =
        double.tryParse(widget.car['price_day']?.toString() ?? '0') ?? 0;
    return totalDays * pricePerDay;
  }

  Future<void> confirmBooking() async {
    // ✅ Guard: ensure user is logged in
    if (user['id'] == null) {
      Get.snackbar(
        "Error",
        "User not logged in. Please log in again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (startDate == null || endDate == null) {
      Get.snackbar(
        "Error",
        "Please select start and end date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (totalDays <= 0) {
      Get.snackbar(
        "Error",
        "End date must be after start date",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // ✅ Fixed: removed space in URL
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.103/flutterapi/create_booking.php"
          "?user_id=${user['id']}"
          "&car_id=${widget.car['id']}"
          "&start_date=${startDate.toString().split(' ')[0]}"
          "&end_date=${endDate.toString().split(' ')[0]}"
          "&total_price=$totalPrice",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1) {
          Get.offAllNamed('/client-home', arguments: user);
          Get.snackbar(
            "Success",
            "Booking confirmed!",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Booking failed",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Please try again",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Connection failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

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
    final String carName =
        "${widget.car['brand'] ?? ''} ${widget.car['model'] ?? ''}".trim();

    return Scaffold(
      backgroundColor: Colors.black,
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
            Text(
              carName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Ksh ${widget.car['price_day']}/day",
              style: TextStyle(color: Colors.grey[400], fontSize: 15),
            ),

            const SizedBox(height: 24),

            // Start Date
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

            // End Date
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

            // Price Summary
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
                        "Ksh $totalPrice",
                        highlight: true,
                      ),
                    ],
                  ),
                ),
              ),

            const Spacer(),

            // Confirm Button
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