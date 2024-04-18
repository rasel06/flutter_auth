import 'package:flutter/material.dart';
import 'package:flutter_auth/controllers/login_controller.dart';
import 'package:flutter_auth/widgets/input_box.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController controller = Get.put(LoginController());

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: Get.width,
          height: Get.height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Login Page",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                const SizedBox(height: 30),
                inputBox(
                  hint: "Username",
                  textController: controller.username,
                ),
                const SizedBox(height: 20),
                inputBox(
                  hint: "Password",
                  textController: controller.password,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: Get.width / 2,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      print('${controller.username.text}');
                    },
                    child: const Text("Presss to Login"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
