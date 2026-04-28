import 'package:flutter/material.dart';
// Imports Flutter UI package

/// Help Desk Screen
/// StatelessWidget is used because this screen
/// displays fixed support options and has no changing state.
class HelpDeskScreen extends StatelessWidget {
  const HelpDeskScreen({super.key});

  /// List of help/support options
  /// Each option contains:
  /// title -> support service name
  /// subtitle -> contact detail
  /// icon -> icon displayed on the left
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Page background color
      backgroundColor: Colors.black,

      /// Top app bar
      appBar: AppBar(
        title: const Text("Help Desk"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),

      /// Builds support options list dynamically
      body: ListView.builder(
        padding: const EdgeInsets.all(16),

        /// Number of support options
        itemCount: helpOptions.length,

        itemBuilder: (context, index) {
          /// Current help option
          final item = helpOptions[index];

          return Card(
            /// Card background color
            color: const Color(0xFF1C1C1E),

            /// Shadow depth
            elevation: 6,

            /// Red glow shadow
            shadowColor: Colors.redAccent.withOpacity(0.4),

            /// Rounded border styling
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),

              side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
            ),

            /// Space between cards
            margin: const EdgeInsets.only(bottom: 16),

            child: ListTile(
              /// Left icon
              leading: Icon(item["icon"], color: Colors.redAccent, size: 30),

              /// Main title
              title: Text(
                item["title"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Contact detail
              subtitle: Text(
                item["subtitle"],
                style: TextStyle(color: Colors.grey[400]),
              ),

              /// Right arrow icon
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),

              /// Action when user taps option
              onTap: () {
                /// Show snackbar feedback
                /// (Currently placeholder action)
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
