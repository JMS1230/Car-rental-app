import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  // Sample bookings data (replace with API later)
  final List<Map<String, String>> bookings = const [
    {"car": "Toyota Corolla", "date": "2026-04-10", "status": "Confirmed"},
    {"car": "Range Rover Evoque", "date": "2026-04-15", "status": "Pending"},
    {"car": "BMW X5", "date": "2026-04-20", "status": "Completed"},
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Confirmed":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Completed":
        return Colors.blue;
      default:
        return Colors.grey;
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];

          return Card(
            color: const Color(0xFF1C1C1E),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.3)),
            ),
            child: ListTile(
              leading: const Icon(
                Icons.directions_car,
                color: Colors.redAccent,
              ),
              title: Text(
                booking["car"]!,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${booking["date"]}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${booking["status"]}",
                    style: TextStyle(
                      color: getStatusColor(booking["status"]!),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.white,
              ),
              onTap: () {
                // Navigate to booking details if needed
              },
            ),
          );
        },
      ),
    );
  }
}
