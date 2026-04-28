import 'dart:convert';
// Used to decode JSON responses from backend

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:get/get.dart';
// GetX for navigation, arguments and snackbars

import 'package:http/http.dart' as http;
// Used for HTTP requests

/// ======================================
/// CHANGE PASSWORD SCREEN
/// ======================================
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  /// Form key for validation
  final _formKey = GlobalKey<FormState>();

  /// Text controllers for password fields
  final TextEditingController currentPasswordController =
      TextEditingController();

  final TextEditingController newPasswordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  /// Loading state for submit button
  bool isLoading = false;

  /// Controls password visibility
  bool obscureCurrent = true;
  bool obscureNew = true;
  bool obscureConfirm = true;

  /// User data passed from previous screen
  late Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();

    /// Safely receive user arguments
    user = Get.arguments ?? {};

    /// If user missing redirect to login
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

  /// ===================================
  /// CHANGE PASSWORD FUNCTION
  /// ===================================
  Future<void> changePassword() async {
    /// Validate form first
    if (!_formKey.currentState!.validate()) return;

    /// Ensure user exists
    if (user['id'] == null) {
      Get.snackbar(
        "Error",
        "User not logged in. Please log in again.",

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );

      return;
    }

    /// Start loading
    setState(() => isLoading = true);

    try {
      /// Send request to backend
      final response = await http.get(
        Uri.parse(
          "http://10.61.228.97/flutterapi/change_password.php"
          "?user_id=${user['id']}"
          "&current_password=${Uri.encodeComponent(currentPasswordController.text)}"
          "&new_password=${Uri.encodeComponent(newPasswordController.text)}",
        ),
      );

      /// Successful server response
      if (response.statusCode == 200) {
        /// Decode response JSON
        final data = jsonDecode(response.body);

        /// Password updated successfully
        if (data['code'] == 1) {
          Get.snackbar(
            "Success",
            "Password changed successfully",

            backgroundColor: Colors.green,

            colorText: Colors.white,
          );

          /// Go back to previous screen
          Get.back();
        } else {
          /// Backend error message
          Get.snackbar(
            "Error",

            data['message'] ?? "Failed to change password",

            backgroundColor: Colors.red,

            colorText: Colors.white,
          );
        }
      } else {
        /// Server returned error
        Get.snackbar(
          "Server Error",
          "Please try again",

          backgroundColor: Colors.red,

          colorText: Colors.white,
        );
      }
    } catch (e) {
      /// Connection error
      Get.snackbar(
        "Error",
        "Connection failed: $e",

        backgroundColor: Colors.red,

        colorText: Colors.white,
      );
    } finally {
      /// Stop loading
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Dark theme background
      backgroundColor: Colors.black,

      /// AppBar
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
              /// ======================
              /// CURRENT PASSWORD FIELD
              /// ======================
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

                  /// Show/Hide button
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

              /// ======================
              /// NEW PASSWORD FIELD
              /// ======================
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

              /// ======================
              /// CONFIRM PASSWORD FIELD
              /// ======================
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

              /// ======================
              /// SUBMIT BUTTON
              /// ======================
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
                      /// Loading spinner
                      ? const CircularProgressIndicator(color: Colors.white)
                      /// Normal button text
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
