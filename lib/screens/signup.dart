// ignore_for_file: deprecated_member_use
// Ignores warnings related to deprecated methods being used in this file.

import 'dart:convert'; // Used for decoding JSON responses from backend.
import 'package:flutter/material.dart'; // Flutter UI framework.
import 'package:http/http.dart' as http; // Used for making HTTP requests.
import 'package:get/get.dart'; // GetX package for navigation and snackbars.
import 'package:flutter_application_1/configs/api.dart';
// Imports backend API URL from config file.

/// Signup Screen Widget
/// StatefulWidget is used because the screen has changing states
/// such as loading indicator and text field values.
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

/// State class for Signup screen
class _SignupState extends State<Signup> {
  /// Controllers capture input from text fields
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  /// Tracks loading state during signup request
  bool isLoading = false;

  /// Backend signup endpoint from config file
  final String apiUrl = backendSignupUrl;

  /// Signup function
  /// Handles:
  /// 1. Input validation
  /// 2. Sending request to backend
  /// 3. Handling success/error responses
  Future<void> signup() async {
    /// Get user inputs and remove unnecessary spaces
    String fullname = fullnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmController.text.trim();

    /// Validate all fields are filled
    if (fullname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill all fields",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return; // Stop execution if validation fails
    }

    /// Check if passwords match
    if (password != confirmPassword) {
      Get.snackbar(
        "Error",
        "Passwords do not match",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    /// Start loading spinner
    setState(() {
      isLoading = true;
    });

    try {
      /// Build API URL and attach query parameters
      final url = Uri.parse(apiUrl).replace(
        queryParameters: {
          'fullname': fullname,
          'email': email,
          'password': password,
        },
      );

      /// Send GET request to backend
      final response = await http.get(url);

      /// Decode backend JSON response
      final data = jsonDecode(response.body);

      /// Check if signup was successful
      if (response.statusCode == 200 && data["status"] == "success") {
        /// Show success message
        Get.snackbar(
          "Success",
          "Account created successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        /// Navigate user to login page and remove previous routes
        Get.offAllNamed('/login');
      } else {
        /// Show backend error message
        Get.snackbar(
          "Error",
          data["message"] ?? "Signup failed",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      /// Handle server/network errors
      Get.snackbar(
        "Error",
        "Server connection failed: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      /// Stop loading spinner whether success or failure
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Dispose controllers when widget is removed
  /// Prevents memory leaks
  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("spurs.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// Dark overlay for readability
          Container(color: Colors.black.withOpacity(0.6)),

          /// Centering signup form
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),

              /// Makes screen scrollable if keyboard appears
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(25),

                  /// Glassmorphism style container
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(25),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /// Page heading
                      const Text(
                        "Create Your Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Full name field
                      TextField(
                        controller: fullnameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration("Full name", Icons.person),
                      ),

                      const SizedBox(height: 20),

                      /// Email field
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                          "Email address",
                          Icons.email,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// Password field
                      TextField(
                        controller: passwordController,
                        obscureText: true, // hides password
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration("Password", Icons.lock),
                      ),

                      const SizedBox(height: 20),

                      /// Confirm password field
                      TextField(
                        controller: confirmController,
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: inputDecoration(
                          "Confirm password",
                          Icons.lock,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Signup button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        /// Disable button while loading
                        onPressed: isLoading ? null : signup,

                        /// Show spinner when loading otherwise show text
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),

                      const SizedBox(height: 20),

                      /// Login redirect section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),

                          /// Clickable login link
                          GestureDetector(
                            onTap: () => Get.toNamed('/login'),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable custom decoration for all text fields
  InputDecoration inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      /// Placeholder text
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),

      /// Icon inside field
      prefixIcon: Icon(icon, color: Colors.white70),

      /// Fill background
      filled: true,
      fillColor: Colors.white.withOpacity(0.1),

      /// Rounded border with no visible line
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
    );
  }
}
