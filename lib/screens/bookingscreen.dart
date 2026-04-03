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
      appBar: AppBar(title: Text("Book ${widget.car["name"]}")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.car["name"],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ListTile(
              title: Text("Start Date"),
              subtitle: Text(
                startDate == null
                    ? "Select date"
                    : startDate.toString().split(" ")[0],
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => pickDate(true),
            ),

            ListTile(
              title: Text("End Date"),
              subtitle: Text(
                endDate == null
                    ? "Select date"
                    : endDate.toString().split(" ")[0],
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () => pickDate(false),
            ),

            SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                child: Text("Confirm Booking"),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text("Booking Confirmed!")));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
