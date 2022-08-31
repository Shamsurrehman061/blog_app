import 'dart:io';

import 'package:ecommerce_app/Component/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  FocusNode titleNode = FocusNode();
  FocusNode detailNode = FocusNode();
  File? image;
  final picker = ImagePicker();
  final db = FirebaseDatabase.instance.ref().child("post");
  final auth = FirebaseAuth.instance;
  bool showSpinner = false;
  final storage = FirebaseStorage.instance;


  Future getImageFromGallery()async
  {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if(pickedImage != null)
        {
          image = File(pickedImage.path);
        }
    });

  }

  void toastMessage(String msg)
  {
    Fluttertoast.showToast(
      msg: msg,
      fontSize: 16.8,
      toastLength: Toast.LENGTH_SHORT,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
    );
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

  Future uploadTaskToFirebase()async
  {
    FocusScope.of(context).unfocus();
    try{
      setState(() {
        showSpinner = true;
      });
      final date = DateTime.now().millisecondsSinceEpoch;
      final ref = storage.ref().child("postPic$date");
      await ref.putFile(image!.absolute);
      final imgUrl = await ref.getDownloadURL();
      final uid = auth.currentUser!.uid;

      db.child("post_list").child(date.toString()).set({
        'pId' : date.toString(),
        'pUrl' : imgUrl.toString(),
        'pTitle' : _titleController.text.toString(),
        'pDescription' : _detailController.text.toString(),
        'uid' : uid.toString(),
      }).then((value){
        setState(() {
          showSpinner = false;
        });
        toastMessage("Post publish");
      }).onError((error, stackTrace){
        setState(() {
          showSpinner = false;
        });
        toastMessage(error.toString());
      });
    }
    catch(e)
    {
      setState(() {
        showSpinner = false;
      });
      toastMessage(e.toString());
    }

    setState(() {
      image = null;
    });

    _titleController.clear();
    _detailController.clear();

  }



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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title:const Text("New Blog"),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Column(
              children:
              [
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
                  height: size.height * 0.05,
                ),

                TextFormField(
                  decoration:const InputDecoration(
                    hintText: 'title',
                    labelText: 'title',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value){
                    if(_detailController.text.isEmpty)
                    {
                      FocusScope.of(context).requestFocus(detailNode);
                    }
                  },
                  controller: _titleController,
                  focusNode: titleNode,
                ),

                SizedBox(
                  height: size.height * 0.02,
                ),


                TextFormField(
                  minLines: 1,
                  maxLength: 500,
                  decoration:const InputDecoration(
                    hintText: 'Description',
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  onFieldSubmitted: (value){
                    if(_titleController.text.isEmpty)
                    {
                      FocusScope.of(context).requestFocus(titleNode);
                    }
                  },
                  controller: _detailController,
                  focusNode: detailNode,
                ),

                SizedBox(
                  height: size.height * 0.05,
                ),

                RoundButton(onPress: (){
                  if(_titleController.text.isEmpty)
                    {
                      FocusScope.of(context).requestFocus(titleNode);
                    }
                  else if(_detailController.text.isEmpty)
                    {
                      FocusScope.of(context).requestFocus(detailNode);
                    }
                  else
                    {
                      uploadTaskToFirebase();
                    }
                }, title: 'Upload'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
