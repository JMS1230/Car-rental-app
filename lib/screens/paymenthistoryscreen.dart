import 'package:flutter/material.dart';

class PaymentHistoryScreen extends StatelessWidget {
  PaymentHistoryScreen({super.key});

  // Sample payment data (replace with API later)
  final List<Map<String, dynamic>> payments = [
    {
      "car": "Toyota Corolla",
      "amount": 9000,
      "date": "2026-04-01",
      "status": "Paid",
    },
    {
      "car": "Honda Civic",
      "amount": 7000,
      "date": "2026-03-20",
      "status": "Paid",
    },
    {
      "car": "BMW X5",
      "amount": 15000,
      "date": "2026-03-10",
      "status": "Pending",
    },
  ];

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Payment History"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: payments.length,
        itemBuilder: (context, index) {
          final payment = payments[index];

          return Card(
            color: const Color(0xFF1C1C1E),
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
            ),
            child: ListTile(
              leading: const Icon(Icons.payment, color: Colors.redAccent),
              title: Text(
                payment["car"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    "Date: ${payment["date"]}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Amount: Ksh ${payment["amount"]}",
                    style: TextStyle(color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Status: ${payment["status"]}",
                    style: TextStyle(
                      color: getStatusColor(payment["status"]),
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
                // Optional: navigate to payment details
              },
            ),
          );
        },
      ),
    );
  }
}
