import 'package:flutter/material.dart';

class DriverLicenceScreen extends StatelessWidget {
  const DriverLicenceScreen({super.key});

  final String fullName = "Bruce Wayne";
  final String licenceNumber = "DL-254-778899";
  final String expiryDate = "2028-12-31";
  final String category = "B, C";
  final String licenceImage = "https://via.placeholder.com/300x180";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Driver Licence"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Licence Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                licenceImage,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            // Licence Details Card
            Card(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildRow("Full Name", fullName),
                    const Divider(color: Colors.grey),
                    _buildRow("Licence Number", licenceNumber),
                    const Divider(color: Colors.grey),
                    _buildRow("Expiry Date", expiryDate),
                    const Divider(color: Colors.grey),
                    _buildRow("Category", category),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(color: Colors.grey[400])),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
