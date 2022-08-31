
import 'package:ecommerce_app/log_in_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'add_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final db = FirebaseDatabase.instance.ref().child('Users');
  final db2 = FirebaseDatabase.instance.ref().child('post');
  final auth = FirebaseAuth.instance;
  String username = "username";
  String profileImg = "images/blog.jpg";


  void getUser()async{
    final val = await db.child(auth.currentUser!.uid).get();
    Map data = val.value as Map;
    setState(() {
      username = data['username'];
      profileImg = data['profile_pic'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title:const Text("Home"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const AddBlog()));
          }, icon:const Icon(Icons.add)),
          IconButton(onPressed: (){
            auth.signOut();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>const LogIn()));
          }, icon:const Icon(Icons.logout)),
        ],
      ),

      body: Column(
        children:
        [
          Expanded(
            child: FirebaseAnimatedList(
              query: db2.child("post_list"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index)
              {
                Map values = snapshot.value as Map;
                final img = values['pUrl'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                      [
                        Row(
                          children:
                          [
                            CircleAvatar(
                              radius: 50.0,
                              child: FadeInImage.assetNetwork(
                                  placeholder: 'images/blog.jpg',
                                image: profileImg,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Column(
                              children: [
                                Text(username),
                              ],
                            ),
                          ],
                        ),
                        ClipRect(
                          child: FadeInImage.assetNetwork(
                            width: MediaQuery.of(context).size.width * 1,
                              height: MediaQuery.of(context).size.height * 0.25,
                              fit: BoxFit.cover,
                              placeholder: 'images/blog.jpg',
                              image: img,
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(values['pTitle'], style:const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                            child: Text(values['pDescription'], style: TextStyle(fontSize: 20),)),
                      ],
                    ),
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }
}
