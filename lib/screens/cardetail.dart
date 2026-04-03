import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/bookingscreen.dart';

class CarDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> car;

  CarDetailsScreen({required this.car});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(car["name"])),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(car["image"]),
            SizedBox(height: 20),

            Text(
              car["name"],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Text(
              "Price: Ksh ${car["price"]}/day",
              style: TextStyle(fontSize: 18),
            ),

            SizedBox(height: 20),

            Text(
              "This is a reliable and comfortable car for your trips.",
              style: TextStyle(fontSize: 16),
            ),

            Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Book Now"),
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
