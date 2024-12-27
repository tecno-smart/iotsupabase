import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iot/auth/login.dart';
import 'package:iot/view/home.dart';

class MyWidget extends StatelessWidget {
  MyWidget({super.key});
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      bool login = box.read('login') ?? false;
      if (login) {
        Get.off(() => Home());
      } else {
        Get.off(() => LoginPage());
      }
    });
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/iconapp/smart-home.png",
                height: 150, width: 150)
          ],
        ),
      ),
    );
  }
}
