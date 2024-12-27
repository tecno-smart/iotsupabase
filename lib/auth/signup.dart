import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot/auth/login.dart';
import 'package:iot/constant.dart';
import 'package:iot/control/controler.dart';

class SignUP extends StatelessWidget {
  SignUP({super.key});
  final TextEditingController name_c = TextEditingController();
  final TextEditingController phone_c = TextEditingController();
  final TextEditingController email_c = TextEditingController();
  final TextEditingController pass_c = TextEditingController();
  final TextEditingController secrt_c = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 236, 236, 236),
        title: const Text("Sign up "),
        centerTitle: true,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.only(top: 50),
            width: screen.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(70),
                    topRight: Radius.circular(70))),
            child: ListView(
              children: [
                //-------------------------------
                Comp(
                  cont: name_c,
                  screen: screen,
                  hent: "name",
                  iconh: Icons.person,
                  secur: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //-------------------------------
                Comp(
                  cont: phone_c,
                  screen: screen,
                  hent: "phone",
                  iconh: Icons.phone,
                  secur: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your phone numper';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //-------------------------------
                Comp(
                  cont: email_c,
                  screen: screen,
                  hent: "Email",
                  iconh: Icons.email_outlined,
                  secur: false,
                  validator: (value) {
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //------------------------------
                Comp(
                  cont: pass_c,
                  screen: screen,
                  hent: "password",
                  iconh: Icons.lock_outline_rounded,
                  secur: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                //------------------------------
                Comp(
                  cont: secrt_c,
                  screen: screen,
                  hent: "secret word for reset passwor",
                  iconh: Icons.security,
                  secur: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'enter your secret word';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 40,
                ),
                //------------------------------
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screen.width * .3),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          var authserv = Authserv();
                          var resp = await authserv.insertRow(
                              email_c.text,
                              name_c.text,
                              pass_c.text,
                              phone_c.text,
                              secrt_c.text,
                              "1/1/2025");
                          if (resp[0]['name'] == name_c.text) {
                            Get.snackbar("succes",
                                'The account has been created successfully');
                            Get.off(() => LoginPage());
                          }
                        } catch (e) {
                          if (e.toString().contains(' already exists')) {
                            Get.snackbar(
                                "Error ", 'This account already exists');
                          }
                        }
                      } else {
                        print('Form is invalid');
                      }
                    },
                    child: Text(
                      "sign up",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Genral.canvas,
                        foregroundColor: Genral.backcolor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Comp extends StatelessWidget {
  const Comp({
    super.key,
    required this.screen,
    required this.hent,
    required this.iconh,
    required this.secur,
    required this.cont,
    this.validator,
  });

  final Size screen;
  final String hent;
  final IconData iconh;
  final TextEditingController cont;
  final bool secur;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        clipBehavior: Clip.hardEdge,
        height: 70,
        width: screen.width * .9,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(30)),
        child: TextFormField(
          validator: validator,
          controller: cont,
          obscureText: secur,
          showCursor: true,
          decoration: InputDecoration(
            focusColor: Colors.blue,
            fillColor: Colors.blue,
            prefixIconColor: Colors.blue,
            hintText: hent,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            prefixIcon: Icon(iconh),
            // border: InputBorder.none
          ),
        ));
  }
}
