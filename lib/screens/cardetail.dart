// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/bookingscreen.dart';
import 'package:get/get.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  const CarDetailsScreen({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    // ✅ Get user passed from CarsScreen
    final user = Get.arguments ?? {};

    final String name = "${car['brand'] ?? ''} ${car['model'] ?? ''}".trim();
    final String price = car['price_day']?.toString() ?? '0';
    final String imageUrl = car['image_url']?.toString() ?? '';
    final String year = car['year']?.toString() ?? 'N/A';
    final String seats = car['seats']?.toString() ?? 'N/A';
    final String fuel = car['fuel_type']?.toString() ?? 'N/A';
    final String transmission = car['transmission']?.toString() ?? 'N/A';
    final String status = car['status']?.toString() ?? 'available';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
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

            Text(
              name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: status == 'available'
                    ? Colors.green.withOpacity(0.2)
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

            Text(
              "Ksh $price / day",
              style: const TextStyle(
                fontSize: 22,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

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
                    _detailRow(Icons.calendar_today, "Year", year),
                    const Divider(color: Colors.grey),
                    _detailRow(Icons.people, "Seats", seats),
                    const Divider(color: Colors.grey),
                    _detailRow(Icons.local_gas_station, "Fuel Type", fuel),
                    const Divider(color: Colors.grey),
                    _detailRow(Icons.settings, "Transmission", transmission),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

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
                // ✅ Pass user to BookingScreen via Get.to
                onPressed: status == 'available'
                    ? () {
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
