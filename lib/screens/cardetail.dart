import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/bookingscreen.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  CarDetailsScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(car["name"]),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                car["image"],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Car Name
            Text(
              car["name"],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            // Price
            Text(
              "Price: Ksh ${car["price"]}/day",
              style: TextStyle(fontSize: 18, color: Colors.grey[400]),
            ),

            const SizedBox(height: 20),

            // Description
            Text(
              "This is a reliable and comfortable car for your trips.",
              style: TextStyle(fontSize: 16, color: Colors.grey[400]),
            ),

            const Spacer(),

            // Book Button
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
                child: const Text(
                  "Book Now",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(car: car),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
