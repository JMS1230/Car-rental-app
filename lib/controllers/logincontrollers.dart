import 'package:get/get.dart';

class Logincontrollers extends GetxController {
  /// PASSWORD VISIBILITY (false = hidden by default)
  var isPasswordVisible =
      false.obs; // FIX 1: was true (password showed in plain text on open)

  /// TOGGLE PASSWORD VISIBILITY
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// LOGIN FUNCTION
  bool login(String username, String password, String role) {
    // FIX 2: added role param
    final trimmedUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimmedUsername.isEmpty || trimmedPassword.isEmpty) {
      return false;
    }

    if (role == 'staff' &&
        trimmedUsername == "staff" &&
        trimmedPassword == "123456") {
      return true;
    }

    if (role == 'client' &&
        trimmedUsername == "client" &&
        trimmedPassword == "123456") {
      return true;
    }

    return false; // FIX 3: was return true (let ANY credentials log in!)
  }
}
