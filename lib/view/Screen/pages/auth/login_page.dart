import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/view/Screen/pages/auth/signup_page.dart';
import 'package:chat_app/view/Screen/pages/homepage.dart';
import 'package:chat_app/view/widget/text_input_decoration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  bool _isLoading = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor))
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
                child: Form(
                  key: formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const Text("ChatApp",
                            style: TextStyle(
                                fontSize: 40, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 15),
                        const Text("Login now to see what they are talking",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 15),
                        Image.asset('assets/images/loginImage.png'),
                        const SizedBox(height: 135),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(
                              labelText: "E-mail",
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor)),
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z.a-z\d!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z\d]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "Please enter a valid E-mail";
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Password",
                                prefixIcon: Icon(Icons.lock,
                                    color: Theme.of(context).primaryColor)),
                            validator: (value) {
                              if (value!.length < 8) {
                                return "Password must be more than 8 characters";
                              } else {
                                return null;
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              });
                            }),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              logIn();
                            },
                            child: const Text(
                              " Sign In ",
                              style: TextStyle(
                                  color: CustomColors.primaryBackgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                              text: " Do not have an account ?  ",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CustomColors.primaryTextColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Sign Up ",
                                    style: const TextStyle(
                                        fontSize: 11,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.off(const SignUpPage());
                                      }),
                              ]),
                        ),
                      ]),
                ),
              ),
            ),
    );
  }

  logIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .logInWithEmailAndPassword(email, password)
          .then((value) async {
        if (value == true) {
          QuerySnapshot snapshot =
              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(email);
          //saving the value to shared Preferences
          await MyFunctions.saveUserLoggedIn(true);
          await MyFunctions.saveUserEmailToSP(email);
          await MyFunctions.saveUserNameToSP(snapshot.docs[0]['fullName']);
          Get.off(const HomePage());
        } else {
          showSnackBar(context, Theme.of(context).primaryColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
