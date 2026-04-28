import 'dart:convert'; // Used to decode JSON response from backend
import 'package:get/get.dart'; // GetX for state management and navigation
import 'package:http/http.dart' as http; // HTTP package for API requests

class Logincontrollers extends GetxController {
  /// CONTROLS PASSWORD VISIBILITY (true = show, false = hide)
  var isPasswordVisible = false.obs;

  /// Toggles password visibility in UI
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// CONTROLS LOADING STATE (shows spinner during login)
  var isLoading = false.obs;

  /// LOGIN FUNCTION: Sends email & password to backend and handles response
  Future<bool> login(String email, String password) async {
    // Remove unnecessary spaces from input
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    // Validate empty fields before sending request
    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return false;
    }

    try {
      // Start loading indicator
      isLoading.value = true;

      // Send GET request to PHP backend login API
      final response = await http.get(
        Uri.parse(
          "http://10.61.228.97/flutterapi/login.php"
          "?email=$trimmedEmail&password=$trimmedPassword",
        ),
      );

      // Check if request was successful
      if (response.statusCode == 200) {
        // Decode JSON response from backend
        final data = json.decode(response.body);

        // Check backend success code (PHP returns code == 1 for success)
        if (data["code"] == 1) {
          // Navigate to client home screen and pass user details
          Get.offAllNamed('/client-home', arguments: data["userdetails"]);

          return true;
        } else {
          // Show error message from backend
          Get.snackbar(
            "Login Failed",
            data["message"] ?? "Invalid credentials",
          );
          return false;
        }
      } else {
        // Handle HTTP error codes (404, 500, etc.)
        Get.snackbar("Error", "Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      // Handle network / connection errors
      Get.snackbar("Error", "Connection failed: $e");
      return false;
    } finally {
      // Stop loading indicator no matter what happens
      isLoading.value = false;
    }
  }
}
