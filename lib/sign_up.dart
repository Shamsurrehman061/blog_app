import 'dart:io';

import 'package:ecommerce_app/Component/round_button.dart';
import 'package:ecommerce_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'log_in_screen.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  bool isVisible = false;
  bool obscrText = true;
  bool showSpinner = false;
  final db = FirebaseDatabase.instance.ref().child('Users');
  final storage = FirebaseStorage.instance.ref();
  File? image;
  final picker = ImagePicker();


  void dialogue(context)
  {
    showDialog(
        context: context,
        builder: (BuildContext context)
        {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)
            ),
            content: Container(
              height: 120.0,
              child: Column(
                children: [

                  ListTile(
                    onTap: (){
                      getImageFromCamera();
                      Navigator.of(context).pop();
                    },
                    leading:const Icon(Icons.camera_alt_rounded),
                    title:const Text("Camera"),
                  ),

                  ListTile(
                    onTap: (){
                      getImageFromGallery();
                      Navigator.of(context).pop();
                    },
                    leading:const Icon(Icons.photo_library),
                    title:const Text("Gallery"),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }


  Future getImageFromGallery()async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState((){
      if(pickedImage != null)
      {
        image = File(pickedImage.path);
      }
    });
  }

  Future getImageFromCamera()async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);setState(() {
      if(pickedImage != null)
      {
        image = File(pickedImage.path);
      }
    });
  }

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
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
              key: key,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    Text("Register", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),),
                    SizedBox(
                      height: size.height * 0.04,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Username',
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      focusNode: usernameFocusNode,
                      onFieldSubmitted: (value) {
                        if (_emailController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(emailFocusNode);
                        } else if (_passwordController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(passwordFocusNode);
                        }
                      },
                      controller: _usernameController,
                      validator: (value) {
                        if (!RegExp(r'^[a-z]').hasMatch(value.toString())) {
                          return 'Enter valid name';
                        }
                      },
                    ),

                    SizedBox(
                      height: size.height * 0.01,
                    ),

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
                        } else if (_usernameController.text.isEmpty) {
                          FocusScope.of(context).requestFocus(usernameFocusNode);
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
                          FocusScope.of(context).requestFocus(passwordFocusNode);
                          return 'Password must be greater than 6 character';
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),

                    Center(
                      child: InkWell(
                        onTap:(){
                          dialogue(context);
                        },
                        child: Container(
                          width: size.width * 1,
                          height: size.height * 0.3,
                          color: Colors.grey.shade200,
                          child: image != null ? ClipRect(
                            child: Image.file(
                              image!.absolute,
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ) : Container(
                            width: 100,
                            height: 100,
                            child: const Icon(Icons.camera_alt, size: 100,),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    RoundButton(
                        onPress: () async{
                          if (_usernameController.text.isEmpty) {
                            FocusScope.of(context).requestFocus(usernameFocusNode);
                          } else if (_emailController.text.isEmpty) {
                            FocusScope.of(context).requestFocus(emailFocusNode);
                          } else if (_passwordController.text.isEmpty) {
                            FocusScope.of(context).requestFocus(passwordFocusNode);
                          } else if (key.currentState!.validate()) {

                            try{
                              setState((){
                                showSpinner = true;
                              });
                              auth.createUserWithEmailAndPassword(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                                  .then((value)async{
                                     final uid = auth.currentUser!.uid;
                                     final ref = storage.child("profilePics$uid");
                                     UploadTask task = ref.putFile(image!.absolute);
                                     final imgUrl = await ref.getDownloadURL();
                                db.child(uid).set({
                                  'username' : _usernameController.text.toString(),
                                  'email' : _emailController.text.toString(),
                                  'profile_pic' : imgUrl.toString(),
                                  'uid' : auth.currentUser!.uid,
                                });

                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage("Create account successfully");
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const HomePage()));
                              }).onError((error, stackTrace) {
                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage("Failed");
                              });
                            }
                            catch(e) {
                              setState(() {
                                showSpinner = false;
                              });
                              toastMessage(e.toString());
                            }
                          }
                        },
                        title: 'Register'),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have account? ',
                          style:
                              TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const LogIn()));
                            },
                            child: const Text(
                              'Login',
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
      ),
    );
  }
}
