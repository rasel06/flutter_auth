import 'package:flutter_auth/models/user_model.dart';

class ValidationResult {
  final bool isValid;
  final String message;

  ValidationResult(this.isValid, this.message);
}

ValidationResult validateUser(UserModel userModel) {
  if (userModel.username == null || userModel.password == null) {
    return ValidationResult(false, "Username or Password cannot be empty");
  }

  if (userModel.username.toString().isEmpty) {
    return ValidationResult(false, "Username cannot be empty");
  }

  if (userModel.password.toString().isEmpty) {
    return ValidationResult(false, "Password cannot be empty");
  }

  return ValidationResult(true, "Validation successful");
}
