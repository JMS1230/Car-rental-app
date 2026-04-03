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
      appBar: AppBar(title: Text("Available Cars")),
      body: ListView.builder(
        itemCount: cars.length,
        itemBuilder: (context, index) {
          var car = cars[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: Image.network(car["image"], width: 60),
              title: Text(car["name"]),
              subtitle: Text("Ksh ${car["price"]}/day"),
              trailing: Icon(Icons.arrow_forward),
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
