import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false;
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  // ✅ Get user passed from previous screen
  late Map<String, dynamic> user; // ✅ FIXED

  @override
  void initState() {
    super.initState();

    // ✅ SAFE USER RECEIVING
    user = Get.arguments ?? {};

    if (user.isEmpty || user['id'] == null) {
      Future.delayed(Duration.zero, () {
        Get.snackbar(
          "Error",
          "User not found. Please login again.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        Get.offAllNamed('/login');
      });
    }
  }

  Future<void> changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // ✅ Guard: ensure user is logged in
    if (user['id'] == null) {
      Get.snackbar(
        "Error",
        "User not logged in. Please log in again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.103/flutterapi/change_password.php"
          "?user_id=${user['id']}"
          "&current_password=${Uri.encodeComponent(currentPasswordController.text)}"
          "&new_password=${Uri.encodeComponent(newPasswordController.text)}",
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['code'] == 1) {
          Get.snackbar(
            "Success",
            "Password changed successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Get.back();
        } else {
          Get.snackbar(
            "Error",
            data['message'] ?? "Failed to change password",
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          "Server Error",
          "Please try again",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Connection failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Change Password"),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Current Password
              TextFormField(
                controller: currentPasswordController,
                obscureText: obscureCurrent,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Current Password",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureCurrent ? Icons.visibility : Icons.visibility_off,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureCurrent = !obscureCurrent;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter current password";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // New Password
              TextFormField(
                controller: newPasswordController,
                obscureText: obscureNew,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "New Password",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureNew ? Icons.visibility : Icons.visibility_off,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureNew = !obscureNew;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              // Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: obscureConfirm,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle: TextStyle(color: Colors.grey[400]),
                  filled: true,
                  fillColor: const Color(0xFF1C1C1E),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscureConfirm ? Icons.visibility : Icons.visibility_off,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      setState(() {
                        obscureConfirm = !obscureConfirm;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm your password";
                  }
                  if (value != newPasswordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Submit Button
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
                  onPressed: isLoading ? null : changePassword,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Update Password",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
