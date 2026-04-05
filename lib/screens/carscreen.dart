import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/cardetail.dart';

class CarsScreen extends StatelessWidget {
  CarsScreen({super.key});

  final List<Map<String, dynamic>> cars = [
    {
      "name": "Toyota Corolla",
      "price": 3000,
      "image": "https://via.placeholder.com/150",
    },
    {
      "name": "Honda Civic",
      "price": 3500,
      "image": "https://via.placeholder.com/150",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Available Cars"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          var car = cars[index];

          return Card(
            color: const Color(0xFF1C1C1E),
            margin: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
            ),
            elevation: 5,
            shadowColor: Colors.redAccent.withOpacity(0.3),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  car["image"],
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(
                car["name"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Ksh ${car["price"]}/day",
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.redAccent,
                size: 16,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CarDetailsScreen(car: car),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
