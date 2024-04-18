import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

showMessage(
    {required BuildContext context,
    required String title,
    required String message}) {
  showCupertinoDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    },
  );
}
