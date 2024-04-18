import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_auth/constants.dart';
import 'package:flutter_auth/models/user_model.dart';
import 'package:flutter_auth/validation/user_login_validation.dart';
import 'package:flutter_auth/widgets/helpers/show_message.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> submit() async {
    UserModel userModel = UserModel(
        username: username.text.trim(), password: password.text.trim());

    ValidationResult validateResult = validateUser(userModel);
    if (validateResult.isValid) {
      bool serverResponse = await authenticateUser(userModel);
      if (serverResponse) {
        await showMessage(
          context: Get.context!,
          title: "Success!",
          message: "User Login Successfully!",
        );
      } else {
        await showMessage(
          context: Get.context!,
          title: "Error",
          message: "Incorrect Username or Password",
        );
      }
    } else {
      await showMessage(
        context: Get.context!,
        title: "Error",
        message: validateResult.message,
      );
    }
  }

  // bool validateUser(UserModel userModel) {
  //   if (userModel.username == null || userModel.password == null) {
  //     _message = "Username or Password cannot be empty";
  //     return false;
  //   }
  //   if (userModel.username.toString().isEmpty) {
  //     _message = "Username cannot be empty";
  //     return false;
  //   }

  //   if (userModel.password.toString().isEmpty) {
  //     _message = "Password cannot be empty";
  //     return false;
  //   }
  //   return true;
  // }

  Future<bool> authenticateUser(UserModel userModel) async {
    Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

    try {
      Map<String, dynamic> requestData = {
        'username': userModel.username,
        'password': userModel.password
      };

      final response = await dio.post("${apiUrl}auth/login", data: requestData);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
