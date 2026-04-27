// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/cardetail.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CarsScreen extends StatefulWidget {
  const CarsScreen({super.key});

  @override
  State<CarsScreen> createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  List<Map<String, dynamic>> cars = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCars();
  }

  Future<void> fetchCars() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.103/flutterapi/get_cars2.php"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['code'] == 1) {
          setState(() {
            cars = List<Map<String, dynamic>>.from(data['cars']);
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Failed to load cars';
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

  @override
  Widget build(BuildContext context) {
    final user = Get.arguments ?? {};

    // ✅ PROMOTION DATA (FIX ADDED HERE)
    final args = Get.arguments ?? {};
    final bool isPromo = args["discount"] ?? false;
    final int discountPercent = args["discount_percent"] ?? 0;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Available Cars"),
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
                      fetchCars();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : cars.isEmpty
          ? const Center(
              child: Text(
                "No cars available",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: cars.length,
              itemBuilder: (context, index) {
                final car = cars[index];

                // ✅ PRICE LOGIC WITH DISCOUNT
                double price = double.parse(car['price_day'].toString());

                double finalPrice = price;

                if (isPromo) {
                  finalPrice = price - (price * discountPercent / 100);
                }

                return Card(
                  color: const Color(0xFF1C1C1E),
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),

                    // 🚗 IMAGE
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          car['image_url'] != null &&
                              car['image_url'].toString().isNotEmpty
                          ? Image.network(
                              car['image_url'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
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

                    // 🚘 NAME
                    title: Text(
                      "${car['brand']} ${car['model']}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // 💰 PRICE WITH DISCOUNT
                    subtitle: Text(
                      isPromo
                          ? "Ksh ${finalPrice.toStringAsFixed(0)}/day (-$discountPercent%)"
                          : "Ksh ${price.toStringAsFixed(0)}/day",
                      style: TextStyle(color: Colors.grey[400]),
                    ),

                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.redAccent,
                      size: 16,
                    ),

                    // 👉 DETAILS PAGE
                    onTap: () {
                      Get.to(() => CarDetailsScreen(car: car), arguments: user);
                    },
                  ),
                );
              },
            ),
    );
  }
}
