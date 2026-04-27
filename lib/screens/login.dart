// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// CONTROLLER
class Logincontrollers extends GetxController {
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }
}

/// MAIN SCREEN
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Logincontrollers loginController = Get.put(Logincontrollers());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
          /// BACKGROUND
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("spurs.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// OVERLAY
          Container(color: Colors.black.withOpacity(0.6)),

          /// CONTENT
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
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// USERNAME / EMAIL
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

                    /// PASSWORD
                    Obx(
                      () => TextField(
                        controller: passwordController,
                        obscureText: !loginController.isPasswordVisible.value,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white70),
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.white70,
                          ),
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

                    /// LOGIN BUTTON
                    Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: loginController.isLoading.value
                            ? null
                            : () async {
                                if (usernameController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Enter email",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } else if (passwordController.text.isEmpty) {
                                  Get.snackbar(
                                    "Error",
                                    "Enter password",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                } else {
                                  loginController.isLoading.value = true;
                                  try {
                                    final response = await http.get(
                                      Uri.parse(
                                        "http://192.168.0.103/flutterapi/login.php?email=${usernameController.text}&password=${passwordController.text}",
                                      ),
                                    );
                                    if (response.statusCode == 200) {
                                      final serverData = jsonDecode(
                                        response.body,
                                      );
                                      if (serverData['code'] == 1) {
                                        // ✅ Pass user details to dashboard
                                        Get.offAllNamed(
                                          '/client-home',
                                          arguments: serverData['userdetails'],
                                        );
                                      } else {
                                        Get.snackbar(
                                          "Wrong Details",
                                          serverData["message"],
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        "Server error",
                                        "Login failed",
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    }
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Server connection failed: $e",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  } finally {
                                    loginController.isLoading.value = false;
                                  }
                                }
                              },
                        child: loginController.isLoading.value
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Login"),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// SIGNUP LINK
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
