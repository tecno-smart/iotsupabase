import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iot/auth/forget.dart';

import 'package:iot/auth/signup.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';
import 'package:iot/view/home.dart';

class LoginPage extends StatelessWidget {
  final box = GetStorage();
  LoginPage({super.key});
  final bool chvalue = false;
  final TextEditingController email = TextEditingController();
  final TextEditingController passwrd = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final autcont = Get.put(Authserv());
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Space(screen: screen, h: .04),
            Text(
              "SMART-CONTROL",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Space(screen: screen, h: .02),
            Expanded(
              child: Container(
                width: screen.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(70),
                        topRight: Radius.circular(70))),
                child: ListView(
                  children: [
                    Space(screen: screen, h: .02),
                    Image.asset(
                      "assets/iconapp/smart-home.png",
                      height: 100,
                      width: 100,
                    ),
                    Space(screen: screen, h: .05),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                              .hasMatch(value!)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                        controller: email,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            label: Text("Email"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    Space(screen: screen, h: .05),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Obx(
                          () => TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'enter your password';
                              }
                              return null;
                            },
                            controller: passwrd,
                            obscureText: autcont.hid.value,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye_sharp,
                                    color: autcont.hid.value
                                        ? Genral.grey
                                        : Genral.barcolor,
                                  ),
                                  onPressed: () {
                                    autcont.hid.value = !autcont.hid.value;
                                  },
                                ),
                                label: Text("Password"),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                        )),
                    Space(screen: screen, h: .05),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (_) {}),
                              Text(
                                " Rememper me",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              Get.to(() => ForgetPage());
                            },
                            child: Text("forget password?",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    Space(screen: screen, h: .05),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: screen.width * .3),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Genral.canvas,
                              foregroundColor: Genral.backcolor),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                autcont.getpass(email.text).then((data) {
                                  if (data['pass'] == passwrd.text) {
                                    box.write('email', email.text);
                                    box.write('pass', passwrd.text);
                                    box.write('login', true);

                                    Get.to(() => Home());
                                  } else {
                                    Get.snackbar(
                                        "", "enter avalid email or password",
                                        snackPosition: SnackPosition.BOTTOM);
                                  }
                                });
                              } catch (e) {
                                print(e);
                              }
                            } else {
                              print('Form is invalid');
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(fontSize: 18),
                          )),
                    ),
                    Space(screen: screen, h: .05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Dont have account?",
                            style: TextStyle(color: Colors.grey)),
                        TextButton(
                          onPressed: () {
                            Get.to(() => SignUP());
                          },
                          child:
                              Text("Sign up", style: TextStyle(fontSize: 18)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Space extends StatelessWidget {
  const Space({
    super.key,
    required this.screen,
    required this.h,
  });

  final Size screen;
  final double h;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: screen.height * h,
    );
  }
}
