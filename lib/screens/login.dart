// ignore_for_file: deprecated_member_use
// Ignores warnings about deprecated members used in this file.

import 'dart:convert';
// Used to decode JSON data returned from backend

import 'package:flutter/material.dart';
// Flutter UI package

import 'package:get/get.dart';
// GetX for state management, navigation and snackbars

import 'package:http/http.dart' as http;
// Used for making HTTP requests

/// =========================
/// LOGIN CONTROLLER
/// =========================
/// Handles reactive state using GetX
class Logincontrollers extends GetxController {
  /// Controls password visibility
  /// false = hidden by default
  var isPasswordVisible = false.obs;

  /// Controls loading state for login button
  var isLoading = false.obs;

  /// Toggles show/hide password
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

/// =========================
/// MAIN LOGIN SCREEN
/// =========================
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Inject Login controller using GetX
  final Logincontrollers loginController = Get.put(Logincontrollers());

  /// Text field controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  /// Dispose controllers to prevent memory leaks
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// =========================
          /// BACKGROUND IMAGE
          /// =========================
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("spurs.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// =========================
          /// DARK OVERLAY
          /// Makes text readable
          /// =========================
          Container(color: Colors.black.withOpacity(0.6)),

          /// =========================
          /// LOGIN CONTENT
          /// =========================
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Container(
                padding: const EdgeInsets.all(25),

                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.55),

                  borderRadius: BorderRadius.circular(25),
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    /// Heading
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// EMAIL FIELD
                    /// =========================
                    TextField(
                      controller: usernameController,

                      style: const TextStyle(color: Colors.white),

                      decoration: InputDecoration(
                        hintText: "Email",

                        hintStyle: const TextStyle(color: Colors.white70),

                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.white70,
                        ),

                        filled: true,

                        fillColor: Colors.white.withOpacity(0.1),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// =========================
                    /// PASSWORD FIELD
                    /// Obx rebuilds when
                    /// visibility changes
                    /// =========================
                    Obx(
                      () => TextField(
                        controller: passwordController,

                        /// Hide/show password
                        obscureText: !loginController.isPasswordVisible.value,

                        style: const TextStyle(color: Colors.white),

                        decoration: InputDecoration(
                          hintText: "Password",

                          hintStyle: const TextStyle(color: Colors.white70),

                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white70,
                          ),

                          /// Eye icon
                          suffixIcon: GestureDetector(
                            onTap: loginController.togglePasswordVisibility,

                            child: Icon(
                              loginController.isPasswordVisible.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,

                              color: Colors.white70,
                            ),
                          ),

                          filled: true,

                          fillColor: Colors.white.withOpacity(0.1),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),

                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// =========================
                    /// LOGIN BUTTON
                    /// Reactive button using Obx
                    /// =========================
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,

                          minimumSize: const Size(double.infinity, 50),
                        ),

                        /// Disable button while loading
                        onPressed: loginController.isLoading.value
                            ? null
                            : () async {
                                /// Validate email field
                                if (usernameController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Enter email",

                                    backgroundColor: Colors.red,

                                    colorText: Colors.white,
                                  );
                                }
                                /// Validate password field
                                else if (passwordController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Enter password",

                                    backgroundColor: Colors.red,

                                    colorText: Colors.white,
                                  );
                                } else {
                                  /// Start loading
                                  loginController.isLoading.value = true;

                                  try {
                                    /// Send login request
                                    final response = await http.get(
                                      Uri.parse(
                                        "http://10.61.228.97/flutterapi/login.php?email=${usernameController.text}&password=${passwordController.text}",
                                      ),
                                    );

                                    /// Check if server responded
                                    if (response.statusCode == 200) {
                                      /// Decode response
                                      final serverData = jsonDecode(
                                        response.body,
                                      );

                                      /// Login success
                                      if (serverData['code'] == 1) {
                                        /// Navigate to dashboard
                                        /// Pass user data
                                        Get.offAllNamed(
                                          '/client-home',

                                          arguments: serverData['userdetails'],
                                        );
                                      } else {
                                        /// Wrong credentials
                                        Get.snackbar(
                                          "Wrong Details",

                                          serverData["message"],

                                          backgroundColor: Colors.red,

                                          colorText: Colors.white,
                                        );
                                      }
                                    } else {
                                      /// Server error response
                                      Get.snackbar(
                                        "Server error",
                                        "Login failed",

                                        backgroundColor: Colors.red,

                                        colorText: Colors.white,
                                      );
                                    }
                                  } catch (e) {
                                    /// Network/connection error
                                    Get.snackbar(
                                      "Error",
                                      "Server connection failed: $e",

                                      backgroundColor: Colors.red,

                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    /// Stop loading
                                    loginController.isLoading.value = false;
                                  }
                                }
                              },

                        /// Show loader while logging in
                        child: loginController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// =========================
                    /// SIGNUP LINK
                    /// =========================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        const Text(
                          "No account? ",
                          style: TextStyle(color: Colors.white70),
                        ),

                        GestureDetector(
                          onTap: () => Get.toNamed('/signup'),

                          child: const Text(
                            "Sign up",

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
        ],
      ),
    );
  }
}
