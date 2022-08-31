import 'package:ecommerce_app/Component/round_button.dart';
import 'package:ecommerce_app/sign_up.dart';
import 'package:flutter/material.dart';

import 'log_in_screen.dart';


class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:
            [
              RoundButton(onPress: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const SignUp()));
              }, title: 'Register'),
              SizedBox(
                height: size.height * 0.05,
              ),
              RoundButton(onPress: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const LogIn()));
              }, title: 'Login'),
            ],
          ),
        ),
      ),
    );
  }
}
