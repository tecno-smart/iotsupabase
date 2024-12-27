import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';

class ForgetPage extends StatelessWidget {
  ForgetPage({super.key});
  final TextEditingController email = TextEditingController();
  final TextEditingController secret = TextEditingController();
  final autcont = Get.put(Authserv());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password recovery"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
              ),
              Image.asset(
                "assets/iconapp/recover.png",
                height: 150,
                width: 150,
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextField(
                  controller: secret,
                  decoration: InputDecoration(
                    label: Text("Your secret word "),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    prefixIcon: Icon(Icons.security),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  try {
                    autcont.Getsecret(email.text, secret.text).then((data) {
                      if (data['pass'] == null) {
                        // print('pleas chick email or secret word');
                        Get.snackbar(
                          "error",
                          'pleas chick email or secret word',
                        );
                      } else {
                        print('your password is : ${data['pass']}');
                        Get.defaultDialog(
                            title: "Password recovery",
                            content: Column(
                              children: [
                                Text("Your password is :-"),
                                Text(data['pass'].toString())
                              ],
                            ));
                      }
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text("Get my password"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Genral.canvas,
                    foregroundColor: Genral.backcolor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
