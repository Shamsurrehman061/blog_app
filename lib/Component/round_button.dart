import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class RoundButton extends StatelessWidget {
  const RoundButton({Key? key, required this.onPress, required this.title}) : super(key: key);

  final String title;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context){
    Size size = MediaQuery.of(context).size;
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      clipBehavior: Clip.antiAlias,
      child: MaterialButton(
        height: size.height * 0.07,
        minWidth: double.infinity,
        color: Colors.green,
        onPressed: onPress,
        child: Text(title, style:const TextStyle(color: Colors.white, fontSize: 20),),
      ),
    );
  }
}
