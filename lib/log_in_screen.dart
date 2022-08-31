import 'package:ecommerce_app/Component/round_button.dart';
import 'package:ecommerce_app/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  bool isVisible = false;
  bool obscrText = true;
  bool showSpinner = false;

  void toastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 16.8,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: SafeArea(
          child: Form(
            key: key,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Email',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    focusNode: emailFocusNode,
                    onFieldSubmitted: (value) {
                      if (_passwordController.text.isEmpty) {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      }
                    },
                    controller: _emailController,
                    validator: (value) {
                      if (!RegExp(
                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                          .hasMatch(value.toString())) {
                        return 'Enter valid email';
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              isVisible = !isVisible;
                              obscrText = !obscrText;
                            });
                          },
                          child: Icon(isVisible
                              ? Icons.visibility
                              : Icons.visibility_off)),
                    ),
                    obscureText: obscrText,
                    onFieldSubmitted: (value) {
                      if (_emailController.text.isEmpty) {
                        FocusScope.of(context).requestFocus(emailFocusNode);
                      }
                    },
                    controller: _passwordController,
                    focusNode: passwordFocusNode,
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Password is incorrect';
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.1,
                  ),
                  RoundButton(
                      onPress: (){
                        if (_emailController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        } else if (_passwordController.text.isEmpty) {
                          FocusScope.of(context)
                              .requestFocus(passwordFocusNode);
                        } else if (key.currentState!.validate()) {
                          try {
                            setState((){
                              showSpinner = true;
                            });
                            auth
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text)
                                .then((value) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage("Sign In Successfully");
                            }).onError((error, stackTrace) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(error.toString());
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(e.toString());
                          }
                        }
                      },
                      title: 'Log In'),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Don\'t have account? ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUp()));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
