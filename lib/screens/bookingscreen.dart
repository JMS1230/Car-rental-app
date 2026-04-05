import 'package:flutter/material.dart';

class BookingScreen extends StatefulWidget {
  final Map<String, dynamic> car;

  BookingScreen({required this.car});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? startDate;
  DateTime? endDate;

  Future<void> pickDate(bool isStart) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Book ${widget.car["name"]}"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Car Name
            Text(
              widget.car["name"],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            // Start Date
            Card(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: ListTile(
                title: const Text(
                  "Start Date",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  startDate == null
                      ? "Select date"
                      : startDate.toString().split(" ")[0],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: Colors.redAccent,
                ),
                onTap: () => pickDate(true),
              ),
            ),

            const SizedBox(height: 10),

            // End Date
            Card(
              color: const Color(0xFF1C1C1E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.redAccent.withOpacity(0.4)),
              ),
              child: ListTile(
                title: const Text(
                  "End Date",
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  endDate == null
                      ? "Select date"
                      : endDate.toString().split(" ")[0],
                  style: TextStyle(color: Colors.grey[400]),
                ),
                trailing: const Icon(
                  Icons.calendar_today,
                  color: Colors.redAccent,
                ),
                onTap: () => pickDate(false),
              ),
            ),

            const SizedBox(height: 30),

            // Confirm Button
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
                  "Confirm Booking",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Booking Confirmed!")),
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
