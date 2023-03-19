import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/view/Screen/pages/auth/login_page.dart';
import 'package:chat_app/view/widget/text_input_decoration.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String fullName = "";
  String email = "";
  String password = "";
  AuthService authService = AuthService();

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
                        const Text("SignUp now to see what they are talking",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 15),
                        Image.asset('assets/images/loginImage.png'),
                        const SizedBox(height: 60),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "user name can not be Empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: "User Name",
                              prefixIcon: Icon(Icons.person,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
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
                          decoration: textInputDecoration.copyWith(
                              labelText: "E-mail",
                              prefixIcon: Icon(Icons.email,
                                  color: Theme.of(context).primaryColor)),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          obscureText: true,
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Password must be more than 7 characters";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(Icons.lock,
                                  color: Theme.of(context).primaryColor)),
                        ),
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
                              signUp();
                            },
                            child: const Text(
                              " Sign Up ",
                              style: TextStyle(
                                  color: CustomColors.primaryBackgroundColor),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                              text: " Already have an account? ",
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CustomColors.primaryTextColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Sign In ",
                                    style: const TextStyle(
                                        fontSize: 11,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.off(const LoginPage());
                                      }),
                              ]),
                        ),
                      ]),
                ),
              ),
            ),
    );
  }

  signUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await authService
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          //  saving the shared preference state
          await MyFunctions.saveUserLoggedIn(true);
          await MyFunctions.saveUserEmailToSP(email);
          await MyFunctions.saveUserNameToSP(fullName);
          Get.off(const LoginPage());
        } else {
          showSnackBar(context, CustomColors.errorColor, value);
          setState(() {
            _isLoading = false;
          });
        }
      });
    }
  }
}
