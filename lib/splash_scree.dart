import 'dart:async';
import 'dart:ui';

import 'package:ecommerce_app/home_page.dart';
import 'package:ecommerce_app/log_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user = auth.currentUser;
    if (user != null) {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const HomePage())));
    } else {
      Timer(
          Duration(seconds: 3),
          () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const LogIn())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Center(
                child: Container(
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/blog.jpg'),
                    ),
                  ),
                ),
              ),
            ),
            const Center(
                child: Text(
              'Post your blogs',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),),
          ],
        ),
      ),
    );
  }
}
