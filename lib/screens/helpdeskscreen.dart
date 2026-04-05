import 'package:flutter/material.dart';

class HelpDeskScreen extends StatelessWidget {
  const HelpDeskScreen({super.key});

  final List<Map<String, dynamic>> helpOptions = const [
    {
      "title": "Call Support",
      "subtitle": "+254 700 123 456",
      "icon": Icons.phone,
    },
    {
      "title": "Email Support",
      "subtitle": "support@carrental.com",
      "icon": Icons.email,
    },
    {
      "title": "Live Chat",
      "subtitle": "Chat with our agent",
      "icon": Icons.chat,
    },
    {
      "title": "FAQs",
      "subtitle": "Common questions & answers",
      "icon": Icons.help_outline,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Help Desk"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: helpOptions.length,
        itemBuilder: (context, index) {
          final item = helpOptions[index];

          return Card(
            color: const Color(0xFF1C1C1E),
            elevation: 6,
            shadowColor: Colors.redAccent.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: Icon(item["icon"], color: Colors.redAccent, size: 30),
              title: Text(
                item["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                item["subtitle"],
                style: TextStyle(color: Colors.grey[400]),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              onTap: () {
                // ✅ ACTIONS (simple feedback for now)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("${item["title"]} clicked")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
