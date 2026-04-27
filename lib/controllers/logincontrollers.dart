import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Logincontrollers extends GetxController {
  /// PASSWORD VISIBILITY
  var isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// LOADING STATE
  var isLoading = false.obs;

  /// LOGIN FUNCTION
  Future<bool> login(String email, String password) async {
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      Get.snackbar("Error", "Email and password are required");
      return false;
    }

    try {
      isLoading.value = true;

      // ✅ Use GET to match PHP $_GET
      final response = await http.get(
        Uri.parse(
          "http://192.168.0.103/flutterapi/login.php"
          "?email=$trimmedEmail&password=$trimmedPassword",
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // ✅ Match PHP response code == 1
        if (data["code"] == 1) {
          // ✅ Pass userdetails to dashboard
          Get.offAllNamed('/client-home', arguments: data["userdetails"]);
          return true;
        } else {
          Get.snackbar(
            "Login Failed",
            data["message"] ?? "Invalid credentials",
          );
          return false;
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Connection failed: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
